@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Total sales by Dimensions'
@Metadata.ignorePropagatedAnnotations: false
@VDM.viewType: #CONSUMPTION
@Analytics.query: true
define view entity ZSS_TOTAL_SALES as select from ZSS_ICO_SALES_CUBE
{
    
    key ProductCategory,
    key CompanyName,
    key Country,
    key Currency,
    Amount
    
}
