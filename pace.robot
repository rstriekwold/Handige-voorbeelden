# Tip: Everything that starts with # is a guidance for you and will not get executed.

*** Settings ***

Documentation          Test suite for CRT starter.
Library                QForce
Library                QWeb
Library                QImage
Suite Setup            Open Browser                about:blank    chrome
Suite Teardown         Close All Browsers

*** Test Cases ***


Test the home page
    [Documentation]    Go to the web shop, and verify that the slogan text appears on the page.
    GoTo               https://qentinelqi.github.io/shop/
    VerifyText         Find your spirit animal
    ClickText          Our Story
    # Taking a 2 full screen screenshots and comparing them
    ${second}=         LogScreenshot
    ${third}=          LogScreenshot
    CompareImages      ${second}                   ${third}
    

Test the home page with reference picture in folder
    [Documentation]    Go to the web shop, and verify that the slogan text appears on the page.
    GoTo               https://qentinelqi.github.io/shop/
    VerifyText         Find your spirit animal
    ClickText          Our Story
    # Taking a 2 full screen screenshots and comparing them
    ${second}=         LogScreenshot

    CompareImages      ${second}                   test.png
    
Test the home page with reference picture in folder and mask tolerance 1.0
    [Documentation]    Go to the web shop, and verify that the slogan text appears on the page.
    GoTo               https://qentinelqi.github.io/shop/
    VerifyText         Find your spirit animal
    ${second}=         LogScreenshot
    ClickText          Our Story
    CompareImages      ${second}                   test.png       mask.png    tolerance=1

Test the home page with reference picture in folder and mask
    [Documentation]    Go to the web shop, and verify that the slogan text appears on the page.
    GoTo               https://qentinelqi.github.io/shop/
    VerifyText         Find your spirit animal
    ${second}=         LogScreenshot
    ClickText          Our Story
    CompareImages      ${second}                   test.png       mask.png    tolerance=0.90

Test the home page with reference picture in folder and mask but difference just above ratio
    [Documentation]    Go to the web shop, and verify that the slogan text appears on the page.
    GoTo               https://qentinelqi.github.io/shop/
    VerifyText         Find your spirit animal
    ${second}=         LogScreenshot
    ClickText          Our Story
    CompareImages      ${second}                   test.png       mask.png    tolerance=0.995

Test the home page two different pages
    [Documentation]    Go to the web shop, and verify that the slogan text appears on the page.
    GoTo               https://qentinelqi.github.io/shop/
    VerifyText         Find your spirit animal
    # Taking a 2 full screen screenshots and comparing them
    ${second}=         LogScreenshot
    ClickText          Our Story
    ${third}=          LogScreenshot
    CompareImages      ${second}                   ${third}    

Test the home page with tolerance same as difference
    [Documentation]    Go to the web shop, and verify that the slogan text appears on the page.
    GoTo               https://qentinelqi.github.io/shop/
    VerifyText         Find your spirit animal
    # Taking a 2 full screen screenshots and comparing them
    ${second}=         LogScreenshot
    ClickText          Our Story
    ${third}=          LogScreenshot
    CompareImages      ${second}                   ${third}       tolerance=0.79

Test the home page with tolerance just above ratio
    [Documentation]    Go to the web shop, and verify that the slogan text appears on the page.
    GoTo               https://qentinelqi.github.io/shop/
    VerifyText         Find your spirit animal
    # Taking a 2 full screen screenshots and comparing them
    ${second}=         LogScreenshot
    ClickText          Our Story
    ${third}=          LogScreenshot
    CompareImages      ${second}                   ${third}       tolerance=0.81