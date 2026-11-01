REPORT zplacement_status_alv.

TABLES: zplacement_details.

SELECT-OPTIONS: s_stat FOR zplacement_details-status,
                s_date FOR zplacement_details-applied_date.

TYPES: BEGIN OF ty_status,
         application_id TYPE zplacement_details-application_id,
         student_id     TYPE zplacement_details-student_id,
         company_id     TYPE zplacement_details-company_id,
         round_name     TYPE zplacement_details-round_name,
         status         TYPE zplacement_details-status,
         applied_date   TYPE zplacement_details-applied_date,
       END OF ty_status.

DATA: gt_status TYPE STANDARD TABLE OF ty_status,
      go_alv    TYPE REF TO cl_salv_table.

START-OF-SELECTION.
  SELECT application_id,
         student_id,
         company_id,
         round_name,
         status,
         applied_date
    FROM zplacement_details
    WHERE status IN @s_stat
      AND applied_date IN @s_date
    INTO TABLE @gt_status.

  IF gt_status IS INITIAL.
    MESSAGE 'No placement status records found' TYPE 'I'.
    RETURN.
  ENDIF.

  TRY.
      cl_salv_table=>factory(
        IMPORTING r_salv_table = go_alv
        CHANGING  t_table      = gt_status ).

      go_alv->get_functions( )->set_all( abap_true ).
      go_alv->get_columns( )->set_optimize( abap_true ).
      go_alv->display( ).

    CATCH cx_salv_msg.
      MESSAGE 'Unable to display ALV report' TYPE 'E'.
  ENDTRY.
