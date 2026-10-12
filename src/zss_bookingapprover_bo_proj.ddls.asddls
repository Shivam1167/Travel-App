@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Projection'
@Metadata.ignorePropagatedAnnotations: false
@VDM.viewType: #CONSUMPTION
@Metadata.allowExtensions: true
define view entity ZSS_BOOKINGAPPROVER_BO_PROJ as projection on ZSS_BOOKING_BO
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
    _Carrier,
    _Connection,
    _Currency,
    _Customer,
    _Travel: redirected to parent ZSS_TRAVELAPPROVER_BO_PROJ
}
