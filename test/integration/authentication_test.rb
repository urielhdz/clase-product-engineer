require "test_helper"

class AuthenticationTest < ActionDispatch::IntegrationTest
  test "un visitante sin sesión es redirigido a /login" do
    get root_path

    assert_redirected_to new_session_path
  end

  test "la página de login muestra el botón para entrar con GitHub" do
    get new_session_path

    assert_response :success
    assert_select "form[action='/auth/github'][method='post'] button", text: /Entrar con GitHub/
  end

  test "iniciar sesión con GitHub crea el usuario y la sesión" do
    assert_difference [ "User.count", "Session.count" ], 1 do
      sign_in_with_github(uid: 999, nickname: "newbie", name: "New Bie")
    end

    assert_redirected_to root_url
    assert cookies[:session_id].present?

    follow_redirect!
    assert_response :success
    assert_select "h1", text: "Hola, New Bie"
  end

  test "iniciar sesión con un usuario existente no lo duplica y actualiza sus datos" do
    octocat = users(:octocat)

    assert_no_difference "User.count" do
      sign_in_with_github(uid: octocat.github_id, nickname: "octocat", name: "Octo Renamed")
    end

    assert_equal "Octo Renamed", octocat.reload.name
  end

  test "tras iniciar sesión vuelve a la página que intentaba visitar" do
    get root_path(foo: "bar")
    sign_in_with_github

    assert_redirected_to root_url(foo: "bar")
  end

  test "si GitHub devuelve un error vuelve a /login con un mensaje" do
    OmniAuth.config.mock_auth[:github] = :access_denied

    assert_no_difference "Session.count" do
      post "/auth/github"
      follow_redirect!
    end

    assert_redirected_to %r{/auth/failure}
    follow_redirect!
    assert_redirected_to new_session_path
    follow_redirect!
    assert_select "#alert", text: "No se pudo iniciar sesión con GitHub. Inténtalo de nuevo."
  end

  test "un usuario con sesión es redirigido de /login a /" do
    sign_in_with_github

    get new_session_path

    assert_redirected_to root_path
  end

  test "cerrar sesión elimina la sesión y la cookie" do
    sign_in_with_github

    assert_difference "Session.count", -1 do
      delete session_path
    end

    assert_redirected_to new_session_path
    assert cookies[:session_id].blank?

    get root_path
    assert_redirected_to new_session_path
  end

  test "iniciar el flujo OAuth con GET no está permitido" do
    get "/auth/github"

    assert_response :not_found
  end
end
