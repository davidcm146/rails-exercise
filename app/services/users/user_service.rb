module Users
  class UserService
    class UpdateProfileService
      def initialize(current_user:, params: {})
        @current_user = current_user
        @params = params
      end

      def call
        form = UserForm.new(@current_user, @params)
        return ResultService.failure(form.errors) unless form.save

        ResultService.success(form.user)
      end
    end
  end
end
