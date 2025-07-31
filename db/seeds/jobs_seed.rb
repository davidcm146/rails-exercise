user = User.first || User.create!(email: "default@example.com", password: "password", full_name: "Default User")

Job.create!([
  {
    title: "Senior Developer",
    status: 1, # ví dụ: 0 - draft, 1 - published
    published_date: Time.current,
    share_link: "https://example.com/senior-dev",
    salary_from: 1500,
    salary_to: 3000,
    created_by_id: user.id
  },
  {
    title: "Junior Developer",
    status: 0,
    published_date: nil,
    share_link: "https://example.com/junior-dev",
    salary_from: 500,
    salary_to: 1000,
    created_by_id: user.id
  }
])
