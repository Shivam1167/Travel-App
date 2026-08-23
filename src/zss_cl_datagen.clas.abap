CLASS zss_cl_datagen DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
    meTHODS fill_master_data.
    meTHODS fill_transaction_data.
    meTHODS flush.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zss_cl_datagen IMPLEMENTATION.


 METHOD fill_master_data.
    data : lt_bp type table of zss_dt_bpa,
           lt_prod type table of zss_dt_product.

    append value #(
                    bp_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                    bp_role = '01'
                    company_name = 'TACUM'
                    street = 'Victoria Street'
                    city = 'Kolkatta'
                    country = 'IN'
                    region = 'APJ'
                    )
                    to lt_bp.
    append value #(
                    bp_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                    bp_role = '01'
                    company_name = 'SAP'
                    street = 'Rosvelt Street Road'
                    city = 'Walldorf'
                    country = 'DE'
                    region = 'EMEA'
                    )
                    to lt_bp.
    append value #(
                    bp_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                    bp_role = '01'
                    company_name = 'Asia High tech'
                    street = '1-7-2 Otemachi'
                    city = 'Tokyo'
                    country = 'JP'
                    region = 'APJ'
                    )
                    to lt_bp.
    append value #(
                    bp_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                    bp_role = '01'
                    company_name = 'AVANTEL'
                    street = 'Bosque de Duraznos'
                    city = 'Maxico'
                    country = 'MX'
                    region = 'NA'
                    )
                    to lt_bp.
    append value #(
                    bp_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                    bp_role = '01'
                    company_name = 'Pear Computing Services'
                    street = 'Dunwoody Xing'
                    city = 'Atlanta, Georgia'
                    country = 'US'
                    region = 'NA'
                    )
                    to lt_bp.
    append value #(
                    bp_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                    bp_role = '01'
                    company_name = 'PicoBit'
                    street = 'Fith Avenue'
                    city = 'New York City'
                    country = 'US'
                    region = 'NA'
                    )
                    to lt_bp.
    append value #(
                    bp_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                    bp_role = '01'
                    company_name = 'TACUM'
                    street = 'Victoria Street'
                    city = 'Kolkatta'
                    country = 'IN'
                    region = 'APJ'
                    )
                    to lt_bp.
    append value #(
                    bp_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                    bp_role = '01'
                    company_name = 'Indian IT Trading Company'
                    street = 'Nariman Point'
                    city = 'Mumbai'
                    country = 'IN'
                    region = 'APJ'
                    )
                    to lt_bp.

   append value #(
                    product_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                    name = 'Blaster Extreme'
                    category = 'Speakers'
                    price = 1500
                    currency = 'INR'
                    discount = 3
                    )
                    to lt_prod.
    append value #(
                    product_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                    name = 'Sound Booster'
                    category = 'Speakers'
                    price = 2500
                    currency = 'INR'
                    discount = 2
                    )
                    to lt_prod.
    append value #(
                    product_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                    name = 'Smart Office'
                    category = 'Software'
                    price = 1540
                    currency = 'INR'
                    discount = 32
                    )
                    to lt_prod.
    append value #(
                    product_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                    name = 'Smart Design'
                    category = 'Software'
                    price = 2400
                    currency = 'INR'
                    discount = 12
                    )
                    to lt_prod.
    append value #(
                    product_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                    name = 'Transcend Carry pocket'
                    category = 'PCs'
                    price = 14000
                    currency = 'INR'
                    discount = 7
                    )
                    to lt_prod.
    append value #(
                    product_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                    name = 'Gaming Monster Pro'
                    category = 'PCs'
                    price = 15500
                    currency = 'INR'
                    discount = 8
                    )
                    to lt_prod.

     insert zss_dt_bpa from table @lt_bp.
     insert zss_dt_product from table @lt_prod.
  ENDMETHOD.


  METHOD fill_transaction_data.
    data : o_rand type REF TO cl_abap_random_int,
           n type i,
           seed type i,
           lv_date type timestamp,
           lv_ord_id type zss_de_id,
           lt_so type table of zss_dt_saleshead,
           lt_so_i type table of zss_dt_salesitem.

    seed = cl_abap_random=>seed( ).
    cl_abap_random_int=>create(
      EXPORTING
        seed = seed
        min  = 1
        max  = 7
      RECEIVING
        prng = o_rand
    ).
    get time stamp FIELD lv_date.

    select * from zss_dt_bpa into table @data(lt_bpa).
    select * from zss_dt_product into table @data(lt_prod).

    do 50 times.
        lv_ord_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32(  ).
        n = o_rand->get_next( ).
        read table lt_bpa into data(ls_bp) index n.
        append value #(
                order_id = lv_ord_id
                order_no = sy-index
                buyer = ls_bp-bp_id
                gross_amount = 10 * n
                currency_code = 'EUR'
                created_by = sy-uname
                created_at = lv_date
                changed_by = sy-uname
                changed_at = lv_date
         ) to lt_so.
        do 2 times.
            read table lt_prod into data(ls_prod) index n.
            append value #(
                item_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32(  )
                order_id = lv_ord_id
                product = ls_prod-product_id
                qty =  n
                uom = 'EA'
                amount =  n * ls_prod-price
                currency = 'USD'
         ) to lt_so_i.

        enddo.
    enddo.

    insert zss_dt_saleshead from table @lt_so.
    insert zss_dt_salesitem from table @lt_so_i.

  ENDMETHOD.


  METHOD flush.
    delete from : zss_dt_bpa, zss_dt_product, zss_dt_saleshead, zss_dt_salesitem.
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    me->flush( ).
    me->fill_master_data( ).
    me->fill_transaction_data(  ).
    out->write(
      EXPORTING
        data   = |I have created sample data now !|
*        name   =
*      RECEIVING
*        output =
    ).
  ENDMETHOD.
ENDCLASS.
