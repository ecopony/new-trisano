# Copyright (C) 2007, 2008, 2009, 2010, 2011 The Collaborative Software Foundation
#
# This file is part of TriSano.
#
# TriSano is free software: you can redistribute it and/or modify it under the
# terms of the GNU Affero General Public License as published by the
# Free Software Foundation, either version 3 of the License,
# or (at your option) any later version.
#
# TriSano is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with TriSano. If not, see http://www.gnu.org/licenses/agpl-3.0.txt.

Feature: Common tests types for lab results

  In order to simplify manual lab result entry
  Administrators need to be able to create common test types.

  Scenario: Listing common test types
    Given I am logged in as a super user
    And I have a common test type named Culture X

    When I go to the common test type index page

    Then I should see a link to "Culture X"
    And I should see "List Common Test Types"

  Scenario: Non-administrators trying to modify common test types
    Given I am logged in as an investigator
    When I go to the new common test type page
    Then I should get a 403 response

  Scenario: Creating a new common test type
    Given I am logged in as a super user

    When I go to the common test type index page
    And I press "Create New Common Test Type"

    Then I should see "Create a Common Test Type"
    And I should see a link to "< Back to Common Test Types"

    When I fill in "common_test_type_common_name" with "Culture X"
    And I press "Create"

    Then I should see "Show a Common Test Type"
    And I should see "Culture X"

  Scenario: Entering an invalid common name for common test type
    Given I am logged in as a super user
    And I have a common test type named Culture X

    When I go to the new common test type page
    And I press "Create"
    Then I should see "Common name is too short"

    When I fill in "common_test_type_common_name" with "Culture X"
    And I press "Create"
    Then I should see "Common name has already been taken"

  Scenario: Showing a common test type
    Given I am logged in as a super user
    And I have a common test type named Culture X

    When I go to the common test type show page

    Then I should see a link to "< Back to Common Test Types"
    And I should see "Culture X"

  Scenario: Changing the common name of a common test type
    Given I am logged in as a super user
    And I have a common test type named Culture X

    When I go to the common test type show page
    And I follow "Edit"
    And I fill in "common_test_type_common_name" with "Lipid Panel"
    And I press "Update"

    Then I should not see "Culture X"
    And I should see "Lipid Panel"
    And I should see "Common test type was successfully updated."

  Scenario: Changing common test type name to something invalid
    Given I am logged in as a super user
    And I have a common test type named Culture X

    When I go to edit the common test type
    And I fill in "common_test_type_common_name" with ""
    And I press "Update"
    Then I should see "Common name is too short"

  Scenario: Associating LOINC codes with a common test type by test name
    Given I am logged in as a super user
    And I have a common test type named Culture X
    And I have the following LOINC codes in the system:
      | loinc_code | test_name                   |
      | 11475-1    | Culture X, Unspecified        |
      | 636-1      | Culture X, Sterile body fluid |
      | 34166-9    | Macroscopy.Electron         |

    When I go to edit the common test type
    And I follow "LOINC codes"
    Then I should see "Add LOINC Codes to Common Test Type"
    And I should see a link to "Edit"
    And I should see a link to "Show"
    And I should see "Culture X"
    And I should not see "No records found"

    When I fill in "loinc_code_search_test_name" with "junk"
    And I press "Search"
    Then I should see "No records found"

    When I fill in "loinc_code_search_test_name" with "culture"
    And I press "Search"
    Then I should see "11475-1"

    When I check "11475-1"
    And I press "Add"
    Then I should see "Common test type was successfully updated."
    And I should see "Culture X, Unspecified"
    And I should see a link to "11475-1"

  Scenario: Searching for LOINCs by code
    Given I am logged in as a super user
    And I have a common test type named Culture X
    And I have the following LOINC codes in the system:
      | loinc_code | test_name                   |
      | 11475-1    | Culture X, Unspecified        |
      | 636-1      | Culture X, Sterile body fluid |
      | 34166-9    | Macroscopy.Electron         |

    When I go to manage the common test type's loinc codes
    And I fill in "loinc_code_search_loinc_code" with "114"
    And I press "Search"

    Then I should see a link to "11475-1"
    And I should see "Culture X, Unspecified"

  Scenario: Searching for loincs will not return any already associated with this test type
    Given I am logged in as a super user
    And I have a common test type named Culture X
    And I have the following LOINC codes in the system:
      | loinc_code | test_name                   |
      | 11475-1    | Culture X, Unspecified        |
      | 636-1      | Culture X, Sterile body fluid |
      | 34166-9    | Macroscopy.Electron         |
    And loinc code "11475-1" is associated with the common test type

    When I go to manage the common test type's loinc codes
    And I fill in "loinc_code_search_test_name" with "culture"
    And I press "Search"

    Then I should see "Culture X, Sterile body fluid"
    And the search results should not have "Culture X, Unspecified"

  Scenario: Searching for loincs *will* return loincs associated w/ other test types
    Given I am logged in as a super user
    And I have the following LOINC codes in the system:
      | loinc_code | test_name                   |
      | 11475-1    | Culture X, Unspecified        |
      | 636-1      | Culture X, Sterile body fluid |
      | 34166-9    | Macroscopy.Electron         |
    And I have a common test type named Culture X
    And loinc code "11475-1" is associated with the common test type
    And I have another common test type named Macroscopy

    When I go to manage the common test type's loinc codes
    And I fill in "loinc_code_search_test_name" with "culture"
    And I press "Search"

    Then the search results should have "Culture X, Unspecified"
    And the search results should show that "Culture X" is already associated

  Scenario: An admin can delete a loinc code association
    Given I am logged in as a super user
    And I have the following LOINC codes in the system:
      |loinc_code | test_name                   |
      |636-1      | Culture X, Sterile body fluid |
    And I have a common test type named Culture X
    And loinc code "636-1" is associated with the common test type

    When I go to manage the common test type's loinc codes
    And I check "636-1"
    And I press "Remove"

    Then I should see "Common test type was successfully updated."
    And I should not see "Culture X, Sterile body fluid" associated with the test type

  Scenario: Trying to delete a common test type
    Given I am logged in as a super user
    And I have a common test type named Culture X

    When I go to the common test type show page
    And I follow "Delete"

    Then I should see "Common test type was successfully deleted"
    And I should not see "Culture X"

  Scenario: Trying to delete a common test type that's already associated w/ a lab result
    Given I am logged in as a super user
    And I have a common test type named Culture X
    And I have a lab result

    When I go to the common test type show page
    Then I should see a link to "Delete"

    When the lab result is associated with the common test type
    And I follow "Delete" expecting a failure

    Then I should get a 500 response
    And I should see "Common test type could not be deleted. It may already be associated with a lab result"
    And I should not see a link to "Delete"

  Scenario: Linking diseases to common test types
    Given I am logged in as a super user
      And the following active diseases:
        | Disease name    |
        | Dropsy          |
        | The Trots       |
        | Reduced Gravity |
      And I have a common test type named Culture X
    When I go to edit common test type "Culture X"
      And I check "Dropsy"
      And I check "The Trots"
      And I press "Update"
    Then I should be on the common test type "Culture X" page
      And I should see "Common test type was successfully updated"
      And I should see "Dropsy"
      And I should see "The Trots"
      And I should not see "Reduced Gravity"

  Scenario: Unlinking all diseases from common test types
    Given I am logged in as a super user
      And the following active diseases:
        | Disease name    |
        | Dropsy          |
        | The Trots       |
        | Reduced Gravity |
      And I have a common test type named Culture X
      And common test type "Culture X" is linked to the following diseases:
        | Disease name    |
        | Dropsy          |
        | Reduced Gravity |
    When I go to edit common test type "Culture X"
      And I uncheck "Dropsy"
      And I uncheck "Reduced Gravity"
      And I press "Update"
    Then I should be on the common test type "Culture X" page
      And I should see "Common test type was successfully updated"
      And I should not see "Dropsy"
      And I should not see "The Trots"
      And I should not see "Reduced Gravity"
