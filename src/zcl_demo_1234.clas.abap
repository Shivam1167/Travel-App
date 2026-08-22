CLASS zcl_demo_1234 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_demo_1234 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

  out->write(
    EXPORTING
      data   = |Welcome to ABAP on Cloud|
*      name   =
*    RECEIVING
*      output =
  ).
  ENDMETHOD.
ENDCLASS.
