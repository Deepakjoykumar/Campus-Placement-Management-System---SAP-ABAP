REPORT zstudent_report.

PARAMETERS:
  p_act  TYPE c LENGTH 1 DEFAULT 'R',
  p_sid  TYPE zstudent_details-student_id,
  p_name TYPE zstudent_details-student_name,
  p_mail TYPE zstudent_details-email,
  p_ph   TYPE zstudent_details-phone,
  p_dept TYPE zstudent_details-department,
  p_cgpa TYPE zstudent_details-cgpa.

DATA: wa_student TYPE zstudent_details.

START-OF-SELECTION.
  CASE p_act.
    WHEN 'C'.
      CLEAR wa_student.
      wa_student-student_id   = p_sid.
      wa_student-student_name = p_name.
      wa_student-email        = p_mail.
      wa_student-phone        = p_ph.
      wa_student-department   = p_dept.
      wa_student-cgpa         = p_cgpa.

      INSERT zstudent_details FROM wa_student.
      IF sy-subrc = 0.
        COMMIT WORK AND WAIT.
        WRITE: / 'Student created successfully'.
      ELSE.
        ROLLBACK WORK.
        WRITE: / 'Student creation failed. Check duplicate key or table definition'.
      ENDIF.

    WHEN 'R'.
      SELECT SINGLE *
        FROM zstudent_details
        INTO @wa_student
        WHERE student_id = @p_sid.
      IF sy-subrc = 0.
        WRITE: / wa_student-student_id,
                 wa_student-student_name,
                 wa_student-email,
                 wa_student-phone,
                 wa_student-department,
                 wa_student-cgpa.
      ELSE.
        WRITE: / 'Student not found'.
      ENDIF.

    WHEN 'U'.
      UPDATE zstudent_details
        SET student_name = @p_name,
            email        = @p_mail,
            phone        = @p_ph,
            department   = @p_dept,
            cgpa         = @p_cgpa
        WHERE student_id = @p_sid.
      IF sy-subrc = 0.
        COMMIT WORK AND WAIT.
        WRITE: / 'Student updated successfully'.
      ELSE.
        ROLLBACK WORK.
        WRITE: / 'Student update failed or student not found'.
      ENDIF.

    WHEN 'D'.
      DELETE FROM zstudent_details WHERE student_id = @p_sid.
      IF sy-subrc = 0.
        COMMIT WORK AND WAIT.
        WRITE: / 'Student deleted successfully'.
      ELSE.
        ROLLBACK WORK.
        WRITE: / 'Student not found'.
      ENDIF.

    WHEN OTHERS.
      WRITE: / 'Invalid action. Use C, R, U or D'.
  ENDCASE.
