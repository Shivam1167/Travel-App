@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Child Entity'
@Metadata.ignorePropagatedAnnotations: true
@VDM.viewType: #BASIC
define view entity ZSS_BOOKING_BO
  as select from /dmo/booking_m
  composition [1..*] of ZSS_BOOKINGSUPP_BO    as _BookSuppl
  --ask student whether the person is father or not
  association     to parent ZSS_TRAVEL_BO         as _Travel on  $projection.TravelId = _Travel.TravelId
  association [1] to /DMO/I_Customer          as _Customer   on  $projection.CustomerId = _Customer.CustomerID
  association [1] to /DMO/I_Carrier           as _Carrier    on  $projection.CarrierId = _Carrier.AirlineID
  association [1] to /DMO/I_Connection        as _Connection on  $projection.CarrierId    = _Connection.AirlineID
                                                             and $projection.ConnectionId = _Connection.ConnectionID
  association [1] to I_Currency               as _Currency   on  $projection.CurrencyCode = _Currency.Currency
  association [1] to /DMO/I_Booking_Status_VH as _BookStatus on  $projection.BookingStatus = _BookStatus.BookingStatus



{

  key travel_id                                                     as TravelId,
  key booking_id                                                    as BookingId,
      booking_date                                                  as BookingDate,
      @ObjectModel.text.element: [ 'CustomerName' ]
      @Consumption.valueHelpDefinition: [
                   {

                     entity.name: '/DMO/I_Customer',
                     entity.element: 'CustomerId'

                    }

       ]
      customer_id                                                   as CustomerId,
      _Customer.LastName                                            as CustomerName,
      @ObjectModel.text.element: [ 'AirlineName' ]
      @Consumption.valueHelpDefinition: [
                   {

                     entity.name: '/DMO/I_Carrier',
                     entity.element: 'AirlineID'

                    }

       ]
      carrier_id                                                    as CarrierId,
      _Carrier.Name                                                 as AirlineName,
      @Consumption.valueHelpDefinition: [
                   {

                     entity.name: '/DMO/I_Connection',
                     entity.element: 'ConnectionID',
                     additionalBinding: [

                       {

                         element: 'AirlineID',
                         localElement: 'CarrierId'

                       }

                     ]

                    }

       ]
      connection_id                                                 as ConnectionId,
      flight_date                                                   as FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      flight_price                                                  as FlightPrice,
      @Consumption.valueHelpDefinition: [ 
                { 
                
                  entity.name: 'I_Currency',
                  entity.element: 'Currency'
                
                 }
                
    ]
      currency_code                                                 as CurrencyCode,
      @ObjectModel.text.element: [ 'BookingStatusText' ]
      @Consumption.valueHelpDefinition: [
                   {

                     entity.name: '/DMO/I_Booking_Status_VH',
                     entity.element: 'BookingStatus'

                    }

       ]
      booking_status                                                as BookingStatus,
      _BookStatus._Text[ Language = $session.system_language ].Text as BookingStatusText,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at                                               as LastChangedAt,
      _Customer,
      _Carrier,
      _Connection,
      _Currency,
      _BookStatus,
      _Travel,
      _BookSuppl
}
