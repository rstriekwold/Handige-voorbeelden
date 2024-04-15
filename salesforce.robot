
*** Settings ***

Documentation          Test suite for CRT starter.
Resource    resources/common.robot
Library                QForce
Library                QWeb
Library                QImage
Suite Setup            Setup Browser
Suite Teardown         Close All Browsers


*** Test Cases ***
Layout Checks example
    Appstate    Home
    ClickText    Accounts
    ClickText    
