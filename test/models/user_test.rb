require "test_helper"

class UserTest < ActiveSupport::TestCase
  def github_auth(uid:, nickname:, name: nil, email: nil, image: nil)
    OmniAuth::AuthHash.new(uid: uid.to_s, info: { nickname: nickname, name: name, email: email, image: image })
  end

  test "from_omniauth crea un usuario nuevo con los datos de GitHub" do
    assert_difference "User.count", 1 do
      user = User.from_omniauth(github_auth(uid: 1, nickname: "mona", name: "Mona", email: "mona@example.com", image: "https://example.com/mona.png"))

      assert_equal 1, user.github_id
      assert_equal "mona", user.login
      assert_equal "Mona", user.name
      assert_equal "mona@example.com", user.email
      assert_equal "https://example.com/mona.png", user.avatar_url
    end
  end

  test "from_omniauth actualiza al usuario existente por github_id aunque cambie su login" do
    octocat = users(:octocat)

    assert_no_difference "User.count" do
      user = User.from_omniauth(github_auth(uid: octocat.github_id, nickname: "octocat-renamed", name: "Octo"))

      assert_equal octocat, user
      assert_equal "octocat-renamed", user.reload.login
      assert_equal "Octo", user.name
    end
  end

  test "requiere github_id único y login" do
    user = User.new(github_id: users(:octocat).github_id)

    assert_not user.valid?
    assert user.errors.of_kind?(:github_id, :taken)
    assert user.errors.of_kind?(:login, :blank)
  end

  test "display_name usa el nombre y, si no hay, el login" do
    assert_equal "The Octocat", users(:octocat).display_name
    assert_equal "hubot", users(:hubot).display_name
  end

  test "al eliminar un usuario se eliminan sus sesiones" do
    assert_difference "Session.count", -1 do
      users(:octocat).destroy
    end
  end
end
