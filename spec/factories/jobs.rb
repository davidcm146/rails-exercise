FactoryBot.define do
  factory :job do
    title { 'Senior Ruby on Rails' }
    salary_from { 1000 }
    salary_to { 2000 }
    status { :draft }
    share_link { SecureRandom.hex(10) }
    association :created_by, factory: :user
  end
end
