# +---------------------+----------------------------+------+-----+---------------------+-----------------------------+
# | Field               | Type                       | Null | Key | Default             | Extra                       |
# +---------------------+----------------------------+------+-----+---------------------+-----------------------------+
# | INTERNAL_ID         | bigint(20) unsigned        | NO   | PRI | NULL                | auto_increment              |
# | TARGET_ID           | bigint(20) unsigned        | NO   | MUL | NULL                |                             |
# | TARGET_SERVICE_ID   | bigint(20) unsigned        | NO   | MUL | NULL                |                             |
# | AUTO_ACTIVE         | enum('YES','NO','INHERIT') | YES  |     | INHERIT             |                             |
# | ACTIVATION_STATUS   | enum('ACTIVE','INACTIVE')  | YES  |     | ACTIVE              |                             |
# | DEACTIVATION_REASON | varchar(255)               | YES  |     | NULL                |                             |
# | SITE_DOWN           | enum('1','0')              | YES  |     | 0                   |                             |
# | SITE_DOWN_DATE      | timestamp                  | NO   |     | 0000-00-00 00:00:00 |                             |
# | SITE_DOWN_REASON    | varchar(255)               | YES  |     | NULL                |                             |
# | OWNER               | varchar(100)               | NO   |     |                     |                             |
# | AVAILABLE_FOR       | varchar(100)               | NO   |     |                     |                             |
# | CREATION_DATE       | timestamp                  | NO   |     | 0000-00-00 00:00:00 |                             |
# | CREATED_BY          | varchar(255)               | NO   |     |                     |                             |
# | LAST_UPDATE_DATE    | timestamp                  | NO   |     | CURRENT_TIMESTAMP   | on update CURRENT_TIMESTAMP |
# | LAST_UPDATED_BY     | varchar(255)               | NO   |     |                     |                             |
# +---------------------+----------------------------+------+-----+---------------------+-----------------------------+
module Sfx4
  module Local
    module LclServiceInventory
      def self.included(klass)
        klass.class_eval do
          self.table_name = 'LCL_SERVICE_INVENTORY'
          self.primary_key = 'INTERNAL_ID'
        end
      end
    end
  end
end
