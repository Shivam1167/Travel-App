@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Total sales by Dimensions'
@Metadata.ignorePropagatedAnnotations: false
@VDM.viewType: #CONSUMPTION
@Analytics.query: true
define view entity ZSS_TOTAL_QUANTITY as select from ZSS_ICO_SALES_CUBE
{
    
    @EndUserText.label: 'Spiderman'
    key ProductCategory,
    @EndUserText.label: 'Customer'
    key CompanyName,
    @EndUserText.label: 'Place of Order'
    key Country,
    @EndUserText.label: 'Unit of Measure'
    key Uom as UnitofMeasure,
    @EndUserText.label: 'Quantity Sold'
    Qty as QuantitySold
    
}
