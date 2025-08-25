module Users
  class UserForm
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :full_name, :string
    attribute :avatar

    attr_reader :params, :user

    validates :full_name, presence: true

    def initialize(user, params = {})
      @user = user
      @params = params
      # super(params) automatically called by ActiveModel::Attributes and assigns attributes variable
    end

    def user_attributes
      @params.except(:avatar).compact_blank
    end

    def save
      return false unless valid?

      if avatar.present?
        @user.avatar.purge
        @user.avatar.attach(avatar)
      end
      @user.assign_attributes(user_attributes)
      @user.save
    end
  end
end
