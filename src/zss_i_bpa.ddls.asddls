@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Business Partner Dimension, Basic Interface'
@Metadata.ignorePropagatedAnnotations: true

@VDM.viewType: #BASIC
@Analytics.dataCategory: #DIMENSION
define view entity ZSS_I_BPA as select from zss_dt_bpa
{
    key bp_id as BpId,
    case  bp_role
      when '01' then 'Customer'
      when '02' then 'Supplier'
      when '03' then 'Employee'
      else 'Unknown'  end as BPType,
    company_name as CompanyName,
    country as Country 
} where bp_role = '01'
