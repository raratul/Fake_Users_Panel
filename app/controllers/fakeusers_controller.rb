class FakeusersController < ApplicationController
  def index
    @user = User.all
    session[:i] ||= 0
  end

  def fake_users_generator
    seed = params[:seed].to_i || Random.new_seed
    region = params[:region] || 'en'
    error_value = params[:error_value].to_f

    session[:i] = 0 if params[:scroll] == 'false'

    set_locale(region)

    num_user = params[:scroll] == 'true' ? 10 : 20
    users = generate_fake_users(num_user, seed, error_value)

    render json: users
  end

  private

  def set_locale(region)
    case region
    when 'Poland'
      Faker::Config.locale = 'pl'
    when 'USA'
      Faker::Config.locale = 'en-US'
    when 'UK'
      Faker::Config.locale = 'en-GB'
    else
      Faker::Config.locale = 'en'
    end
  end

  def generate_fake_users(num_users, seed, error_value)
    faker_rand = Random.new(seed)
    Faker::UniqueGenerator.clear
    Faker::Config.random = faker_rand
    users = []

    num_users.times do
      if error_value != 0 && rand(0..10) < error_value
        name = Faker::Name.name
        modified_name = modify_string(name, error_value)
        address = Faker::Address.full_address
        modified_address = modify_string(address, error_value)
        phone = Faker::PhoneNumber.phone_number
        modified_phone = modify_string(phone, error_value)

        users << {
          id: session[:i] + 1,
          name: modified_name,
          address: modified_address,
          phone: modified_phone,
          identifier: Faker::Alphanumeric.alphanumeric(number: 10)
        }
      else
        users << {
          id: session[:i] + 1,
          name: Faker::Name.name,
          address: Faker::Address.full_address,
          phone: Faker::PhoneNumber.phone_number,
          identifier: Faker::Alphanumeric.alphanumeric(number: 10)
        }
      end

      session[:i] += 1
    end

    users
  end

  def modify_string(string, error_value)
    if rand(0..error_value) < error_value
      num_modifications = (error_value / 10).to_i + 1
      num_modifications.times do
        index = rand(string.length)
        random_letter = Faker::Lorem.characters(number: 1)
        if rand(0..1) == 1
          string[index] = random_letter.upcase
        else
          string[index] = random_letter.downcase
        end
      end
    end

    string
  end
end
