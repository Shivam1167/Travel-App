@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Attachment Child CDS Entity for Travel'
@Metadata.ignorePropagatedAnnotations: false
define view entity ZSS_TBLATTACH as select from zss_attach_tbl

association to parent ZSS_TRAVEL_BO as _Travel on
 $projection.TravelId = _Travel.TravelId
{
    key travel_id as TravelId,
    @EndUserText.label: 'Attach Id'
    key id as Id,
    @EndUserText.label: 'Comments'
    memo as Memo,
    @EndUserText.label: 'Attachment'
    @Semantics.largeObject : {
      mimeType: 'FileType',
      fileName : 'FileName',
      contentDispositionPreference: #INLINE,
      acceptableMimeTypes: ['application/pdf']
      
      }  
    attachment as Attachment,
    @EndUserText.label: 'File Name'
    filename as Filename,
    @EndUserText.label: 'File Type'
    filetype as Filetype,
    @Semantics.user.createdBy: true
    local_created_by as LocalCreatedBy,
    @Semantics.systemDateTime.createdAt: true
    local_created_at as LocalCreatedAt,
    @Semantics.user.lastChangedBy: true
    local_last_changed_by as LocalLastChangedBy,
    @Semantics.systemDateTime.lastChangedAt: true
    local_last_changed_at as LocalLastChangedAt,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at as LastChangedAt,
    _Travel
}
