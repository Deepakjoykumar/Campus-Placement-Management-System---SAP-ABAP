# Campus Placement Management System – SAP ABAP

A sample SAP ABAP project for managing students, companies, placement applications and ALV reports.

## Prerequisites
Create and activate the three transparent tables in SE11 before running the reports:

- `ZSTUDENT_DETAILS`
- `ZCOMPANY_DETAILS`
- `ZPLACEMENT_DETAILS`

The field definitions are documented in `TABLES/`. Use suitable customer data elements/domains or the listed built-in types. Ensure the key fields and client field are configured correctly.

## Repository structure
- `REPORTS/` – CRUD reports for students, companies and placement applications.
- `TABLES/` – SE11 table field specifications.
- `ALV_REPORTS/` – ALV list reports.
- `MODULES/` – module documentation.
- `SCREENSHOTS/` – add screenshots from your SAP system.

## Importing
Create each ABAP report in SE38/SE80 using the matching filename as the program name, paste the source, activate, and execute. These are learning examples and may need adjustment for your SAP release and DDIC definitions.

## Important
Do not upload real student personal information, passwords, SAP credentials, connection details, or confidential company data to a public repository. Use fictional test data only.
