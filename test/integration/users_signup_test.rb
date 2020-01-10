require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  # 無効なデータを与えても登録ユーザ数が変わらないことを確認する 
  test "invalid signup information" do
    # ユーザー登録ページにアクセス
    get signup_path
    # それぞれ無効な値でPOSTリクエストを送信     
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    # POSTが失敗すると new actionが再描画される   
    assert_template 'users/new'
    assert_select 'form[action="/signup"]'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end
  
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
  end

end