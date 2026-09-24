CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS augment_create FOR MODIFY
       entities FOR CREATE Travel.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD augment_create.
   DATA: travel_create TYPE TABLE FOR create ZSS_TRAVEL_BO.

   travel_create = CORRESPONDING #( entities ).

   LOOP AT travel_create ASSIGNING FIELD-SYMBOL(<travel>).
   <travel>-AgencyId = '70003'.
   <travel>-OverallStatus = 'O'.
   <travel>-%control-AgencyId = if_abap_behv=>mk-on.
   <travel>-%control-OverallStatus = if_abap_behv=>mk-on.

   ENDLOOP.

   MODIFY AUGMENTING ENTITIES OF ZSS_TRAVEL_BO
   ENTITY Travel
   CREATE from travel_create.


  ENDMETHOD.

ENDCLASS.
