@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel Processor Root Entity'
@Metadata.ignorePropagatedAnnotations: false
define root view entity ZSS_TRAVEL_BO_PROJ as projection on ZSS_TRAVEL_BO
{
    key TravelId,
    AgencyId,
    CustomerId,
    BeginDate,
    EndDate,
    BookingFee,
    TotalPrice,
    CurrencyCode,
    Description,
    OverallStatus,
    /* Associations */
    _Agency,
    _Booking: redirected to composition child ZSS_BOOKING_BO_PROJ,
    _Currency,
    _Customer,
    _OverallStatus
}
