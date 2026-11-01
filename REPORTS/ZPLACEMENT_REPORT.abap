REPORT zplacement_report.

PARAMETERS:
  p_act  TYPE c LENGTH 1 DEFAULT 'R',
  p_aid  TYPE zplacement_details-application_id,
  p_sid  TYPE zplacement_details-student_id,
  p_cid  TYPE zplacement_details-company_id,
  p_round TYPE zplacement_details-round_name,
  p_stat TYPE zplacement_details-status,
  p_date TYPE zplacement_details-applied_date DEFAULT sy-datum.

DATA: wa_application TYPE zplacement_details.

START-OF-SELECTION.
  CASE p_act.
    WHEN 'C'.
      CLEAR wa_application.
      wa_application-application_id = p_aid.
      wa_application-student_id     = p_sid.
      wa_application-company_id     = p_cid.
      wa_application-round_name     = p_round.
      wa_application-status         = p_stat.
      wa_application-applied_date   = p_date.

      INSERT zplacement_details FROM wa_application.
      IF sy-subrc = 0.
        COMMIT WORK AND WAIT.
        WRITE: / 'Placement application created successfully'.
      ELSE.
        ROLLBACK WORK.
        WRITE: / 'Application creation failed. Check duplicate key or table definition'.
      ENDIF.

    WHEN 'R'.
      SELECT SINGLE *
        FROM zplacement_details
        INTO @wa_application
        WHERE application_id = @p_aid.
      IF sy-subrc = 0.
        WRITE: / wa_application-application_id,
                 wa_application-student_id,
                 wa_application-company_id,
                 wa_application-round_name,
                 wa_application-status,
                 wa_application-applied_date.
      ELSE.
        WRITE: / 'Application not found'.
      ENDIF.

    WHEN 'U'.
      UPDATE zplacement_details
        SET student_id   = @p_sid,
            company_id   = @p_cid,
            round_name   = @p_round,
            status       = @p_stat,
            applied_date = @p_date
        WHERE application_id = @p_aid.
      IF sy-subrc = 0.
        COMMIT WORK AND WAIT.
        WRITE: / 'Placement application updated successfully'.
      ELSE.
        ROLLBACK WORK.
        WRITE: / 'Application update failed or application not found'.
      ENDIF.

    WHEN 'D'.
      DELETE FROM zplacement_details WHERE application_id = @p_aid.
      IF sy-subrc = 0.
        COMMIT WORK AND WAIT.
        WRITE: / 'Placement application deleted successfully'.
      ELSE.
        ROLLBACK WORK.
        WRITE: / 'Application not found'.
      ENDIF.

    WHEN OTHERS.
      WRITE: / 'Invalid action. Use C, R, U or D'.
  ENDCASE.
