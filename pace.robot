# Tip: Everything that starts with # is a guidance for you and will not get executed.

*** Settings ***

Documentation           Test suite for CRT starter.
Library                 QWeb
Library       QImage
Suite Setup             Open Browser    about:blank    chrome
Suite Teardown          Close All Browsers

# Tip: The Settings section is where you define test suite level configuration.
#      Suite Setup and Teardown are actions that happen before and after a test suite run.
#      For first time users, we don't recommend to change them.
#      You may change chrome to firefox should you wish to test your application on Firefox.

*** Test Cases ***

# Tip: Test cases start from here. The structure of a test case is as follows:
#      Name of the test
#          [Documentation]    A short explanation of the test.
#          Test steps
#
#      A new test case starts from the beginning of the line. Each test step starts with four
#      spaces, followed by a QWord, at least four spaces, and its arguments.

Test the home page
    [Documentation]     Go to the web shop, and verify that the slogan text appears on the page.
    GoTo                https://qentinelqi.github.io/shop/
    VerifyText          Find your spirit animal
    ClickText       Our Story
    # Taking a 2 full screen screenshots and comparing them
        ${second}=  LogScreenshot
        ${third}=   LogScreenshot
        CompareImages     ${second}         ${third}

Test the home page with reference picture in folder
    [Documentation]     Go to the web shop, and verify that the slogan text appears on the page.
    GoTo                https://qentinelqi.github.io/shop/
    VerifyText          Find your spirit animal
    ClickText       Our Story
    # Taking a 2 full screen screenshots and comparing them
        ${second}=  LogScreenshot
        
        CompareImages     ${second}         test.png

Test the home page two different pages
    [Documentation]     Go to the web shop, and verify that the slogan text appears on the page.
    GoTo                https://qentinelqi.github.io/shop/
    VerifyText          Find your spirit animal
    # Taking a 2 full screen screenshots and comparing them
        ${second}=  LogScreenshot
    ClickText       Our Story
        ${third}=   LogScreenshot
        CompareImages     ${second}         ${third}

Test the home page with tolerance same as difference
    [Documentation]     Go to the web shop, and verify that the slogan text appears on the page.
    GoTo                https://qentinelqi.github.io/shop/
    VerifyText          Find your spirit animal
    # Taking a 2 full screen screenshots and comparing them
        ${second}=  LogScreenshot
    ClickText       Our Story
        ${third}=   LogScreenshot
        CompareImages     ${second}         ${third}    tolerance=0.79

Test the home page with tolerance just above ratio
    [Documentation]     Go to the web shop, and verify that the slogan text appears on the page.
    GoTo                https://qentinelqi.github.io/shop/
    VerifyText          Find your spirit animal
    # Taking a 2 full screen screenshots and comparing them
        ${second}=  LogScreenshot
    ClickText       Our Story
        ${third}=   LogScreenshot
        CompareImages     ${second}         ${third}    tolerance=0.81