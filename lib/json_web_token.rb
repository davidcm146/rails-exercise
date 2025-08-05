# frozen_string_literal: true

class JsonWebToken
  SECRET_KEY = ENV['JWT_SECRET'].to_s
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end

  def self.decode(token)
    body = JWT.decode(token, SECRET_KEY, algorithms: 'HS256')[0]
    HashWithIndifferentAccess.new(body)
  rescue StandardError
    nil
  end
end
