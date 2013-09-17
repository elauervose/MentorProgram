def sign_in(admin)
  visit admin_sign_in_path
  fill_in "Email", with: admin.email
  fill_in "Password", with: admin.password
  click_button "Sign in"
end
