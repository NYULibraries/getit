# +----------------------------+-------------------------+------+-----+---------------------+-----------------------------+
# | Field                      | Type                    | Null | Key | Default             | Extra                       |
# +----------------------------+-------------------------+------+-----+---------------------+-----------------------------+
# | INTERNAL_ID                | bigint(20) unsigned     | NO   | PRI | NULL                | auto_increment              |
# | TARGET_SERVICE_ID          | bigint(20) unsigned     | NO   | MUL | NULL                |                             |
# | SERVICE_PUBLIC_DESCRIPTION | varchar(255)            | YES  |     | NULL                |                             |
# | AUTHENTICATION_NOTE        | varchar(255)            | YES  |     | NULL                |                             |
# | GENERAL_NOTE               | mediumtext              | YES  |     | NULL                |                             |
# | INTERNAL_DESCRIPTION       | varchar(255)            | YES  |     |                     |                             |
# | TARGET_PARSER_PROGRAM      | varchar(50)             | YES  |     | NULL                |                             |
# | PARSE_PARAM                | text                    | YES  |     | NULL                |                             |
# | TARGET_DISPLAYER_PROGRAM   | varchar(50)             | YES  |     |                     |                             |
# | PROXY_ENABLED              | int(1)                  | NO   |     | 0                   |                             |
# | OBJECT_LOOKUP              | enum('Y','N','INHERIT') | NO   | MUL | INHERIT             |                             |
# | CROSSREF_ENABLED           | enum('INHERIT','NO')    | NO   |     | INHERIT             |                             |
# | THRESHOLD                  | text                    | NO   |     | NULL                |                             |
# | AUTO_UPDATE                | enum('Y','N')           | NO   |     | N                   |                             |
# | OWNER                      | varchar(100)            | NO   |     |                     |                             |
# | AVAILABLE_FOR              | varchar(100)            | NO   |     |                     |                             |
# | CREATION_DATE              | timestamp               | NO   |     | 0000-00-00 00:00:00 |                             |
# | CREATED_BY                 | varchar(255)            | NO   |     |                     |                             |
# | LAST_UPDATE_DATE           | timestamp               | NO   |     | CURRENT_TIMESTAMP   | on update CURRENT_TIMESTAMP |
# | LAST_UPDATED_BY            | varchar(255)            | NO   |     |                     |                             |
# +----------------------------+-------------------------+------+-----+---------------------+-----------------------------+
module Sfx4
  module Local
    module LclServiceLinkingInfo
      def self.included(klass)
        klass.class_eval do
          self.table_name = 'LCL_SERVICE_LINKING_INFO'
          self.primary_key = 'INTERNAL_ID'
        end
      end
    end
  end
end
