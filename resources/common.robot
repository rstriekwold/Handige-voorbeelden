*** Settings ***
Library                         QForce
Library                         String
Library                         FakerLibrary
Library    
Library    OperatingSystem


*** Variables ***
# IMPORTANT: Please read the readme.txt to understand needed variables and how to handle them!!
${BROWSER}                      chrome
${username}                     pace.delivery1@qentinel.com.demonew
${LOCAL_LOGIN_URL}                    https://qentinel--demonew.my.salesforce.com/            # Salesforce instance. NOTE: Should be overwritten in CRT variables
${home_url}                     ${LOCAL_LOGIN_URL}/lightning/page/home
${testtest}    testtest

*** Keywords ***

Unique Test Data
    [Documentation]    lets create some documentation 
    ...                lets create some documentation 
    ...                lets create some documentation 
    ...                lets create some documentation 
    ...                lets create some documentation 
    ...                lets create some documentation 
    ${testsetup_Last_Name}=     Last Name
    Set Suite Variable          ${testsetup_last_name}      ${testsetup_Last Name}
    ${testsetup_Company}=       Company
    Set Suite Variable          ${testsetup_company}        ${testsetup_Company}
    ${testsetup_First_Name}=    First Name
    Set Suite Variable          ${testsetup_first_name}     ${testsetup_First_Name}

Prep Data
    ${appstate_Last_Name}=      Last Name
    Set Suite Variable          ${appstate_last_name}       ${appstate_Last Name}
    ${appstate_Company}=        Company
    Set Suite Variable          ${appstate_company}         ${appstate_Company}
    ${appstate_First_Name}=     First Name
    Set Suite Variable          ${appstate_first_name}      ${appstate_First_Name}

Setup Browser
    # Setting search order is not really needed here, but given as an example
    # if you need to use multiple libraries containing keywords with duplicate names
    # Set Library Search Order    QForce                      QWeb
    Open Browser                about:blank                 ${BROWSER}
    SetConfig                   LineBreak                   ${EMPTY}                    #\ue000
    SetConfig                   DefaultTimeout              20s                         #sometimes salesforce is slow
    Evaluate                    random.seed()               random                      # initialize random generator


End suite
    Close All Browsers


Login
    [Documentation]             Login to Salesforce instance
    GoTo                        ${login_url}
    TypeText                    Username                    ${username}                 delay=1
    TypeText                    Password                    ${password}
    ClickText                   Log In
    # We'll check if variable ${secret} is given. If yes, fill the MFA dialog.
    # If not, MFA is not expected.
    # ${secret} is ${None} unless specifically given.
    ${MFA_needed}=              Run Keyword And Return Status                           Should Not Be Equal         ${None}                     ${secret}
    Run Keyword If              ${MFA_needed}               Fill MFA


Login As
    [Documentation]             Login As different persona. User needs to be logged into Salesforce with Admin rights
    ...                         before calling this keyword to change persona.
    ...                         Example:
    ...                         LoginAs                     Chatter Expert
    [Arguments]                 ${persona}
    ClickText                   Setup
    ClickText                   Setup for current app
    SwitchWindow                NEW
    TypeText                    Search Setup                ${persona}                  delay=2
    ClickText                   User                        anchor=${persona}           delay=5                     # wait for list to populate, then click
    VerifyText                  Freeze                      timeout=45                  # this is slow, needs longer timeout
    ClickText                   Login                       anchor=Freeze               delay=1

Fill MFA
    ${mfa_code}=                GetOTP                      ${username}                 ${secret}                   ${login_url}
    TypeSecret                  Verification Code           ${mfa_code}
    ClickText                   Verify


Home
    [Documentation]             Navigate to homepage, login if needed
    GoTo                        ${home_url}
    ${login_status} =           IsText                      To access this page, you have to log in to Salesforce.                              2
    Run Keyword If              ${login_status}             Login
    ClickText                   Home
    VerifyTitle                 Home | Salesforce


    # Example of custom keyword with robot fw syntax
VerifyStage
    [Documentation]             Verifies that stage given in ${text} is at ${selected} state; either selected (true) or not selected (false)
    [Arguments]                 ${text}                     ${selected}=true
    VerifyElement               //a[@title\="${text}" and (@aria-checked\="${selected}" or @aria-selected\="${selected}")]


NoData
    VerifyNoText                ${data}                     timeout=3                   delay=2


DeleteAccounts
    [Documentation]             RunBlock to remove all data until it doesn't exist anymore
    ClickText                   ${data}
    ClickText                   Delete
    VerifyText                  Are you sure you want to delete this account?
    ClickText                   Delete                      2
    VerifyText                  Undo
    VerifyNoText                Undo
    ClickText                   Accounts                    partial_match=False


DeleteLeads
    [Documentation]             RunBlock to remove all data until it doesn't exist anymore
    ClickText                   ${data}
    ClickText                   Delete
    VerifyText                  Are you sure you want to delete this lead?
    ClickText                   Delete                      2
    VerifyText                  Undo
    VerifyNoText                Undo
    ClickText                   Leads                       partial_match=False

Close all tabs
    [Documentation]             To close all open Salesforce Tabs
    PressKey                    ${EMPTY}                    {SHIFT + W}
    ${Open}=                    IsText                      Close all tabs?
    IF                          ${Open}
        ClickText               Close All                   partial_match=False
    END

Global search and select type
    [Documentation]             searching and navigating to name with specific type
    [Arguments]                 ${name}    ${type}
    ClickText                   Search...                   
    # ClickElement              //button[contains(@aria-label,'Search')]
    TypeText                    Search...                   ${name}
    Clickelement              //span[contains(@title,'${name}')]/ancestor::div[@class\='instant-results-list']//span[contains(text(),'${type}')]

Find and Open Case with Global Search
    [Arguments]                 ${case}
    ClickText                   Search...                   anchor=Wren Kitchens
    TypeText                    Search...                   ${case}
    ${xpathCase}                Set Variable                xpath=//span[contains(@title,'${case}')]/ancestor::div[@class\='instant-results-list']//span[contains(text(),'Case')]
    VerifyText                  Show more
    VerifyText                  Do more with Search!        recognition_mode=vision
    ${caseExist}=               IsElement                   ${xpathCase}

    Log To Console              ${caseExist}

    WHILE                       '${caseExist}' == 'False'                               limit=20
        RefreshPage
        ClickText               Search...                   anchor=Wren Kitchens
        VerifyText              Do more with Search!
        TypeText                Search...                   ${case}
        VerifyText              Show more
        ${caseExist}=           IsElement                   ${xpathCase}                timeout=5s
    END
    ClickElement                ${xpathCase}

Approve quote on Approval Screen
    [Documentation]             will approve the quote on the approval screen. Will click the next page till amount of pages is reached.
    [Arguments]                 ${qNumber}
    Sleep                       5s
    ${getPageNum}=              GetText                     //div[contains(@class,'slds-page-header__title')]
    ${PageNumber}=              Fetch From Right            ${getPageNum}               /
    ${status}=                  IsText                      ${qNumber}
    FOR                         ${i}                        IN RANGE                    ${PageNumber}
        Exit For Loop If        "${status}" == "${TRUE}"
        ClickText               Next Page
        sleep                   3s
        ${status}=              IsText                      ${qNumber}
    END
    VerifyText                   Approve                     anchor=${qNumber}

Preview and download document
    [Documentation]             Preview Document
    ClickText                   Preview Document
    Dropdown                    Template                    01 - EN_New Service Agreement
    ClickText                   Preview
    Sleep                       2s
    RightClick                  //div[@class\='sbDialogBody']                           timeout=30
    ClickText                   Save as...                  recognition_mode=Vision
    PressKey                    ${EMPTY}                    {ENTER}
    Sleep                       10s

    IF    "${EXECDIR}" == "/home/executor/execution"    # normal test run environment
        ${downloads_folder}=    Set Variable    /home/executor/Downloads
    ELSE    # Live Testing environment
        ${downloads_folder}=    Set Variable    /home/services/Downloads
    END
 
     #Get file name from download folder
    @{downloads}=               List Files In Directory    ${downloads_folder}
    ${pdf_file}=                Get From List               ${downloads}                0
    Log                         PDF Filename: ${pdf_file}
    
    #Moving file to Outpur dir so it will be attached to the run
    Move File                   ${downloads_folder}/${pdf_file}                        ${OUTPUT_DIR}
    Sleep                       2s
    List Files In Directory     ${OUTPUT_DIR}
    LogScreenshot


Global search Cases
    [Documentation]             searching and navigating for cases (Celine Perez profil)
    [Arguments]                 ${name}                     ${type}
    VerifyText                  Search...
    ClickText                   Search...                   
    # ClickElement              //button[contains(@aria-label,'Search')]
    TypeText                    Search Cases and more...    ${name}
    Clickelement                //span[contains(@title,'${name}')]/ancestor::div[@class\='instant-results-list']//span[contains(text(),'${type}')]

Global search for type
    [Documentation]             searching and navigating
    [Arguments]                 ${name}                     ${type}
    VerifyText                  Search...
    ClickText                   Search...                   
    # ClickElement              //button[contains(@aria-label,'Search')]
    TypeText                    Search...    ${name}
    Clickelement                //span[contains(@title,'${name}')]/ancestor::div[@class\='instant-results-list']//span[contains(text(),'${type}')]
Verify current Quote stage status
    [Documentation]  Verify the current stage of the quote
    [Arguments]      ${expectedStage}
    VerifyElement    //li[contains(@class,"current")]//span[text()\="${expectedStage}"]

Verify current stage status
    [Documentation]  Verify the current stage
    [Arguments]      ${expectedStage}
    VerifyElement    //li[contains(@class,"current")]//span[text()\="${expectedStage}"]

Verify current Case stage status
    [Documentation]  Verify the current stage of the case
    [Arguments]      ${expectedStage}
    VerifyElement    //li[contains(@class,"current")]//span[text()\="${expectedStage}"]

Verify Login As else Refresh
    [Documentation]             Validate we are logged in as a user, else we refresh the browser
    [Arguments]                 ${user}
    ${loggedInAs}               IsText                      Logged in as ${user}

    WHILE                       "${loggedInAs}"=="False"    limit=10
        RefreshPage
        ${loggedInAs}           IsText                      Logged in as ${user}                          delay=3s
    END

    VerifyText                  Logged in as ${user}                               timeout=10

Close All Console Tabs
    [Documentation]  Closes all tabs from Lightning app
    ClickUntilNoElements    xpath=//li[./a[@role="tab" and not(contains(@data-tabid, "_"))]]//button[contains(@title, "Close")]

Close All Subtabs
    [Documentation]  Closes all subtabs from Lightning Sales Console app
    ...  Subtabs mean the second row of tabs which might be present
    ClickUntilNoElements    xpath=//li[./a[@role="tab" and (contains(@data-tabid, "_"))]]//button[contains(@title, "Close")]

Click Until No Elements
    [Documentation]    Clicks the element for given xpath until no such elements exist
    [Arguments]    ${xpath}
    ${tabs_present}=    IsElement    ${xpath}    timeout=5
    WHILE    ${tabs_present}    limit=5
        @{tabs_open}=        GetWebelement    locator=${xpath}
        FOR                  ${elem}    IN    @{tabs_open}
            RunKeywordAndIgnoreError    ClickElement     ${elem}    js=${TRUE}    timeout=2
        END
        Sleep    1
        ${tabs_present}=    IsElement    ${xpath}    timeout=5
    END

Global search for type with loop
    [Arguments]                 ${name}    ${type}
    ClickText                   Search...                   
    TypeText                    Search...                   ${name}
    ${xpathElement}                Set Variable                xpath=//span[contains(@title,'${name}')]/ancestor::div[@class\='instant-results-list']//span[contains(text(),'${type}')]
    VerifyText                  Show more
    VerifyText                  Do more with Search!        recognition_mode=vision
    ${ElementExist}=               IsElement                   ${xpathElement}

    Log To Console              ${ElementExist}

    WHILE                       '${ElementExist}' == 'False'                               limit=20
        RefreshPage
        ClickText               Search...                 
        VerifyText              Do more with Search!
        TypeText                //div[@class\="forceSearchAssistantDialog"]//input[@type\="search"]                  ${name}
        VerifyText              Show more
        ${ElementExist}=           IsElement                   ${xpathElement}                timeout=5s
    END
    ClickElement                ${xpathElement}

Logout As
    [Documentation]             Logout as specific user and closing second tab and switching to first tab.
    ${loggedIn}=                isText                      Log out as
    IF                          ${loggedIn}
        ClickText               Log out as
        VerifyText              New User
        CloseWindow
        Switchwindow            1
    END

Logout
    [Documentation]             Logout sessions
    ${loggedIn}=                isText                      Log out
    IF                          ${loggedIn}
        ClickText               Log out                     partial_match=False
        
    END