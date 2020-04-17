connection: "xamplify"

# include all the views
include: "/views/**/*.view"

datagroup: xamplify_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: xamplify_default_datagroup


#explore: orders_with_share_of_wallet_application {
 # label: "(5) Share of Wallet Analysis"
 # extends: [order_items]
  #view_name: order_items

 # join: order_items_share_of_wallet {
  #  view_label: "Share of Wallet"
#  }
#}



explore:campaign1   {}



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
      "Email View".action_id "Action ID",
      "Email View".country "View Country",
      "Email View".state "View State",
      "Email View".city as "View City",
      "Email View".zip as "View Zip Code",
      "Email View".longitude as "View Longitude",
      "Email View".latitude as  "View Latitude",
      "Contact Received Campaigns".user_id as "Contact User ID",
      "Contact Received Campaigns".user_list_id as "Contact User List ID",
      "Contact Received Campaigns".contact_company as "Contact Company",
      "Contact Received Campaigns".email_id as "Contact Email ID",
      "Contact Received Campaigns".contact_first_name as "Contact First Name",
      "Contact Received Campaigns".contact_last_name as "Contact Last Name",
      "Contact Received Campaigns".contact_mobile_number as "Contact Mobile Number",
      "Contact Received Campaigns".contact_country as "Contact Country",
      "Contact Received Campaigns".contact_state as "Contact State",
      "Contact Received Campaigns".contact_city as "Contact City",
      "Contact Received Campaigns".contact_zip as "Contact Zip Code"
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
    link: {
      label: "Detail Report"
      url: "{{link}}&pivots=
      vendor_campaign_name"
    }
  }


  measure:Partners_Redistributed_campaigns {
    type: count_distinct
    sql: ${redistributed_campaign_id} ;;
    drill_fields: [redistributed_campaign_id,redistributed_campaign_name]
  }
  measure: Total_Recipients {
    type: count_distinct
    sql: ${contact_user_id};;
   # sql_distinct_key: ${contact_user_id} ;;
    drill_fields: [
      email_id
      ]
  }

  measure: Email_Opened{
    type: count_distinct
    sql: ${view_user_id} ;;
    drill_fields: [
      email_id
      ]
  }



  #dimension: Boolean_filter{
   # type: yesno
    #sql: (${campaign1.contact_user_id})=
    #(${campaign1.view_user_id});;
  #}

  measure: Email_Not_Opened{
    type: number
    sql: ${Total_Recipients}-${Email_Opened};;
    link: {
      label: "Detail Report"
      url: "https://stratappspartner.looker.com/looks/29"
    }
   # drill_fields: [
    #  email_id
     # ]
  }



  measure: Email_Not_Openedstr{
    type: string
    sql: CAST (${Email_Not_Opened} as Character Varying ) ;;
  }

  measure: Email_Openedstr{
    type: string
    sql: CAST ( ${Email_Opened} as Character Varying ) ;;
    drill_fields: [
      email_id
    ]
  }
  measure: Email_Opened_Percent{
    type: number
   sql:Round(100.00* ${Email_Opened}/NULLIF(${Total_Recipients},0)) ;;
    value_format: "0\%"
  }

  measure: Email_Opened_Percentstr{
    type: string
    sql:Cast(${Email_Opened_Percent} as character Varying);;

  }


measure: Email_opened1 {
  type: string
  sql: Concat(${Email_Opened_Percentstr},'%',' (',${Email_Openedstr} ,')');;
  #html: {{${Email_Opened_Percentstr  }} || {{ ${Email_Openedstr} }} of total>> ;;
}


  measure: Email_Not_Opened_Percent {
    type: number
    sql: round(100.00* ${Email_Not_Opened}/NULLIF(${Total_Recipients},0)) ;;
    value_format: "0\%"
  }
  measure: Email_Not_Opened_Percentstr {
    type: string
    sql: cast(${Email_Not_Opened_Percent} as Character varying);;

  }
  measure: Email_Not_Opened1 {
    type: string
    sql: Concat(${Email_Not_Opened_Percentstr},'%',' (',${Email_Not_Openedstr} ,')');;

  }

  measure: Redistributed_Campaigns{
    type: count_distinct
    sql: ${redistributed_campaign_id} ;;
    drill_fields: [partner_company_name,redistributed_campaign_id,redistributed_campaign_name]
    link: {
      label: "Detail Report"
      url: "{{https://stratappspartner.looker.com/looks/20}}&pivots
      "
    }

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
    drill_fields: [view_id,
      email_id,
      view_time_date]
  }

  measure: partners {
    type: count_distinct
     sql: ${partner_company_id} ;;
    drill_fields: [partner_company_id,partner_company_name]
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

  dimension: contact_country {
    type: string
    map_layer_name: countries
    label: "Contact Country"
    sql: ${TABLE}."Contact Country" ;;
  }

  dimension: contact_state {
    type: string
    map_layer_name: us_states
    label: "Contact State"
    sql: ${TABLE}."Contact State" ;;
  }
  dimension: contact_city {
    type: string
    label: "Contact City"
    sql: ${TABLE}."Contact City" ;;
  }

  dimension: contact_zip {
    type: zipcode
    label: "Contact Zip Code"
    sql: ${TABLE}."Contact Zip Code" ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    label: "View Country"
    sql: ${TABLE}."View Country" ;;
  }

  dimension: state {
    type: string
    map_layer_name: us_states
    label: "View State"
    sql: ${TABLE}."View State" ;;
  }
  dimension: city {
    type: string
    label: "View City"
    sql: ${TABLE}."View City" ;;
  }

  dimension: zip {
    type: zipcode
    label: "View Zip Code"
    sql: ${TABLE}."View Zip Code" ;;
  }

  dimension:longitude {
    type: string
    label: "View Longitude"
    sql: ${TABLE}."View Longitude" ;;

  }

  dimension:latitude{
    type: string
    label: "View Latitude"
    sql: ${TABLE}."View Latitude" ;;

  }

  dimension: user_location {
  type: location
  sql_latitude: ${latitude} ;;
  sql_longitude: ${longitude} ;;
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
      contact_mobile_number,
      contact_country,
      contact_state,
      contact_city,
      contact_zip,
      country,
      state,
      city,
      zip,
      longitude,
      latitude,
      user_location
    ]
  }
}





explore: vendors {}
view:vendors {
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

  measure: Parnters{
    type: count_distinct
    sql: ${partner_company_name};;
    drill_fields: [partner_company_name]

  }

  measure:campaigns_received_Partner{
    type: count_distinct
    sql: ${partner_received_campaign} ;;
    drill_fields: [vendor_campaign_id,vendor_campaign_type,vendor_campaign_name]

  }


  measure: campaigns_Redistribued_by_Partners{
    type: count_distinct
    sql: ${parent_campaign_id} ;;
    drill_fields: [vendor_campaign_id,vendor_campaign_type,vendor_campaign_name]
  }

  measure:Not_Redistributed  {
    type:number
    sql: ${campaigns_received_Partner}- ${campaigns_Redistribued_by_Partners} ;;
    drill_fields: [vendor_campaign_id,vendor_campaign_type,vendor_campaign_name]

  }
  measure: Vendor_Cam_Lauched{
    type: count_distinct

    #(IF ${vendor_cam_is_launched}  THEN  ${vendor_campaign_id} END);;
    drill_fields: [vendor_campaign_id,vendor_campaign_type,vendor_campaign_name]
    link: {
      label: "Detail Report"
      url: "{{https://stratappspartner.looker.com/looks/20}}"
    }
    sql: (case when ${vendor_cam_is_launched} then ${vendor_campaign_id} END);;
  }

  measure: Deals  {
    type:count_distinct
     sql: (case when ${is_deal} then ${id} END);;
    drill_fields: [ deal_partner_company,deal_first_name,deal_last_name,deal_email_id,deal_phone_number,deal_company]

  }
  measure: Leads  {
    type:count_distinct
    sql: ${id};;
    drill_fields: [deal_partner_company,deal_first_name,deal_last_name,deal_email_id,deal_phone_number,deal_company]


  }

  measure: Redistributed_Campaigns  {
    type:count_distinct
    sql: ${redistributed_campaign_id};;
    drill_fields: [redistributed_campaign_id,redistributed_campaign_name]

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



explore: leads_deals {}

view:leads_deals {
  derived_table: {
    sql: select distinct "Vendor Campaign".campaign_id as "Vendor Campaign ID",
      "Vendor Campaign".campaign_name as "Vendor Campaign Name",
      "Vendor Company".company_id as "Vendor Company ID",
      "Vendor Company".company_name as "Vendor Company Name",
      "Vendor Campaign".is_launched "Vendor Cam Is Launched",
      "Vendor Campaign".launch_time "Vendor Cam Launch Time",
      "Redistributed Cam".campaign_id as "Redistributed Campaign ID",
      "Redistributed Cam".campaign_name as "Redistributed Campaign Name",
      "Redistributed Cam".campaign_type as "Redistributed Campaign Type",
      "Redistributed Cam".campaign_schedule_type as "Redistributed Cam Schedule Type",
      "Redistributed Cam".created_time as "Redistributed Cam Created Time",
      "Redistributed Cam".parent_campaign_id as "Parent Campaign ID",
      "Redistributed Cam".is_launched "Redistributed Cam Is Launched",
      "Redistributed Cam".launch_time "Redistributed Cam Launch Time",
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
      "Campaign Deal Reg".lead_country as "Lead Country",
      "Campaign Deal Reg".lead_state as "Lead State",
      "Campaign Deal Reg".lead_city as "Lead City",
      "Campaign Deal Reg".lead_street as "Lead Street",
      "Campaign Deal Reg".postal_code "Postal Code",
      "Campaign Deal Reg".partner_company_id as "Partner Company ID",
      "Campaign Deal Reg".partner_company_name as "Partner Company Name",
      "Campaign Deal Status".deal_status as "Deal Status",
      "Campaign Deal Reg".company as "Deal Company"
      from
      xamplify_test.xa_campaign_d "Vendor Campaign"
      INNER JOIN xamplify_test.xa_user_d "Vendor Users" ON ("Vendor Campaign".customer_id = "Vendor Users".user_id)
      INNER JOIN xamplify_test.xa_company_d "Vendor Company" ON ("Vendor Users".company_id = "Vendor Company".company_id)
      left JOIN xamplify_test.xa_campaign_d "Redistributed Cam" ON ("Vendor Campaign".campaign_id = "Redistributed Cam".parent_campaign_id)
      left join xamplify_test.xa_campaign_deal_registration_d "Campaign Deal Reg" on "Redistributed Cam".campaign_id = "Campaign Deal Reg".campaign_id
      left join xamplify_test.xa_campaign_deal_status_d "Campaign Deal Status" on "Campaign Deal Status".deal_id = "Campaign Deal Reg".id
      left join xamplify_test.xa_date_dim "Date" on (split_part("Campaign Deal Reg".created_time::text , '-',1)||split_part("Campaign Deal Reg".created_time::text , '-',2)||left(split_part("Campaign Deal Reg".created_time::text , '-',3),2))::int
      = "Date".date_key
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: Deals  {
    type:count_distinct
    sql: (case when ${is_deal} then ${id} END);;
    drill_fields: [ partner_company_name,vendor_campaign_name,deal_first_name,deal_last_name,deal_email_id,
      deal_phone_number,deal_company,deal_created_time_date]

  }
  measure: Leads  {
    type:count_distinct
    sql: ${id};;
    drill_fields: [partner_company_name,vendor_campaign_name,deal_first_name,deal_last_name,deal_email_id,
      deal_phone_number,deal_company,deal_created_time_date]

  }
  measure: 20Q1leads{
    type: count_distinct
    sql: case when ${year_qtr}='20Q1' then ${id} end ;;
  }

  measure: 20Q2leads{
    type: count_distinct
    sql: case when ${year_qtr}='20Q2' then ${id} end ;;
  }

  measure: 20Q1Deals{
    type: count_distinct
    sql: case when ${year_qtr}='20Q1' and ${is_deal}='true' then ${id} end ;;
  }

  measure: 20Q2Deals{
    type: count_distinct
    sql: case when ${year_qtr}='20Q2' and ${is_deal}='true' then ${id} end ;;
  }

  measure: 20Q1DealPercentage {
  type: number
  sql:100* ${20Q1Deals}/coalesce(NULLIF(${20Q1leads},0),1) ;;
  value_format: "0\%"
      }

  measure: 20Q2DealPercentage {
  type: number
  sql: 100* ${20Q2Deals}/coalesce(NULLIF(${20Q2leads},0),1);;
  value_format: "0\%"

    }

  measure: Lead_QTD_Growth_Percentage {
    type: number
    sql:100*coalesce((${20Q2leads}-${20Q1leads}),0)/coalesce(NULLIF(${20Q1leads},0),1);;
    value_format: "0\%"
  }

  measure: Deal_QTD_Growth_Percentage {
    type: number
    sql: 100*coalesce((${20Q2Deals}-${20Q1Deals}),0)/coalesce(NULLIF(${20Q1Deals},0),1);;
    value_format: "0\%"
  }

      measure: Percentage_QOQ_Deals{
        type: number
        sql:100*coalesce((${20Q2DealPercentage}-${20Q1DealPercentage}),0)/coalesce(NULLIF(${20Q1DealPercentage},0),1);;
        value_format: "0\%"
  }

  measure: Prev_Month_Leads {
    type: count_distinct
    sql:case when extract(month from ${deal_created_time_date})= (extract(month from now())-1)
          and extract(year from ${deal_created_time_date})=2020  then ${id} end;;
  }
  measure: Cur_Month_Leads {
    type: count_distinct
    sql:case when extract(month from ${deal_created_time_date})= extract(month from now())
          and extract(year from ${deal_created_time_date})=2020 then ${id} end;;
  }
  measure: Prev_Month_Deals{
    type: count_distinct
    sql:case when extract(month from ${deal_created_time_date})= (extract(month from now())-1)
              and extract(year from ${deal_created_time_date})=2020 and ${is_deal}='true'
    then ${id} end;;
  }
  measure: Cur_Month_Deals{
    type: count_distinct
    sql:case when extract(month from ${deal_created_time_date})= extract(month from now())
          and extract(year from ${deal_created_time_date} )=2020   and ${is_deal}='true'
    then ${id} end;;
  }
 measure:Prev_Month_Deals_Percentage{
   type: number
  sql: 100*${Prev_Month_Deals}/coalesce(NULLIF(${Prev_Month_Leads},0),1);;
  value_format: "0\%"
 }
 measure: Cur_Month_Deals_Percentage{
   type: number
  sql: 100*${Cur_Month_Deals}/coalesce(NULLIF(${Cur_Month_Leads},0),1) ;;
  value_format: "0\%"
 }
  measure:Percentage_Leads_Growth{
    type: number
    sql: 100*coalesce((${Cur_Month_Leads}-${Prev_Month_Leads}),0)/coalesce(NULLIF(${Prev_Month_Leads},0),1);;
    value_format: "0\%"
  }
  measure:Percentage_Deals_Growth{
    type:number
    sql: 100*coalesce((${Cur_Month_Deals}-${Prev_Month_Deals}),0)/coalesce(NULLIF(${Prev_Month_Deals},0),1);;
    value_format: "0\%"
  }
  measure: Percentage_MOM_Deals{
    type: number
    sql: 100*coalesce((${Cur_Month_Deals_Percentage}-${Prev_Month_Deals_Percentage}),0)/coalesce(NULLIF(${Prev_Month_Deals_Percentage},0),1);;
    value_format: "0\%"
  }
  dimension: created_week {
    type:date_week_of_year
    label: "Redistributed Cam Week"
    sql: ${TABLE}."Redistributed Cam Created Time" ;;
  }

  dimension: created_week1 {
    type:date_week_of_year
    label: "Redistributed Cam Week1"
    sql: ${TABLE}."Redistributed Cam Created Time" ;;
    order_by_field:created_week
  }
  dimension: Week_NO{
    type:string
    label: "Week_No"
    sql: concat(cast(${created_week1} as character varying),'Week') ;;
  }

  dimension: vendor_campaign_id {
    type: number
    label: "Vendor Campaign ID"
    sql: ${TABLE}."Vendor Campaign ID" ;;
  }
  dimension: deal_status {
    type: string
    label: "Deal Status"
    sql: ${TABLE}."Deal Status" ;;
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
    label: "ID"
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

  dimension: lead_country {
    type: string
    label: "Lead Country"
    sql: ${TABLE}."Lead Country" ;;
  }

  dimension: lead_state {
    type: string
    label: "Lead State"
    sql: ${TABLE}."Lead State" ;;
  }

  dimension: lead_city {
    type: string
    label: "Lead City"
    sql: ${TABLE}."Lead City" ;;
  }

  dimension: lead_street {
    type: string
    label: "Lead Street"
    sql: ${TABLE}."Lead Street" ;;
  }

  dimension: postal_code {
    type: string
    label: "Postal Code"
    sql: ${TABLE}."Postal Code" ;;
  }

  dimension:partner_company_id  {
    type: number
    label: "Partner Company ID"
    sql: ${TABLE}."Partner Company ID" ;;
  }

  dimension: partner_company_name {
    type: string
    label: "Partner Company Name"
    sql: ${TABLE}."Partner Company Name" ;;
  }

  dimension: deal_company {
    type: string
    label: "Deal Company"
    sql: ${TABLE}."company" ;;
  }


  set: detail {
    fields: [
      vendor_campaign_id,
      vendor_campaign_name,
      vendor_company_id,
      vendor_company_name,
      vendor_cam_is_launched,
      vendor_cam_launch_time_time,
      redistributed_campaign_id,
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
      id,
      is_deal,
      deal_created_time_time,
      deal_first_name,
      deal_last_name,
      deal_email_id,
      deal_phone_number,
      opportunity_amt,
      lead_country,
      lead_state,
      lead_city,
      lead_street,
      postal_code,
      partner_company_id,
      partner_company_name,
      deal_status,
      deal_company
    ]
  }
}


explore:nurture_campaigns  {}
view: nurture_campaigns {
  derived_table: {
    sql: with t1 as (
      select * from xamplify_test.xa_emailtemplates_d order by id limit 13
      ),
      t2 as (select * from xamplify_test.xa_drip_email_history_d)
      select distinct t1.name,t1.subject,t2.user_id,u.email_id,u.firstname,u.lastname,c.company_name,t2.sent_time
      from t1
      left join t2 on (t1.id = t2.email_template_id)
      left join xamplify_test.xa_user_d u on (t2.user_id = u.user_id)
      left join xamplify_test.xa_company_d c on (u.company_id = c.company_id)
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: name {
    type: string
    sql: ${TABLE}."name" ;;
  }

  dimension: subject {
    type: string
    sql: ${TABLE}."subject" ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}."user_id" ;;
  }

  dimension: email_id {
    type: string
    sql: ${TABLE}."email_id" ;;
  }

  dimension: firstname {
    type: string
    sql: ${TABLE}."firstname" ;;
  }

  dimension: lastname {
    type: string
    sql: ${TABLE}."lastname" ;;
  }

  dimension: company_name {
    type: string
    sql: ${TABLE}."company_name" ;;
  }

  dimension_group: sent_time {
    type: time
    sql: ${TABLE}."sent_time" ;;
  }

  set: detail {
    fields: [
      name,
      subject,
      user_id,
      email_id,
      firstname,
      lastname,
      company_name,
      sent_time_time
    ]
  }
}









view: campaign2 {
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
      "Date".cal_week "Week"
      --"Campaign Deal Reg".id as "Deal ID",
      --"Campaign Deal Reg".is_deal as "Is Deal",
      --"Campaign Deal Reg".created_time as "Deal Created Time",
      --"Campaign Deal Reg".first_name as "Deal First Name",
      --"Campaign Deal Reg".last_name as "Deal Last Name",
      --"Campaign Deal Reg".email "Deal Email ID",
      --"Campaign Deal Reg".phone as "Deal Phone Number",
      --"Campaign Deal Reg".opportunity_amount "Opportunity Amt"
      from
      xamplify_test.xa_campaign_d "Vendor Campaign"
      INNER JOIN xamplify_test.xa_user_d "Vendor Users" ON ("Vendor Campaign".customer_id = "Vendor Users".user_id)
      INNER JOIN xamplify_test.xa_company_d "Vendor Company" ON ("Vendor Users".company_id = "Vendor Company".company_id)
      left JOIN xamplify_test.xa_campaign_d "Redistributed Cam" ON ("Vendor Campaign".campaign_id = "Redistributed Cam".parent_campaign_id)
      left JOIN xamplify_test.xa_user_d "Partner Users" ON ("Redistributed Cam".customer_id = "Partner Users".user_id)
      left JOIN xamplify_test.xa_company_d "Partner Company" ON ("Partner Users".company_id = "Partner Company".company_id)
      left JOIN xamplify_test.xa_campaign_user_userlist_d "Partner Received Campaigns" ON ("Vendor Campaign".campaign_id = "Partner Received Campaigns".campaign_id)
      left join xamplify_test.xa_date_dim "Date" on (split_part("Redistributed Cam".launch_time::text , '-',1)||split_part("Redistributed Cam".launch_time::text , '-',2)||left(split_part("Redistributed Cam".launch_time::text , '-',3),2))::int
      = "Date".date_key
      --left join xamplify_test.xa_campaign_deal_registration_d "Campaign Deal Reg" on "Redistributed Cam".campaign_id = "Campaign Deal Reg".campaign_id
      ),
      b as (select distinct "Redistributed Cam1".campaign_id as "Redistributed Campaign ID1",
      "Email View".action_id "Action ID",
      "Email View".id "View ID",
      "Email View".time "View Time",
      "Email View".user_id as "View User ID",
      "Contact Received Campaigns".user_id as "Contact User ID",
      "Contact Received Campaigns".user_list_id as "Contact User List ID",
      "Contact Received Campaigns".contact_email_name as "Contact Email",
      "Contact Received Campaigns".contact_first_name as "Contact First Name",
      "Contact Received Campaigns".contact_last_name as "Contact Last Name",
      "Contact Received Campaigns".contact_mobile_number as "Contact Mobile Number"
      from
      xamplify_test.xa_campaign_d "Vendor Company1"
      left outer join
      xamplify_test.xa_campaign_d "Redistributed Cam1"
      on "Vendor Company1".campaign_id = "Redistributed Cam1".parent_campaign_id
      join xamplify_test.xa_campaign_user_userlist_d "Contact Received Campaigns"
      on "Redistributed Cam1".campaign_id = "Contact Received Campaigns".campaign_id
      left JOIN xamplify_test.xa_emaillog_d "Email View"
      ON (("Redistributed Cam1".campaign_id = "Email View".campaign_id)
      and "Email View".user_id = "Contact Received Campaigns".user_id)
      where "Redistributed Cam1".is_nurture_campaign = true
      )
      select * from a left join b on a."Redistributed Campaign ID" = b."Redistributed Campaign ID1"
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
  }
  measure: Vendor_campaign_id{
    type: count_distinct
    sql: ${vendor_campaign_id} ;;
    drill_fields: [Campaigns_created*]
  }

  measure:campaigns_received_Partner{
    type: count_distinct
    sql: ${partner_received_campaign} ;;
    drill_fields: [campaign_received_partners*]
  }
  measure:Not_Redistributed  {
    type:number
    sql: ${campaigns_received_Partner}- ${campaigns_Redistribued_by_Partners} ;;
    drill_fields: [Not_redistributed_campaign*]
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

  dimension: contact_email {
    type: string
    label: "Contact Email"
    sql: ${TABLE}."Contact Email" ;;
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
    fields: [vendor_company_name,vendor_campaign_name ]
  }

  set: Campaigns_created{
    fields: [ vendor_company_name,vendor_campaign_name
    ]
  }

  set: campaign_received_partners {
    fields: [vendor_company_name,vendor_campaign_name]
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
      redistributed_campaign_id1,
      action_id,
      view_id,
      view_time_time,
      view_user_id,
      contact_user_id,
      contact_user_list_id,
      contact_email,
      contact_first_name,
      contact_last_name,
      contact_mobile_number
    ]
  }
}



























explore: user_profile  {
  label: "1 Vendor dashboard"
  view_name: xa_user_profile_f

  join: xa_campaign_d {
    type: left_outer
    relationship: many_to_one
    sql_on: ${xa_user_profile_f.campaign_id}=${xa_campaign_d.campaign_id} ;;
  }
  join: xa_company_d {
    type: left_outer
    relationship: many_to_one
    sql_on: ${xa_user_profile_f.company_id}=${xa_company_d.company_id} ;;
  }
  join: xa_role_d {
    type: inner
    relationship: many_to_one
    sql_on: ${xa_user_profile_f.role_id}=${xa_role_d.role_id} ;;
  }
  join: xa_user_d {
    type: inner
    relationship: many_to_one
    sql_on: ${xa_user_profile_f.user_id}=${xa_user_d.user_id} ;;
  }
   join: xa_team_member_d {
   type: inner
   relationship:many_to_one
   sql_on: ${xa_user_profile_f.company_id}=${xa_team_member_d.company_id} ;;
}
   join: xa_campaign_user_userlist_d {
   type: left_outer
  relationship: one_to_many
  sql_on: ${xa_campaign_d.campaign_id}=${xa_campaign_user_userlist_d.campaign_id} ;;
}
  join: xa_emaillog_d {
  type: left_outer
  relationship: one_to_many
  sql_on: ${xa_campaign_d.campaign_id}=${xa_emaillog_d.campaign_id} ;;
}
join: xa_xtremandlog_d {
  type: left_outer
  relationship: one_to_many
  sql_on: ${xa_campaign_d.campaign_id}=${xa_xtremandlog_d.campaign_id} ;;
}
join:xa_user_list_d {
  type: left_outer
  relationship: one_to_many
  sql_on:${xa_user_d.user_id}=${xa_user_list_d.customer_id};;
}
join: xa_emailtemplates_d {
  type: inner
relationship: one_to_many
sql_on:${xa_user_d.user_id}=${xa_emailtemplates_d.user_id} ;;
}
join: xa_campaign_deal_registration_d {
  type: left_outer
  relationship: one_to_many
  sql_on: ${xa_campaign_d.campaign_id}=${xa_campaign_deal_registration_d.campaign_id} ;;

}
}



############# 2 Partners Dashboard ##############

explore: xa_user_list_d {
  label: "2 Partner dashboard"
  view_name: xa_user_list_d

  join: xa_user_d {
    type: inner
    relationship: many_to_one
    sql_on: ${xa_user_list_d.customer_id}=${xa_user_d.user_id} ;;
  }
  join: xa_user_d_partner {
    from: xa_user_d
    type: inner
    relationship: many_to_one
    sql_on: ${xa_user_list_d.listby_partner_id}=${xa_user_d_partner.user_id} ;;
  }
  join:xa_user_list_d1  {
    from:xa_user_list_d
    type:left_outer
    relationship: many_to_many
    sql_on: ${xa_user_list_d.listby_partner_id}=${xa_user_list_d1.customer_id} ;;
  }
  join: xa_company_d {
    type: left_outer
    relationship: many_to_one
    sql_on: ${xa_user_d.company_id}=${xa_company_d.company_id} ;;
  }
  join: xa_company_d_partner {
    from: xa_company_d
    type: left_outer
    relationship: many_to_one
    sql_on: ${xa_user_d.company_id}=${xa_company_d.company_id} ;;
  }
  join:xa_user_d_contact {
    from: xa_user_d
    type: left_outer
    relationship: many_to_one
    sql_on: ${xa_user_list_d1.listby_partner_id}=${xa_user_d.user_id} ;;
  }
  }
