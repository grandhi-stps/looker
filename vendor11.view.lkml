view: vendor11 {
  derived_table: {
    sql: select distinct "Vendor Campaign".campaign_id as "Vendor Campaign ID",
      "Vendor Campaign".campaign_name as "Vendor Campaign Name",
      "Vendor Company".company_id as "Vendor Company ID",
      "Vendor Company".company_name as "Vendor Company Name",
      "Vendor Campaign".is_launched "Vendor Cam Is Launched",
      "Vendor Campaign".launch_time "Vendor Cam Launch Time",
      "Vendor Campaign".campaign_type "Vendor Campaign Type",
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
      "Partner Received Campaigns".email_id "Partner Email ID",
      "Partner Received Campaigns".user_list_id "Partner User List ID",
      "Partner Received Campaigns".partner_first_name "Partner First Name",
      "Partner Received Campaigns".partner_last_name "Partner Last Name",
      "Partner Received Campaigns".partner_company_name "Partner Company Name1",
      "Date".date "Date",
      "Date".yearqtr "Year Qtr",
      "Date".cal_month "Month",
      "Date".month_name "Month Name",
      "Date".cal_week "Week",
      "Campaign Deal Reg".id as "ID",
      "Campaign Deal Reg".is_deal as "Is Deal",
      "Campaign Deal Reg".created_time as "Deal Created Time",
      "Campaign Deal Reg".first_name as "Deal First Name",
      "Campaign Deal Reg".last_name as "Deal Last Name",
      "Campaign Deal Reg".email "Deal Email ID",
      "Campaign Deal Reg".phone as "Deal Phone Number",
      "Campaign Deal Reg".opportunity_amount "Opportunity Amt",
      "Campaign Deal Reg".partner_company_name "Deal Partner Company",
      "Campaign Deal Reg".company "Deal Company"
      from
      xamplify_test.xa_campaign_d "Vendor Campaign"
      INNER JOIN xamplify_test.xa_user_d "Vendor Users" ON ("Vendor Campaign".customer_id = "Vendor Users".user_id)
      INNER JOIN xamplify_test.xa_company_d "Vendor Company" ON ("Vendor Users".company_id = "Vendor Company".company_id)
      left JOIN xamplify_test.xa_campaign_d "Redistributed Cam" ON ("Vendor Campaign".campaign_id = "Redistributed Cam".parent_campaign_id)
      left JOIN xamplify_test.xa_user_d "Partner Users" ON ("Redistributed Cam".customer_id = "Partner Users".user_id)
      left JOIN xamplify_test.xa_company_d "Partner Company" ON ("Partner Users".company_id = "Partner Company".company_id)
      left JOIN xamplify_test.xa_campaign_user_userlist_d "Partner Received Campaigns" ON ("Vendor Campaign".campaign_id = "Partner Received Campaigns".campaign_id)
      left join xamplify_test.xa_campaign_deal_registration_d "Campaign Deal Reg" on "Redistributed Cam".campaign_id = "Campaign Deal Reg".campaign_id
      left join xamplify_test.xa_date_dim "Date" on (split_part("Vendor Campaign".launch_time::text , '-',1)||split_part("Vendor Campaign".launch_time::text , '-',2)||left(split_part("Vendor Campaign".launch_time::text , '-',3),2))::int
      = "Date".date_key
      where "Vendor Company".company_id in  (202,262,268,269,283,291,305,325,328,343,399,422,464)
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

  dimension: vendor_campaign_type {
    type: string
    label: "Vendor Campaign Type"
    sql: ${TABLE}."Vendor Campaign Type" ;;
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

  dimension: partner_user_list_id {
    type: number
    label: "Partner User List ID"
    sql: ${TABLE}."Partner User List ID" ;;
  }

  dimension: partner_first_name {
    type: string
    label: "Partner First Name"
    sql: ${TABLE}."Partner First Name" ;;
  }

  dimension: partner_last_name {
    type: string
    label: "Partner Last Name"
    sql: ${TABLE}."Partner Last Name" ;;
  }

  dimension: partner_company_name1 {
    type: string
    label: "Partner Company Name1"
    sql: ${TABLE}."Partner Company Name1" ;;
  }

  dimension: date {
    type: date
    sql: ${TABLE}."Date" ;;
  }

  dimension: year_qtr {
    type: string
    label: "Year Qtr"
    sql: ${TABLE}."Year Qtr" ;;
  }

  dimension: month {
    type: number
    sql: ${TABLE}."Month" ;;
  }

  dimension: month_name {
    type: string
    label: "Month Name"
    sql: ${TABLE}."Month Name" ;;
  }

  dimension: week {
    type: number
    sql: ${TABLE}."Week" ;;
  }

  dimension: id {
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: is_deal {
    type: string
    label: "Is Deal"
    sql: ${TABLE}."Is Deal" ;;
  }

  dimension_group: deal_created_time {
    type: time
    label: "Deal Created Time"
    sql: ${TABLE}."Deal Created Time" ;;
  }

  dimension: deal_first_name {
    type: string
    label: "Deal First Name"
    sql: ${TABLE}."Deal First Name" ;;
  }

  dimension: deal_last_name {
    type: string
    label: "Deal Last Name"
    sql: ${TABLE}."Deal Last Name" ;;
  }

  dimension: deal_email_id {
    type: string
    label: "Deal Email ID"
    sql: ${TABLE}."Deal Email ID" ;;
  }

  dimension: deal_phone_number {
    type: string
    label: "Deal Phone Number"
    sql: ${TABLE}."Deal Phone Number" ;;
  }

  dimension: opportunity_amt {
    type: number
    label: "Opportunity Amt"
    sql: ${TABLE}."Opportunity Amt" ;;
  }

  dimension: deal_partner_company {
    type: string
    label: "Deal Partner Company"
    sql: ${TABLE}."Deal Partner Company" ;;
  }

  dimension: deal_company {
    type: string
    label: "Deal Company"
    sql: ${TABLE}."Deal Company" ;;
  }

  set: detail {
    fields: [
      vendor_campaign_id,
      vendor_campaign_name,
      vendor_company_id,
      vendor_company_name,
      vendor_cam_is_launched,
      vendor_cam_launch_time_time,
      vendor_campaign_type,
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
      partner_user_list_id,
      partner_first_name,
      partner_last_name,
      partner_company_name1,
      date,
      year_qtr,
      month,
      month_name,
      week,
      id,
      is_deal,
      deal_created_time_time,
      deal_first_name,
      deal_last_name,
      deal_email_id,
      deal_phone_number,
      opportunity_amt,
      deal_partner_company,
      deal_company
    ]
  }
}
