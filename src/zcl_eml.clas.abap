CLASS zcl_eml DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .


  PUBLIC SECTION.
  DATA: lv_opr TYPE C VALUE 'D'.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_eml IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

  case lv_opr.
    when 'r'.
         READ ENTITIES OF ZSS_TRAVEL_BO
         ENTITY Travel
         fields ( travelid begindate agencyid customerid overallstatus )
         with VALUE #(

                 ( travelid = '00000010' )
                 ( travelid = '00000024' )
                 ( travelid = '50000024' )
         )

         RESULT data(lt_result)
         FAILED data(lt_failed)
         REPORTED data(lt_report).

         out->write(
           EXPORTING
             data   = lt_result
         ).

         out->write(
           EXPORTING
             data   = lt_failed
         ).

         out->write(
           EXPORTING
             data   = lt_report
         ).
         WHEN 'C'.


          data(lv_descr) = 'Shivam rocks with RAP'.
          data(lv_agency) = '070016'.
          data(lv_customer) = '000697'.

          MODIFY ENTITIES OF ZSS_TRAVEL_BO
          ENTITY Travel
          CREATE FIELDS ( TravelId AgencyId CustomerId CurrencyCode BeginDate EndDate Description OverallStatus )
                WITH VALUE #(

                                (
                                   %CID = 'Shivam'
                                   TravelId = '00012347'
                                   AgencyId = lv_agency
                                   CustomerId = lv_customer
                                   CurrencyCode = 'USD'
                                   BeginDate = cl_abap_context_info=>get_system_date( )
                                   EndDate = cl_abap_context_info=>get_system_date(  ) + 30
                                   Description = lv_descr
                                   OverallStatus = 'O'

                                 )


                                (
                                   %CID = 'Shivam-1'
                                   TravelId = '00012348'
                                   AgencyId = lv_agency
                                   CustomerId = lv_customer
                                   CurrencyCode = 'USD'
                                   BeginDate = cl_abap_context_info=>get_system_date( )
                                   EndDate = cl_abap_context_info=>get_system_date(  ) + 30
                                   Description = lv_descr
                                   OverallStatus = 'O'

                                 )


                                (
                                   %CID = 'Shivam-2'
                                   TravelId = '00012347'
                                   AgencyId = lv_agency
                                   CustomerId = lv_customer
                                   CurrencyCode = 'USD'
                                   BeginDate = cl_abap_context_info=>get_system_date( )
                                   EndDate = cl_abap_context_info=>get_system_date(  ) + 30
                                   Description = lv_descr
                                   OverallStatus = 'O'

                                 )



                            )

                           mapped data(lt_mapped)
                           failed lt_failed
                           reported lt_report.

                       out->write(
           EXPORTING
             data   = lt_mapped
         ).

         out->write(
           EXPORTING
             data   = lt_failed
         ).

         out->write(
           EXPORTING
             data   = lt_report
         ).
         COMMIT ENTITIES.

         WHEN 'U'.

          lv_agency = '070018'.
          lv_descr = 'S S  S Shivam'.

          MODIFY ENTITIES OF ZSS_TRAVEL_BO
          ENTITY Travel
          UPDATE FIELDS (  AgencyId  Description )
                WITH VALUE #(

                                (

                                   TravelId = '00012347'
                                   AgencyId = lv_agency
                                   Description = lv_descr

                                 )


                                (

                                   TravelId = '00012348'
                                   AgencyId = lv_agency
                                   Description = lv_descr

                                 )



                            )

                           mapped lt_mapped
                           failed lt_failed
                           reported lt_report.

                       out->write(
           EXPORTING
             data   = lt_mapped
         ).

         out->write(
           EXPORTING
             data   = lt_failed
         ).

         out->write(
           EXPORTING
             data   = lt_report
         ).

         COMMIT ENTITIES.

         WHEN 'D'.

         MODIFY ENTITIES OF ZSS_TRAVEL_BO
          ENTITY Travel
          DELETE FROM
                VALUE #(

                                (

                                   TravelId = '00012347'
                                 )


                                (

                                   TravelId = '00012348'
                                 )



                            )

                           mapped lt_mapped
                           failed lt_failed
                           reported lt_report.

                       out->write(
           EXPORTING
             data   = lt_mapped
         ).

         out->write(
           EXPORTING
             data   = lt_failed
         ).

         out->write(
           EXPORTING
             data   = lt_report
         ).

         COMMIT ENTITIES.


ENDCASE.
  ENDMETHOD.
ENDCLASS.
