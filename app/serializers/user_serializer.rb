class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :email, :full_name, :avatar

  def avatar
    object.avatar.attached? ? rails_blob_url(object.avatar, only_path: true) : nil
  end
end
