Feature: assessment event form core follow ups

  To allow for a more relevant event form
  An investigator should see core follow ups configured on a moridity form

  Scenario: assessment event core follow ups
    Given I am logged in as a super user
    And a assessment event form exists
    And that form has core follow ups configured for all core fields
    And that form is published
    And a assessment event exists with a disease that matches the form
    And I am on the assessment event edit page
    And I don't see any of the core follow up questions
#    TODO Jay Core follow ups are broken, the form does not properly 
#    display on the investigation tab
#    When I answer all of the core follow ups with a matching condition
#    Then I should see all of the core follow up questions

#   When I answer all core follow up questions
#    And I save and continue
#    Then I should see all of the core follow up questions
#    And I should see all follow up answers

#    When I am on the assessment event edit page
#    And I answer all of the core follow ups with a non-matching condition
#    Then I should not see any of the core follow up questions
#    And I should not see any follow up answers

#    When I save and continue
#    Then I should not see any of the core follow up questions
#    And I should not see any follow up answers

