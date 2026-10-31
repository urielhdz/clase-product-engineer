class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create failure ]

  def new
    redirect_to root_path if authenticated?
  end

  def create
    user = User.from_omniauth(request.env["omniauth.auth"])
    start_new_session_for user
    redirect_to after_authentication_url, notice: "Sesión iniciada como #{user.login}."
  end

  def failure
    redirect_to new_session_path, alert: "No se pudo iniciar sesión con GitHub. Inténtalo de nuevo."
  end

  def destroy
    terminate_session
    redirect_to new_session_path, notice: "Sesión cerrada.", status: :see_other
  end
end
