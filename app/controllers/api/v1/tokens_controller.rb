class Api::V1::TokensController < Api::V1::ApplicationController
  def create
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      if user.activated?
        @token = User.new_token(urlsafe: false)
        user.update_attribute(:api_digest, User.digest(@token))
        @current_user = user
        render status: 201
      else
        render(
          json: { error: "Account not activated. Check your email for the
          activation link." },
          status: 401
        )
      end
    else
      render(
        json: { error: "Invalid email/password combination" },
        status: 401
      )
    end
  end
end
