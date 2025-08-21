module Authentication
  class LoginForm
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :email, :string
    attribute :password, :string

    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, presence: true
  end
end
