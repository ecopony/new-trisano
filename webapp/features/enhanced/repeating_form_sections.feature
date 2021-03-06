Feature: Morbidity event form core view configs

  To allow for a more relevant event form
  An investigator should see core view configs on a moridity form

  Scenario: Morbidity event repeating sections
    Given   I am logged in as a super user
    And     a morbidity event form exists
    And     that form has two repeating sections configured in the default view with a question
    And     that form is published
    And     a morbidity event exists with a disease that matches the form

    When    I am on the morbidity event edit page
	When    I navigate to the Investigation tab
    And     I create 1 new instances of all section repeaters
    Then    I should see 2 instances of the repeater section questions in body text

    When    I answer 2 instances of all repeater section questions
    And     I save and continue
    Then    I should see "successfully updated"
    And     I should see 2 instances of the repeater section questions in body text
    And     I should see 2 instances of answers to the repeating section questions
    And     the database should have 4 answers and investigator form questions for this event

    When    I save and exit
    Then    I should see "successfully updated"
    And     I should see 2 instances of the repeater section questions in body text
    And     I should see 2 instances of answers to the repeating section questions

    When    I print the morbidity event
    And     I should see 2 instances of the repeater section questions
    And     I should see 2 instances of answers to the repeating section questions

    When    I am on the morbidity event edit page
	When    I navigate to the Investigation tab
    And     I mark all section repeaters for removal
    And     I save and continue
    Then    I should see "successfully updated"
    And     I should see 1 instances of the repeater section questions in body text
    And     I should see 0 instances of answers to the repeating section questions
    And     the database should have 0 answers and investigator form questions for this event


  Scenario: Assessment event repeating sections
    Given   I am logged in as a super user
    And     a assessment event form exists
    And     that form has two repeating sections configured in the default view with a question
    And     that form is published
    And     a assessment event exists with a disease that matches the form

    When    I am on the assessment event edit page
	When    I navigate to the Investigation tab
    And     I create 1 new instances of all section repeaters
    Then    I should see 2 instances of the repeater section questions in body text

    When    I answer 2 instances of all repeater section questions
    And     I save and continue
    Then    I should see "successfully updated"
    And     I should see 2 instances of the repeater section questions in body text
    And     I should see 2 instances of answers to the repeating section questions
    And     the database should have 4 answers and investigator form questions for this event

    When    I save and exit
    Then    I should see "successfully updated"
    And     I should see 2 instances of the repeater section questions in body text
    And     I should see 2 instances of answers to the repeating section questions

    When    I print the assessment event
    And     I should see 2 instances of the repeater section questions
    And     I should see 2 instances of answers to the repeating section questions

    When    I am on the assessment event edit page
	When    I navigate to the Investigation tab
    And     I mark all section repeaters for removal
    And     I save and continue
    Then    I should see "successfully updated"
    And     I should see 1 instances of the repeater section questions in body text
    And     I should see 0 instances of answers to the repeating section questions
    And     the database should have 0 answers and investigator form questions for this event


  Scenario: Contact event repeating sections
    Given   I am logged in as a super user
    And     a contact event form exists
    And     that form has two repeating sections configured in the default view with a question
    And     that form is published
    And     a contact event exists with a disease that matches the form

    When    I am on the contact event edit page
	When    I navigate to the Investigation tab
    And     I create 1 new instances of all section repeaters
    Then    I should see 2 instances of the repeater section questions in body text

    When    I answer 2 instances of all repeater section questions
    And     I save and continue
    Then    I should see "successfully updated"
    And     I should see 2 instances of the repeater section questions in body text
    And     I should see 2 instances of answers to the repeating section questions
    And     the database should have 4 answers and investigator form questions for this event

    When    I save and exit
    Then    I should see "successfully updated"
    And     I should see 2 instances of the repeater section questions in body text
    And     I should see 2 instances of answers to the repeating section questions

    When    I print the contact event
    And     I should see 2 instances of the repeater section questions
    And     I should see 2 instances of answers to the repeating section questions

    When    I am on the contact event edit page
	When    I navigate to the Investigation tab
    And     I mark all section repeaters for removal
    And     I save and continue
    Then    I should see "successfully updated"
    And     I should see 1 instances of the repeater section questions in body text
    And     I should see 0 instances of answers to the repeating section questions
    And     the database should have 0 answers and investigator form questions for this event


  Scenario: Place event repeating sections
    Given   I am logged in as a super user
    And     a place event form exists
    And     that form has two repeating sections configured in the default view with a question
    And     that form is published
    And     a place event exists with a disease that matches the form

    When    I am on the place event edit page
	When    I navigate to the Investigation tab
    And     I create 1 new instances of all section repeaters
    Then    I should see 2 instances of the repeater section questions in body text

    When    I answer 2 instances of all repeater section questions
    And     I save and continue
    Then    I should see "successfully updated"
	When    I navigate to the Investigation tab
    And     I should see 2 instances of the repeater section questions in body text
    And     I should see 2 instances of answers to the repeating section questions
    And     the database should have 4 answers and investigator form questions for this event

    When    I save and exit
    Then    I should see "successfully updated"
    And     I should see 2 instances of the repeater section questions in body text
	When    I navigate to the Investigation tab
    And     I should see 2 instances of answers to the repeating section questions

    When    I am on the place event edit page
	When    I navigate to the Investigation tab
    And     I mark all section repeaters for removal
    And     I save and continue
    Then    I should see "successfully updated"
	When    I navigate to the Investigation tab
    And     I should see 1 instances of the repeater section questions in body text
    And     I should see 0 instances of answers to the repeating section questions
    And     the database should have 0 answers and investigator form questions for this event


  Scenario: Encounter event repeating sections
    Given   I am logged in as a super user
    And     a encounter event form exists
    And     that form has two repeating sections configured in the default view with a question
    And     that form is published
    And     a encounter event exists with a disease that matches the form

    When    I am on the encounter event edit page
	When    I navigate to the Investigation tab
    And     I create 1 new instances of all section repeaters
    Then    I should see 2 instances of the repeater section questions in body text

    When    I answer 2 instances of all repeater section questions
    And     I save and continue
    Then    I should see "successfully updated"
    And     I should see 2 instances of the repeater section questions in body text
    And     I should see 2 instances of answers to the repeating section questions
    And     the database should have 4 answers and investigator form questions for this event

    When    I save and exit
    Then    I should see "successfully updated"
    And     I should see 2 instances of the repeater section questions in body text
    And     I should see 2 instances of answers to the repeating section questions

    When    I am on the encounter event edit page
	When    I navigate to the Investigation tab
    And     I mark all section repeaters for removal
    And     I save and continue
    Then    I should see "successfully updated"
    And     I should see 1 instances of the repeater section questions in body text
    And     I should see 0 instances of answers to the repeating section questions
    And     the database should have 0 answers and investigator form questions for this event


  Scenario: Answer all repeaters after adding a form.
    Given   a basic assessment event exists
    And     a assessment event form exists with a matching disease
    And     that form has two repeating sections configured in the default view with a question
    And     that form is published

    When    I navigate to the assessment event edit page
    Then    I should see 0 instances of the repeater section questions in body text

	When    I navigate to the Investigation tab
    When    I click the "Add/Remove forms for this event" link
    And     I check the form for addition
    And     I click the "Add Forms" button
    And     I navigate to the assessment event edit page
	When    I navigate to the Investigation tab
    Then    I should see 1 instances of the repeater section questions in body text

    When    I create 1 new instances of all section repeaters
    And     I answer 2 instances of all repeater section questions
    And     I save and continue
    Then    I should see "successfully updated"
    And     I should see 2 instances of the repeater section questions in body text
    And     I should see 2 instances of answers to the repeating section questions
    And     the database should have 4 answers and investigator form questions for this event


  Scenario: Removing forms removes repeater answers. 
    Given   a assessment event form exists
    And     that form has two repeating sections configured in the default view with a question
    And     that form is published
    And     a assessment event exists with a disease that matches the form

    When    I navigate to the assessment event edit page
	When    I navigate to the Investigation tab
    Then    I should see 1 instances of the repeater section questions in body text

    When    I create 1 new instances of all section repeaters
    And     I answer 2 instances of all repeater section questions
    And     I save and continue
    Then    I should see "successfully updated"
    And     I should see 2 instances of the repeater section questions in body text
    And     I should see 2 instances of answers to the repeating section questions
    And     the database should have 4 answers and investigator form questions for this event

    When    I click the "Add/Remove forms for this event" link
    And     I check the form for removal
    And     I click and confirm the "Remove Forms" button
    And     I navigate to the assessment event edit page
    Then    I should see 0 instances of the repeater section questions in body text
    And     I should see 0 instances of answers to the repeating section questions
    And     the database should have 0 answers and investigator form questions for this event


  Scenario: Empty repeaters are ignored.
    Given   I am logged in as a super user
    And     a morbidity event form exists
    And     that form has two repeating sections configured in the default view with a question
    And     that form is published
    And     a morbidity event exists with a disease that matches the form

    When    I am on the morbidity event edit page
	When    I navigate to the Investigation tab
    Then    I should see 1 instances of the repeater section questions in body text
    And     the database should have 0 answers and investigator form questions for this event

    When    I save and continue
    Then    I should see "successfully updated"
    And     I should see 1 instances of the repeater section questions in body text
    And     I should see 0 instances of answers to the repeating section questions
    And     the database should have 0 answers and investigator form questions for this event

    When    I save and exit
    Then    I should see "successfully updated"
    And     I should see 0 instances of the repeater section questions in body text
    And     I should see 0 instances of answers to the repeating section questions

    When    I print the morbidity event
    And     I should see 0 instances of the repeater section questions
    And     I should see 0 instances of answers to the repeating section questions
