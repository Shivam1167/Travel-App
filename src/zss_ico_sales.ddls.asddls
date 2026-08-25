@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales and Product View'
@Metadata.ignorePropagatedAnnotations: false
@VDM.viewType: #COMPOSITE
@Analytics.dataCategory: #FACT
define view entity ZSS_ICO_SALES as select from ZSS_I_SALES as Sales
association of many to one ZSS_I_PRODUCT as _Product
on $projection.Product = _Product.ProductId
{
    key ItemId,
    OrderId,
    Product,
    Amount,
    Currency,
    Qty,
    Uom,
    /* Associations */
    _header.buyer as Buyer,
    _Product.Category as ProductCategory,
    _Product.Name as ProductName
    
}
