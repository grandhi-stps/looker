view: vendor_partners1 {
  derived_table: {
    sql: with a as (
      select * from (
      select * from (
      with pc1 as (
      select  v_com,customer_id,company_id,p_com,email_id,firstname,lastname,datereg,datelastlogin
      ,campaign_name as first_campaign_name,launch_time as first_campaign_launch_time from (
      select distinct xcp.company_name as v_com ,xc1.customer_id,xup1.email_id,xup1.firstname,xup1.lastname,xup1.datereg,xup1.datelastlogin
      ,xup1.company_id,xcp1.company_name as p_com,xc1.campaign_name,xc1.launch_time
      ,row_number()over(partition by xup1.company_id order by xc1.launch_time) rn
      from public."xt_campaign" xc
      LEFT JOIN public."xt_user_profile" "xup" ON (xc."customer_id" = "xup"."user_id")
      LEFT JOIN public."xt_company_profile" "xcp" ON ("xup"."company_id" = "xcp"."company_id")
      LEFT JOIN public."xt_campaign" "xc1" ON ("xc"."campaign_id" = "xc1"."parent_campaign_id")
      left JOIN public."xt_user_profile" "xup1" ON ("xc1"."customer_id" = "xup1"."user_id")
      LEFT JOIN public."xt_company_profile" "xcp1" ON ("xup1"."company_id" = "xcp1"."company_id")
      ) fc where rn = 1),
      pc2 as (
      select  v_com,customer_id,company_id,p_com,email_id,firstname,lastname,datereg,datelastlogin
      ,campaign_name as second_campaign_name,launch_time as second_campaign_launch_time from (
      select distinct xcp.company_name as v_com ,xc1.customer_id,xup1.email_id,xup1.firstname,xup1.lastname,xup1.datereg,xup1.datelastlogin
      ,xup1.company_id,xcp1.company_name as p_com,xc1.campaign_name,xc1.launch_time
      ,row_number()over(partition by xup1.company_id order by xc1.launch_time) rn
      from public."xt_campaign" xc
      LEFT JOIN public."xt_user_profile" "xup" ON (xc."customer_id" = "xup"."user_id")
      LEFT JOIN public."xt_company_profile" "xcp" ON ("xup"."company_id" = "xcp"."company_id")
      LEFT JOIN public."xt_campaign" "xc1" ON ("xc"."campaign_id" = "xc1"."parent_campaign_id")
      left JOIN public."xt_user_profile" "xup1" ON ("xc1"."customer_id" = "xup1"."user_id")
      LEFT JOIN public."xt_company_profile" "xcp1" ON ("xup1"."company_id" = "xcp1"."company_id")
      ) sc where rn = 2
      order by p_com),
      pc3 as (
      select v_com,customer_id,company_id,p_com,email_id,firstname,lastname,datereg,datelastlogin
      ,campaign_name as recent_campaign_name,launch_time as recent_campaign_launch_time from (
      select distinct xcp.company_name as v_com ,xc1.customer_id,xup1.email_id,xup1.firstname,xup1.lastname,xup1.datereg,xup1.datelastlogin
      ,xup1.company_id,xcp1.company_name as p_com,xc1.campaign_name,xc1.launch_time
      ,row_number()over(partition by xup1.company_id order by xc1.launch_time desc) rn
      from public."xt_campaign" xc
      LEFT JOIN public."xt_user_profile" "xup" ON (xc."customer_id" = "xup"."user_id")
      LEFT JOIN public."xt_company_profile" "xcp" ON ("xup"."company_id" = "xcp"."company_id")
      LEFT JOIN public."xt_campaign" "xc1" ON ("xc"."campaign_id" = "xc1"."parent_campaign_id")
      left JOIN public."xt_user_profile" "xup1" ON ("xc1"."customer_id" = "xup1"."user_id")
      LEFT JOIN public."xt_company_profile" "xcp1" ON ("xup1"."company_id" = "xcp1"."company_id")
      ) rc where rn = 1
      order by p_com)
      select distinct pc1.v_com as "Vendor Company Name",pc1.company_id,pc1.p_com as "Partner Company Name",pc1.email_id as "Email ID"
      ,pc1.firstname as "First Name",pc1.lastname "Last Name",pc1.datereg as "Registered Date",pc1.datelastlogin as "Last Login Date"
      ,pc1.first_campaign_name as "First Campaign Name",pc1.first_campaign_launch_time as "First Campaign Launch Time"
      ,pc2.second_campaign_name as "Second Campaign Name",pc2.second_campaign_launch_time as "Second Campaign Launch Time"
      ,pc3.recent_campaign_name as "Recent Campaign Name",pc3.recent_campaign_launch_time as "Recent Campaign Launch Time"
      from pc1 left join pc2 on pc1.company_id = pc2.company_id
      left join pc3 on pc3.company_id = pc2.company_id
      order by pc1.v_com,pc1.p_com) total
      union all
      select * from (
      with a as (
      select distinct xp.vendor_company_id,xcp.company_name as v_com,xp.partner_company_id,xcp1.company_name as p_com,xup1.email_id
      ,xup1.firstname,xup1.lastname,xup1.datereg,xup1.datelastlogin
      from xt_user_profile xup
      left join xt_company_profile xcp on xcp.company_id = xup.company_id
      left join xt_partnership xp on xp.vendor_company_id = xcp.company_id
      left join xt_user_profile xup1 on xup1.user_id = xp.partner_id
      left join xt_company_profile xcp1 on xcp1.company_id = xup1.company_id
      where xcp1.company_id is not null
      ),
      b as (
      select xup.company_id,xup.user_id,xc.campaign_id ,xc.vendor_organization_id
      from xt_campaign xc
      left join xt_user_profile xup on xup.user_id = xc.customer_id
      where xc.parent_campaign_id is not null
      )
      select distinct a.v_com,a.partner_company_id,a.p_com,a.email_id,a.firstname,a.lastname,a.datereg,a.datelastlogin
      ,null::text,null::timestamp,null::text,null::timestamp,null::text,null::timestamp
      from a left join b on a.partner_company_id = b.company_id and a.vendor_company_id = b.vendor_organization_id
      where a.partner_company_id is not null
      and b.campaign_id is null
      ) as inactive
      union all
      select distinct xcp.company_name,xcp1.company_id,xcp1.company_name,xup1.email_id,xup1.firstname,xup1.lastname,xup1.datereg,xup1.datelastlogin
      ,null::text,null::timestamp,null::text,null::timestamp,null::text,null::timestamp
      from xt_partnership xp
      left join xt_company_profile xcp on xcp.company_id = xp.vendor_company_id
      left join xt_user_profile xup1 on xup1.user_id = xp.partner_id
      left join xt_company_profile xcp1 on xcp1.company_id = xup1.company_id
      where partner_company_id is null
      ) as incomplete
      ),
      b as (
      select  xup.company_id,xc.campaign_id,xc.campaign_name,xc.campaign_type,xc.launch_time
      from xt_campaign xc
      left join xt_user_profile xup on xc.customer_id = xup.user_id
      where xc.is_nurture_campaign and xc.parent_campaign_id is not null
      )
      select distinct a.*,b.campaign_id,b.campaign_name as "Campaign Name",b.campaign_type as "Campaign Type",b.launch_time as "Launch Time"
      from a left join b on a.company_id = b.company_id
      order by 1,2;
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: vendor_company_name {
    type: string
    label: "Vendor Company Name"
    sql: ${TABLE}."Vendor Company Name" ;;
  }

  dimension: company_id {
    type: number
    sql: ${TABLE}."company_id" ;;
  }

  dimension: partner_company_name {
    type: string
    label: "Partner Company Name"
    sql: ${TABLE}."Partner Company Name" ;;
  }

  dimension: email_id {
    type: string
    label: "Email ID"
    sql: ${TABLE}."Email ID" ;;
  }

  dimension: first_name {
    type: string
    label: "First Name"
    sql: ${TABLE}."First Name" ;;
  }

  dimension: last_name {
    type: string
    label: "Last Name"
    sql: ${TABLE}."Last Name" ;;
  }

  dimension_group: registered_date {
    type: time
    label: "Registered Date"
    sql: ${TABLE}."Registered Date" ;;
  }

  dimension_group: last_login_date {
    type: time
    label: "Last Login Date"
    sql: ${TABLE}."Last Login Date" ;;
  }

  dimension: first_campaign_name {
    type: string
    label: "First Campaign Name"
    sql: ${TABLE}."First Campaign Name" ;;
  }

  dimension_group: first_campaign_launch_time {
    type: time
    label: "First Campaign Launch Time"
    sql: ${TABLE}."First Campaign Launch Time" ;;
  }

  dimension: second_campaign_name {
    type: string
    label: "Second Campaign Name"
    sql: ${TABLE}."Second Campaign Name" ;;
  }

  dimension_group: second_campaign_launch_time {
    type: time
    label: "Second Campaign Launch Time"
    sql: ${TABLE}."Second Campaign Launch Time" ;;
  }

  dimension: recent_campaign_name {
    type: string
    label: "Recent Campaign Name"
    sql: ${TABLE}."Recent Campaign Name" ;;
  }

  dimension_group: recent_campaign_launch_time {
    type: time
    label: "Recent Campaign Launch Time"
    sql: ${TABLE}."Recent Campaign Launch Time" ;;
  }

  dimension: campaign_id {
    type: string
    sql: ${TABLE}."campaign_id" ;;
  }

  dimension: campaign_name {
    type: string
    label: "Campaign Name"
    sql: ${TABLE}."Campaign Name" ;;
  }

  dimension: campaign_type {
    type: string
    label: "Campaign Type"
    sql: ${TABLE}."Campaign Type" ;;
  }

  dimension_group: launch_time {
    type: time
    label: "Launch Time"
    sql: ${TABLE}."Launch Time" ;;
  }

  set: detail {
    fields: [
      vendor_company_name,
      company_id,
      partner_company_name,
      email_id,
      first_name,
      last_name,
      registered_date_time,
      last_login_date_time,
      first_campaign_name,
      first_campaign_launch_time_time,
      second_campaign_name,
      second_campaign_launch_time_time,
      recent_campaign_name,
      recent_campaign_launch_time_time,
      campaign_id,
      campaign_name,
      campaign_type,
      launch_time_time
    ]
  }
}
