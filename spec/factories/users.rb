FactoryBot.define do
  factory :user do
    full_name { Faker::Name }
    email { Faker::Internet.unique.email }
    password { 'password' }
    password_confirmation { password }
  end
end
