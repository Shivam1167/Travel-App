@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Processor Projection for Attachement'
@Metadata.ignorePropagatedAnnotations: false
@Metadata.allowExtensions: true
define view entity ZSS_TBLATTACH_PROCESSOR as projection on ZSS_TBLATTACH
{
    key TravelId,
    key Id,
    Memo,
    Attachment,
    Filename,
    Filetype,
    LocalCreatedBy,
    LocalCreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt,
    /* Associations */
    _Travel: redirected to parent ZSS_TRAVEL_BO_PROJ
}
