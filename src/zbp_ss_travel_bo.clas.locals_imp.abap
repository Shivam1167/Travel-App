

CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR Travel RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
       keys REQUEST requested_features FOR Travel RESULT result.
    METHODS copytravel FOR MODIFY
      keys FOR ACTION travel~copytravel.
    METHODS calctotalprice FOR MODIFY
      keys FOR ACTION travel~calctotalprice.
    METHODS calculatetotalprice FOR DETERMINE ON MODIFY
      keys FOR travel~calculatetotalprice.
    METHODS validateheaderdata FOR VALIDATE ON SAVE
      keys FOR travel~validateheaderdata.
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
  METHOD get_instance_features.

  "Disabling creation of further bookings inside a Travel Request if it is Rejected.
  "Read the data using EML
  READ ENTITIES OF zss_travel_bo in LOCAL MODE
   ENTITY TRAVEL
      FIELDS ( travelId OverallStatus )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_travels)
      FAILED failed.

   "Step 2: Return the result with Booking Creation is possible or not
       READ TABLE lt_travels INTO DATA(ls_travel) INDEX 1.

   ""Step3: Determine if the status is rejected
   IF ls_travel-OverallStatus = 'X' .
     data(lv_allow) = if_abap_behv=>fc-o-disabled.
   else.
   lv_allow = if_abap_behv=>fc-o-enabled.
   ENDIF.

   result = value #( for travel in lt_travels (

        %tky = travel-%tky
        %assoc-_Booking = lv_allow
   ) ).


  ENDMETHOD.

  METHOD copyTravel.

  ""Step 1: Declare new itab where we store data to be created
  DATA: travels type table for create zss_travel_bo\\Travel,
        bookings_cba TYPE TABLE FOR CREATE zss_travel_bo\\Travel\_Booking,
        booksuppl_cba TYPE TABLE FOR CREATE zss_travel_bo\\Booking\_BookSuppl.

  ""Step 2: Remove the travel instances with initial %cid
  READ TABLE keys WITH KEY %cid = '' into data(key_with_initial_cid).
  ASSERT KEY_with_initial_cid IS INITIAL.

  ""Step3: Read all the travel data for incoming travel id
  READ ENTITIES OF ZSS_TRAVEL_BO IN LOCAL MODE
  ENTITY travel
     ALL FIELDS WITH CORRESPONDING #( keys )
     RESULT data(lt_travel)
     failed failed.

  READ ENTITIES OF ZSS_TRAVEL_BO IN LOCAL MODE
  ENTITY travel by \_Booking
     ALL FIELDS WITH CORRESPONDING #( lt_travel )
     RESULT data(lt_booking)
     failed failed.

  READ ENTITIES OF ZSS_TRAVEL_BO IN LOCAL MODE
  ENTITY Booking BY \_BookSuppl
     ALL FIELDS WITH CORRESPONDING #( lt_booking )
     RESULT data(lt_booksuppl)
     failed failed.

  ""Step 4: Loop at our actual data and prepare our table for create new travel req.
  LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<travel>).

  APPEND VALUE #( %cid = keys[ %tky = <travel>-%tky ]-%cid
                 %data = CORRESPONDING #( <travel> except travelid )
                  ) to travels ASSIGNING FIELD-SYMBOL(<new_travel>).

           <new_travel>-BeginDate = cl_abap_Context_info=>get_system_Date( ).
           <new_travel>-EndDate = cl_abap_Context_info=>get_system_date(  ) + 5.
           <new_travel>-OverallStatus = 'O'.

       "Step 4.1: Fill the booking internal table for data creation - deep copy
       APPEND VALUE #( %cid_ref = keys[ %tky = <travel>-%tky ]-%cid
       ) to bookings_cba ASSIGNING FIELD-SYMBOL(<bookings_cba>).


       LOOP AT lt_booking ASSIGNING FIELD-SYMBOL(<booking>) WHERE travelid = <travel>-TravelId.

       APPEND value #( %cid = keys[ %tky = <travel>-%tky ]-%cid && <booking>-BookingId
                       %data = CORRESPONDING #( lt_booking[ key entity %tky = <booking>-%tky ] except travelid )
                       ) to <bookings_cba>-%target ASSIGNING FIELD-SYMBOL(<new_booking>).

                  <new_booking>-bookingstatus = 'N'.

           APPEND VALUE #(
                %cid_ref = <new_booking>-%cid
               ) TO booksuppl_cba
                  ASSIGNING FIELD-SYMBOL(<booksuppl_cba>).

        ""Step 2: Fill the supplement data
        LOOP AT lt_booksuppl ASSIGNING FIELD-SYMBOL(<booksuppl>)
  USING KEY ENTITY
  WHERE travelid = <travel>-TravelId
    AND bookingid = <booking>-BookingId.

  APPEND VALUE #(
    %cid = |{ <new_booking>-%cid }_{ <booksuppl>-BookingSupplementId }|
    %data = CORRESPONDING #(
      <booksuppl>
      EXCEPT travelid bookingid
    )
  ) TO <booksuppl_cba>-%target.

ENDLOOP.
      ENDLOOP.
      ENDLOOP.

    ""Step 5: Fire EML to create new data in DB
      MODIFY ENTITIES OF ZSS_TRAVEL_BO IN LOCAL MODE
  ENTITY Travel
  CREATE FIELDS (
    AgencyId
    CustomerId
    BeginDate
    EndDate
    BookingFee
    TotalPrice
    CurrencyCode
    OverallStatus
  )
  WITH travels
  CREATE BY \_Booking fields ( bookingid bookingdate customerid carrierid connectionid flightdate flightprice currencycode bookingstatus )
  with bookings_cba
  entity booking
  CREATE by \_BookSuppl fields ( bookingsupplementid supplementid price currencycode )
      with booksuppl_cba
  MAPPED DATA(mapped_create).

mapped-travel = mapped_create-travel.
  ENDMETHOD.

  METHOD calcTotalPrice.
* Define a structure to store AMT+CURRENCY
  TYPES: BEGIN OF ty_amount_per_Currency,
               amount TYPE /dmo/total_price,
               currency_code TYPE /dmo/currency_code,
     END OF ty_amount_per_currency.


* Create a internal table for that Structure
   DATA: amounts_per_currency TYPE STANDARD TABLE OF ty_amount_per_currency.

* First add the Booking fee to the table

   READ ENTITIES OF ZSS_TRAVEL_BO IN LOCAL MODE
     ENTITY TRAVEL
     FIELDS ( BookingFee CurrencyCode )
     WITH CORRESPONDING #( keys )
     RESULT DATA(travels).


   READ ENTITIES OF ZSS_TRAVEL_BO IN LOCAL MODE
     ENTITY TRAVEL by \_Booking
     FIELDS ( FlightPrice CurrencyCode )
     WITH CORRESPONDING #( travels )
     RESULT DATA(bookings).


   READ ENTITIES OF ZSS_TRAVEL_BO IN LOCAL MODE
     ENTITY booking by \_BookSuppl
     FIELDS ( Price CurrencyCode )
     WITH CORRESPONDING #( Bookings )
     RESULT DATA(bookingsupplements).

     "Delete all records which does not have currency code -- Throw Exception
     DELETE travels WHERE currencycode IS INITIAL.
     DELETE bookings WHERE currencycode IS INITIAL.
     DELETE bookingsupplements WHERE currencycode IS INITIAL.

     "Total amount will be calculated by summing in common curr(header)
     LOOP AT travels ASSIGNING FIELD-SYMBOL(<travels>).

     "Set our first value in internal table for booking fee which comes from header
     amounts_per_currency = value #( ( amount = <travels>-BookingFee Currency_code = <travels>-CurrencyCode ) ).

     "Loop at booking data and accumulate all bookings total in each currency

     LOOP AT bookings INTO DATA(booking) WHERE travelid = <travels>-Travelid.

      COLLECT value ty_amount_per_currency( amount = booking-FlightPrice currency_code = booking-CurrencyCode )
         INTO amounts_per_currency.

      ENDLOOP.

      LOOP AT bookingsupplements INTO DATA(supplement) where travelid = <travels>-Travelid.

      COLLECT value ty_amount_per_currency( amount = supplement-Price currency_code = supplement-CurrencyCode )
         INTO amounts_per_currency.

      ENDLOOP.

     ENDLOOP.

     "Loop at each record in our temp table, compare currency at header , if not match convert and total

     LOOP AT amounts_per_currency INTO DATA(amount_per_currency).

     IF amount_per_currency-currency_code = <travels>-CurrencyCode.
      <travels>-TotalPrice += amount_per_currency-amount.

      else.

      "Currency Conversion
      /dmo/cl_flight_amdp=>convert_currency(
        EXPORTING
          iv_amount               = amount_per_currency-amount
          iv_currency_code_source = amount_per_currency-currency_code
          iv_currency_code_target = <travels>-CurrencyCode
          iv_exchange_rate_date   = cl_abap_context_info=>get_system_date(  )
        IMPORTING
          ev_amount               =  data(total_amount)
      ).

            <travels>-TotalPrice += total_amount.
        ENDIF.
        ENDLOOP.

    "EML to update data in database for the current travel request
    MODIFY ENTITIES OF ZSS_TRAVEL_BO IN LOCAL MODE
    ENTITY TRAVEL
       UPDATE FIELDS ( totalprice )
       WITH CORRESPONDING #( travels ).







  ENDMETHOD.

  METHOD calculateTotalPrice.

  MODIFY ENTITIES OF ZSS_TRAVEL_BO  IN LOCAL MODE
  ENTITY Travel
  EXECUTE calcTotalPrice
  FROM CORRESPONDING #( keys ).

  ENDMETHOD.


  METHOD validateHeaderData.

    READ ENTITIES OF ZSS_TRAVEL_BO  IN LOCAL MODE
  ENTITY Travel
  fields ( customerid begindate enddate agencyid )
  WITH CORRESPONDING #( keys )
  RESULT DATA(lt_travel).

"Declare a internal table of unique customer id's which needs to be validated

DATA customers TYPE SORTED TABLE OF /dmo/customer WITH UNIQUE KEY customer_id.

LOOP AT lt_travel INTO DATA(ls_travel).

"Unique customer id's in a table
customers = CORRESPONDING #( lt_travel DISCARDING DUPLICATES MAPPING
                                         customer_id = customerid except *
                                          ).

                    DELETE customers where customer_id IS INITIAL.


    "Call DB to fetch valid customers from master data table
    IF customers IS NOT INITIAL.
    SELECT FROM /dmo/customer fields customer_id
           FOR ALL ENTRIES IN @customers
           where customer_id = @customers-customer_id
           INTO TABLE @data(lt_db_customers).


       ENDIF.

     IF ( ls_travel-CustomerId IS INITIAL OR
        NOT line_exists( lt_db_customers[ customer_id = ls_travel-CustomerId ] )
        ).

      APPEND VALUE #( %tky = ls_travel-%tky ) to failed-travel.
      APPEND VALUE #( %tky = ls_travel-%tky
                      %element-customerid = if_abap_behv=>mk-on
                      %msg = new /dmo/cm_flight_messages(
                      textid =  /dmo/cm_flight_messages=>customer_unkown
                      customer_id = ls_travel-CustomerId
                      severity = if_abap_behv_message=>severity-error
                      )

                  ) to reported-travel.


     ENDIF.






 ENDLOOP.





  ENDMETHOD.

ENDCLASS.
