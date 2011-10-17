Feature: Help Banner
  In order to know what this gem does
  I want to see the help banner

  Scenario: Run blazing --help
    When I get help for "blazing"
    Then the exit status should be 0
    And the banner should be present

  Scenario:
    When I run `blazing`
    Then the exit status should not be 0
    And the output should contain "'command' is required"
