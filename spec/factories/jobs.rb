FactoryBot.define do
  factory :job do
    title { Faker::Job.title }
    salary_from { 1000 }
    salary_to { 2000 }
    status { Job.statuses.values.sample }
    share_link { SecureRandom.hex(10) }
    association :created_by, factory: :user
  end
end
