view: sendgrid1 {
  derived_table: {
    sql: select
      distinct cp.company_name "Vendor Company Name",
      cp1.company_name "Partner Company Name",
      ca1.campaign_id "Redistributed Campaign Id",
      ca1.campaign_name "Redistributed Campaign Name",
      ca1.launch_time "Redistributed Launch time",
      cuul.user_id "Partner Recieved Users",
      bo.created "Bounced time",
      bo.email "Bounced Email",
      bl.created "Blocked time",
      bl.email "Blocked Email",
      sp.created "Spamed time",
      sp.email "Spamed Email"
      from xamplify_test.xa_user_d ud
      left outer join xamplify_test.xa_company_d cp on(ud.company_id=cp.company_id)
      left outer join xamplify_test.xa_campaign_d ca on(ca.customer_id=ud.user_id)
      left outer join xamplify_test.xa_campaign_d ca1 on(ca1.parent_campaign_id=ca.campaign_id)
      left outer join xamplify_test.xa_user_d ud1 on(ud1.user_id=ca1.customer_id)
      left outer join xamplify_test.xa_company_d cp1 on(cp1.company_id=ud1.company_id)
      left outer join xamplify_test.xa_campaign_user_userlist_d cuul on (cuul.campaign_id=ca1.campaign_id)
      left outer join xamplify_test.xa_user_d ud3 on(ud3.user_id=cuul.user_id)
      left outer join xamplify_test.xa_bounce_d bo on(bo.email=ud3.email_id)
      left outer join xamplify_test.xa_block_d bl on (bl.email=ud3.email_id)
      left outer join xamplify_test.xa_spam_d sp on (sp.email=ud3.email_id)
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

  dimension: redistributed_campaign_id {
    type: number
    label: "Redistributed Campaign Id"
    sql: ${TABLE}."Redistributed Campaign Id" ;;
  }

  dimension: redistributed_campaign_name {
    type: string
    label: "Redistributed Campaign Name"
    sql: ${TABLE}."Redistributed Campaign Name" ;;
  }

  dimension_group: redistributed_launch_time {
    type: time
    label: "Redistributed Launch time"
    sql: ${TABLE}."Redistributed Launch time" ;;
  }

  dimension: partner_recieved_users {
    type: number
    label: "Partner Recieved Users"
    sql: ${TABLE}."Partner Recieved Users" ;;
  }

  dimension_group: bounced_time {
    type: time
    label: "Bounced time"
    sql: ${TABLE}."Bounced time" ;;
  }

  dimension: bounced_email {
    type: string
    label: "Bounced Email"
    sql: ${TABLE}."Bounced Email" ;;
  }

  dimension_group: blocked_time {
    type: time
    label: "Blocked time"
    sql: ${TABLE}."Blocked time" ;;
  }

  dimension: blocked_email {
    type: string
    label: "Blocked Email"
    sql: ${TABLE}."Blocked Email" ;;
  }

  dimension_group: spamed_time {
    type: time
    label: "Spamed time"
    sql: ${TABLE}."Spamed time" ;;
  }

  dimension: spamed_email {
    type: string
    label: "Spamed Email"
    sql: ${TABLE}."Spamed Email" ;;
  }

  set: detail {
    fields: [
      vendor_company_name,
      partner_company_name,
      redistributed_campaign_id,
      redistributed_campaign_name,
      redistributed_launch_time_time,
      partner_recieved_users,
      bounced_time_time,
      bounced_email,
      blocked_time_time,
      blocked_email,
      spamed_time_time,
      spamed_email
    ]
  }
}
