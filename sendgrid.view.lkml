view: sendgrid {
  derived_table: {
    sql: select
      cp.company_id "Vendor Company Id" ,
      cp.company_name "Vendor Company Name",
      ud1.user_id "Partners",
      cp1.company_id "Partner Company Id",
      cp1.company_name "Partner Company Name",
      ca1.campaign_id "Redistributed Campaign Id",
      ca1.campaign_name "Redistributed Campaign Name",
      cuul.user_id "Partner Recieved Users",
      sg.user_id "Send grid Users",
      sg.bounce "Bounce",
      sg.block "Block",
      sg.spam "Spam",
      ud3.is_email_valid "Is Email Valid"


      from
      xamplify_test.xa_user_d ud left join xamplify_test.xa_company_d cp on(ud.company_id=cp.company_id)
      left join xamplify_test.xa_campaign_d ca  on (ca.customer_id=ud.user_id)
      left join xamplify_test.xa_campaign_d ca1 on (ca.campaign_id=ca1.parent_campaign_id)
      left join xamplify_test.xa_user_d ud1 on (ud1.user_id=ca1.customer_id)
      left join xamplify_test.xa_company_d cp1 on (cp1.company_id=ud1.company_id)
      left join xamplify_test.xa_campaign_user_userlist_d cuul on (cuul.campaign_id=ca1.campaign_id)
      left join xamplify_test.xa_sendgrid_d sg on (sg.user_id=cuul.user_id)
      left join xamplify_test.xa_user_d ud3 on (ud3.user_id=cuul.user_id)
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: vendor_company_id {
    type: number
    label: "Vendor Company Id"
    sql: ${TABLE}."Vendor Company Id" ;;
  }

  dimension: vendor_company_name {
    type: string
    label: "Vendor Company Name"
    sql: ${TABLE}."Vendor Company Name" ;;
  }

  dimension: partners {
    type: number
    sql: ${TABLE}."Partners" ;;
  }

  dimension: partner_company_id {
    type: number
    label: "Partner Company Id"
    sql: ${TABLE}."Partner Company Id" ;;
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

  dimension: partner_recieved_users {
    type: number
    label: "Partner Recieved Users"
    sql: ${TABLE}."Partner Recieved Users" ;;
  }

  dimension: send_grid_users {
    type: number
    label: "Send grid Users"
    sql: ${TABLE}."Send grid Users" ;;
  }

  dimension: bounce {
    type: string
    sql: ${TABLE}."Bounce" ;;
  }

  dimension: block {
    type: string
    sql: ${TABLE}."Block" ;;
  }

  dimension: spam {
    type: string
    sql: ${TABLE}."Spam" ;;
  }

  dimension: is_email_valid {
    type: string
    label: "Is Email Valid"
    sql: ${TABLE}."Is Email Valid" ;;
  }

  set: detail {
    fields: [
      vendor_company_id,
      vendor_company_name,
      partners,
      partner_company_id,
      partner_company_name,
      redistributed_campaign_id,
      redistributed_campaign_name,
      partner_recieved_users,
      send_grid_users,
      bounce,
      block,
      spam,
      is_email_valid
    ]
  }
}
