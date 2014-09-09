# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Administrator User
user = User.new(
        first_name: 'Administrator',
        last_name: 'User',
        email: 'admin@example.com',
        password: 'admin',
        public: false,
        role: User.roles[:admin],
       )
user.save!(:validate => false)
