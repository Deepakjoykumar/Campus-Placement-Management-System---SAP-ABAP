REPORT zcompany_report.

PARAMETERS:
  p_act  TYPE c LENGTH 1 DEFAULT 'R',
  p_cid  TYPE zcompany_details-company_id,
  p_name TYPE zcompany_details-company_name,
  p_loc  TYPE zcompany_details-location,
  p_role TYPE zcompany_details-job_role,
  p_pkg  TYPE zcompany_details-package.

DATA: wa_company TYPE zcompany_details.

START-OF-SELECTION.
  CASE p_act.
    WHEN 'C'.
      CLEAR wa_company.
      wa_company-company_id   = p_cid.
      wa_company-company_name = p_name.
      wa_company-location     = p_loc.
      wa_company-job_role     = p_role.
      wa_company-package      = p_pkg.

      INSERT zcompany_details FROM wa_company.
      IF sy-subrc = 0.
        COMMIT WORK AND WAIT.
        WRITE: / 'Company registered successfully'.
      ELSE.
        ROLLBACK WORK.
        WRITE: / 'Company registration failed. Check duplicate key or table definition'.
      ENDIF.

    WHEN 'R'.
      SELECT SINGLE *
        FROM zcompany_details
        INTO @wa_company
        WHERE company_id = @p_cid.
      IF sy-subrc = 0.
        WRITE: / wa_company-company_id,
                 wa_company-company_name,
                 wa_company-location,
                 wa_company-job_role,
                 wa_company-package.
      ELSE.
        WRITE: / 'Company not found'.
      ENDIF.

    WHEN 'U'.
      UPDATE zcompany_details
        SET company_name = @p_name,
            location     = @p_loc,
            job_role     = @p_role,
            package      = @p_pkg
        WHERE company_id = @p_cid.
      IF sy-subrc = 0.
        COMMIT WORK AND WAIT.
        WRITE: / 'Company updated successfully'.
      ELSE.
        ROLLBACK WORK.
        WRITE: / 'Company update failed or company not found'.
      ENDIF.

    WHEN 'D'.
      DELETE FROM zcompany_details WHERE company_id = @p_cid.
      IF sy-subrc = 0.
        COMMIT WORK AND WAIT.
        WRITE: / 'Company deleted successfully'.
      ELSE.
        ROLLBACK WORK.
        WRITE: / 'Company not found'.
      ENDIF.

    WHEN OTHERS.
      WRITE: / 'Invalid action. Use C, R, U or D'.
  ENDCASE.
