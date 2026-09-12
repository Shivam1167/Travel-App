

CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR Travel RESULT result.
    METHODS earlynumbering_cba_Booking FOR NUMBERING
      entities FOR CREATE Travel\_Booking.
    METHODS earlynumbering_create FOR NUMBERING
      entities FOR CREATE Travel.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_instance_authorizations.

  ENDMETHOD.

  METHOD get_global_authorizations.

  ENDMETHOD.

  METHOD earlynumbering_create.

  "Step 1: Data type declaration
  DATA: entity TYPE STRUCTURE FOR CREATE ZSS_TRAVEL_BO\\Travel,
        travel_id_max TYPE /dmo/travel_id.

  "Step 2: Ensure that the travel id is not set for any of the record.
  LOOP AT entities into entity where travelid IS NOT INITIAL.
   APPEND CORRESPONDING #( entity ) to mapped-travel.

  ENDLOOP.

  "Step 3: Keep the record where travel id is blank -  I as dev. will take control to generateid
  DATA(entities_wo_travelid) = entities.
  delete entities_wo_travelid where travelid IS NOT INITIAL.

  "Step 4: Get the sequence no. from snro ----> starting seq. no. how many no. 2002 -- 3 numbers
  try.

    cl_numberrange_runtime=>number_get(
      EXPORTING
        nr_range_nr       = '01'
        object            = conv #( '/DMO/TRAVL' )
        quantity          = conv #( LINES( entities_wo_travelid ) )
      IMPORTING
         number            = data(number_Range_key)
         returncode        = data(number_range_return_code)
        returned_quantity =  data(number_range_return_quantity)
    ).
    CATCH cx_nr_object_not_found into data(lx_not_found).
     LOOP AT entities_wo_travelid INTO entity.
     append value #( %cid = entity-%cid %key = entity-%key %msg = lx_not_found ) to reported-travel.
     append value #( %cid = entity-%cid %key = entity-%key ) to failed-travel.
     ENDLOOP.

    CATCH cx_number_ranges into data(lx_number_range).
      LOOP AT entities_wo_travelid INTO entity.
     APPEND value #( %cid = entity-%cid %key = entity-%key %msg = lx_number_range ) to reported-travel.
     APPEND value #( %cid = entity-%cid %key = entity-%key ) to failed-travel.
     ENDLOOP.
  endtry.

  "Extra Bonus
   CASE number_range_return_code.
   WHEN '1'.
   "When number range exceeded a critical threshold
   LOOP AT entities_wo_travelid into entity.
        APPEND VALUE #(    %cid = entity-%cid %key = entity-%key
                        %msg = new /dmo/cm_flight_messages(

                                textid = /dmo/cm_flight_messages=>number_range_depleted
                                severity = if_abap_behv_message=>severity-warning
                                )


                        )
                       to reported-travel.
                   ENDLOOP.

    WHEN '2' or '3'.
      LOOP AT entities_wo_travelid into entity.
        APPEND VALUE #( %cid = entity-%cid %key = entity-%key
                        %msg = new /dmo/cm_flight_messages(

                                textid = /dmo/cm_flight_messages=>not_sufficient_numbers
                                severity = if_abap_behv_message=>severity-error
                        )
                        )
                       to reported-travel.

                 append value #( %cid = entity-%cid %key = entity-%key
                                 %fail-cause = if_abap_behv=>cause-conflict

                                 )
                                to failed-travel.
       ENDLOOP.

       ENDCASE.

 ""Step 5: Count the records loop the data and assign number range by incrementing one every time
   ASSERT number_range_return_quantity = lines( entities_wo_travelid ).

   travel_id_max = number_range_key - number_range_return_quantity.

   LOOP AT entities_wo_travelid INTO ENTITY.

     travel_id_max += 1.
     entity-TravelId = travel_id_max.

     APPEND value #( %cid = entity-%cid %key = entity-%key ) to mapped-travel.
     ENDLOOP.


  ENDMETHOD.

  METHOD earlynumbering_cba_Booking.

  "Step 1: Define variable to get max booking ID for given travel
  DATA max_booking_id TYPE /dmo/booking_id.

  "Step 2: Get existing bookings for the travel
  READ ENTITIES OF ZSS_TRAVEL_BO IN LOCAL MODE

    ENTITY Travel BY \_Booking

    FROM CORRESPONDING #( entities )

    LINK DATA(lt_bookings).


  "Step 3: Process each Travel separately
  LOOP AT entities ASSIGNING FIELD-SYMBOL(<travel_group>)
       GROUP BY <travel_group>-TravelId.

    "Reset max booking ID for every Travel
    CLEAR max_booking_id.


    "Step 4: Find highest existing Booking ID
    LOOP AT lt_bookings INTO DATA(ls_booking)
         USING KEY entity
         WHERE source-TravelId = <travel_group>-TravelId.

      IF max_booking_id < ls_booking-target-BookingId.

        max_booking_id = ls_booking-target-BookingId.

      ENDIF.

    ENDLOOP.


    "Step 5: Check Booking IDs coming in the current request
    LOOP AT GROUP <travel_group>
         ASSIGNING FIELD-SYMBOL(<travel>).

      LOOP AT <travel>-%target
           INTO DATA(ls_target).

        IF max_booking_id < ls_target-BookingId.

          max_booking_id = ls_target-BookingId.

        ENDIF.

      ENDLOOP.

    ENDLOOP.


    "Step 6: Assign new Booking IDs
    LOOP AT GROUP <travel_group>
         ASSIGNING <travel>.

      LOOP AT <travel>-%target
           ASSIGNING FIELD-SYMBOL(<booking_wo_numbers>).

        APPEND CORRESPONDING #( <booking_wo_numbers> )
          TO mapped-booking
          ASSIGNING FIELD-SYMBOL(<mapped_booking>).

        IF <mapped_booking>-BookingId IS INITIAL.

          max_booking_id += 10.

          <mapped_booking>-BookingId = max_booking_id.

        ENDIF.

      ENDLOOP.

    ENDLOOP.

  ENDLOOP.

ENDMETHOD.
ENDCLASS.
