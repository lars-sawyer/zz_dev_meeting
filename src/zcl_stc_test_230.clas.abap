CLASS zcl_stc_test_230 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS start.
    METHODS exit.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_stc_test_230 IMPLEMENTATION.

  METHOD exit.

  ENDMETHOD.

  METHOD start.
*    data lv_guid type guid.
    DATA ls_new_entry TYPE zstc_t_test_002.

    DATA lv_guid_initial TYPE guid.
    DATA(lv_guid) = hlp=>get( guid16 = 'X' ).
    DATA(lv_guid_gds) = hlp=>get( guid16 = 'X' ).

*    select single guid
*    from ZSTC_T_TEST_002
*    into @data(ls_entry)
*    where guid_next = @lv_guid. "is Initial.


    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " sperren

    "sonderlogik tabelle ist ller
    select count(  * )
    from zstc_t_test_002
    into @data(lv_counter).
    if lv_counter <> 0.

    DO.
      UPDATE zstc_t_test_002
         SET
           guid_next  = lv_guid
           text       = 'Maschine wird gestartet'
           busyflag   = 'X'
         WHERE
           guid_next  = lv_guid_initial.
      IF sy-subrc = 0.
        COMMIT WORK.
        EXIT.
      ENDIF.

      SELECT SINGLE *
      FROM zstc_t_test_002
      INTO @DATA(ls_entry)
      WHERE
        busyflag = 'X'.
      IF sy-subrc = 0.
        hlp=>x_raise( ls_entry-text ).
      ENDIF.

    ENDDO.

    else.

    endif.


    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " Schnittstelle



    WAIT UP TO 3 SECONDS.




    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " updaten

    SELECT SINGLE *
     FROM zstc_t_test_002
     INTO ls_entry
     WHERE
       guid_next =  lv_guid.
*       busyflag = 'X'.
*    IF sy-subrc <> 0.
*      hlp=>x_raise( ls_entry-text ).
*    ENDIF.

    DATA lt_entry TYPE STANDARD TABLE OF zstc_t_test_002.
    ls_entry-busyflag = ''.
    ls_entry-timestampl = hlp=>get( timestampl = 'X' ).
    ls_entry-text = 'Maschine gestartet'.
    ls_entry-lgpla = 'ABCDEF'.
    ls_entry-guid_gds = lv_guid_gds.
    INSERT ls_entry INTO TABLE lt_entry.

    CLEAR ls_entry.
    ls_entry-guid = lv_guid.
    INSERT ls_entry INTO TABLE lt_entry.

    MODIFY zstc_t_test_002 FROM TABLE lt_entry.

    gds=>factory( lv_guid_gds )->add_log( hlp=>msg( val = 'Maschine wurde erfolgreich gestartet' type = 'S' ) )->db_create(  ).

    COMMIT WORK AND WAIT.

  ENDMETHOD.

ENDCLASS.
