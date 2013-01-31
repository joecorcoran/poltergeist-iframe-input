# Poltergeist iframe form submission demo

Trying to work out why the form inside the iframe is not being submitted.

```
$ bundle
$ rake cucumber
```

Output:

```
Using the default profile...
Rack::File headers parameter replaces cache_control after Rack 1.5.
Feature: As some guy
  I want to create a new post
  So I can post

  Scenario: Creating a new post without the lightbox # features/posts/creating_a_post.feature:5
    Given I am on the posts index                    # features/step_definitions/post_steps.rb:1
    When I follow "Write a post"                     # features/step_definitions/post_steps.rb:5
    And I write a post                               # features/step_definitions/post_steps.rb:17
    Then a post should have been saved               # features/step_definitions/post_steps.rb:23

  @javascript
  Scenario: Creating a new post in a lightbox # features/posts/creating_a_post.feature:12
    Given I am on the posts index             # features/step_definitions/post_steps.rb:1
    When I follow "Write a post"              # features/step_definitions/post_steps.rb:5
    And I write a post in the lightbox        # features/step_definitions/post_steps.rb:9
    Then a post should have been saved        # features/step_definitions/post_steps.rb:23
      <1> expected but was
      <0>. (MiniTest::Assertion)
      ./features/step_definitions/post_steps.rb:24:in `/^a post should have been saved$/'
      features/posts/creating_a_post.feature:16:in `Then a post should have been saved'

Failing Scenarios:
cucumber features/posts/creating_a_post.feature:12 # Scenario: Creating a new post in a lightbox

2 scenarios (1 failed, 1 passed)
8 steps (1 failed, 7 passed)
0m4.584s
```

[Step definitions:](https://github.com/joecorcoran/poltergeist-iframe-input/blob/master/features/step_definitions/post_steps.rb).

```ruby
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

When /^I write a post$/ do
  fill_in 'post_title', :with => 'My post'
  fill_in 'post_body', :with => 'Great post body'
  click_button 'Create Post'
end

Then /^a post should have been saved$/ do
  assert_equal 1, Post.count
end
```

When I turn debug on, I can see phantomjs entering the iframe and filling in the form...

```
{"response"=>{"page_id"=>1, "ids"=>[]}}
{"name"=>"find", "args"=>[".//*[contains(concat(' ', @class, ' '), ' lightbox ')]//iframe"]}
{"response"=>{"page_id"=>1, "ids"=>[1]}}
{"name"=>"visible", "args"=>[1, 1]}
{"response"=>true}
{"name"=>"attribute", "args"=>[1, 1, "name"]}
{"response"=>"1359653466863"}
{"name"=>"push_frame", "args"=>["1359653466863"]}
{"response"=>true}
{"name"=>"find", "args"=>[".//*[self::input | self::textarea][not(./@type = 'submit' or ./@type = 'image' or ./@type = 'radio' or ./@type = 'checkbox' or ./@type = 'hidden' or ./@type = 'file')][((./@id = 'post_title' or ./@name = 'post_title') or ./@id = //label[normalize-space(string(.)) = 'post_title']/@for)] | .//label[normalize-space(string(.)) = 'post_title']//.//*[self::input | self::textarea][not(./@type = 'submit' or ./@type = 'image' or ./@type = 'radio' or ./@type = 'checkbox' or ./@type = 'hidden' or ./@type = 'file')]"]}
{"response"=>{"page_id"=>1, "ids"=>[0]}}
{"name"=>"visible", "args"=>[1, 0]}
{"response"=>true}
{"name"=>"tag_name", "args"=>[1, 0]}
{"response"=>"INPUT"}
{"name"=>"attribute", "args"=>[1, 0, "type"]}
{"response"=>"text"}
{"name"=>"set", "args"=>[1, 0, "My post"]}
{"response"=>true}
{"name"=>"find", "args"=>[".//*[self::input | self::textarea][not(./@type = 'submit' or ./@type = 'image' or ./@type = 'radio' or ./@type = 'checkbox' or ./@type = 'hidden' or ./@type = 'file')][((./@id = 'post_body' or ./@name = 'post_body') or ./@id = //label[normalize-space(string(.)) = 'post_body']/@for)] | .//label[normalize-space(string(.)) = 'post_body']//.//*[self::input | self::textarea][not(./@type = 'submit' or ./@type = 'image' or ./@type = 'radio' or ./@type = 'checkbox' or ./@type = 'hidden' or ./@type = 'file')]"]}
{"response"=>{"page_id"=>1, "ids"=>[1]}}
{"name"=>"visible", "args"=>[1, 1]}
{"response"=>true}
{"name"=>"tag_name", "args"=>[1, 1]}
{"response"=>"INPUT"}
{"name"=>"attribute", "args"=>[1, 1, "type"]}
{"response"=>"text"}
{"name"=>"set", "args"=>[1, 1, "Great post body"]}
{"response"=>true}
{"name"=>"find", "args"=>[".//input[./@type = 'submit' or ./@type = 'image' or ./@type = 'button'][((./@id = 'Create Post' or ./@value = 'Create Post') or ./@title = 'Create Post')] | .//input[./@type = 'image'][./@alt = 'Create Post'] | .//button[(((./@id = 'Create Post' or ./@value = 'Create Post') or normalize-space(string(.)) = 'Create Post') or ./@title = 'Create Post')] | .//input[./@type = 'image'][./@alt = 'Create Post']"]}
{"response"=>{"page_id"=>1, "ids"=>[2]}}
{"name"=>"visible", "args"=>[1, 2]}
{"response"=>true}
{"name"=>"click", "args"=>[1, 2]}
{"response"=>{"x"=>47.5, "y"=>168}}
{"name"=>"pop_frame", "args"=>[]}
```

...but the form is never submitted.