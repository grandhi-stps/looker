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
      "Contact Received Campaigns".user_list_id as "Contact User List ID"
      --"Contact Received Campaigns".contact_company as "Contact Company",
      --"Contact Received Campaigns".email_id as "Contact Email ID",
      --"Contact Received Campaigns".contact_first_name as "Contact First Name",
      --"Contact Received Campaigns".contact_last_name as "Contact Last Name",
      --"Contact Received Campaigns".contact_mobile_number as "Contact Mobile Number",
      --"Contact Received Campaigns".contact_country as "Contact Country",
      --"Contact Received Campaigns".contact_state as "Contact State",
      --"Contact Received Campaigns".contact_city as "Contact City",
      --"Contact Received Campaigns".contact_zip as "Contact Zip Code"
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
      ),
       c as (select distinct user_id as "Contact User ID1",
contact_company as "Contact Company",
email_id as "Contact Email ID",
contact_first_name as "Contact First Name",
contact_last_name as "Contact Last Name",
contact_mobile_number as "Contact Mobile Number",
contact_country as "Contact Country",
contact_state as "Contact State",
contact_city as "Contact City",
contact_zip as "Contact Zip Code",ROW_NUMBER () OVER (PARTITION BY user_id order by 1,2,3,4,5,6,7,8,9,10 desc nulls last) as row_number1
from xamplify_test.xa_campaign_user_userlist_d)
      select * from a left join b on a."Redistributed Campaign ID" = b."Redistributed Campaign ID1"
      inner join c on b."Contact User ID" = c."Contact User ID1"
      where a."Vendor Company ID" in (202,262,268,269,283,291,305,325,328,343,399,422,464)
      and c.row_number1 = 1
     -- and b."Contact User ID" is not null
 ;;
  }
  parameter: Date_selector {
    label: "Date_Selector"
    description: "This filter applies only for Quarter,Month,Week Report "
    allowed_value: { value: "Last 4 Quarters" }
    allowed_value: { value: "Last 4 Months" }
    allowed_value: { value: "Last 4 Weeks" }
  }


  dimension: Quarter {
    type: string
    sql:
           CASE
           when {% parameter Date_selector %} = 'Last 4 Quarters'
  and
  (( extract(year from age(now(), (${redistributed_cam_launch_time_date})))*4)
        +
        ( extract(quarter from age(now(), (${redistributed_cam_launch_time_date})))) )>=0
        and
              (( extract(year from age(now(), (${redistributed_cam_launch_time_date})))*4)
        +
        ( extract(quarter from age(now(), (${redistributed_cam_launch_time_date})))) )<4

  then cast (${year_qtr} as character varying)
  end;;
   drill_fields: [Months]
  }

    dimension: Months {
    type: string
    sql:
    CASE

  when {% parameter Date_selector %} = 'Last 4 Months'
   and
   ( ( extract(year from age(now(), (${redistributed_cam_launch_time_date})))*12)
        +
    ( extract(month from age(now(), (${redistributed_cam_launch_time_date})))))>=0
 and
  ( ( extract(year from age(now(), (${redistributed_cam_launch_time_date})))*12)
        +
   ( extract(month from age(now(), (${redistributed_cam_launch_time_date})))))<4


 then concat ( ${month_name},' - ' , cast( ${vendor_cam_created_time_year} as character varying ))

end;;
}

      dimension: Quarters {
        type: string
        sql:
        CASE


 when {% parameter Date_selector %} = 'Last 4 Weeks'
  and
    ( ( extract(year from age(now(), (${redistributed_cam_launch_time_date})))*53)
        +
        ( extract(week from  age(now(), (${redistributed_cam_launch_time_date})))) )>=0

     and
              ( ( extract(year from age(now(), (${redistributed_cam_launch_time_date})))*53)
        +
        ( extract(week from  age(now() , (${redistributed_cam_launch_time_date})))) )<4
then cast(${week} as character varying)
                 end
                ;;
  }
  measure: Emailopened_Count{
    type:count_distinct
    sql:

    case when {% parameter Date_selector %} = 'Last 4 Quarters'
  and
  (( extract(year from age(now(), (${redistributed_cam_launch_time_date})))*4)
        +
        ( extract(quarter from age(now(), (${redistributed_cam_launch_time_date})))) )>=0
        and
              (( extract(year from age(now(), (${redistributed_cam_launch_time_date})))*4)
        +
        ( extract(quarter from age(now(), (${redistributed_cam_launch_time_date})))) )<4

  then ${view_user_id}

  when {% parameter Date_selector %} = 'Last 4 Months'
   and
   ( ( extract(year from age(now(), (${redistributed_cam_launch_time_date})))*12)
        +
    ( extract(month from age(now(), (${redistributed_cam_launch_time_date})))))>=0
 and
  ( ( extract(year from age(now(), (${redistributed_cam_launch_time_date})))*12)
        +
   ( extract(month from age(now(), (${redistributed_cam_launch_time_date})))))<4

 then ${view_user_id}

 when {% parameter Date_selector %} = 'Last 4 Weeks'
  and
    ( ( extract(year from age(now(), (${redistributed_cam_launch_time_date})))*53)
        +
        ( extract(week from age(now() , (${redistributed_cam_launch_time_date})))) )>=0

     and
              ( ( extract(year from age(now(), (${redistributed_cam_launch_time_date})))*53)
        +
        ( extract(week from  age(now() , (${redistributed_cam_launch_time_date})))) )<4
then ${view_user_id}
                 end
                ;;
  }

  measure: Views_Count{
    type:count_distinct
    sql:

    case when {% parameter Date_selector %} = 'Last 4 Quarters'
  and
  (( extract(year from age(now(), (${redistributed_cam_launch_time_date})))*4)
        +
        ( extract(quarter from age(now(), (${redistributed_cam_launch_time_date})))) )>=0
        and
              (( extract(year from age(now(), (${redistributed_cam_launch_time_date})))*4)
        +
        ( extract(quarter from age(now(), (${redistributed_cam_launch_time_date})))) )<4

  then ${view_id}

  when {% parameter Date_selector %} = 'Last 4 Months'
   and
   ( ( extract(year from age(now(), (${redistributed_cam_launch_time_date})))*12)
        +
    ( extract(month from age(now(), (${redistributed_cam_launch_time_date})))))>=0
 and
  ( ( extract(year from age(now(), (${redistributed_cam_launch_time_date})))*12)
        +
   ( extract(month from age(now(), (${redistributed_cam_launch_time_date})))))<4

 then ${view_id}

 when {% parameter Date_selector %} = 'Last 4 Weeks'
  and
    ( ( extract(year from age(now(), (${redistributed_cam_launch_time_date})))*53)
        +
        ( extract(week from age(now(), (${redistributed_cam_launch_time_date})))) )>=0

     and
              ( ( extract(year from age(now(), (${redistributed_cam_launch_time_date})))*53)
        +
        ( extract(week from age(now() , (${redistributed_cam_launch_time_date})))) )<4
then ${view_id}
                 end
                ;;
  }

  measure: leads_Count{
    type:count_distinct
    sql:

    case when {% parameter Date_selector %} = 'Last 4 Quarters'
  and
  (( extract(year from age(now(), (${deal_created_time_date})))*4)
        +
        ( extract(quarter from age(now(), (${deal_created_time_date})))) )>=0
        and
              (( extract(year from age(now(), (${deal_created_time_date})))*4)
        +
        ( extract(quarter from age(now(), (${deal_created_time_date})))) )<4

  then ${deal_id}

  when {% parameter Date_selector %} = 'Last 4 Months'
   and
   ( ( extract(year from age(now(), (${deal_created_time_date})))*12)
        +
    ( extract(month from age(now(), (${deal_created_time_date})))))>=0
 and
  ( ( extract(year from age(now(), (${deal_created_time_date})))*12)
        +
   ( extract(month from age(now(), (${deal_created_time_date})))))<4

 then ${deal_id}

 when {% parameter Date_selector %} = 'Last 4 Weeks'
  and
    ( ( extract(year from age(now(), (${deal_created_time_date})))*53)
        +
        ( extract(week from  age(now(), (${deal_created_time_date})))) )>=0

     and
              ( ( extract(year from age(now(), (${deal_created_time_date})))*53)
        +
        ( extract(week from   age(now() , (${deal_created_time_date})))) )<4
then ${deal_id}
                 end
                ;;
  }


  measure: Deals_Count{
    type:count_distinct
    sql:

    case when {% parameter Date_selector %} = 'Last 4 Quarters'
  and
  (( extract(year from age(now(), (${deal_created_time_date})))*4)
        +
        ( extract(quarter from age(now(), (${deal_created_time_date})))) )>=0
        and
              (( extract(year from age(now(), (${deal_created_time_date})))*4)
        +
        ( extract(quarter from age(now(), (${deal_created_time_date})))) )<4
        and ${is_deal}=true

  then ${deal_id}

  when {% parameter Date_selector %} = 'Last 4 Months'
   and
   ( ( extract(year from age(now(), (${deal_created_time_date})))*12)
        +
    ( extract(month from age(now(), (${deal_created_time_date})))))>=0
 and
  ( ( extract(year from age(now(), (${deal_created_time_date})))*12)
        +
   ( extract(month from age(now(), (${deal_created_time_date})))))<4
  and ${is_deal}=true

 then ${deal_id}

 when {% parameter Date_selector %} = 'Last 4 Weeks'
  and
    ( ( extract(year from age(now(), (${deal_created_time_date})))*53)
        +
        ( extract(week from age(now() , (${deal_created_time_date})))) )>=0

     and
              ( ( extract(year from age(now(), (${deal_created_time_date})))*53)
        +
        ( extract(week from age(now()  , (${deal_created_time_date})))) )<4
        and ${is_deal}=true
then ${deal_id}
                 end
                ;;
  }



dimension: category {
  type:  string
  sql: ${TABLE}.'Email_opend' ;;

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

      drill_fields: [partner_company_name,redistributed_campaign_id,redistributed_campaign_name]

      link: {
        label: "Redistributed Details"
        url: "https://stratappspartner.looker.com/looks/37?
        &f[campaign1.vendor_company_name]={{ _filters['campaign1.vendor_company_name'] | url_encode }}
        &f[campaign1.partner_company_name]={{ _filters['campaign1.partner_company_name'] | url_encode }}
        &f[campaign1.redistributed_campaign_name]={{ _filters['campaign1.redistributed_campaign_name'] | url_encode }}
        &f[campaign1.redistributed_cam_launch_time_date]={{ _filters['campaign1.redistributed_cam_launch_time_date'] | url_encode }}"
      }

    }

   measure: Total_Recipients {
    type: count_distinct

    sql: ${contact_user_id};;
    # sql_distinct_key: ${contact_user_id} ;;

   # html: {{rendered_value}} , {{Active_recipients.rendered_value}};;
    drill_fields: [
      email_id,contact_company,contact_mobile_number,contact_country,contact_state,contact_city
    ]


    #link: {
     # label: "Total Recipients Map"
      #url: "https://stratappspartner.looker.com/looks/36?toggle=pik
      #&f[campaign1.vendor_company_name]={{ _filters['campaign1.vendor_company_name'] | url_encode }}
      #"
    #}

    #link: {
     # label: "Total Recipient details"
    #  url: "https://stratappspartner.looker.com/looks/38?
     # &f[campaign1.vendor_company_name]={{ _filters['campaign1.vendor_company_name'] | url_encode }}
    #  &f[campaign1.partner_company_name]={{ _filters['campaign1.partner_company_name'] | url_encode }}
     # &f[campaign1.redistributed_campaign_name]={{ _filters['campaign1.redistributed_campaign_name'] | url_encode }}
    #  &f[campaign1.redistributed_cam_launch_time_date]={{ _filters['campaign1.redistributed_cam_launch_time_date'] | url_encode }}"
    #}

  }






    measure: Email_Opened{
      type: count_distinct
      sql: ${view_user_id} ;;
      drill_fields: [
        email_id,contact_company,contact_mobile_number,contact_country,contact_state,contact_city
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
        label: "Email Not Opened Details"
        url: "https://stratappspartner.looker.com/looks/33?
        &f[campaign1.vendor_company_name]={{ _filters['campaign1.vendor_company_name'] | url_encode }}
        &f[campaign1.partner_company_name]={{ _filters['campaign1.partner_company_name'] | url_encode }}
        &f[campaign1.redistributed_campaign_name]={{ _filters['campaign1.redistributed_campaign_name'] | url_encode }}
        &f[campaign1.redistributed_cam_launch_time_date]={{ _filters['campaign1.redistributed_cam_launch_time_date'] | url_encode }}"
      }
      # drill_fields: [
      #  partner_company_name,redistributed_campaign_name,email_id,contact_mobile_number
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
      drill_fields: [partner_company_name,redistributed_campaign_name]
      # link: {
      #  label: "Detail Report"
      #url: "https://stratappspartner.looker.com/looks/20 & pivots"

      #}

    }




  measure: Active_recipients {
    type: count_distinct
    sql: ${view_user_id} ;;
    drill_fields: [email_id,contact_first_name,contact_last_name,country,state,city,contact_mobile_number]

  }

    measure: Views {
      type: count_distinct
      sql: ${view_id} ;;
      drill_fields: [
        email_id,
        view_time_time,view_id,email_id,contact_company,contact_mobile_number,contact_country,contact_state,contact_city]
    }

    measure: partners {
      type: count_distinct
      sql: ${partner_company_id} ;;
      drill_fields: [partner_company_name]
    }
    measure: Deals  {
      type:count_distinct
      sql: (case when ${is_deal} =true then ${deal_id} END);;
    }
    measure: Leads  {
      type:count_distinct
      sql: ${deal_id};;


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
      drill_fields: [partner_company_name,redistributed_campaign_type]
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
      drill_fields: [redistributed_campaign_type]
    }

    dimension: redistributed_campaign_name {
      type: string
      label: "Redistributed Campaign Name"
      sql: ${TABLE}."Redistributed Campaign Name" ;;


      drill_fields: [partner_company_name]
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
      drill_fields: [redistributed_cam_launch_time_month,redistributed_cam_launch_time_week]
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
      drill_fields: [partner_company_name,redistributed_campaign_name,email_id]
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

  dimension: contact_user_id1 {
    type: number
    label: "Contact User ID1"
    sql: ${TABLE}."Contact User ID1" ;;
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

   map_layer_name: countries
    label: "View Country"
    sql: ${TABLE}."View Country" ;;
  }

  dimension: state {

    map_layer_name: us_states
    label: "View State"
    sql: ${TABLE}."View State" ;;
  }
  dimension: city {

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


    dimension: Apx_lat  {
      type: number
      sql: (case when POSITION('.' IN ${latitude})=3 and substring(${latitude},1,1)<>'-'
                      then ((ascii(substring(${latitude},1,1))-48)*10+ (ascii(substring(${latitude},2,1))-48)+round((ascii(substring(${latitude},4,1))-48)*(1::numeric/10),1)
                           +round((ascii(substring(${latitude},5,1))-48)*(1::numeric/100),2))
                when POSITION('.' IN ${latitude})=3 and substring(${latitude},1,1)='-'
                       then  (-1*((ascii(substring(${latitude},2,1))-48)+ +round((ascii(substring(${latitude},4,1))-48)*(1::numeric/10),1)
                           +round((ascii(substring(${latitude},5,1))-48)*(1::numeric/100),2)))
                  when  POSITION('.' IN ${latitude})=4 and substring(${latitude},1,1)<>'-'
                      then  ((ascii(substring(${latitude},1,1))-48)*100+ (ascii(substring(${latitude},2,1))-48)*10+(ascii(substring(${latitude},3,1))-48)+round((ascii(substring(${latitude},5,1))-48)*(1::numeric/10),1)
                           +round((ascii(substring(${latitude},6,1))-48)*(1::numeric/100),2))

                when POSITION('.' IN ${latitude})=4 and substring(${latitude},1,1)='-'
                       then (-1*((ascii(substring(${latitude},2,1))-48)*10+ (ascii(substring(${latitude},3,1))-48)+round((ascii(substring(${latitude},5,1))-48)*(1::numeric/10),1)
                       +round((ascii(substring(${latitude},6,1))-48)*(1::numeric/100),2)))
                when POSITION('.' IN ${latitude})=2 and substring(${latitude},1,1)<>'-'
                      then   ((ascii(substring(${latitude},1,1))-48)+ +round((ascii(substring(${latitude},3,1))-48)*(1::numeric/10),1)
                           +round((ascii(substring(${latitude},4,1))-48)*(1::numeric/100),2))
                  end)
                ;;
    }

    dimension: Apx_long {
      type: number
      sql:(case when POSITION('.' IN ${longitude})=3 and substring(${longitude},1,1)<>'-'
                      then ((ascii(substring(${longitude},1,1))-48)*10+ (ascii(substring(${longitude},2,1))-48)+round((ascii(substring(${longitude},4,1))-48)*(1::numeric/10),1)
                           +round((ascii(substring(${longitude},5,1))-48)*(1::numeric/100),2))
               when POSITION('.' IN ${longitude})=4 and substring(${longitude},1,1)='-'
                       then (-1*((ascii(substring(${longitude},2,1))-48)*10+ (ascii(substring(${longitude},3,1))-48)+round((ascii(substring(${longitude},5,1))-48)*(1::numeric/10),1)
                       +round((ascii(substring(${longitude},6,1))-48)*(1::numeric/100),2)))
                 when  POSITION('.' IN ${longitude})=4 and substring(${longitude},1,1)<>'-'
                      then  ((ascii(substring(${longitude},1,1))-48)*100+ (ascii(substring(${longitude},2,1))-48)*10+(ascii(substring(${longitude},3,1))-48)+round((ascii(substring(${longitude},5,1))-48)*(1::numeric/10),1)
                           +round((ascii(substring(${longitude},6,1))-48)*(1::numeric/100),2))
               when   POSITION('.' IN ${longitude})=5 and substring(${longitude},1,1)='-'
                      then   (-1*((ascii(substring(${longitude},2,1))-48)*100+ (ascii(substring(${longitude},3,1))-48)*10+(ascii(substring(${longitude},4,1))-48)+round((ascii(substring(${longitude},6,1))-48)*(1::numeric/10),1)
                           +round((ascii(substring(${longitude},7,1))-48)*(1::numeric/100),2)))
                 when POSITION('.' IN ${longitude})=3 and substring(${longitude},1,1)='-'
                       then  (-1*((ascii(substring(${longitude},2,1))-48)+ +round((ascii(substring(${longitude},4,1))-48)*(1::numeric/10),1)
                           +round((ascii(substring(${longitude},5,1))-48)*(1::numeric/100),2)))
               when POSITION('.' IN ${longitude})=2 and substring(${longitude},1,1)<>'-'
                      then   ((ascii(substring(${longitude},1,1))-48)+ +round((ascii(substring(${longitude},3,1))-48)*(1::numeric/10),1)
                           +round((ascii(substring(${longitude},4,1))-48)*(1::numeric/100),2))
                  end)
              ;;
    }

    dimension: user_location {
      type: location
      sql_latitude: ${latitude} ;;
      sql_longitude: ${longitude} ;;
    }
    dimension: max_ip_adress{
      type: string
      sql: select max(${latitude}||${longitude})
            from ${TABLE}
            group by ${country},${state};;
    }


    dimension: Apx_location {
      type: location
      sql_latitude:round(${Apx_lat},1) ;;
      sql_longitude:round(${Apx_long},1);;
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
        contact_user_id1,
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
      drill_fields: [vendor_campaign_type,vendor_campaign_name]

    }


    measure: campaigns_Redistribued_by_Partners{
      type: count_distinct
      sql: ${parent_campaign_id} ;;
      drill_fields: [vendor_campaign_type,vendor_campaign_name]
    }

    measure:Not_Redistributed  {
      type:number
      sql: ${campaigns_received_Partner}- ${campaigns_Redistribued_by_Partners} ;;
      drill_fields: [vendor_campaign_type,vendor_campaign_name]

    }
    measure: Vendor_Cam_Lauched{
      type: count_distinct
      sql: (case when ${vendor_cam_is_launched} then ${vendor_campaign_id} END);;
      #(IF ${vendor_cam_is_launched}  THEN  ${vendor_campaign_id} END);;
      drill_fields: [vendor_campaign_type,vendor_campaign_name]
     # link: {
      #  label: "Detail Report"
       # url: "{{https://stratappspartner.looker.com/looks/20}}"
    #  }

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
      drill_fields: [redistributed_campaign_name]

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
     # link: {
      #  label: "Detail Report1"
       # url: "https://stratappspartner.looker.com/looks/35?
      #  &f[campaign1.vendor_company_name]={{_filters['vendors.vendor_company_name'] | url_encode }}
       # &f[campaign1.partner_company_name]={{_filters['vendors.partner_company_name'] | url_encode }}"
      #}
      link:{
        label:"{{value}} Partner Dashboard"
        url: "https://stratappspartner.looker.com/dashboards/16?Vendor%20Company%20Name={{_filters['vendors.vendor_company_name'] | url_encode }}&Partner%20Company%20Name={{ value | encode_uri }}"
        icon_url: "http://www.looker.com/favicon.ico"
      }
      drill_fields: [vendor_campaign_name]
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
      link:{
        label:"{{value}} Partner Dashboard"
        url: "https://stratappspartner.looker.com/dashboards/16?Vendor%20Company%20Name={{_filters['vendors.vendor_company_name'] | url_encode }}&Campaign%20Name={{ value | encode_uri }}"
        icon_url: "http://www.looker.com/favicon.ico"
      }
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
                 "Campaign Deal Status".created_time as "Deal_status_created_time",
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
      drill_fields: [partner_company_name,
      redistributed_campaign_name,
      deal_email_id
      ]
      }

      measure: Leads  {
        type:count_distinct
        sql: ${id};;
        drill_fields: [partner_company_name,
          redistributed_campaign_name,redistributed_campaign_type,deal_email_id
        ]
     }

    measure: 20Q1leads{
      type: count_distinct
      sql: case when ${year_qtr}='20Q1' then ${id} end ;;
    }

    measure: 20Q2leads{
      type: count_distinct
      sql: case when ${year_qtr}='20Q2' then ${id} end ;;
      drill_fields: [partner_company_name,
        redistributed_campaign_name,redistributed_campaign_type,deal_email_id,deal_first_name,deal_last_name,deal_created_time_date]
    }

    measure: 20Q1Deals{
      type: count_distinct
      sql: case when ${year_qtr}='20Q1' and ${is_deal}='true' then ${id} end ;;
    }

    measure: 20Q2Deals{
      type: count_distinct
      sql: case when ${year_qtr}='20Q2' and ${is_deal}='true' then ${id} end ;;
      drill_fields: [partner_company_name,
        redistributed_campaign_name,redistributed_campaign_type,deal_email_id,deal_first_name,deal_last_name,deal_created_time_date]
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

    measure: Prev_Year_Leads {
      type: count_distinct
      sql:case when extract(year from ${deal_created_time_date})= (extract(year from now())-1)
        and extract(year from ${deal_created_time_date})=2020  then ${id} end;;
    }
    measure: Cur_Year_Leads {
      type: count_distinct
      sql:case when extract(year from ${deal_created_time_date})= extract(year from now())
        and extract(year from ${deal_created_time_date})=2020 then ${id} end;;

    }

    measure: Prev_Year_Deals{
      type: count_distinct
      sql:case when extract(year from ${deal_created_time_date})= (extract(year from now())-1)
              and extract(year from ${deal_created_time_date})=2020 and ${is_deal}='true'
    then ${id} end;;

    }
    measure: Cur_Year_Deals{
      type: count_distinct
      sql:case when extract(year from ${deal_created_time_date})= extract(year from now())
                      and extract(year from ${deal_created_time_date} )=2020   and ${is_deal}='true'
                then ${id} end;;

    }

    measure: Percent_change_Leads {
      type: percent_of_previous
      sql: 100*coalesce(((${Cur_Year_Leads}-${Prev_Year_Leads})*100),0)/coalesce(NULLIF(${Prev_Year_Leads},0),1) ;;

    }

    measure: Percent_change_Deals {
      type: percent_of_previous
      sql: 100*coalesce(((${Cur_Year_Deals}-${Prev_Year_Deals})*100),0)/coalesce(NULLIF(${Prev_Year_Deals},0),1) ;;

    }
    dimension: Year_Mon {
      type: string
      sql:  concat(cast(extract(year from ${deal_status_created_time_date}) as character varying),'-',
          cast(extract(month  from ${deal_status_created_time_date} ) as character varying))
          ;;
          order_by_field: deal_status_created_time_month


      }

        dimension: month_startdate_enddatee{
          type: string
          sql: concat(to_char((date_trunc('week',${date_date})),'Mon'),' ',extract(day from date_trunc('week', ${date_date})) || ' - ' || to_char(((date_trunc('week',${date_date})) + '6 days'),'Mon'),' ',
               extract(day from (date_trunc('week', ${date_date}) + '6 days')))
         ;;
        order_by_field: week

            }

           dimension: month_startdate_enddate{
            type: string
            #allow_fill: yes
            sql: concat(to_char((date_trunc('week',"Deal Created Time")),'Mon'),' ',extract(day from date_trunc('week', "Deal Created Time")) || ' - ' || to_char(((date_trunc('week',"Deal Created Time")) + '6 days'),'Mon'),' ',
               extract(day from (date_trunc('week', "Deal Created Time") + '6 days')))
         ;;
            order_by_field: deal_created_time_week
          }


    dimension: week_start_date {
      type: string
      sql: date_trunc('week',${date_date} ;;
    }






    dimension: created_week {
      type:date_week_of_year
      label: "Redistributed Cam Week"
      sql: ${TABLE}."Deal Created Time" ;;
    }

    dimension: Created_year {
      type: date_fiscal_year
      label: "Created_time of deal Status"
      sql: ${TABLE}.created_time ;;

    }
    dimension: week_no {
      type: date_day_of_week
      label: "Redistributed Cam Weekno"
      sql: extract('week' from "Deal Created Time") ;;
    }


    dimension: created_week_startdate{
      type: date_week
      label: "created_week_startdate"
      sql: ${TABLE}."Deal Created Time" ;;

    }
    dimension: created_week1 {
      type:date_week_of_year
      label: "Redistributed Cam Week1"
      sql: ${TABLE}."Deal Created Time" ;;
      order_by_field:created_week
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
      drill_fields: [partner_company_name,
        redistributed_campaign_name,redistributed_campaign_type,deal_email_id]

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

    dimension_group:: date {
      type: time
      sql: ${TABLE}."Date";;
      order_by_field: date_week_of_year
    }

    dimension: year_qtr {
      type: string
      label: "Year Qtr"
      sql: ${TABLE}."Year Qtr" ;;
      drill_fields: [partner_company_name,
        redistributed_campaign_name,redistributed_campaign_type,deal_email_id
      ]

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
    dimension_group: deal_status_created_time {
      type: time
      label: "Deal_Status_Created_time"
      sql: ${TABLE}."Deal_status_created_time" ;;
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
        date_date,
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
        Deal_status_created_time.created_time,
        deal_company
      ]
    }
  }


  explore:nurture_campaigns  {}
  view: nurture_campaigns {
    derived_table: {
      sql: with t1 as (
                select * from xamplify_test.xa_emailtemplates_d
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

      explore:vendor_nurtures  {}

view: vendor_nurtures {
  derived_table: {
    sql: SELECT distinct
         xa_user_d.user_id AS user_id,
         xa_company_d.company_name AS company_name,
                  xa_user_d.email_id AS email_id,
                  xa_user_d.firstname AS firstname,
                  xa_user_d.lastname AS lastname,
                  xa_user_d.datereg AS datereg,
                  xa_user_d.datelastlogin AS datelastlogin,
                  xa_user_d.created_time AS created_time,
                 xa_user_d.mobile_number AS mobile_number,
                xa_user_d.company_id as User_Company_Id,

                  xa_campaign_d.campaign_id AS campaign_id_d,
                 xa_campaign_d.customer_id AS customer_id,
                  xa_campaign_d.campaign_name AS campaign_name,
                 xa_campaign_d.campaign_type AS campaign_type,
                  xa_campaign_d.created_time AS created_time_d,
                  xa_campaign_d.launch_time AS launch_time,
                  xa_campaign_d.parent_campaign_id AS parent_campaign_id,
                  xa_campaign_d.is_launched AS is_launched,
                  xa_company_d.company_id AS company_id,

                  xa_drip_email_history_d.user_id AS user_id_drip,
                  xa_drip_email_history_d.sent_time AS sent_time,
                  xa_emailtemplates_d.name AS name,
                  xa_emailtemplates_d.type AS type,
                    CAST(xa_emailtemplates_d.subject AS TEXT) AS subject,
                  xa_user_role_d.role_id AS role_id,
                  xa_drip_email_history_d.action_id as action_id_drip,
                 a.action_type as action_type_a,
                  a.action_id as action_id_a,
                  a.action_name as action_name_a

                FROM xamplify_test.xa_user_d xa_user_d
                  LEFT JOIN (select * from (select campaign_id,customer_id,created_time,campaign_name,campaign_type,
                      launch_time,parent_campaign_id,is_launched,RANK () OVER (
    PARTITION BY customer_id
    ORDER BY launch_time asc
  ) rank
    from xamplify_test.xa_campaign_d) a
    where a.rank<=5  ) as xa_campaign_d ON (xa_user_d.user_id =xa_campaign_d.customer_id)
                  LEFT JOIN (select * from xamplify_test.xa_company_d where xa_company_d.company_id not in(231,130,265,266,313,391,280,281,303,307,311,357,320,326,331,334,356,270,368,370,369,372,376,
                  380,382,398,215,273,410,413,415,374,389,322,332,333,335,367,349,358,359,362,371,378,379,381,385,386,388,393,395,401,414,384,421,424)) xa_company_d ON (xa_user_d.company_id = xa_company_d.company_id)
                  LEFT JOIN xamplify_test.xa_campaign_d xa_campaign_d1 ON (xa_campaign_d.campaign_id = xa_campaign_d1.parent_campaign_id)
                  LEFT JOIN xamplify_test.xa_campaign_user_userlist_d xa_campaign_user_userlist_d ON (xa_campaign_d.campaign_id = xa_campaign_user_userlist_d.campaign_id)
                  left JOIN (select * from xamplify_test.xa_drip_email_history_d where xa_drip_email_history_d.action_id>=22 and xa_drip_email_history_d.action_id<=36) xa_drip_email_history_d ON (xa_user_d.user_id = xa_drip_email_history_d.user_id)
                  full join (select * from xamplify_test.xa_action_type_d
              where xa_action_type_d.action_id >= 22 and xa_action_type_d.action_id <= 36) a on (xa_drip_email_history_d.action_id=a.action_id)
                  left JOIN xamplify_test.xa_emailtemplates_d xa_emailtemplates_d ON (xa_drip_email_history_d.email_template_id = xa_emailtemplates_d.id)
                  left JOIN xamplify_test.xa_user_role_d xa_user_role_d ON (xa_user_d.user_id = xa_user_role_d.user_id)
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }
  measure: Name {
   type: count_distinct
    sql: ${name};;
    drill_fields: [company_name,created_time_raw,datereg_raw,name,subject,sent_time_raw]
  }

  measure: Active_Nurtures{
    type: count_distinct

    sql: ${action_id_a} ;;
    drill_fields: [action_name_a,action_name_Category]
  }



  measure: Vendor_nurtures{
    type: count_distinct
    sql: ${action_type_a} ;;
    drill_fields: [action_name_a,action_name_Category]
  }

  measure: Inactive_nurtures {
    type: count_distinct
    sql: ${action_type_a} ;;
    drill_fields: [action_name_a,action_name_Category]
  }

  measure: Nurture_companies {
    type: count_distinct
    sql: ${company_id_xa_company_d};;
    drill_fields: [company_name,action_name_Category,name,subject,sent_time_date]
  }
  measure: Nurture_Without_companies {
    type: count_distinct
    sql: ${company_id_xa_company_d};;
   drill_fields: [company_name,created_time_date,datereg_date]
  }

  measure: launch_time {
    type: count_distinct
     sql: ${launch_time_raw} ;;
  }

  measure: Inactive_vendors{
    type: count_distinct
    sql: ${user_id} ;;
    drill_fields: [email_id,created_time_date,datereg_date,name,sent_time_date]

  }


  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: email_id {
    type: string
    sql: ${TABLE}.email_id ;;
  }

  dimension: firstname {
    type: string
    sql: ${TABLE}.firstname ;;
  }

  dimension: lastname {
    type: string
    sql: ${TABLE}.lastname ;;
  }

  dimension_group: datereg {
    type: time
    sql: ${TABLE}.datereg ;;
  }

  dimension_group: datelastlogin {
    type: time
    sql: ${TABLE}.datelastlogin ;;
  }


  dimension_group: created_time {
    type: time
    sql: ${TABLE}.created_time ;;
  }

  dimension: mobile_number {
    type: string
    sql: ${TABLE}.mobile_number ;;
  }
  dimension: company_id_xa_user_d {
    type: number
    label: "User_Company_Id"
    sql: ${TABLE}.User_Company_Id ;;
  }


  dimension: campaign_id_xa_campaign_d {
    type: number
    label: "campaign_id_d"
    sql: ${TABLE}.campaign_id_d ;;
  }

  dimension: customer_id {
    type: number
    sql: ${TABLE}.customer_id ;;
  }

  dimension: campaign_name {
    type: string
    sql: ${TABLE}.campaign_name ;;
  }

  dimension: campaign_type {
    type: string
    sql: ${TABLE}.campaign_type ;;
  }

  dimension_group: created_time_xa_campaign_d {
    type: time
    label: "created_time_d"
    sql: ${TABLE}.created_time_d ;;
  }

  dimension_group: launch_time {
    type: time
    sql: ${TABLE}.launch_time ;;
  }



  dimension: parent_campaign_id {
    type: number
    sql: ${TABLE}.parent_campaign_id ;;
  }

  dimension: is_launched {
    type: string
    sql: ${TABLE}.is_launched ;;
  }

  dimension: company_id_xa_company_d {
    type: number
    label: "company_id"
    sql: ${TABLE}."company_id" ;;
  }

  dimension: company_name {
    type: string
    sql: ${TABLE}.company_name ;;
  }

  dimension: action_id_a {
    type: number
    label: "action_id_a"
    sql: ${TABLE}.action_id_a ;;
  }
  dimension: action_type_a {
    type: string
    label: "action_type_a"
    sql: ${TABLE}.action_type_a ;;

  }
  dimension: action_name_a {
    type: string
    label: "action_name_a"
    sql: ${TABLE}.action_name_a ;;


  }

  dimension: user_id_xa_drip_email_history_d {
    type: number
    label: "user_id_drip"
    sql: ${TABLE}.user_id_drip ;;
  }
  dimension: action_id_xa_drip_email_history_d {
    type: number
    label: "action_id_drip"
    sql: ${TABLE}.action_id_drip ;;
  }

  dimension_group: sent_time {
    type: time
    sql: ${TABLE}.sent_time ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }

  dimension: subject {
    type: string
    sql: ${TABLE}.subject ;;
  }

  dimension: role_id {
    type: number
    sql: ${TABLE}.role_id ;;
  }
  dimension: action_name_Category {
    type: string
    sql:
     CASE
     when ${action_name_a}='vendor_welcome' THEN 'Welcome Nurtures'
    when ${action_name_a}='vendor_csm_intro' THEN 'Welcome Nurtures'
    when ${action_name_a}='vendor_kick_off' THEN 'Welcome Nurtures'
    when ${action_name_a}='vendor_complete_profile_success_nurture#1' THEN 'Company Profile Nurtures'
    when ${action_name_a}='vendor_incomplete_profile' THEN 'Company Profile Nurtures'
    when ${action_name_a}='vendor_inactive_support_nurture#1' THEN 'Company Profile Nurtures'
    when ${action_name_a}='vendor_inactive_support_nurture#2' THEN 'Company Profile Nurtures'
    when ${action_name_a}='vendor_adding_partner_nurture' THEN 'OnBoard Partner Nurtures'
    when ${action_name_a}='vendor_first_campaign_congrats' THEN 'Campaign Nurtures'
    when ${action_name_a}='vendor_first_campaign_nurture#1' THEN 'Campaign Nurtures'
    when ${action_name_a}='vendor_first_campaign_nurture#2' THEN 'Campaign Nurtures'
    when ${action_name_a}='vendor_first_campaign_nurture#3' THEN 'Campaign Nurtures'
    when ${action_name_a}='vendor_success_nurture#2' THEN 'Campaign Nurtures'
    when ${action_name_a}='vendor_removal_warning' THEN 'Removal warning Nurtures'
    when ${action_name_a}='vendor_churn_farewell_nurture' THEN 'Removal warning Nurtures'
    END ;;

    #drill_fields: [company_name,created_time_date,datereg_date]




    link:{
      label:"{{value}} With Nurture Details"
      url: "https://stratappspartner.looker.com/looks/97?&f[vendor_nurtures.action_name_Category]={{ value | encode_uri }}"
      icon_url: "http://www.looker.com/favicon.ico"
    }
    link:{
      label:"{{value}} Without Nurture Details"
      url: "https://stratappspartner.looker.com/looks/98?&f[vendor_nurtures.action_name_Category]=-{{ value | encode_uri }}"
      icon_url: "http://www.looker.com/favicon.ico"
    }


 }



  set: detail {
    fields: [
      user_id,
      email_id,
      firstname,
      lastname,
      datereg_time,
      datelastlogin_time,
      created_time_time,
      mobile_number,
      company_id_xa_user_d,
      campaign_id_xa_campaign_d,
      customer_id,
      campaign_name,
      campaign_type,
      created_time_xa_campaign_d_time,
      launch_time_time,
      parent_campaign_id,
      is_launched,
      company_id_xa_company_d,
      company_name,
      user_id_xa_drip_email_history_d,
      sent_time_time,
      name,
      type,
      subject,
      role_id,
      action_id_xa_drip_email_history_d,
      action_id_a,
      action_type_a,
      action_name_a,
      action_name_Category
    ]
  }
}



explore:partner_nurtures  {}
view: partner_nurtures {
  derived_table: {
    sql: SELECT xa_user_d.user_id AS user_id,
                  xa_user_d.email_id AS email_id,
                  xa_user_d.company_id AS company_id,
                  xa_company_d.company_id AS company_id_c,
                  xa_company_d.company_name AS company_name,
                  xa_campaign_d1.campaign_id AS campaign_id_cam1,
                  xa_campaign_d1.customer_id AS customer_id_cam1,
                  xa_campaign_d1.campaign_name AS campaign_name_cam1,
                  xa_campaign_d1.created_time AS created_time_cam1,
                  xa_campaign_d1.launch_time AS launch_time_cam1,
                  xa_campaign_d1.parent_campaign_id AS parent_campaign_id_cam1,
                  xa_campaign_user_userlist_d.campaign_id AS campaign_id_cul,
                  xa_campaign_user_userlist_d.user_id AS user_id_cul,
                  xa_campaign_user_userlist_d.email_id AS email_id_cul,
                  xa_campaign_user_userlist_d.partner_company_name AS partner_company_name,
                  xa_campaign_user_userlist_d.partner_first_name AS partner_first_name,
                  xa_campaign_user_userlist_d.partner_last_name AS partner_last_name,
                  xa_campaign_user_userlist_d.contact_user_id AS contact_user_id_cul,
                  xa_campaign_user_userlist_d.contact_first_name AS contact_first_name,
                  xa_campaign_user_userlist_d.contact_last_name AS contact_last_name,
                  xa_campaign_user_userlist_d.contact_company AS contact_company,
                  xa_drip_email_history_d.sent_time AS sent_time,
                  xa_emailtemplates_d.name AS name,
                  CAST(xa_emailtemplates_d.subject AS TEXT) AS subject,
          xa_user_d1.user_id AS user_id_p,
                  xa_user_d1.email_id AS email_id_p,
                  xa_user_d1.firstname AS firstname_p,
                  xa_user_d1.lastname AS lastname_p,
                  xa_user_d1.datereg AS datereg_p,
                  xa_user_d1.datelastlogin AS datelastlogin_p,
                  xa_user_d1.created_time AS created_time_p,
                  xa_user_d1.company_id AS company_id_p,
          xa_company_d1.company_id AS company_id_c1,
                  xa_company_d1.company_name AS company_name_c1,
          xa_user_role_d.user_id AS user_id_role,
                  xa_user_role_d.role_id AS role_id,
          xa_drip_email_history_d.action_id as action_id_drip,
                  a.action_type as action_type_a,
                  a.action_id as action_id_a,
                  a.action_name as action_name_a

               FROM xamplify_test.xa_user_d xa_user_d
                 left JOIN xamplify_test.xa_campaign_d xa_campaign_d ON (xa_user_d.user_id = xa_campaign_d.customer_id)
                 left JOIN xamplify_test.xa_campaign_d xa_campaign_d1 ON (xa_campaign_d.campaign_id = xa_campaign_d1.parent_campaign_id)
                 LEFT JOIN (select c.company_id,c.company_name from xamplify_test.xa_company_d c, xamplify_test.xa_user_d  u,xamplify_test.xa_user_role_d r
                 where u.company_id=c.company_id
                 and u.user_id=r.user_id
                 and r.role_id in(2,13) and c.company_id not in(231,130,265,266,313,391,280,281,303,307,311,357,320,326,331,334,356,270,368,370,369,372,376,
                 380,382,398,215,273,410,413,415,374,389,322,332,333,335,367,349,358,359,362,371,378,379,381,385,386,388,393,395,401,414,384,421,424)
           ) xa_company_d ON (xa_user_d.company_id = xa_company_d.company_id)
                 left JOIN xamplify_test.xa_user_d xa_user_d1 ON (xa_campaign_d1.customer_id = xa_user_d1.user_id)
                 LEFT JOIN xamplify_test.xa_company_d xa_company_d1 ON (xa_user_d1.company_id = xa_company_d1.company_id)
                 left JOIN (select * from xamplify_test.xa_drip_email_history_d where xa_drip_email_history_d.action_id>=37 and xa_drip_email_history_d.action_id<=48) xa_drip_email_history_d ON (xa_user_d1.user_id = xa_drip_email_history_d.user_id)
                 full join (select * from xamplify_test.xa_action_type_d
             where xa_action_type_d.action_id >= 37 and xa_action_type_d.action_id <= 48) a on (xa_drip_email_history_d.action_id=a.action_id)
                 left JOIN xamplify_test.xa_emailtemplates_d xa_emailtemplates_d ON (xa_drip_email_history_d.email_template_id = xa_emailtemplates_d.id)
                 LEFT JOIN xamplify_test.xa_campaign_user_userlist_d xa_campaign_user_userlist_d ON (xa_campaign_d1.campaign_id = xa_campaign_user_userlist_d.campaign_id)
                 left JOIN xamplify_test.xa_user_role_d xa_user_role_d ON (xa_user_d.user_id = xa_user_role_d.user_id)
                  --where  xa_user_role_d.role_id in(2,13)


                 ;;
  }

 # parameter: Total_Nurture_count {
  #  label: "Total Nurture Count"
   # allowed_value: {value:"Nurtures"}
  #}

  #measure: Nurture_count {
   # type: count_distinct
  #  sql:
   # case when {% parameter Total_Nurture_count %} = 'Nurtures'
  #  then ${action_id_a}
   # end ;;
  #}

#  measure: inactive_nurtures {
 #   label: "inactive_nurtures"
  #  sql: ${Nurture_count}-${Active_Nurture} ;;
  #}

  measure: count {
    type: count
    drill_fields: [detail*]
  }
  measure: Name {
    type: count_distinct
    sql: ${name};;
    drill_fields: [company_name_xa_company_d1,created_time_xa_user_d1_raw,datereg_xa_user_d1_raw,name,subject,sent_time_raw]
  }

  measure: Partner_Nurture {
    type: count_distinct
    sql: ${action_id_a};;
    drill_fields: [action_name_a]

  }

  measure: Active_Nurture {
    type: count_distinct
    sql: ${name};;
    drill_fields: [name,subject]

  }
    measure: InActive_Nurture {
      type: number
      sql: count( ${action_id_a}) over(PARTITION BY ${action_id_a}  order by ${action_id_a})-count(distinct ${name});;

    }


  measure: Total_Partners{
    type: count_distinct
    sql: ${user_id_xa_user_d1};;
    drill_fields: [company_name_xa_company_d1,email_id_xa_user_d1,created_time_xa_user_d1_date,datereg_xa_user_d1_date]

  }
  measure: Partners_with_nurture{
    type: count_distinct
    sql: ${user_id_xa_user_d1};;
    drill_fields: [company_name_xa_company_d1,email_id_xa_user_d1,firstname_xa_user_d1,lastname_xa_user_d1,created_time_xa_user_d1_date,datereg_xa_user_d1_date]

  }
  measure: Partners_without_nurture{
    type: count_distinct
    sql: ${user_id_xa_user_d1};;
    drill_fields:[company_name_xa_company_d1,email_id_xa_user_d1,firstname_xa_user_d1,lastname_xa_user_d1,created_time_xa_user_d1_date,datereg_xa_user_d1_date]

  }
  measure: Partners_count{
    type: count_distinct
    sql: ${user_id_xa_user_d1};;
    drill_fields:[company_name_xa_company_d1,email_id_xa_user_d1,name,subject,sent_time_date]

  }



  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: email_id {
    type: string
    sql: ${TABLE}.email_id ;;
  }


  dimension: company_id {
    type: number
    sql: ${TABLE}.company_id ;;
  }

  dimension: company_id_xa_company_d {
    type: number
    label: "company_id_c"
    sql: ${TABLE}.company_id_c ;;
  }

  dimension: company_name {
    type: string
    sql: ${TABLE}.company_name ;;
  }



  dimension: campaign_id_xa_campaign_d1 {
    type: number
    label: "campaign_id_cam1"
    sql: ${TABLE}.campaign_id_cam1 ;;
  }

  dimension: customer_id_xa_campaign_d1 {
    type: number
    label: "customer_id_cam1"
    sql: ${TABLE}.customer_id_cam1 ;;
  }

  dimension: campaign_name_xa_campaign_d1 {
    type: string
    label: "campaign_name_cam1"
    sql: ${TABLE}.campaign_name_cam1 ;;
  }


  dimension_group: created_time_xa_campaign_d1 {
    type: time
    label: "created_time_cam1"
    sql: ${TABLE}.created_time_cam1 ;;
  }

  dimension_group: launch_time_xa_campaign_d1 {
    type: time
    label: "launch_time_cam1"
    sql: ${TABLE}.launch_time_cam1 ;;
  }

  dimension: parent_campaign_id_xa_campaign_d1 {
    type: number
    label: "parent_campaign_id_cam1"
    sql: ${TABLE}.parent_campaign_id_cam1 ;;
  }

  dimension: campaign_id_xa_campaign_user_userlist_d {
    type: number
    label: "campaign_id_cul"
    sql: ${TABLE}.campaign_id_cul ;;
  }

  dimension: user_id_xa_campaign_user_userlist_d {
    type: number
    label: "user_id_cul"
    sql: ${TABLE}.user_id_cul ;;
  }

  dimension: email_id_xa_campaign_user_userlist_d {
    type: string
    label: "email_id_cul"
    sql: ${TABLE}.email_id_cul ;;
  }

  dimension: partner_company_name {
    type: string
    sql: ${TABLE}.partner_company_name ;;
  }

  dimension: partner_first_name {
    type: string
    sql: ${TABLE}.partner_first_name ;;
  }

  dimension: partner_last_name {
    type: string
    sql: ${TABLE}.partner_last_name ;;
  }

  dimension: contact_user_id {
    type: number
    sql: ${TABLE}.contact_user_id ;;
  }

  dimension: contact_first_name {
    type: string
    sql: ${TABLE}.contact_first_name ;;
  }

  dimension: contact_last_name {
    type: string
    sql: ${TABLE}.contact_last_name ;;
  }

  dimension: contact_company {
    type: string
    sql: ${TABLE}.contact_company ;;
  }


  dimension_group: sent_time {
    type: time
    sql: ${TABLE}.sent_time ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: subject {
    type: string
    sql: ${TABLE}.subject ;;
  }

  dimension: user_id_xa_user_d1 {
    type: number
    label: "user_id_p"
    sql: ${TABLE}.user_id_p ;;
  }

  dimension: email_id_xa_user_d1 {
    type: string
    label: "email_id_p)"
    sql: ${TABLE}.email_id_p ;;
  }

  dimension: firstname_xa_user_d1 {
    type: string
    label: "firstname_p"
    sql: ${TABLE}.firstname_p ;;
  }

  dimension: lastname_xa_user_d1 {
    type: string
    label: "lastname_p"
    sql: ${TABLE}.lastname_p ;;
  }

  dimension_group: datereg_xa_user_d1 {
    type: time
    label: "datereg_p"
    sql: ${TABLE}.datereg_p ;;
  }

  dimension_group: datelastlogin_xa_user_d1 {
    type: time
    label: "datelastlogin_p"
    sql: ${TABLE}.datelastlogin_p ;;
  }

  dimension_group: created_time_xa_user_d1 {
    type: time
    label: "created_time_p"
    sql: ${TABLE}.created_time_p ;;
  }

  dimension: company_id_xa_user_d1 {
    type: number
    label: "company_id_p"
    sql: ${TABLE}.company_id_p ;;
  }

  dimension: company_id_xa_company_d1 {
    type: number
    label: "company_id_c1"
    sql: ${TABLE}.company_id_c1 ;;
  }

  dimension: company_name_xa_company_d1 {
    type: string
    label: "company_name_c1"
    sql: ${TABLE}.company_name_c1 ;;
  }

  dimension: user_id_xa_user_role_d {
    type: number
    label: "user_id_role"
    sql: ${TABLE}.user_id (xa_user_role_d) ;;
  }

  dimension: role_id {
    type: number
    sql: ${TABLE}.role_id ;;
  }
  dimension: action_id_a {
    type: number
    label: "action_id_a"
    sql: ${TABLE}.action_id_a ;;
  }
  dimension: action_type_a {
    type: string
    label: "action_type_a"
    sql: ${TABLE}.action_type_a ;;
  }
  dimension: action_name_a {
    type: string
    label: "action_name_a"
    sql: ${TABLE}.action_name_a ;;
  }
  dimension: action_id_xa_drip_email_history_d {
    type: number
    label: "action_id_drip"
    sql: ${TABLE}.action_id_drip ;;
  }


  set: detail {
    fields: [
      user_id,
      email_id,
      company_id,
      company_id_xa_company_d,
      company_name,
      campaign_id_xa_campaign_d1,
      customer_id_xa_campaign_d1,
      campaign_name_xa_campaign_d1,
      created_time_xa_campaign_d1_time,
      launch_time_xa_campaign_d1_time,
      parent_campaign_id_xa_campaign_d1,
      campaign_id_xa_campaign_user_userlist_d,
      user_id_xa_campaign_user_userlist_d,
      email_id_xa_campaign_user_userlist_d,
      partner_company_name,
      partner_first_name,
      partner_last_name,
      contact_user_id,
      contact_first_name,
      contact_last_name,
      contact_company,
      sent_time_time,
      name,
      subject,
      user_id_xa_user_d1,
      email_id_xa_user_d1,
      firstname_xa_user_d1,
      lastname_xa_user_d1,
      datereg_xa_user_d1_time,
      datelastlogin_xa_user_d1_time,
      created_time_xa_user_d1_time,
      company_id_xa_user_d1,
      company_id_xa_company_d1,
      company_name_xa_company_d1,
      user_id_xa_user_role_d,
      role_id,
      action_id_xa_drip_email_history_d,
      action_id_a,
      action_name_a,
      action_type_a,


    ]
  }
}

explore:teammembers  {}

view: teammembers {
  derived_table: {
    sql: select
      "Vendor Campaign".campaign_id as "Vendor Campaign ID",
      "Vendor Campaign".campaign_name as "Vendor Campaign Name",
      "Vendor Company".company_id as "Vendor Company ID",
      "Vendor Company".company_name as "Vendor Company Name",
      "Vendor Campaign".is_launched "Vendor Cam Is Launched",
      "Vendor Campaign".launch_time "Vendor Cam Launch Time",
      "Vendor Campaign".campaign_type "Vendor Campaign Type",
      "Vendor Campaign".campaign_schedule_type "Vendor Cam Schedule Type",
      "Vendor Campaign".created_time "Vendor Cam Created Time",
    --  "Partner Company".company_id "Partner Company ID",
    --  "Partner Company".company_name "Partner Company Name",
    "Social connection".id as "Soc ID",
    "Social connection".profile_name as "socialconn name",
      "Social connection".source as "Social_Source",
    "Social connection".user_id as "Social user ID",
    "Videofiles".  id as "Video ID",
    "Videofiles".customer_id as "Video Customer ID",
    "Videofiles".title as "Video Title",
    "Videofiles".created_time as "Video Created Time",
    "Team Member".team_member_id as "Teammember ID",
    "Team Member".id as "Team ID",
    "Team Member".email_id as "Teammember email_id",
    "Team Member".firstname as "Teammember Firstname",
    "Team Member".lastname as "Teammember Lastname",
    "Team Member".status as "Teammember status",
    "Team Member".created_time as "Teammember Created Time",
    "Team Member".company_id as "Teammember company_id"
      from
      xamplify_test.xa_team_member_d "Team Member"
      left JOIN xamplify_test.xa_user_d "Vendor Users" ON ("Team Member".team_member_id = "Vendor Users".user_id)
      left JOIN xamplify_test.xa_company_d "Vendor Company" ON ("Team Member".company_id = "Vendor Company".company_id)
      left JOIN xamplify_test.xa_user_list_d "Userlist" ON ("Userlist".customer_id = "Team Member".team_member_id)
      left JOIN xamplify_test.xa_user_d "Partner Users" ON ("Userlist".listby_partner_id = "Partner Users".user_id)
      left JOIN xamplify_test.xa_company_d "Partner Company" ON ("Partner Users".company_id = "Partner Company".company_id)
     left  join xamplify_test.xa_campaign_d "Vendor Campaign" on ("Vendor Campaign".customer_id="Team Member".team_member_id)
    left join xamplify_test.xa_socialconn_d "Social connection" on("Social connection".user_id="Team Member".team_member_id)
    left join xamplify_test.xa_videofiles_d "Videofiles" on("Team Member".team_member_id="Videofiles".customer_id)
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

  dimension: soc_id {
    type: number
    label: "Soc ID"
    sql: ${TABLE}."Soc ID" ;;
  }

  dimension: socialconn_name {
    type: string
    label: "socialconn name"
    sql: ${TABLE}."socialconn name" ;;
  }

  dimension: social_source {
    type: string
    sql: ${TABLE}."Social_Source" ;;
  }

  dimension: social_user_id {
    type: number
    label: "Social user ID"
    sql: ${TABLE}."Social user ID" ;;
  }

  dimension: video_id {
    type: number
    label: "Video ID"
    sql: ${TABLE}."Video ID" ;;
  }

  dimension: video_customer_id {
    type: number
    label: "Video Customer ID"
    sql: ${TABLE}."Video Customer ID" ;;
  }

  dimension: video_title {
    type: string
    label: "Video Title"
    sql: ${TABLE}."Video Title" ;;
  }

  dimension_group: video_created_time {
    type: time
    label: "Video Created Time"
    sql: ${TABLE}."Video Created Time" ;;
  }

  dimension: teammember_id {
    type: number
    label: "Teammember ID"
    sql: ${TABLE}."Teammember ID" ;;
  }

  dimension: team_id {
    type: number
    label: "Team ID"
    sql: ${TABLE}."Team ID" ;;
  }

  dimension: teammember_email_id {
    type: string
    label: "Teammember email_id"
    sql: ${TABLE}."Teammember email_id" ;;
  }

  dimension: teammember_firstname {
    type: string
    label: "Teammember Firstname"
    sql: ${TABLE}."Teammember Firstname" ;;
  }

  dimension: teammember_lastname {
    type: string
    label: "Teammember Lastname"
    sql: ${TABLE}."Teammember Lastname" ;;
  }

  dimension: teammember_status {
    type: string
    label: "Teammember status"
    sql: ${TABLE}."Teammember status" ;;
  }

  dimension_group: teammember_created_time {
    type: time
    label: "Teammember Created Time"
    sql: ${TABLE}."Teammember Created Time" ;;
  }

  dimension: teammember_company_id {
    type: number
    label: "Teammember company_id"
    sql: ${TABLE}."Teammember company_id" ;;
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
      vendor_cam_schedule_type,
      vendor_cam_created_time_time,
      soc_id,
      socialconn_name,
      social_source,
      social_user_id,
      video_id,
      video_customer_id,
      video_title,
      video_created_time_time,
      teammember_id,
      team_id,
      teammember_email_id,
      teammember_firstname,
      teammember_lastname,
      teammember_status,
      teammember_created_time_time,
      teammember_company_id
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
