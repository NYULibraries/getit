# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(
  username: 'xx123',
  email: 'xx123@nyu.edu',
  firstname: 'Charley',
  lastname: 'Matthew',
  provider: 'nyulibraries',
  aleph_id: 'N000000000',
  institution_code: 'NYU',
  patron_status: '51',
  barcode: '12345'
)
