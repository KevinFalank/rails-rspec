require 'spec_helper'

feature 'Admin panel' do

  before(:each) do
    page.driver.browser.authorize "geek", "jock"
  end

  context "on admin homepage" do
    it "can see a list of recent posts" do
      post = Post.new(title: "more postings", content: "More fancy things")
      post.save
      visit admin_posts_url
      page.should have_content "More Postings"
    end

    it "can edit a post by clicking the edit link next to a post" do
      post = Post.create(title: "more postings", content: "More fancy things")
      visit admin_posts_url
      click_link "Edit"
      expect(page).to have_content "Content:"
    end

    it "can delete a post by clicking the delete link next to a post" do
      post = Post.create(title: "more postings", content: "More fancy things")
      visit admin_posts_url
      click_link "Delete"
      expect(page).to have_no_content("More Postings")
    end

    it "can create a new post and view it" do
       visit new_admin_post_url

       expect {
         fill_in 'post_title',   with: "Hello world!"
         fill_in 'post_content', with: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat."
         page.check('post_is_published')
         click_button "Save"
       }.to change(Post, :count).by(1)

       page.should have_content "Published: true"
       page.should have_content "Post was successfully saved."
     end
  end

  context "editing post" do
    it "can mark an existing post as unpublished" do
      post = Post.create(title: "more postings", content: "More fancy things", is_published: true)
      visit admin_posts_url
      click_link "Edit"
      page.uncheck("post[is_published]")
      click_button "Save"
      page.should have_content "Published: false"
    end
  end

  context "on post show page" do
    it "can visit a post show page by clicking the title" do
      #can't be done!
      post = Post.create(title: "more postings", content: "More fancy things", is_published: true)
      visit admin_posts_url
      click_link "More Postings"
      page.should have_content "More Postings"
    end

    it "can see an edit link that takes you to the edit post path" do
      post = Post.create(title: "more postings", content: "More fancy things", is_published: true)
      visit admin_post_url(post.id)
      page.should have_content "Edit"
    end

    it "can go to the admin homepage by clicking the Admin welcome page link" do
      post = Post.create(title: "more postings", content: "More fancy things", is_published: true)
      visit admin_post_url(post.id)
      click_link "Admin welcome page"
      page.should have_content "Welcome to the admin panel!"
    end
  end
end
