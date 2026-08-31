@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Supplement Projection Processor'
@Metadata.ignorePropagatedAnnotations: false
@VDM.viewType: #CONSUMPTION
@Metadata.allowExtensions: true
define view entity ZSS_BOOKINGSUPP_BO_PROJ as projection on ZSS_BOOKINGSUPP_BO
{
    key TravelId,
    key BookingId,
    key BookingSupplementId,
    SupplementId,
    Price,
    CurrencyCode,
    LastChangedAt,
    /* Associations */
    _Booking: redirected to parent ZSS_BOOKING_BO_PROJ,
    _ProductText,
    _Travel: redirected to ZSS_TRAVEL_BO_PROJ
}
