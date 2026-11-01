REPORT zapplied_students_alv.

TABLES: zplacement_details.

SELECT-OPTIONS: s_sid FOR zplacement_details-student_id,
                s_cid FOR zplacement_details-company_id.

TYPES: BEGIN OF ty_output,
         application_id TYPE zplacement_details-application_id,
         student_id     TYPE zplacement_details-student_id,
         student_name   TYPE zstudent_details-student_name,
         company_id     TYPE zplacement_details-company_id,
         company_name   TYPE zcompany_details-company_name,
         round_name     TYPE zplacement_details-round_name,
         status         TYPE zplacement_details-status,
         applied_date   TYPE zplacement_details-applied_date,
       END OF ty_output.

DATA: gt_output TYPE STANDARD TABLE OF ty_output,
      go_alv    TYPE REF TO cl_salv_table.

START-OF-SELECTION.
  SELECT p~application_id,
         p~student_id,
         s~student_name,
         p~company_id,
         c~company_name,
         p~round_name,
         p~status,
         p~applied_date
    FROM zplacement_details AS p
    INNER JOIN zstudent_details AS s
      ON s~student_id = p~student_id
    INNER JOIN zcompany_details AS c
      ON c~company_id = p~company_id
    WHERE p~student_id IN @s_sid
      AND p~company_id IN @s_cid
    INTO CORRESPONDING FIELDS OF TABLE @gt_output.

  IF gt_output IS INITIAL.
    MESSAGE 'No placement applications found' TYPE 'I'.
    RETURN.
  ENDIF.

  TRY.
      cl_salv_table=>factory(
        IMPORTING r_salv_table = go_alv
        CHANGING  t_table      = gt_output ).

      go_alv->get_functions( )->set_all( abap_true ).
      go_alv->get_columns( )->set_optimize( abap_true ).
      go_alv->display( ).

    CATCH cx_salv_msg.
      MESSAGE 'Unable to display ALV report' TYPE 'E'.
  ENDTRY.
