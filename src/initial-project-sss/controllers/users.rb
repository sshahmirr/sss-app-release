class UserController
  def get_all_users
    users = User.all
    if users.empty?
      puts 'no users found!'
    else 
      users
    end
  end

  def get_user(user_id)
    user = User.find_by_id(user_id)
    if user.nil?
      'user not found!'
    else
      user
    end
  end

  def create_user(user_data)
    new_user = User.new(name: user_data['name'], created_at: Time.now)
    # Saving the user in DB
    if new_user.save
      # Returning the newly created user object
      new_user
    else
      false
    end
  end
end
