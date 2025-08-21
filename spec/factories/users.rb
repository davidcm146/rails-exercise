FactoryBot.define do
  factory :user do
    full_name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { 'password' }
    password_confirmation { password }
    trait :with_avatar do
      after(:build) do |user|
        user.avatar.attach(
          io: File.open(Rails.root.join('spec/factories/files/shutup.jpg')),
          filename: 'shutup.jpg',
          content_type: 'image/jpg'
        )
      end
    end
  end
end
