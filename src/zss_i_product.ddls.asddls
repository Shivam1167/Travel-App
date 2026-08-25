@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product CDS  Entity, Basic, Interface Dimension'
@Metadata.ignorePropagatedAnnotations: true
@VDM.viewType: #BASIC
@Analytics.dataCategory: #DIMENSION
define view entity ZSS_I_PRODUCT as select from zss_dt_product
{
    key product_id as ProductId,
    name as Name,
    category as Category,
    price as Price,
    currency as Currency,
    discount as Discount
    
}
