module Authentication
  class RegistrationForm
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :email, :string
    attribute :full_name, :string
    attribute :password, :string
    attribute :password_confirmation, :string

    attr_reader :user

    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validate :email_uniqueness
    validates :full_name, presence: true
    validates :password, presence: true, confirmation: true, length: { minimum: 6 }

    def save
      return false unless valid?

      @user = User.new(
        email: email,
        full_name: full_name,
        password: password
      )
      @user.save
    end

    private

    def email_uniqueness
      return unless User.exists?(email: email)

      errors.add(:email, 'has already been taken')
    end
  end
end
