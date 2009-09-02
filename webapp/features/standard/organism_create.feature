Feature: Creating Organisms

  To respond quickly to changes in health care
  Administrators need to be able to add organisms to the system

  Scenario: An administrator creates an organism
    Given I am logged in as a super user
    When I go to the new organism page
      And I fill in "Organism name" with "Arbovirus"
      And I press "Create"
    Then I should be on the "Arbovirus" organism page

  Scenario: An investigator cannot create an organism
    Given I am logged in as an investigator
    When I go to the the new organism page
    Then I should get a 403 response