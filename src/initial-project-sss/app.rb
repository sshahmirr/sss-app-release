require 'sinatra'
require 'sinatra/activerecord'
require 'json'

require_relative 'controllers/users'

puts 'app has started'

# Defining the data model
class User < ActiveRecord::Base
  self.table_name = 'users'
end

database_url = ENV['DATABASE_URL']
DB = ActiveRecord::Base.establish_connection(database_url)
# DB = ActiveRecord::Base.establish_connection(
#   adapter: 'postgresql',
#   database: 'postgres',
#   host: 'localhost',
#   username: 'postgres',
#   password: 'mysecretpassword'
# )

if DB.nil?
  puts 'connection to DB not established'
else
  puts 'connection to DB established successfully'
end

# Creating tables
ActiveRecord::Base.connection.create_table(:users, primary_key: 'id', force: true) do |t|
  t.string :name
  t.string :created_at
end

# Creating some records to populate the Users table on starting
User.create(name: 'Michael Scott', created_at: Time.now)
User.create(name: 'Andy Bernard', created_at: Time.now)

# Creating the User Controller
userController = UserController.new

get '/' do
  'Welcome to the application!'
end

# Endpoint to get a list of users
get '/users' do
  puts 'returning users from controller function!'
  all_users = userController.get_all_users
  if all_users.length > 0
    { users: all_users }.to_json
  else
    'No users found in the system'
  end
end

# Endpoint to get a specific user
get '/users/:id' do
  user_id = params['id']
  userController.get_user(user_id).to_json
end

# Endpoint to create a new user
post '/users' do
  payload = JSON.parse(request.body.read)
  user_created = userController.create_user(payload)
  if user_created
    user_created.to_json
  else
    'Unable to create a user'
  end
end
