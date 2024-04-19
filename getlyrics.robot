*** Settings ***
Documentation       Google translate song lyrics from source to target language.
...                 Saves the original and the translated lyrics as text files.

Library             RPA.Browser.Selenium
Library             DateTime
Library             OperatingSystem

Task Teardown       Close All Browsers


*** Variables ***
# Path to save the original lyrics.
${ORIGINAL_FILE_PATH}       ${OUTPUT_DIR}${/}${SONG_TITLE}-${SOURCE_LANGUAGE}-original.txt
# Path to save the translation lyrics.
${TRANSLATION_FILE_PATH}    ${OUTPUT_DIR}${/}${SONG_TITLE}-${TARGET_LANGUAGE}-translation.txt
# Song title to search for lyrics
${SONG_TITLE}               Peaches
# Source language of the song lyrics
${SOURCE_LANGUAGE}          en
# Target language for translation
${TARGET_LANGUAGE}          vi
# URL to get song lyrics
${URL_GET_LYRIC}            https://www.lyrics.com/lyrics/${SONG_TITLE}
${DEFAULT_TRANSLATION}      Translation failed or empty


*** Tasks ***
Google Translate Song Lyrics From Source To Target Language
    [Documentation]    This task performs getting lyrics, translating lyrics, and saving lyrics, with the detailed steps as follows:
    ...    Gets the lyrics of a song from a lyrics website.
    ...    Validates the length of the lyrics.
    ...    Translates the lyrics from the source language to the target language using google translate.
    ...    Saves the original and translated lyrics as text files.
    ${lyric}=    Get Lyrics
    Handle Get Lyrics Error    ${lyric}
    ${translation}=    Translate Lyrics    ${lyric}
    Save Lyrics    ${lyric}    ${translation}
    Task Teardown


*** Keywords ***
Get Lyrics
    [Documentation]    Get the song lyrics from the lyrics website.
    Open Available Browser    ${URL_GET_LYRIC}
    Wait Until Element Is Visible    css:.best-matches a
    Click Element    css:.best-matches a
    ${lyric_element}=    Set Variable    id:lyric-body-text
    Wait Until Element Is Visible    ${lyric_element}
    ${lyric}=    Get Text    ${lyric_element}
    Log    ${lyric}
    RETURN    ${lyric}

Translate Lyrics
    [Documentation]    Translate the given lyrics from source to target language.
    [Arguments]    ${lyrics}
    ${translation}=    Run Keyword And Return Status    Perform Translation    ${lyrics}
    IF    '${translation}' == 'FAIL'
        Set Test Variable    ${DEFAULT_TRANSLATION}
    END
    RETURN    ${translation}

Perform Translation
    [Arguments]    ${lyrics}
    ${translation}=    Set Variable    None
    FOR    ${i}    IN RANGE    3
        Run Keyword And Ignore Error
        ...    Go To
        ...    https://translate.google.com/?sl=${SOURCE_LANGUAGE}&tl=${TARGET_LANGUAGE}&text=${lyrics}&op=translate
        ${translation_element}=    Set Variable    css:.HwtZe
        ${translation}=    Run Keyword And Ignore Error    Get Text    ${translation_element}
        Run Keyword Unless    '${translation}' == '${DEFAULT_TRANSLATION}'    Set Variable    ${translation}
    END
    RETURN    ${translation}

Save Lyrics
    [Documentation]    Save the original and translated lyrics to text files.
    [Arguments]    ${original_lyrics}    ${translation_lyrics}
    Create File    ${ORIGINAL_FILE_PATH}    ${original_lyrics}
    Create File    ${TRANSLATION_FILE_PATH}    ${translation_lyrics}

Task Teardown
    [Documentation]    Perform cleanup actions after each test case.
    ...    Close all open browser instances.
    Close All Browsers

Handle Get Lyrics Error
    [Documentation]    Validates the length of lyrics and checks if the song title is found.
    ...    Arguments: ${lyrics} (The lyrics of the song)
    ...    If the lyrics are too short (less than or equal to 10 characters) or missing, it will fail with the message "Lyrics validation failed: Lyrics are too short or missing."
    ...    If the song title is not found (lyrics are empty), it will fail with the message "Song title not found: Song lyrics could not be retrieved."
    [Arguments]    ${lyrics}
    ${length_lyrics}=    Get Length    ${lyrics}
    IF    '${length_lyrics}' == '0'
        Fail    Song title not found: Song lyrics could not be retrieved.
    END
    IF    '${length_lyrics}' <= '10'
        Fail    Lyrics validation failed: Lyrics are too short or missing.
    END

Handle Translation Errors
    [Arguments]    ${translation}
    Run Keyword Unless    '${translation}' == '${DEFAULT_TRANSLATION}'    Log    Translation: ${translation}
    IF    '${translation}' == '${DEFAULT_TRANSLATION}'
        Log    Translation failed or empty
    END
