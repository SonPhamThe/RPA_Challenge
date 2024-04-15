*** Settings ***
Documentation       Fill data from Excel to web form

Library             RPA.Excel
Library             RPA.Browser.Selenium
Library             RPA.Excel.Files


*** Variables ***
${EXCEL_FILE}       /Users/m143/Documents/RPA_challenger/challenge.xlsx
${URL}              https://www.rpachallenge.com/
${WAIT_FOR_LOAD}    5s


*** Tasks ***
Fill Data From Excel
    Open Workbook    ${EXCEL_FILE}    read_only=True
    ${data}    Read Worksheet    header=True
    Open Browser    ${URL}
    Wait Until Page Contains Element    css:.btn.uiColorButton

    FOR    ${row}    IN    @{data}
        ${first_name}    Set Variable If    '${row["First Name"]}'!='None'    ${row["First Name"]}    ""
        ${last_name}    Set Variable If    '${row["Last Name "]}'!='None'    ${row["Last Name "]}    ""
        ${company_name}    Set Variable If    '${row["Company Name"]}'!='None'    ${row["Company Name"]}    ""
        ${role}    Set Variable If    '${row["Role in Company"]}'!='None'    ${row["Role in Company"]}    ""
        ${address}    Set Variable If    '${row["Address"]}'!='None'    ${row["Address"]}    ""
        ${email}    Set Variable If    '${row["Email"]}'!='None'    ${row["Email"]}    ""
        ${phone}    Set Variable If    '${row["Phone Number"]}'!='None'    ${row["Phone Number"]}    ""

        # Kiểm tra nếu các biến đều rỗng thì thoát khỏi vòng lặp
        IF    '${first_name}' == '' AND '${last_name}' == '' AND '${company_name}' == '' AND '${role}' == '' AND '${address}' == '' AND '${email}' == '' AND '${phone}' == ''
            BREAK
        ELSE
            Log
            ...    Filling data for: ${first_name} ${last_name}
            ...    Fill Input Fields
            ...    ${first_name}
            ...    ${last_name}
            ...    ${company_name}
            ...    ${role}
            ...    ${address}
            ...    ${email}
            ...    ${phone}
            ...    Click Submit Button
            ...    Wait Until Page Contains Element
            ...    css:.btn.uiColorButton
        END
    END


*** Keywords ***
Fill Input Fields
    [Arguments]    ${first_name}    ${last_name}    ${company_name}    ${role}    ${address}    ${email}    ${phone}
    Input Text    css:[ng-reflect-name="labelFirstName"]    ${first_name}
    Input Text    css:[ng-reflect-name="labelLastName"]    ${last_name}
    Input Text    css:[ng-reflect-name="labelCompanyName"]    ${company_name}
    Input Text    css:[ng-reflect-name="labelRole"]    ${role}
    Input Text    css:[ng-reflect-name="labelAddress"]    ${address}
    Input Text    css:[ng-reflect-name="labelEmail"]    ${email}
    Input Text    css:[ng-reflect-name="labelPhone"]    ${phone}

Click Submit Button
    Click Element    css:.btn.uiColorButton
