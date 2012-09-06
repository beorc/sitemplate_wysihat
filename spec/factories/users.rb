# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :role do
    name 'member'
  end

  factory :user, :class => 'User' do |user|
    name 'user'
    email 'beorc@httplab.com'
    password 'please'
    password_confirmation 'please'
    after(:create) do |user|
      FactoryGirl.create_list(:role, 1, users: [user])
    end
  end

  factory :admin, :class => 'User' do
    name 'admin'
    email 'bairkan@gmail.com'
    password 'please'
    password_confirmation 'please'
    after(:create) do |user|
      FactoryGirl.create_list(:role, 1, name: 'admin', users: [user])
    end
  end
end
