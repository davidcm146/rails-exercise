class JobSerializer < ActiveModel::Serializer
  belongs_to :created_by, serializer: UserSerializer
  attributes :id, :title, :published_date, :salary_from, :salary_to, :status, :share_link
end
