CLASS zcl_ss_ve_calc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ss_ve_calc IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.
    check it_original_data IS NOT INITIAL.

    DATA: lt_calc_data TYPE STANDARD TABLE OF ZSS_TRAVEL_BO_PROJ,
          lv_rate TYPE p decimals 2 value '0.025'.

          lt_calc_data = CORRESPONDING #( it_original_data ).

          LOOP AT lt_calc_data ASSIGNING FIELD-SYMBOL(<fs_calc>).

          <fs_calc>-co2 = <fs_calc>-TotalPrice * lv_rate.
          ""TODO: Replace below code with some class in abap which give you day from date
          <fs_calc>-dayofTravel = 'Sunday'.
          ENDLOOP.

          ct_calculated_data = CORRESPONDING #( lt_calc_data ).


  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
  ENDMETHOD.
ENDCLASS.
