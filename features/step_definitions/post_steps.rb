Given /^I am on the posts index$/ do
  visit(posts_path)
end

When /^I follow "(.+)"$/ do |text|
  click_link(text)
end

When /^I write a post in the lightbox$/ do
  within_frame(find('.lightbox iframe')[:name]) do
    fill_in 'post_title', :with => 'My post'
    fill_in 'post_body', :with => 'Great post body'
    click_button 'Create Post'
  end
end

When /^I write a post in the lightbox using jQuery$/ do
  within_frame(find('.lightbox iframe')[:name]) do
    page.execute_script("$('#post_title').val('My post')")
    page.execute_script("$('#post_body').val('Great post body')")
    click_button 'Create Post'
  end
end

When /^I write a post$/ do
  fill_in 'post_title', :with => 'My post'
  fill_in 'post_body', :with => 'Great post body'
  click_button 'Create Post'
end

Then /^a post should have been saved$/ do
  assert_equal 1, Post.count
end