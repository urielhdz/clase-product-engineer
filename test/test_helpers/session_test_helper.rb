module SessionTestHelper
  def mock_github_auth(uid: 583231, nickname: "octocat", name: "The Octocat", email: "octocat@github.com",
                       image: "https://avatars.githubusercontent.com/u/583231")
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      provider: "github",
      uid: uid.to_s,
      info: { nickname: nickname, name: name, email: email, image: image }
    )
  end

  def sign_in_with_github(**attributes)
    mock_github_auth(**attributes)
    post "/auth/github"
    follow_redirect!
  end
end
