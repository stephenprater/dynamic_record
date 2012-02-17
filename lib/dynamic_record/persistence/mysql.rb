module DynamicRecord
  module Persistence
    module MySql
      def materialize_record(ids = nil)
        
        eav_sql = "SELECT `eav`.`entity` AS `id`,\n"
        eav_sql << field_descriptions.collect do |fd|
          "MAX(IF(attribute = #{ActiveRecord::Base.sanitize(fd.field_name)}, `eav`.`value`, NULL)) AS #{ActiveRecord::Base.sanitize(fd.method_name)}"
        end.join(",\n")
      
        #these are not user generated table names, so it
        #should be okay to just quote them directly
        case_stmt = "CASE `sq`.`value_type`\n"
        case_stmt << DynamicRecord::Value.available_types.collect do |rvt|
          "WHEN '#{rvt.to_s}' THEN (SELECT `value` from `#{rvt.table_name}` WHERE `#{rvt.table_name}`.`id` = `sq`.`value_id`)"
        end.join("\n")
        case_stmt << "\nEND AS `value`"

        select_records = <<-SQL
          SELECT `records`.`id` AS `id`, `record_field_descriptions`.`field_name` as `field_name`, 
            `record_fields`.`value_id` AS `value_id`, `record_fields`.`value_type` AS `value_type`
          FROM `records`
          INNER JOIN `record_fields` ON `record_fields`.`record_id` = `records`.`id`
          INNER JOIN `record_field_descriptions` ON `record_field_descriptions`.`id` = `record_fields`.`record_field_description_id`
        SQL
        
        if ids
          select_records.concat <<-SQL
            WHERE `record`.`id` IN (#{ids.join(',')})
          SQL
        end

        view_select = <<-SQL
          #{eav_sql} FROM (
            SELECT `id` AS `entity`,
            `sq`.`field_name` AS `attribute`,
            #{case_stmt} FROM ( #{select_records} ) AS `sq` 
          ) AS `eav`
          GROUP BY `eav`.`entity`
        SQL
        
        
        table_name = self.name.split(/\s/).map { |i| i.underscore.pluralize }.join('_')

        # I need to futze about with the table name so that it's propery sanitized.

        if ids
          table_name = ActiveRecord::Base.sanitize(table_name)
          update_table = "UPDATE `#{table_name}` SET"
          update_table << field_descriptions.collect do |fd|
            "SET `#{table_name}`.#{ActiveRecord::Base.sanitize(fd.method_name)} = `new`.#{ActiveRecord::Base.sanitize(fd.method_name)}"
          end.join(",\n")
          update_table.concat <<-SQL
            FROM
              #{table_name}
            INNER JOIN
              #{view_select} AS `new`
            ON
              `#{table_name}`.`id` = `new`.`id`
          SQL
        else
          #column_types
          columns = "id INT(11) PRIMARY KEY, "
          columns << field_descriptions.collect do |fd|
            "#{fd.method_name} #{fd.sql_type}"
          end.join(", ")
          update_table = "CREATE TABLE `#{table_name + '_new'}` (#{columns}) AS (#{view_select})"
        end

        begin
          #mysql does not suport transactional ddl, so we have to write our own
          #facility for recovering if we screw it up
          self.class.connection.execute("DROP TABLE IF EXISTS `#{table_name}_new`")
          self.class.connection.execute(update_table)
          self.class.connection.execute("CREATE TABLE IF NOT EXISTS `#{table_name}` (dummy INT(11))")
          self.class.connection.execute("DROP TABLE IF EXISTS `#{table_name}_old`")
          self.class.connection.execute("RENAME TABLE `#{table_name}` TO `#{table_name + '_old'}`,`#{table_name + '_new'}` TO `#{table_name}`")
          self.class.connection.execute("DROP TABLE `#{table_name + '_old'}`")
        rescue ActiveRecord::StatementInvalid => e
          self.class.connection.execute("DROP TABLE IF EXISTS `#{table_name}_new`")
          self.class.connection.execute("DROP TABLE IF EXISTS `#{table_name}_old")
          self.class.connection.execute("DROP TABLE IF EXISTS `#{table_name}")
          raise MaterializationError, e.message
        end
      end
    end
  end
end
