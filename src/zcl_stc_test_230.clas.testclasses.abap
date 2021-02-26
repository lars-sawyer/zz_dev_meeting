*"* use this source file for your ABAP unit test classes
CLASS ltcl_test DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      first_test FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_test IMPLEMENTATION.

  METHOD first_test.


    NEW zcl_stc_test_230(  )->start( ).

    DO 10 TIMES.
      TRY.

          NEW zcl_stc_test_230(  )->start( ).

        CATCH cx_root.
      ENDTRY.
    ENDDO.

  ENDMETHOD.

ENDCLASS.
