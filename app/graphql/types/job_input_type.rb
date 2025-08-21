module Types
  class JobInputType < Types::BaseInputObject
    graphql_name 'JobInput'

    argument :title, String, required: true
    argument :published_date, GraphQL::Types::ISO8601Date, required: false
    argument :salary_from, Integer, required: false
    argument :salary_to, Integer, required: false
    argument :status, Integer, required: true
    argument :share_link, String, required: false
  end
end
