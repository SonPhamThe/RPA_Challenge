*** Settings ***
Documentation       Fill Data From Excel Into Web Form

Library             RPA.Browser.Selenium
Library             RPA.Excel.Files
Library             RPA.Desktop
Library             fill_data.py    WITH NAME    FillData


*** Variables ***
${EXCEL_FILE}       /Users/m143/Documents/RPA_challenger/challenge.xlsx
${URL_RPA}          https://www.rpachallenge.com/
${WAIT_FOR_LOAD}    1S


*** Tasks ***
Fill Data From Excel
    Open the website
    Fill Data From Excel Into Web Form For Each Row
    ${c}=    Add Num    1    2
    Log    ${c}


*** Keywords ***
Open the website
    Open Available Browser    ${URL_RPA}
    Click Button    Start

Fill Data From Excel Into Web Form
    # ${data_challenge}: A dictionary containing data from the Excel file
    [Arguments]    ${data_challenge}
    # """
    # Fill data from Excel file into web form:
    # - Input 'First Name', 'Last Name', 'Company Name', 'Role in Company', 'Address', 'Email', and 'Phone Number'
    # - Wait until 'Submit' button is visible, then click it.
    # """
    Input Text    css:[ng-reflect-name="labelFirstName"]    ${data_challenge}[First Name]
    Input Text    css:[ng-reflect-name="labelLastName"]    ${data_challenge}[Last Name]
    Input Text    css:[ng-reflect-name="labelCompanyName"]    ${data_challenge}[Company Name]
    Input Text    css:[ng-reflect-name="labelRole"]    ${data_challenge}[Role in Company]
    Input Text    css:[ng-reflect-name="labelAddress"]    ${data_challenge}[Address]
    Input Text    css:[ng-reflect-name="labelEmail"]    ${data_challenge}[Email]
    Input Text    css:[ng-reflect-name="labelPhone"]    ${data_challenge}[Phone Number]
    Wait Until Element Is Visible    css:input.btn.uiColorButton[type='submit']    ${WAIT_FOR_LOAD}
    Click Button    Submit

Fill Data From Excel Into Web Form For Each Row
    Open Workbook    challenge.xlsx
    ${data_challenges}=    Read Worksheet As Table    header=True
    Close Workbook
    # """
    # Fill Data From Excel Into Web Form For Each Row
    # - Open the Excel workbook 'challenge.xlsx'
    # - Read the data from each row of the Excel file as a table with headers
    # - For each row in the Excel data:
    #    -- Fill data from the current row into the web form
    # """
    FOR    ${data_challenge}    IN    @{data_challenges}
        Fill Data From Excel Into Web Form    ${data_challenge}
    END

Custom Fill Data From Excel Into Web Form
    [Arguments]    ${data_challenge}
    ${result}=    Add Num 1 2
    RETURN    ${result}
