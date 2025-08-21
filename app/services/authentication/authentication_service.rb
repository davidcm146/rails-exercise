module Authentication
  class AuthenticationService
    class LoginService
      def initialize(params)
        @params = params
      end

      def call
        form = Authentication::LoginForm.new(@params)
        return ResultService.failure(form.errors) unless form.valid?

        user = User.find_by(email: form.email)
        unless user&.authenticate(form.password)
          form.errors.add(:base, 'Invalid email or password')
          return ResultService.failure(form.errors)
        end

        token = JsonWebToken.encode(user_id: user.id)
        ResultService.success(token)
      end
    end

    class RegisterService
      def initialize(params)
        @params = params
      end

      def call
        form = Authentication::RegistrationForm.new(@params)
        return ResultService.failure(form.errors) unless form.save

        ResultService.success(form.user)
      end
    end
  end
end
