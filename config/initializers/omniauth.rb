# Sign in with GitHub. Credentials come from ENV (Kamal, compose) or, when blank, Rails credentials:
#   github:
#     client_id: ...
#     client_secret: ...
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github,
    ENV["GITHUB_CLIENT_ID"].presence || Rails.application.credentials.dig(:github, :client_id),
    ENV["GITHUB_CLIENT_SECRET"].presence || Rails.application.credentials.dig(:github, :client_secret),
    scope: "read:user,user:email"
end

OmniAuth.config.logger = Rails.logger
# Send OAuth errors (e.g. the user cancels on GitHub) to /auth/failure instead of raising in development.
OmniAuth.config.on_failure = proc { |env| OmniAuth::FailureEndpoint.new(env).redirect_to_failure }
