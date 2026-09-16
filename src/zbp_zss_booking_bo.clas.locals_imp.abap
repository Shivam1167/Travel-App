CLASS lhc_Booking DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS earlynumbering_cba_Booksuppl FOR NUMBERING
       entities FOR CREATE Booking\_Booksuppl.

ENDCLASS.

CLASS lhc_Booking IMPLEMENTATION.

  METHOD earlynumbering_cba_Booksuppl.
  "Implement logic to generate supplement id's as starring point of booking id and +1
  DATA max_booking_suppl_id TYPE /dmo/booking_supplement_id.

  ""Step1: Get all the travel request and their booking data
  READ ENTITIES OF ZSS_TRAVEL_BO in LOCAL MODE
    entity booking by \_BookSuppl
    from CORRESPONDING #( entities )
    link data(booking_supplement).

  ""Loop at unique travel id
  LOOP AT entities ASSIGNING FIELD-SYMBOL(<booking_group>) GROUP by <booking_group>-%tky.

  "Step 2: Get the highest booking supplement number which is already there
  LOOP AT booking_supplement into data(ls_booking) USING key entity where
                                             source-TravelId = <booking_group>-TravelId and
                                             source-BookingId = <booking_group>-BookingId.

                IF max_booking_suppl_id < ls_booking-target-BookingSupplementId.
                   max_booking_suppl_id = ls_booking-target-BookingId.

                ENDIF.
                ENDLOOP.

        ""Step 3: Get the assigned booking supplement numbers from incoming request
        LOOP AT entities into data(ls_entity) USING key entity
                                              where travelId = <booking_group>-TravelId and
                                                    bookingId = <booking_group>-BookingId.


            LOOP AT ls_entity-%target into data(ls_target).
              if max_booking_suppl_id < ls_target-BookingId.
                 max_booking_suppl_id = ls_target-BookingId.
                 ENDIF.
                 ENDLOOP.
                 ENDLOOP.
            ""Step4: Loop at all the entities of Travel with save travel id
            LOOP AT entities ASSIGNING FIELD-SYMBOL(<booking>) USING key entity
                                                 where travelId = <booking_group>-TravelId and
                                                    bookingId = <booking_group>-BookingId.
            "Step 5: Assign the new supplement id inside each travel => booking => supplement
            LOOP AT <booking>-%target ASSIGNING FIELD-SYMBOL(<bookingsuppl_wo_numbers>).
              APPEND CORRESPONDING #( <bookingsuppl_wo_numbers> ) to mapped-booksuppl
                                       ASSIGNING FIELD-SYMBOL(<mapped_supplement>).

            IF <mapped_supplement>-BookingSupplementId IS INITIAL.
            max_booking_suppl_id += 1.
            <mapped_supplement>-BookingSupplementId = max_booking_suppl_id.
            ENDIF.
            ENDLOOP.
        ENDLOOP.


    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
