view: vendor_received_campaigns {
  derived_table: {
    sql: select distinct "Vendor Campaign".campaign_id as "Vendor Campaign ID",
                "Vendor Campaign".campaign_name as "Vendor Campaign Name",
                "Vendor Company".company_id as "Vendor Company ID",
                "Vendor Company".company_name as "Vendor Company Name",
                "Vendor Campaign".is_launched "Vendor Cam Is Launched",
                "Vendor Campaign".launch_time "Vendor Cam Launch Time",
                "Vendor Campaign".created_time "Vendor Cam Created Time",
                "Vendor Campaign".campaign_type "Vendor Campaign Type",
                 "Vendor Campaign".campaign_schedule_type "Vendor Campaign Schedule Type",
                "Partner Company".company_id "Partner Company ID",
                "Partner Company".company_name "Partner Company Name",
                "Redistributed Cam".campaign_id as "Redistributed Campaign ID",
                "Redistributed Cam".campaign_name as "Redistributed Campaign Name",
                "Redistributed Cam".campaign_type as "Redistributed Campaign Type",
                "Redistributed Cam".campaign_schedule_type as "Redistributed Cam Schedule Type",
                "Redistributed Cam".created_time as "Redistributed Cam Created Time",
                "Redistributed Cam".parent_campaign_id as "Parent Campaign ID",
                "Redistributed Cam".is_launched "Redistributed Cam Is Launched",
                "Redistributed Cam".launch_time "Redistributed Cam Launch Time",
                "Partner Received Campaigns".campaign_id as "Partner Received Campaign",
               "Partner Received Campaigns".user_id "Partner User ID",
                "Partner Received Campaigns".email_id as "Partner Email ID",
                "Partner Received Campaigns".partner_company_name "Partner Company Name1",
                "Partner Users".datereg as "Partner Datereg",
                 "Partner Users".user_id as "Partner Users ID",
                  "Partner Users".email_id as "Partners email_id"

                from
                xamplify_test.xa_campaign_d "Vendor Campaign"
                left JOIN xamplify_test.xa_user_d "Vendor Users" ON ("Vendor Campaign".customer_id = "Vendor Users".user_id)
                left JOIN (select distinct c.company_id,c.company_name from xamplify_test.xa_company_d c, xamplify_test.xa_user_d  u,xamplify_test.xa_user_role_d r
                       where u.company_id=c.company_id
                       and u.user_id=r.user_id
                       and r.role_id in(2,13) and c.company_id not in(231,130,265,266,313,391,280,281,303,307,311,357,320,326,331,334,356,270,368,370,369,372,376,
                       380,382,398,215,273,410,413,415,374,389,322,332,333,335,367,349,358,359,362,371,378,379,381,385,386,388,393,395,401,414,384,421,424)) "Vendor Company" ON ("Vendor Users".company_id = "Vendor Company".company_id)
                left JOIN xamplify_test.xa_campaign_d "Redistributed Cam" ON ("Vendor Campaign".campaign_id = "Redistributed Cam".parent_campaign_id)
                left JOIN xamplify_test.xa_user_d "Partner Users" ON ("Redistributed Cam".customer_id = "Partner Users".user_id)
                left JOIN xamplify_test.xa_company_d "Partner Company" ON ("Partner Users".company_id = "Partner Company".company_id)
                left JOIN (select distinct campaign_id ,user_id,partner_company_name,email_id from xamplify_test.xa_campaign_user_userlist_d) "Partner Received Campaigns" ON ("Vendor Campaign".campaign_id = "Partner Received Campaigns".campaign_id)
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: vendor_campaign_id {
    type: number
    label: "Vendor Campaign ID"
    sql: ${TABLE}."Vendor Campaign ID" ;;
  }

  dimension: vendor_campaign_name {
    type: string
    label: "Vendor Campaign Name"
    sql: ${TABLE}."Vendor Campaign Name" ;;
  }

  dimension: vendor_company_id {
    type: number
    label: "Vendor Company ID"
    sql: ${TABLE}."Vendor Company ID" ;;
  }

  dimension: vendor_company_name {
    type: string
    label: "Vendor Company Name"
    sql: ${TABLE}."Vendor Company Name" ;;
  }

  dimension: vendor_cam_is_launched {
    type: string
    label: "Vendor Cam Is Launched"
    sql: ${TABLE}."Vendor Cam Is Launched" ;;
  }

  dimension_group: vendor_cam_launch_time {
    type: time
    label: "Vendor Cam Launch Time"
    sql: ${TABLE}."Vendor Cam Launch Time" ;;
  }

  dimension_group: vendor_cam_created_time {
    type: time
    label: "Vendor Cam Created Time"
    sql: ${TABLE}."Vendor Cam Created Time" ;;
  }

  dimension: vendor_campaign_type {
    type: string
    label: "Vendor Campaign Type"
    sql: ${TABLE}."Vendor Campaign Type" ;;
  }

  dimension: vendor_campaign_schedule_type {
    type: string
    label: "Vendor Campaign Schedule Type"
    sql: ${TABLE}."Vendor Campaign Schedule Type" ;;
  }

  dimension: partner_company_id {
    type: number
    label: "Partner Company ID"
    sql: ${TABLE}."Partner Company ID" ;;
  }

  dimension: partner_company_name {
    type: string
    label: "Partner Company Name"
    sql: ${TABLE}."Partner Company Name" ;;
  }

  dimension: redistributed_campaign_id {
    type: number
    label: "Redistributed Campaign ID"
    sql: ${TABLE}."Redistributed Campaign ID" ;;
  }

  dimension: redistributed_campaign_name {
    type: string
    label: "Redistributed Campaign Name"
    sql: ${TABLE}."Redistributed Campaign Name" ;;
  }

  dimension: redistributed_campaign_type {
    type: string
    label: "Redistributed Campaign Type"
    sql: ${TABLE}."Redistributed Campaign Type" ;;
  }

  dimension: redistributed_cam_schedule_type {
    type: string
    label: "Redistributed Cam Schedule Type"
    sql: ${TABLE}."Redistributed Cam Schedule Type" ;;
  }

  dimension_group: redistributed_cam_created_time {
    type: time
    label: "Redistributed Cam Created Time"
    sql: ${TABLE}."Redistributed Cam Created Time" ;;
  }

  dimension: parent_campaign_id {
    type: number
    label: "Parent Campaign ID"
    sql: ${TABLE}."Parent Campaign ID" ;;
  }

  dimension: redistributed_cam_is_launched {
    type: string
    label: "Redistributed Cam Is Launched"
    sql: ${TABLE}."Redistributed Cam Is Launched" ;;
  }

  dimension_group: redistributed_cam_launch_time {
    type: time
    label: "Redistributed Cam Launch Time"
    sql: ${TABLE}."Redistributed Cam Launch Time" ;;
  }

  dimension: partner_received_campaign {
    type: number
    label: "Partner Received Campaign"
    sql: ${TABLE}."Partner Received Campaign" ;;
  }

  dimension: partner_user_id {
    type: number
    label: "Partner User ID"
    sql: ${TABLE}."Partner User ID" ;;
  }

  dimension: partner_email_id {
    type: string
    label: "Partner Email ID"
    sql: ${TABLE}."Partner Email ID" ;;
  }

  dimension: partner_company_name1 {
    type: string
    label: "Partner Company Name1"
    sql: ${TABLE}."Partner Company Name1" ;;
  }

  dimension_group: partner_datereg {
    type: time
    label: "Partner Datereg"
    sql: ${TABLE}."Partner Datereg" ;;
  }

  dimension: partner_users_id {
    type: number
    label: "Partner Users ID"
    sql: ${TABLE}."Partner Users ID" ;;
  }

  dimension: partners_email_id {
    type: string
    label: "Partners email_id"
    sql: ${TABLE}."Partners email_id" ;;
  }

  set: detail {
    fields: [
      vendor_campaign_id,
      vendor_campaign_name,
      vendor_company_id,
      vendor_company_name,
      vendor_cam_is_launched,
      vendor_cam_launch_time_time,
      vendor_cam_created_time_time,
      vendor_campaign_type,
      vendor_campaign_schedule_type,
      partner_company_id,
      partner_company_name,
      redistributed_campaign_id,
      redistributed_campaign_name,
      redistributed_campaign_type,
      redistributed_cam_schedule_type,
      redistributed_cam_created_time_time,
      parent_campaign_id,
      redistributed_cam_is_launched,
      redistributed_cam_launch_time_time,
      partner_received_campaign,
      partner_user_id,
      partner_email_id,
      partner_company_name1,
      partner_datereg_time,
      partner_users_id,
      partners_email_id
    ]
  }
}
