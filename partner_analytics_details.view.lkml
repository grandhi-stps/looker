view: partner_analytics_details {
  derived_table: {
    sql: select
      cp.company_name as "Vendor Company Name",
      cp1.company_name as "Partner Company Name",
      c.campaign_id,
      c.campaign_name as "Redistributed Campaign Name",
      c.launch_time as "Redistributed Date",
      cul.user_id as "#Total Recipients",
      el.user_id as "#Active Recipients",
       case when el.action_id = 13 and el.url_id is null and el.reply_id is null and el.video_id is null
      then el.user_id end "Email Opened",
      case when (el.action_id = 14 or el.action_id = 15) and el.url_id is null and el.reply_id is null
      then el.user_id end "Email Clicked",
      case when el.action_id = 13 and (el.reply_id is not null or  el.url_id is not null)
      then el.user_id end as "#Auto Responses Opened",
      dr.id as "Leads"
      from
      xamplify_test.xa_campaign_d p
      left join xamplify_test.xa_campaign_d c on(p.campaign_id=c.parent_campaign_id)
      left join xamplify_test.xa_user_d ud on(p.customer_id=ud.user_id)
      left join xamplify_test.xa_company_d cp on(cp.company_id=ud.company_id)
      left join xamplify_test.xa_user_d ud1 on(c.customer_id=ud1.user_id)
      left join xamplify_test.xa_company_d  cp1 on(ud1.company_id=cp1.company_id)
      left join xamplify_test.xa_campaign_user_userlist_d cul on(cul.campaign_id=c.campaign_id)
      left join xamplify_test.xa_emaillog_d el on(c.campaign_id=el.campaign_id and cul.user_id=el.user_id)
      left join xamplify_test.xa_campaign_deal_registration_d dr on(dr.campaign_id=c.campaign_id)
      --where ud.company_id=399
      --and ud1.company_id=480
      and c.is_launched=true
      --group by 1,2,3,4
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

  dimension: partner_company_name {
    type: string
    label: "Partner Company Name"
    sql: ${TABLE}."Partner Company Name" ;;
  }

  dimension: campaign_id {
    type: number
    sql: ${TABLE}."campaign_id" ;;
  }

  dimension: redistributed_campaign_name {
    type: string
    label: "Redistributed Campaign Name"
    sql: ${TABLE}."Redistributed Campaign Name" ;;
  }

  dimension_group: redistributed_date {
    type: time
    label: "Redistributed Date"
    sql: ${TABLE}."Redistributed Date" ;;
  }

  dimension: total_recipients {
    type: number
    label: "#Total Recipients"
    sql: ${TABLE}."#Total Recipients" ;;
  }

  dimension: active_recipients {
    type: number
    label: "#Active Recipients"
    sql: ${TABLE}."#Active Recipients" ;;
  }

  dimension: email_opened {
    type: number
    label: "Email Opened"
    sql: ${TABLE}."Email Opened" ;;
  }

  dimension: email_clicked {
    type: number
    label: "Email Clicked"
    sql: ${TABLE}."Email Clicked" ;;
  }

  dimension: auto_responses_opened {
    type: number
    label: "#Auto Responses Opened"
    sql: ${TABLE}."#Auto Responses Opened" ;;
  }

  dimension: leads {
    type: number
    sql: ${TABLE}."Leads" ;;
  }

  set: detail {
    fields: [
      vendor_company_name,
      partner_company_name,
      campaign_id,
      redistributed_campaign_name,
      redistributed_date_time,
      total_recipients,
      active_recipients,
      email_opened,
      email_clicked,
      auto_responses_opened,
      leads
    ]
  }
}
