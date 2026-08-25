@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Cube'
@Metadata.ignorePropagatedAnnotations: false
@VDM.viewType: #COMPOSITE
@Analytics.dataCategory: #CUBE
define view entity ZSS_ICO_SALES_CUBE as select from ZSS_ICO_SALES
association of many to one ZSS_I_BPA as _BusinessPartner
on $projection.Buyer = _BusinessPartner.BpId
{
    key ItemId,
    OrderId,
    Product,
    @DefaultAggregation: #SUM
    Amount,
    Currency,
    @DefaultAggregation: #SUM
    Qty,
    Uom,
    Buyer,
    ProductCategory,
    ProductName,
    _BusinessPartner.CompanyName,
    _BusinessPartner.Country
}
