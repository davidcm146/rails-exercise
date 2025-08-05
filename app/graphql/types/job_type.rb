# frozen_string_literal: true

module Types
  class JobType < Types::BaseObject
    field :id, ID, null: false
    field :title, String
    field :status, Integer
    field :published_date, GraphQL::Types::ISO8601DateTime
    field :share_link, String
    field :salary_from, Integer
    field :salary_to, Integer
    field :created_by_id, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
