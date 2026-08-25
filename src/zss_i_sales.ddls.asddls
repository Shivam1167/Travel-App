@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Pure transaction Basic Interface, fact'
@Metadata.ignorePropagatedAnnotations: false
@VDM.viewType: #BASIC
@Analytics.dataCategory: #FACT
define view entity ZSS_I_SALES as select from zss_dt_salesitem
association of one to one zss_dt_saleshead as _header on
$projection.OrderId = _header.order_id
{
    key item_id as ItemId,
    order_id as OrderId,
    product as Product,
    amount as Amount,
    currency as Currency,
    qty as Qty,
    uom as Uom,
    _header
}
