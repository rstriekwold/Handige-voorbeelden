*** Settings ***
Library                         QForce
Library                         String
Library                         FakerLibrary
Library    
Library    OperatingSystem
Library    Collections

*** Keywords ***
Move to outputdir
    IF                      "${EXECDIR}"=="/home/executor/execution"
    # normal test run environment
        ${downloads_folder}=                            Set Variable                /home/executor/Downloads
    ELSE                    # Live Testing environment
        ${downloads_folder}=                            Set Variable                /home/services/Downloads
    END
 
    #Get file name from download folder
    @{downloads}=           List Files In Directory     ${downloads_folder}
    ${pdf_file}=            Get From List               ${downloads}                0
    Log To Console                     PDF Filename: ${pdf_file}
    Set Suite Variable      ${pdf_file}                 ESTA.pdf
 
    #Moving file to Outpur dir so it will be attached to the run
    Move File               ${CURDIR}/../${pdf_file}                         ${OUTPUT_DIR}
    Sleep                   2s
 
ReadPDF
    UsePdf    ${OUTPUT_DIR}/${pdf_file}
 
VerifyPDFText
    [Arguments]   ${pdftext}
    ReadPDF    
    VerifyPDFText    ${pdftext}        
    VerifyPDFText     Streamlined  
 
   