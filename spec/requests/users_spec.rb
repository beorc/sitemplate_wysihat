require 'spec_helper'

describe "Users" do
  def sign_in(user)
    visit user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: 'please'
    click_on 'Sign in'
  end

  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  it 'can edit text', js: true do
    visit user_path(@user)

    content = 'Test input'
    page.execute_script( "$('.editor:first').html('#{content}')" )
    find('.button.save').click
    find('p.first').text.should == content
  end
end
