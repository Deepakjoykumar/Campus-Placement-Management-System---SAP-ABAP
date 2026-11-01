# ZPLACEMENT_DETAILS – SE11 specification

| Field | Suggested type | Key | Notes |
|---|---|---:|---|
| MANDT | MANDT | Yes | Client field |
| APPLICATION_ID | CHAR10 | Yes | Application identifier |
| STUDENT_ID | CHAR10 | No | Student identifier |
| COMPANY_ID | CHAR10 | No | Company identifier |
| ROUND_NAME | CHAR30 | No | Recruitment round |
| STATUS | CHAR20 | No | Applied/Selected/Rejected etc. |
| APPLIED_DATE | DATS | No | Application date |

Create as a transparent table and activate it. Consider foreign-key relationships to student and company tables.
