Feature: Shopping

  In order to read a new book
  As a customer
  I want to buy a book from the store

  Scenario: purchase a single book
    Given a user on the index page
    When user adds a product to their shopping cart
    And fills in their details on the checkout form
    Then an order is created for the user with a line item corresponding to their selected product
