# +-----------------------+---------------------+------+-----+---------------------+-----------------------------+
# | Field                 | Type                | Null | Key | Default             | Extra                       |
# +-----------------------+---------------------+------+-----+---------------------+-----------------------------+
# | INTERNAL_ID           | bigint(20) unsigned | NO   | PRI | NULL                | auto_increment              |
# | OP_ID                 | bigint(20) unsigned | NO   | MUL | NULL                |                             |
# | AUTHENTICATION_NOTE   | varchar(255)        | YES  |     | NULL                |                             |
# | GENERAL_NOTE          | mediumtext          | YES  |     | NULL                |                             |
# | INTERNAL_DESCRIPTION  | varchar(255)        | YES  |     |                     |                             |
# | TARGET_PARSER_PROGRAM | varchar(50)         | YES  |     |                     |                             |
# | PARSE_PARAM           | text                | YES  |     | NULL                |                             |
# | THRESHOLD             | varchar(2048)       | YES  |     | NULL                |                             |
# | PROXY_ENABLED         | int(1)              | NO   |     | 0                   |                             |
# | OWNER                 | varchar(100)        | NO   |     |                     |                             |
# | AVAILABLE_FOR         | varchar(100)        | NO   |     |                     |                             |
# | CREATION_DATE         | timestamp           | NO   |     | 0000-00-00 00:00:00 |                             |
# | CREATED_BY            | varchar(255)        | NO   |     |                     |                             |
# | LAST_UPDATE_DATE      | timestamp           | NO   |     | CURRENT_TIMESTAMP   | on update CURRENT_TIMESTAMP |
# | LAST_UPDATED_BY       | varchar(255)        | NO   |     |                     |                             |
# +-----------------------+---------------------+------+-----+---------------------+-----------------------------+
module Sfx4
  module Local
    module LclObjectPortfolioLinkingInfo
      def self.included(klass)
        klass.class_eval do
          self.table_name = 'LCL_OBJECT_PORTFOLIO_LINKING_INFO'
          self.primary_key = 'INTERNAL_ID'
        end
      end
    end
  end
end
