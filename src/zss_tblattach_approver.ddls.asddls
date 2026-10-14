
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Approver Attachment Projection'
@Metadata.ignorePropagatedAnnotations: false
@Metadata.allowExtensions: true

define view entity ZSS_TBLATTACH_APPROVER
  as projection on ZSS_TBLATTACH
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

  _Travel : redirected to parent ZSS_TRAVELAPPROVER_BO_PROJ
}
