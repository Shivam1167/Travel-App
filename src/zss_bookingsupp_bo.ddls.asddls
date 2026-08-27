@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Supplement Grand Child Entity'
@Metadata.ignorePropagatedAnnotations: true
@VDM.viewType: #BASIC
define view entity ZSS_BOOKINGSUPP_BO as select from /dmo/booksuppl_m
association to parent ZSS_BOOKING_BO as _Booking on
   $projection.TravelId = _Booking.TravelId and
   $projection.BookingId = _Booking.BookingId
   
association[1..1] to ZSS_TRAVEL_BO as _Travel on
   $projection.TravelId = _Travel.TravelId
   
association[0..1] to /DMO/I_Supplement as _Product on
   $projection.SupplementId = _Product.SupplementID
   
association[1..1] to /DMO/I_SupplementText as _ProductText on
   $projection.SupplementId = _ProductText.SupplementID
   

{
    key /dmo/booksuppl_m.travel_id as TravelId,
    key /dmo/booksuppl_m.booking_id as BookingId,
    key /dmo/booksuppl_m.booking_supplement_id as BookingSupplementId,
    /dmo/booksuppl_m.supplement_id as SupplementId,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    /dmo/booksuppl_m.price as Price,
    /dmo/booksuppl_m.currency_code as CurrencyCode,
    @Semantics.systemDateTime.lastChangedAt: true
    /dmo/booksuppl_m.last_changed_at as LastChangedAt,
    _Booking,
    _Travel,
    _ProductText
}
