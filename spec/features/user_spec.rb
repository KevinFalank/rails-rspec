require 'spec_helper'

feature 'User browsing the website' do

  before(:each) do
    Post.create(title: "Hello", content: "I'm here!")
    Post.create(title: "Hola", content: "Yo estoy aqui!")
  end

  context "on homepage" do
    it "sees a list of recent posts titles" do
      visit root_url
      page.should have_content "Hola"
    end

    it "can click on titles of recent posts and should be on the post show page" do
      visit root_url
      click_link "Hello"
      page.should have_content "I'm here!"
    end
  end

  context "post show page" do
    it "sees title and body of the post" do
      visit root_url
      click_link "Hola"
      page.should have_content "Hola Yo estoy aqui!"
    end
  end
end
