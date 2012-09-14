# +--------------------------+-------------------------------------------------------------------------------------------------+------+-----+------------------------+-----------------------------+
# | Field                    | Type                                                                                            | Null | Key | Default                | Extra                       |
# +--------------------------+-------------------------------------------------------------------------------------------------+------+-----+------------------------+-----------------------------+
# | OP_ID                    | bigint(20) unsigned                                                                             | NO   | PRI | NULL                   | auto_increment              |
# | TARGET_ID                | bigint(20) unsigned                                                                             | NO   | MUL | NULL                   |                             |
# | TARGET_SERVICE_ID        | bigint(20) unsigned                                                                             | NO   | MUL | NULL                   |                             |
# | OBJECT_ID                | bigint(20) unsigned                                                                             | NO   | MUL | NULL                   |                             |
# | TARGET_PARSER_PROGRAM    | varchar(50)                                                                                     | YES  |     | NULL                   |                             |
# | PARSE_PARAM              | text                                                                                            | YES  | MUL | NULL                   |                             |
# | DESCRIPTION              | varchar(255)                                                                                    | YES  |     |                        |                             |
# | KB_INTERNAL_DESCRIPTION  | mediumtext                                                                                      | YES  |     | NULL                   |                             |
# | LINKING_LEVEL            | enum('ARTICLE','ARTICLE_DOI','ISSUE','VOLUME','JOURNAL','CITATION','BOOK','DATABASE','INHERIT') | NO   |     | INHERIT                |                             |
# | THRESHOLD                | varchar(2048)                                                                                   | YES  |     | NULL                   |                             |
# | OWNER                    | varchar(100)                                                                                    | NO   |     |                        |                             |
# | AVAILABLE_FOR            | varchar(100)                                                                                    | NO   |     |                        |                             |
# | STATUS                   | enum('ACTIVE','WITHDRAWN')                                                                      | YES  |     | ACTIVE                 |                             |
# | STATUS_DATE              | timestamp                                                                                       | NO   |     | 0000-00-00 00:00:00    |                             |
# | DISTRIBUTION_STATUS      | enum('READY FOR DISTRIBUTION','NOT FOR DISTRIBUTION')                                           | YES  |     | READY FOR DISTRIBUTION |                             |
# | DISTRIBUTION_STATUS_DATE | timestamp                                                                                       | NO   |     | 0000-00-00 00:00:00    |                             |
# | CREATION_DATE            | timestamp                                                                                       | NO   |     | 0000-00-00 00:00:00    |                             |
# | CREATED_BY               | varchar(255)                                                                                    | NO   |     |                        |                             |
# | LAST_UPDATE_DATE         | timestamp                                                                                       | NO   |     | CURRENT_TIMESTAMP      | on update CURRENT_TIMESTAMP |
# | LAST_UPDATED_BY          | varchar(255)                                                                                    | NO   |     |                        |                             |
# | VERSION_NUMBER           | int(10)                                                                                         | NO   |     | 1                      |                             |
# | RELEASE_NUMBER           | int(10)                                                                                         | NO   |     | 1                      |                             |
# | CRUD_TYPE                | enum('CREATE','UPDATE','DELETE')                                                                | NO   |     | CREATE                 |                             |
# +--------------------------+-------------------------------------------------------------------------------------------------+------+-----+------------------------+-----------------------------+
module Sfx4
  module Global
    class KbObjectPortfolio < ActiveRecord::Base
      self.table_name = 'KB_OBJECT_PORTFOLIOS'
      self.primary_key = 'OP_ID'
      self.establish_connection :sfx_global
    end
  end
end
