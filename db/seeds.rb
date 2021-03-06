# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# Create a user
User.create!( name: 'Jason Ball',
              email: 'jasonlukeball@me.com',
              password: 'password',
              password_confirmation: 'password',
              admin: true,
              activated: true,
              activated_at: Time.zone.now )

# Create another 99 users
99.times do |i|

  name      = Faker::Name.name
  email     = "example-#{i+1}@example.com"
  password  = 'password'
  User.create!(   name: name,
                  email: email,
                  password: password,
                  password_confirmation: password,
                  activated: true,
                  activated_at: Time.zone.now )
end

# Create 50 microposts for the first 6 users
# Get 6 users
users = User.order(:created_at).take(6)

# Create 50 microposts for each of the first 6 users
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content)}
end


# Following relationships
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }