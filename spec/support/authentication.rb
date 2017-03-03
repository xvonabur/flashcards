# frozen_string_literal: true
module AuthenticationForFeatureSpecs
  def login(user, password = 'login')
    user.update_attributes password: password

    page.driver.post home_user_sessions_url,
                     { user_session: { email: user.email, password: password } }
    visit root_url
  end
end
