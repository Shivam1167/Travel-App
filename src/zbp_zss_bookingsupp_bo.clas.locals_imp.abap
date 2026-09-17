CLASS lhc_BookSuppl DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS calculateTotalPrice FOR DETERMINE ON MODIFY
       keys FOR BookSuppl~calculateTotalPrice.

ENDCLASS.

CLASS lhc_BookSuppl IMPLEMENTATION.

  METHOD calculateTotalPrice.

  MODIFY ENTITIES OF ZSS_TRAVEL_BO  IN LOCAL MODE
  ENTITY Travel
  EXECUTE calcTotalPrice
  FROM CORRESPONDING #( keys ).

  ENDMETHOD.

ENDCLASS.
