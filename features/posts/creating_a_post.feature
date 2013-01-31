Feature: As some guy
  I want to create a new post
  So I can post

  Scenario: Creating a new post without the lightbox
    Given I am on the posts index
    When I follow "Write a post"
    And I write a post
    Then a post should have been saved

  @javascript
  Scenario: Creating a new post in a lightbox, using jQuery
    Given I am on the posts index
    When I follow "Write a post"
    And I write a post in the lightbox using jQuery
    Then a post should have been saved

  @javascript
  Scenario: Creating a new post in a lightbox
    Given I am on the posts index
    When I follow "Write a post"
    And I write a post in the lightbox
    Then a post should have been saved