require 'spec_helper'
require_relative './helpers/session'

include SessionHelpers


feature "User signs up" do
  
  scenario "when being logged out" do
    lambda { sign_up }.should change(User, :count).by(1)
    expect(page).to have_content("Welcome, alice@example.com")
    expect(User.first.email).to eq("alice@example.com")
  end

  scenario "with a password that doesn't match" do
    lambda { sign_up('a@a.com', 'pass', 'wrong') }.should change(User, :count).by(0)
    expect(current_path).to eq('/users')  
    expect(page).to have_content("Password does not match the confirmation")
  end

  scenario "with an email that is already registered" do
    lambda { sign_up }.should change(User, :count).by(1)
    lambda { sign_up }.should change(User, :count).by(0)
    expect(page).to have_content("This email is already taken")
  end
end


feature "User signs in" do

  before(:each) do
    User.create(:email => "test@test.com",
                :password => 'test',
                :password_confirmation => 'test'
                )
  end

    scenario "with correct credentials" do
      visit '/'
      expect(page).not_to have_content("Welcome, test@test.com")
      sign_in('test@test.com', 'test')
      expect(page).to have_content("Welcome, test@test.com")
    end

    scenario "with incorrect credentials" do
      visit '/'
      expect(page).not_to have_content("Welcome, test@test.com")
      sign_in('test@test.com', 'wrong')
      expect(page).not_to have_content("Welcome, test@test.com")
    end
end


feature 'User signs out' do

  before(:each) do
    User.create(:email => "test@test.com", 
                :password => 'test', 
                :password_confirmation => 'test')
  end

    scenario 'while being signed in' do
      sign_in('test@test.com', 'test')
      click_button "Sign out"
      expect(page).to have_content("Good bye!")
      expect(page).not_to have_content("Welcome, test@test.com")
    end

end


feature 'User forgets password' do

  before(:each) do
    User.create(:email => "test@test.com", 
                :password => 'test',
                :password_confirmation => 'test'
                )
  end

  scenario 'and recovers it' do
    visit '/users/forgotten_pwd'
    fill_in('email', :with => 'test@test.com')
    click_button "Retrieve password"
    expect(page).to have_content("Your password has been sent to your email")
    visit '/users/reset_password/' + User.first.password_token # /users/reset_password/t8t8134r1ddad7f8hrwhfkjasd
    fill_in('password', :with => 'new_password')
    fill_in('password_confirmation', :with => 'new_password')
    click_button "Reset password"
    expect(page).to have_content("Thank you, your password has been reset")
    sign_in('test@test.com', 'new_password')
    expect(page).to have_content("Welcome, test@test.com")
  end

end

