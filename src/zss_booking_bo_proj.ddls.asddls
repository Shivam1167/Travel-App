@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Projection'
@Metadata.ignorePropagatedAnnotations: false
@VDM.viewType: #CONSUMPTION
@Metadata.allowExtensions: true
define view entity ZSS_BOOKING_BO_PROJ as projection on ZSS_BOOKING_BO
{
    key TravelId,
    key BookingId,
    BookingDate,
    CustomerId,
    CarrierId,
    ConnectionId,
    FlightDate,
    FlightPrice,
    CurrencyCode,
    BookingStatus,
    LastChangedAt,
    BookingStatusText,
    AirlineName,
    CustomerName,
    /* Associations */
    _BookStatus,
    _BookSuppl: redirected to composition child ZSS_BOOKINGSUPP_BO_PROJ,
    _Carrier,
    _Connection,
    _Currency,
    _Customer,
    _Travel: redirected to parent ZSS_TRAVEL_BO_PROJ
}
