view: campaign1 {
  derived_table: {
    sql: with a as (select distinct "Redistributed Cam".campaign_id as "Redistributed Campaign ID",
      "Vendor Campaign".campaign_id as "Vendor Campaign ID",
      "Vendor Campaign".campaign_name as "Vendor Campaign Name",
      "Vendor Company".company_id as "Vendor Company ID",
      "Vendor Company".company_name as "Vendor Company Name",
      "Vendor Campaign".is_launched "Vendor Cam Is Launched",
      "Vendor Campaign".launch_time "Vendor Cam Launch Time",
      "Vendor Campaign".campaign_type "Vendor Campaign Type",
      "Vendor Campaign".campaign_schedule_type "Vendor Cam Schedule Type",
      "Vendor Campaign".created_time "Vendor Cam Created Time",
      "Partner Company".company_id "Partner Company ID",
      "Partner Company".company_name "Partner Company Name",
      "Redistributed Cam".campaign_name as "Redistributed Campaign Name",
      "Redistributed Cam".campaign_type as "Redistributed Campaign Type",
      "Redistributed Cam".campaign_schedule_type as "Redistributed Cam Schedule Type",
      "Redistributed Cam".created_time as "Redistributed Cam Created Time",
      "Redistributed Cam".parent_campaign_id as "Parent Campaign ID",
      "Redistributed Cam".is_launched "Redistributed Cam Is Launched",
      "Redistributed Cam".launch_time "Redistributed Cam Launch Time",
      --"Partner Received Campaigns".campaign_id as "Partner Received Campaign",
      --"Partner Received Campaigns".user_id "Partner User ID",
      --"Partner Received Campaigns".email_id "Partner Email ID",
      --"Partner Received Campaigns".user_list_id "Partner User List ID",
      --"Partner Received Campaigns".partner_first_name "Partner First Name",
      --"Partner Received Campaigns".partner_last_name "Partner Last Name",
      --"Partner Received Campaigns".partner_company_name "Partner Company Name1",
      "Date".date "Date",
      "Date".yearqtr "Year Qtr",
      "Date".cal_month "Month",
      "Date".month_name "Month Name",
      "Date".cal_week "Week",
      "Campaign Deal Reg".id as "Deal ID",
      "Campaign Deal Reg".is_deal as "Is Deal",
      "Campaign Deal Reg".created_time as "Deal Created Time",
      "Campaign Deal Reg".first_name as "Deal First Name",
      "Campaign Deal Reg".last_name as "Deal Last Name",
      "Campaign Deal Reg".email "Deal Email ID",
      "Campaign Deal Reg".phone as "Deal Phone Number",
      "Campaign Deal Reg".opportunity_amount "Opportunity Amt"
      from
      xamplify_test.xa_campaign_d "Vendor Campaign"
      INNER JOIN xamplify_test.xa_user_d "Vendor Users" ON ("Vendor Campaign".customer_id = "Vendor Users".user_id)
      INNER JOIN xamplify_test.xa_company_d "Vendor Company" ON ("Vendor Users".company_id = "Vendor Company".company_id)
      left JOIN xamplify_test.xa_campaign_d "Redistributed Cam" ON ("Vendor Campaign".campaign_id = "Redistributed Cam".parent_campaign_id)
      left JOIN xamplify_test.xa_user_d "Partner Users" ON ("Redistributed Cam".customer_id = "Partner Users".user_id)
      left JOIN xamplify_test.xa_company_d "Partner Company" ON ("Partner Users".company_id = "Partner Company".company_id)
      --left JOIN xamplify_test.xa_campaign_user_userlist_d "Partner Received Campaigns" ON ("Vendor Campaign".campaign_id = "Partner Received Campaigns".campaign_id)
      left join xamplify_test.xa_date_dim "Date" on (split_part("Redistributed Cam".launch_time::text , '-',1)||split_part("Redistributed Cam".launch_time::text , '-',2)||left(split_part("Redistributed Cam".launch_time::text , '-',3),2))::int
      = "Date".date_key
      left join xamplify_test.xa_campaign_deal_registration_d "Campaign Deal Reg" on "Redistributed Cam".campaign_id = "Campaign Deal Reg".campaign_id
      ),
      b as (select distinct "Redistributed Cam1".campaign_id as "Redistributed Campaign ID1",
      "Email View".action_id "Action ID",
      "Email View".id "View ID",
      "Email View".time "View Time",
      "Email View".user_id as "View User ID",
      "Contact Received Campaigns".user_id as "Contact User ID",
      "Contact Received Campaigns".user_list_id as "Contact User List ID",
      "Contact Received Campaigns".contact_company as "Contact Company",
      "Contact Received Campaigns".email_id as "Contact Email ID",
      "Contact Received Campaigns".contact_first_name as "Contact First Name",
      "Contact Received Campaigns".contact_last_name as "Contact Last Name",
      "Contact Received Campaigns".contact_mobile_number as "Contact Mobile Number"
      from
      xamplify_test.xa_campaign_d "Vendor Campaign1"
      left outer join
      xamplify_test.xa_campaign_d "Redistributed Cam1"
      on "Vendor Campaign1".campaign_id = "Redistributed Cam1".parent_campaign_id
      join xamplify_test.xa_campaign_user_userlist_d "Contact Received Campaigns"
      on "Redistributed Cam1".campaign_id = "Contact Received Campaigns".campaign_id
      left JOIN xamplify_test.xa_emaillog_d "Email View"
      ON (("Redistributed Cam1".campaign_id = "Email View".campaign_id)
      and "Email View".user_id = "Contact Received Campaigns".user_id)
      where "Redistributed Cam1".is_nurture_campaign = true
      )
      select * from a left join b on a."Redistributed Campaign ID" = b."Redistributed Campaign ID1"
      where a."Vendor Company ID" in (202,262,268,269,283,291,305,325,328,343,399,422,464)
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: Vendor_Cam_Lauched{
    type: count_distinct
    sql: (case when ${vendor_cam_is_launched} then ${vendor_campaign_id} END);;
    #(IF ${vendor_cam_is_launched}  THEN  ${vendor_campaign_id} END);;
    drill_fields: [campaigns_launched*]
  }

  measure: campaigns_Redistribued_by_Partners{
    type: count_distinct
    sql: ${parent_campaign_id} ;;
    drill_fields: [vendor_campaign_id,vendor_campaign_type,vendor_campaign_name,parent_campaign_id]
    #drill_fields: [redistributed_campaign_id,redistributed_campaign_name,redistributed_campaign_type]
  }





  #filters: {
  # field: is_bounce_session
  #value: "Yes"
  #}



  measure: Vendor_campaign_id{
    type: count_distinct
    sql: ${vendor_campaign_id} ;;
    drill_fields: [Campaigns_created*]
  }


  measure:Partners_Redistributed_campaigns {
    type: count_distinct
    sql: ${redistributed_campaign_id} ;;
    drill_fields: [redistributed_campaign_id,redistributed_campaign_name]
  }
  measure: Total_Recipients {
    type: count_distinct
    sql: ${contact_user_id} ;;
    drill_fields: [vendor_company_name,partner_company_name,
      redistributed_campaign_name,
      email_id,
      contact_first_name,
      contact_last_name]
  }



  measure: Email_Opened{
    type: count_distinct
    sql: ${view_user_id} ;;
    drill_fields: [vendor_company_name,partner_company_name,
      redistributed_campaign_name,
      email_id,
      contact_first_name,
      contact_last_name]
  }

  measure: Email_Not_Opened{
    type: number
    sql: ${Total_Recipients}-${Email_Opened} ;;
    drill_fields: [vendor_company_name,partner_company_name,
      redistributed_campaign_name,
      email_id,
      contact_first_name,
      contact_last_name]
  }


  measure: Email_Opened_Percent{
    type: number

    sql:100.00* ${Email_Opened}/NULLIF(${Total_Recipients},0) ;;
    value_format: "0.00\%"
  }

  measure: Email_Not_Opened_Percent {
    type: number
    sql: 100.00* ${Email_Not_Opened}/NULLIF(${Total_Recipients},0) ;;
    value_format: "0.00\%"
  }

  measure: Redistributed_Campaigns{
    type: count_distinct
    sql: ${redistributed_campaign_id} ;;
    drill_fields: [partner_company_name,redistributed_campaign_id,redistributed_campaign_name]
  }


  measure: Active_recipients {
    type: count_distinct
    sql: ${view_user_id} ;;
    drill_fields: [vendor_company_name,partner_company_name,
      redistributed_campaign_name,
      email_id,
      contact_first_name,
      contact_last_name]
  }

  measure: Views {
    type: count_distinct
    sql: ${view_id} ;;
    drill_fields: [partner_company_name,
      redistributed_campaign_name,
      email_id,
      contact_first_name,
      contact_last_name,
      view_time_date]
  }

  dimension: redistributed_campaign_id {
    type: number
    label: "Redistributed Campaign ID"
    sql: ${TABLE}."Redistributed Campaign ID" ;;
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

  dimension: vendor_cam_schedule_type {
    type: string
    label: "Vendor Cam Schedule Type"
    sql: ${TABLE}."Vendor Cam Schedule Type" ;;
  }

  dimension_group: vendor_cam_created_time {
    type: time
    label: "Vendor Cam Created Time"
    sql: ${TABLE}."Vendor Cam Created Time" ;;
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

  dimension: deal_id {
    type: number
    label: "Deal ID"
    sql: ${TABLE}."Deal ID" ;;
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

  dimension: redistributed_campaign_id1 {
    type: number
    label: "Redistributed Campaign ID1"
    sql: ${TABLE}."Redistributed Campaign ID1" ;;
  }

  dimension: action_id {
    type: number
    label: "Action ID"
    sql: ${TABLE}."Action ID" ;;
  }

  dimension: view_id {
    type: number
    label: "View ID"
    sql: ${TABLE}."View ID" ;;
  }

  dimension_group: view_time {
    type: time
    label: "View Time"
    sql: ${TABLE}."View Time" ;;
  }

  dimension: view_user_id {
    type: number
    label: "View User ID"
    sql: ${TABLE}."View User ID" ;;
  }

  dimension: contact_user_id {
    type: number
    label: "Contact User ID"
    sql: ${TABLE}."Contact User ID" ;;
  }

  dimension: contact_user_list_id {
    type: number
    label: "Contact User List ID"
    sql: ${TABLE}."Contact User List ID" ;;
  }

  dimension: contact_company {
    type: string
    label: "Contact Company"
    sql: ${TABLE}."Contact Company" ;;
  }

  dimension: email_id {
    type: string
    label: "Contact Email ID"
    sql: ${TABLE}."Contact Email ID" ;;
  }

  dimension: contact_first_name {
    type: string
    label: "Contact First Name"
    sql: ${TABLE}."Contact First Name" ;;
  }

  dimension: contact_last_name {
    type: string
    label: "Contact Last Name"
    sql: ${TABLE}."Contact Last Name" ;;
  }

  dimension: contact_mobile_number {
    type: string
    label: "Contact Mobile Number"
    sql: ${TABLE}."Contact Mobile Number" ;;
  }


  set:campaigns_launched{
    fields: [vendor_company_name,
      vendor_campaign_type,
      vendor_campaign_name,
      vendor_cam_schedule_type
    ]
  }

  set: Campaigns_created{
    fields: [ vendor_company_name,
      vendor_campaign_name,
      vendor_cam_created_time_time,
      vendor_campaign_type,
    ]
  }

  set: campaign_received_partners {
    fields: [vendor_company_name,vendor_campaign_type,vendor_campaign_name]
  }
  set: Not_redistributed_campaign{
    fields: [vendor_company_name,vendor_campaign_name,vendor_campaign_type]
  }


  set: detail {
    fields: [
      redistributed_campaign_id,
      vendor_campaign_id,
      vendor_campaign_name,
      vendor_company_id,
      vendor_company_name,
      vendor_cam_is_launched,
      vendor_cam_launch_time_time,
      vendor_campaign_type,
      vendor_cam_schedule_type,
      vendor_cam_created_time_time,
      partner_company_id,
      partner_company_name,
      redistributed_campaign_name,
      redistributed_campaign_type,
      redistributed_cam_schedule_type,
      redistributed_cam_created_time_time,
      parent_campaign_id,
      redistributed_cam_is_launched,
      redistributed_cam_launch_time_time,
      date,
      year_qtr,
      month,
      month_name,
      week,
      deal_id,
      is_deal,
      deal_created_time_time,
      deal_first_name,
      deal_last_name,
      deal_email_id,
      deal_phone_number,
      opportunity_amt,
      redistributed_campaign_id1,
      action_id,
      view_id,
      view_time_time,
      view_user_id,
      contact_user_id,
      contact_user_list_id,
      contact_company,
      email_id,
      contact_first_name,
      contact_last_name,
      contact_mobile_number
    ]
  }
}
