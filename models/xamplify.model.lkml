connection: "xamplify"

# include all the views
include: "/views/**/*.view"

#datagroup: xamplify_default_datagroup {
#  sql_trigger: SELECT MAX(id) FROM etl_log;;
#  max_cache_age: "24 hour"
#}

#persist_with: xamplify_default_datagroup





explore:campaign1   {
#  persist_for: "2 hour"
}
view: campaign1 {
  derived_table: {
    sql:with a as  (select distinct "Redistributed Cam".campaign_id as "Redistributed Campaign ID",
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
      INNER JOIN (select distinct c.company_id,c.company_name from xamplify_test.xa_company_d c, xamplify_test.xa_user_d  u,xamplify_test.xa_user_role_d r
                       where u.company_id=c.company_id
                       and u.user_id=r.user_id
                       and r.role_id in(2,13) and c.company_id not in(231,130,265,266,313,391,280,281,303,307,311,357,320,326,331,334,356,270,368,370,369,372,376,
                       380,382,398,215,273,410,413,415,374,389,322,332,333,335,367,349,358,359,362,371,378,379,381,385,386,388,393,395,401,414,384,421,424))"Vendor Company" ON ("Vendor Users".company_id = "Vendor Company".company_id)
      left JOIN xamplify_test.xa_campaign_d "Redistributed Cam" ON ("Vendor Campaign".campaign_id = "Redistributed Cam".parent_campaign_id)
      left JOIN xamplify_test.xa_user_d "Partner Users" ON ("Redistributed Cam".customer_id = "Partner Users".user_id)
      left JOIN xamplify_test.xa_company_d "Partner Company" ON ("Partner Users".company_id = "Partner Company".company_id)
     -- left JOIN xamplify_test.xa_userlist_d "Partners" ON ("Vendor Campaign".campaign_id = "Partner Received Campaigns".campaign_id)
      left join xamplify_test.xa_date_dim "Date" on (split_part("Redistributed Cam".launch_time::text , '-',1)||split_part("Redistributed Cam".launch_time::text , '-',2)||left(split_part("Redistributed Cam".launch_time::text , '-',3),2))::int
      = "Date".date_key
      left join xamplify_test.xa_campaign_deal_registration_d "Campaign Deal Reg" on "Redistributed Cam".campaign_id = "Campaign Deal Reg".campaign_id
      ),
      b as (select distinct "Redistributed Cam1".campaign_id as "Redistributed Campaign ID1",
      "Email View".action_id "Action ID",
      "Email View".id "View ID",
      "Email View".time "View Time",
      "Email View".user_id as "View User ID",
      --"Email View".action_id "Action ID",
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
      left JOIN  xamplify_test.xa_emaillog_d "Email View"
      ON (("Redistributed Cam1".campaign_id = "Email View".campaign_id)
      and "Email View".user_id = "Contact Received Campaigns".user_id)
      where "Redistributed Cam1".is_nurture_campaign = true
      ),
       c as (select distinct cuul.user_id as "Contact User ID1",
cuul.contact_company as "Contact Company",
cuul.email_id as "Contact Email ID",
cuul.contact_first_name as "Contact First Name",
cuul.contact_last_name as "Contact Last Name",
cuul.contact_mobile_number as "Contact Mobile Number",
cuul.contact_country as "Contact Country",
cuul.contact_state as "Contact State",
cuul.contact_city as "Contact City",
cuul.contact_zip as "Contact Zip Code",
(case when sg.user_id=cuul.user_id then sg.bounce else false end) as "Bounce",
sg.reason as "Bounce_Reason",
(case when sg.user_id=cuul.user_id then sg.block else false end) as "Block",
(case when sg.user_id=cuul.user_id then sg.spam else false end) as "Spam" ,
ud.is_email_valid as "Is_Email_Valid",
ud.email_category as "Email not Valid Reason",

       ROW_NUMBER () OVER (PARTITION BY cuul.user_id order by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16 desc nulls last) as row_number1
from xamplify_test.xa_campaign_user_userlist_d cuul left join xamplify_test.xa_user_d ud
    on(cuul.user_id=ud.user_id)
  left join (select distinct sg.*,b.reason from xamplify_test.xa_sendgrid_d sg left join
      xamplify_test.xa_bounce_d b on(b.email=sg.email)) sg on(sg.user_id=cuul.user_id)
   )

      select * from a left join b on a."Redistributed Campaign ID" = b."Redistributed Campaign ID1"
      inner join c on b."Contact User ID" = c."Contact User ID1"
     -- where a."Vendor Company ID" in (202,262,268,269,283,291,305,325,328,343,399,422,464)
      and c.row_number1 = 1
 ;;
  }

dimension: category {
  type:  string
  sql: ${TABLE}.'Email_opend' ;;

}


dimension: Vendor_schedule_type {
  type: string
  label: "Vendor Campaign Schedule Type"
  sql: case when ${vendor_cam_schedule_type}='NOW' then 'LAUNCHED'
            when ${vendor_cam_schedule_type}='SAVE' then 'SAVE'
            when ${vendor_cam_schedule_type}='SCHEDULE' then 'SCHEDULE'
            end;;
}

  dimension: Partner_schedule_type {
    type: string
    label: "Redistributed Campaign Schedule Type"
    sql: case when ${redistributed_cam_schedule_type} ='NOW' then 'LAUNCHED'
            when ${redistributed_cam_schedule_type}='SAVE' then 'SAVE'
            when ${redistributed_cam_schedule_type}='SCHEDULE' then 'SCHEDULE'
            end;;
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

      drill_fields: [vendor_campaign_id,vendor_campaign_type,vendor_campaign_name,
        Vendor_schedule_type, parent_campaign_id]
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

      drill_fields: [redistributed_campaign_id,redistributed_campaign_name,redistributed_campaign_type,
        Partner_schedule_type ,redistributed_cam_launch_time]

      link: {
        label: "Redistributed Details"
        url: "https://stratappspartner.looker.com/looks/37?
        &f[campaign1.vendor_company_name]={{ _filters['campaign1.vendor_company_name'] | url_encode }}
        &f[campaign1.partner_company_name]={{ _filters['campaign1.partner_company_name'] | url_encode }}
        &f[campaign1.redistributed_campaign_name]={{ _filters['campaign1.redistributed_campaign_name'] | url_encode }}
        &f[campaign1.redistributed_cam_launch_date]={{ _filters['campaign1.redistributed_cam_launch_date'] | url_encode }}"
        icon_url: "http://www.looker.com/favicon.ico"
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




 measure: Delivered {
  type: count_distinct
  sql: case when ${Bounce}=false and ${Block}=false and ${Spam}=false and ${Is_Email_Valid}=true
       then ${contact_user_id} end;;
}

  measure: Delivered_KPI{
    type: count_distinct
    sql: case when ${Bounce}=false and ${Block}=false and ${Spam}=false and ${Is_Email_Valid}=true
      then ${contact_user_id} end;;
    drill_fields: [
      email_id,contact_company,contact_mobile_number,contact_country,contact_state,contact_city
    ]
    }

  measure: Not_Delivered{
    type: count_distinct
    sql: case when ${Bounce}=true or ${Block}=true or ${Spam}=true
      then ${contact_user_id} end;;
    drill_fields: [
      email_id,contact_company,contact_mobile_number,contact_country,contact_state,contact_city
    ]

    link: {
      label: "Bounce "
      url: "https://stratappspartner.looker.com/looks/172?
      &f[campaign1.vendor_company_name]={{ _filters['campaign1.vendor_company_name'] | url_encode }}
      &f[campaign1.partner_company_name]={{ _filters['campaign1.partner_company_name'] | url_encode }}
      &f[campaign1.redistributed_campaign_name]={{ _filters['campaign1.redistributed_campaign_name'] | url_encode }}
      &f[campaign1.redistributed_cam_launch_date]={{ _filters['campaign1.redistributed_cam_launch_date'] | url_encode }}"
      icon_url: "http://www.looker.com/favicon.ico"
    }
    link: {
      label: "Block "
      url: "https://stratappspartner.looker.com/looks/173?
      &f[campaign1.vendor_company_name]={{ _filters['campaign1.vendor_company_name'] | url_encode }}
      &f[campaign1.partner_company_name]={{ _filters['campaign1.partner_company_name'] | url_encode }}
      &f[campaign1.redistributed_campaign_name]={{ _filters['campaign1.redistributed_campaign_name'] | url_encode }}
      &f[campaign1.redistributed_cam_launch_date]={{ _filters['campaign1.redistributed_cam_launch_date'] | url_encode }}"
      icon_url: "http://www.looker.com/favicon.ico"
    }
    link: {
      label: "Spam "
      url: "https://stratappspartner.looker.com/looks/174?
      &f[campaign1.vendor_company_name]={{ _filters['campaign1.vendor_company_name'] | url_encode }}
      &f[campaign1.partner_company_name]={{ _filters['campaign1.partner_company_name'] | url_encode }}
      &f[campaign1.redistributed_campaign_name]={{ _filters['campaign1.redistributed_campaign_name'] | url_encode }}
      &f[campaign1.redistributed_cam_launch_date]={{ _filters['campaign1.redistributed_cam_launch_date'] | url_encode }}"
      icon_url: "http://www.looker.com/favicon.ico"
    }
   }

  measure:  Email_not_valid{
    type: count_distinct
    sql: case when ${Is_Email_Valid}=false then ${contact_user_id} end  ;;
    drill_fields: [
      email_id,contact_company,contact_mobile_number,contact_country,contact_state,contact_city,Email_not_Valid_Reason
    ]
  }


  measure: Bounce1 {
    type: count_distinct
    sql: case when ${Bounce}=true then ${contact_user_id} end  ;;
  }


  measure: block1 {
    type: count_distinct
    sql: case when ${Block}=true  then ${contact_user_id} end  ;;
  }

  measure: spam1 {
    type: count_distinct
    sql: case when ${Spam}=true  then ${contact_user_id} end  ;;
  }





    measure: Email_Opened{
      type: count_distinct
      sql:
      ${view_user_id}

      ;;
      drill_fields: [
        email_id,contact_company,contact_mobile_number,contact_country,contact_state,contact_city
      ]



    }

  measure: Email_Opened_Quarter{
    type: count_distinct
    sql:
      ${view_user_id} ;;
   # filters: [redistributed_cam_launch_quarter: ""]
   # drill_fields: [
     # email_id,contact_company,contact_mobile_number,contact_country,contact_state,contact_city ]

  }



    #dimension: Boolean_filter{
    # type: yesno
    #sql: (${campaign1.contact_user_id})=
    #(${campaign1.view_user_id});;
    #}

    measure: Email_Not_Opened{
      type: number
      sql: ${Delivered}-${Email_Opened};;
      link: {
        label: "Email Not Opened Details"
        url: "https://stratappspartner.looker.com/looks/33?
        &f[campaign1.vendor_company_name]={{ _filters['campaign1.vendor_company_name'] | url_encode }}
        &f[campaign1.partner_company_name]={{ _filters['campaign1.partner_company_name'] | url_encode }}
        &f[campaign1.redistributed_campaign_name]={{ _filters['campaign1.redistributed_campaign_name'] | url_encode }}
        &f[campaign1.redistributed_cam_launch_date]={{ _filters['campaign1.redistributed_cam_launch_date'] | url_encode }}"
        icon_url: "http://www.looker.com/favicon.ico"
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
      sql:Round(100.00* ${Email_Opened}/NULLIF(${Delivered},0)) ;;
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
      sql: round(100.00* ${Email_Not_Opened}/NULLIF(${Delivered},0)) ;;
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
      drill_fields: [partner_company_name,redistributed_campaign_name,
        redistributed_campaign_type,Partner_schedule_type,redistributed_cam_launch_time]
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
      drill_fields: [email_id,view_time_minute,view_id, email_id,contact_company,contact_mobile_number,contact_country,contact_state,contact_city]
    }

  measure: Views1 {
   type: number
    sql: count(${view_user_id});;
    drill_fields: [ email_id, view_time_minute, contact_company,contact_mobile_number,contact_country,contact_state,contact_city]
  }
  measure: Views2{
    type: number
    sql: count(${view_user_id}) ;;
    #drill_fields: [email_id,view_time_minute,view_id, email_id,contact_company,contact_mobile_number,contact_country,contact_state,contact_city]
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

    measure: View {
      type: count_distinct
      sql: ${view_id} ;;
    }
    dimension: Is_Email_Valid {
      type:string
      sql:${TABLE}."Is_Email_Valid"  ;;

    }
    dimension: Bounce {
      type: string
      sql:  ${TABLE}."Bounce" ;;
    }
  dimension: Bounce_Reason {
    type: string
    sql:  ${TABLE}."Bounce_Reason" ;;
  }
  dimension: Block {
    type: string
    sql:  ${TABLE}."Block" ;;
  }
  dimension:Spam {
    type: string
    sql:  ${TABLE}."Spam" ;;
  }

  dimension:Email_not_Valid_Reason {
    type: string
    label: "Reason"
    sql:  ${TABLE}."Email not Valid Reason" ;;
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

    dimension_group: vendor_cam_launch {
      type: time
      label: "Vendor Cam Launch"
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

    dimension_group: redistributed_cam_launch {
      type: time
      label: "Redistributed Campaign Launch"
      sql: ${TABLE}."Redistributed Cam Launch Time" ;;
      drill_fields: [redistributed_cam_launch_month,redistributed_cam_launch_week]
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
      label: "View"
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
    label: "Country"
    sql: ${TABLE}."View Country" ;;
  }

  dimension: state {

    map_layer_name: us_states
    label: "State"
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
        vendor_cam_launch_time,
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
        redistributed_cam_launch_time,
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
        user_location,
        Bounce,
        Bounce_Reason,
        Block,
        Spam,
        Is_Email_Valid,
        Email_not_Valid_Reason
      ]
    }
  }











explore: vendors {
  # persist_for: "30 minutes"

}
view:vendors {
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
                --"Partner Received Campaigns".campaign_id as "Partner Received Campaign",
               --"Partner Received Campaigns".user_id "Partner User ID",
                --"Partner Received Campaigns".email_id as "Partner Email ID",
               -- "Partner Received Campaigns".user_list_id "Partner User List ID",
                --"Partner Received Campaigns".partner_first_name "Partner First Name",
               -- "Partner Received Campaigns".partner_last_name "Partner Last Name",
                --"Partner Received Campaigns".partner_company_name "Partner Company Name1",
                "Partner Users".datereg as "Partner Datereg",
                 "Partner Users".user_id as "Partner Users ID",
                  "Partner Users".email_id as "Partners email_id",
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
               -- rcam.campaign_id as "R Campaign_id"
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
               -- left JOIN (select distinct campaign_id ,user_id,partner_company_name,email_id from xamplify_test.xa_campaign_user_userlist_d) "Partner Received Campaigns" ON ("Vendor Campaign".campaign_id = "Partner Received Campaigns".campaign_id)
                left join xamplify_test.xa_campaign_deal_registration_d "Campaign Deal Reg" on "Redistributed Cam".campaign_id = "Campaign Deal Reg".campaign_id
                left join xamplify_test.xa_date_dim "Date" on (split_part("Vendor Campaign".launch_time::text , '-',1)||split_part("Vendor Campaign".launch_time::text , '-',2)||left(split_part("Vendor Campaign".launch_time::text , '-',3),2))::int
                = "Date".date_key
                --where "Vendor Company".company_id in  (202,262,268,269,283,291,305,325,328,343,399,422,464)
                 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: Vendor_schedule_type {
    type: string
    label: "Vendor Campaign Schedule Type"
    sql: case when ${vendor_campaign_schedule_type}='NOW' then 'LAUNCHED'
            when ${vendor_campaign_schedule_type}='SAVE' then 'SAVE'
            when ${vendor_campaign_schedule_type}='SCHEDULE' then 'SCHEDULE'
            end;;
  }

  dimension: Partner_schedule_type {
    type: string
    label: "Redistributed Campaign Schedule Type"
    sql: case when ${redistributed_cam_schedule_type} ='NOW' then 'LAUNCHED'
            when ${redistributed_cam_schedule_type}='SAVE' then 'SAVE'
            when ${redistributed_cam_schedule_type}='SCHEDULE' then 'SCHEDULE'
            end;;
  }

  measure: Partners_Recieved_Campaigns{
    type: count_distinct
    sql: ${parent_campaign_id} ;;
    drill_fields: [vendor_campaign_name,vendor_campaign_type,Vendor_schedule_type,
      vendor_cam_launch_time,Redistributed_Campaigns]
  }


  measure: Deals_KPI{
    type:count_distinct
    sql: (case when ${is_deal} then ${id} END);;
   drill_fields: [ deal_partner_company,deal_first_name,deal_last_name,deal_email_id, deal_phone_number,deal_company,deal_created_time]
   }


  measure: Deals  {
    type:count_distinct
    sql: (case when ${is_deal} then ${id} END);;
   # drill_fields: [ deal_partner_company,deal_first_name,deal_last_name,deal_email_id, deal_phone_number,deal_company,deal_created_time]

  }
  measure: Leads  {
    type:count_distinct
    sql: ${id};;
    drill_fields: [lead_partner_company,lead_first_name,lead_last_name,lead_email_id,
      lead_phone_number,lead_company,lead_created_time]


  }

  measure: Redistributed_Campaigns  {
    type:count_distinct
    sql: ${redistributed_campaign_id};;
    drill_fields: [redistributed_campaign_name,redistributed_campaign_type,
      Partner_schedule_type,redistributed_cam_launched_time]

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

  dimension_group: vendor_cam_launch {
    type: time
    label: "Vendor Campaign Launch"
    sql: ${TABLE}."Vendor Cam Launch Time" ;;
  }

  dimension_group: vendor_cam_created {
    type: time
    label: "Vendor Campaign Created"
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
    label: "Redistributed Campaign Schedule Type"
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

  dimension_group: redistributed_cam_launched{
    type: time
    label: "Redistributed Cam Launch"
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

  # dimension: partner_user_list_id {
  #  type: number
  # label: "Partner User List ID"
  #sql: ${TABLE}."Partner User List ID" ;;
  #}

  #dimension: partner_first_name {
  # type: string
  #label: "Partner First Name"
  #sql: ${TABLE}."Partner First Name" ;;
  #}

  #dimension: partner_last_name {
  # type: string
  #label: "Partner Last Name"
  #sql: ${TABLE}."Partner Last Name" ;;
  #}

  dimension: partner_company_name1 {
    type: string
    label: "Partner Company Name"
    sql: ${TABLE}."Partner Company Name1" ;;
  }

  dimension_group: Partner_Datereg {
    type: time
    label: "Partner Datereg"
    sql: ${TABLE}."Partner Datereg" ;;
  }

  dimension: Partners_users {
    type: number
    label: "User ID"
    sql: ${TABLE}."Partner Users ID" ;;
  }

  dimension: Partners_email_id {
    type: string
    label: "Partner Email id"
    sql: ${TABLE}."Partners email_id" ;;
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

  dimension_group: deal_created {
    type: time
    label: "Deal Created"
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

  dimension_group: lead_created {
    type: time
    label: "Lead Created"
    sql: ${TABLE}."Deal Created Time" ;;
  }

  dimension: lead_first_name {
    type: string
    label: "Lead First Name"
    sql: ${TABLE}."Deal First Name" ;;
  }

  dimension: lead_last_name {
    type: string
    label: "Lead Last Name"
    sql: ${TABLE}."Deal Last Name" ;;
  }

  dimension: lead_email_id {
    type: string
    label: "Lead Email ID"
    sql: ${TABLE}."Deal Email ID" ;;
  }

  dimension: lead_phone_number {
    type: string
    label: "Lead Phone Number"
    sql: ${TABLE}."Deal Phone Number" ;;
  }



  dimension: lead_partner_company {
    type: string
    label: "Lead Partner Company"
    sql: ${TABLE}."Deal Partner Company" ;;
  }

  dimension: lead_company {
    type: string
    label: "Lead Company"
    sql: ${TABLE}."Deal Company" ;;
  }

  set: detail {
    fields: [

      vendor_campaign_id,
      vendor_campaign_name,
      vendor_company_id,
      vendor_company_name,
      vendor_cam_is_launched,
      vendor_cam_launch_time,
      vendor_cam_created_time,
      vendor_campaign_type,
      vendor_campaign_schedule_type,
      partner_company_id,
      partner_user_id ,
      partner_company_name,
      redistributed_campaign_id,
      redistributed_campaign_name,
      redistributed_campaign_type,
      redistributed_cam_schedule_type,
      redistributed_cam_created_time_time,
      parent_campaign_id,
      redistributed_cam_is_launched,
      redistributed_cam_launched_time,
      partner_received_campaign,

      partner_company_name1,
      partner_email_id,
      Partner_Datereg_time,
      Partners_users,
      date,
      year_qtr,
      month,
      month_name,
      week,
      id,
      is_deal,
      deal_created_time,
      deal_first_name,
      deal_last_name,
      deal_email_id,
      deal_phone_number,
      opportunity_amt,
      deal_partner_company,
      deal_company,
      lead_company,
      lead_partner_company,
      lead_phone_number,
      lead_email_id,
      lead_last_name,
      lead_first_name,
      lead_created_time,

    ]
  }
}



explore: vendor_received_campaigns  {}
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

  dimension: Vendor_schedule_type {
    type: string
    label: "Vendor Campaign Schedule Type"
    sql: case when ${vendor_campaign_schedule_type}='NOW' then 'LAUNCHED'
            when ${vendor_campaign_schedule_type}='SAVE' then 'SAVE'
            when ${vendor_campaign_schedule_type}='SCHEDULE' then 'SCHEDULE'
            end;;
  }

  dimension: Partner_schedule_type {
    type: string
    label: "Redistributed Campaign Schedule Type"
    sql: case when ${redistributed_cam_schedule_type} ='NOW' then 'LAUNCHED'
            when ${redistributed_cam_schedule_type}='SAVE' then 'SAVE'
            when ${redistributed_cam_schedule_type}='SCHEDULE' then 'SCHEDULE'
            end;;
  }


  measure: Partners{
    type: count_distinct
    label: "Received Partners"
    sql: ${partner_user_id};;
    drill_fields: [partner_company_name1,partner_email_id]
  }


  measure: Vendor_Cam_Lauched{
    type: count_distinct
    sql: (case when ${vendor_cam_is_launched} then ${vendor_campaign_id} END);;
    drill_fields: [vendor_campaign_name,vendor_campaign_type, Vendor_schedule_type,
      vendor_cam_launch_time_time,Partners,Redistributed_Partners]

  }

  measure: Total_Campaigns {
    type: count_distinct
    label: "Total Campaigns"
    sql: ${vendor_campaign_id} ;;
    drill_fields: [vendor_campaign_name,vendor_campaign_type,Vendor_schedule_type,
      vendor_cam_created_time_time,Partners,Redistributed_Partners]
  }

  measure:campaigns_received_Partner{
    type: count_distinct
    sql: ${partner_received_campaign} ;;
    drill_fields: [vendor_campaign_name,vendor_campaign_type,Vendor_schedule_type,
     vendor_cam_launch_time_time,Partners,Redistributed_Partners]
  }

  measure:Not_Redistributed  {
    type:number
    sql: ${campaigns_received_Partner}- ${campaigns_Redistribued_by_Partners} ;;
    drill_fields: [vendor_campaign_name,vendor_campaign_type,Vendor_schedule_type,
      vendor_cam_launch_time_time,Partners,Redistributed_Partners]

  }

  measure: Redistributed_Campaigns  {
    type:count_distinct
    sql: ${redistributed_campaign_id};;
    drill_fields: [redistributed_campaign_name,redistributed_campaign_type,
      Partner_schedule_type,redistributed_cam_launch_time_time]

  }
  measure: Redistributed_Partners {
    type: count_distinct
    sql: ${partner_users_id} ;;
    drill_fields: [partners_email_id,partner_company_name,Redistributed_Campaigns]
  }

  measure: campaigns_Redistribued_by_Partners{
    type: count_distinct
    sql: ${parent_campaign_id} ;;
    drill_fields: [vendor_campaign_name,vendor_campaign_type,Vendor_schedule_type,
      vendor_cam_launch_time_time,Partners,Redistributed_Partners]
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
    label: "Vendor Campaign Launch"
    sql: ${TABLE}."Vendor Cam Launch Time" ;;
  }

  dimension_group: vendor_cam_created_time {
    type: time
    label: "Vendor Campaign Created"
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
    label: "Partner Company Name"
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
                INNER JOIN (select distinct c.company_id,c.company_name from xamplify_test.xa_company_d c, xamplify_test.xa_user_d  u,xamplify_test.xa_user_role_d r
                       where u.company_id=c.company_id
                       and u.user_id=r.user_id
                       and r.role_id in(2,13) and c.company_id not in(231,130,265,266,313,391,280,281,303,307,311,357,320,326,331,334,356,270,368,370,369,372,376,
                       380,382,398,215,273,410,413,415,374,389,322,332,333,335,367,349,358,359,362,371,378,379,381,385,386,388,393,395,401,414,384,421,424))"Vendor Company" ON ("Vendor Users".company_id = "Vendor Company".company_id)
                left JOIN xamplify_test.xa_campaign_d "Redistributed Cam" ON ("Vendor Campaign".campaign_id = "Redistributed Cam".parent_campaign_id)
                left join xamplify_test.xa_campaign_deal_registration_d "Campaign Deal Reg" on "Redistributed Cam".campaign_id = "Campaign Deal Reg".campaign_id
                left join xamplify_test.xa_campaign_deal_status_d "Campaign Deal Status" on "Campaign Deal Status".deal_id = "Campaign Deal Reg".id
                left join xamplify_test.xa_date_dim "Date" on (split_part("Campaign Deal Reg".created_time::text , '-',1)||split_part("Campaign Deal Reg".created_time::text , '-',2)||left(split_part("Campaign Deal Reg".created_time::text , '-',3),2))::int
                = "Date".date_key
                left join xamplify_test.xa_user_role_d "User_Role" on "Vendor Users".user_id="User_Role".user_id
                where "User_Role".role_id in(2,13)
                 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }




  measure: Deal  {

    type:count_distinct
    sql: (case when ${is_deal}='true' then ${id} END);;
    drill_fields:[partner_company_name,deal_first_name,deal_last_name,deal_email_id,
      deal_phone_number
    ]
  }


measure: Deals {
  type:count_distinct
  sql: (case when ${is_deal}='true' then ${id} END);;


}


measure: Leads  {
  type:count_distinct
  sql: ${id};;
  #html: <font size="30"><b>{{ value }}<\b></font>
  drill_fields: [partner_company_name,
    Lead_firstname,Lead_lastname,Lead_emailid,Lead_company,Lead_phonenumber,deal_created_time_time
  ]
}
  dimension: company_name {
    type: string
    label: "Company Name"
    sql: case when ${is_deal}='true' then ${partner_company_name};;
  }

  dimension: Deal_company {
    type: string
    label: "Deals Company"
    sql:  case when ${is_deal}='true' then ${deal_company} ;;
  }
  dimension: Lead_company {
    type: string
    label: "Lead Company"
    sql: ${TABLE}."Deal Company";;
  }


  dimension: campaign_name {
    type: string
    label: "Campaign Name"
    sql: case when ${is_deal}='true' then ${redistributed_campaign_name} ;;
  }

  dimension: Deal_first_name {
    type: string
    label: "Deals First Name"
    sql:case when ${is_deal}='true' then  ${deal_first_name};;
  }

  dimension: Deal_last_name {
    type: string
    label: "Deals Last Name"
    sql: case when ${is_deal}='true' then ${deal_last_name};;
  }

  dimension: Deal_email_id {
    type: string
    label: "Deals Email ID"
    sql:case when ${is_deal}='true' then ${deal_email_id} ;;
  }

  dimension: Deal_phone_number {
    type: string
    label: "Deals Phone Number"
    sql:case when ${is_deal}='true' then  ${deal_phone_number} ;;
  }






  measure: Prev_Qtr_DealPercentage {
    type: number
    sql:100* ${Previous_Quarter_Deals}/coalesce(NULLIF(${Previous_Quarter_Leads},0),1) ;;
    value_format: "0\%"
  }

  measure: Current_Qtr_DealPercentage {
    type: number
    sql: 100* ${Current_Quarter_Deals}/coalesce(NULLIF(${Current_Quarter_Leads},0),1);;
    value_format: "0\%"

  }

  measure: Lead_QTD_Growth_Percentage {
    type: number
    sql:100*coalesce((${Current_Quarter_Leads}-${Previous_Quarter_Leads}),0)/coalesce(NULLIF(${Previous_Quarter_Leads},0),1);;
    value_format: "0\%"
  }

  measure: Deal_QTD_Growth_Percentage {
    type: number
    sql: 100*coalesce((${Current_Quarter_Deals}-${Previous_Quarter_Deals}),0)/coalesce(NULLIF(${Previous_Quarter_Deals},0),1);;
    value_format: "0\%"
  }

  measure: Percentage_QOQ_Deals{
    type: number
    sql:100*coalesce(${Current_Qtr_DealPercentage},0)/coalesce(NULLIF(${Prev_Qtr_DealPercentage},0),1);;
    value_format: "0\%"
  }

  measure: Prev_Month_Leads {
    type: count_distinct
    sql:case when extract(month from ${deal_created_time_raw})= extract(month from now())-1
      and extract(year from ${deal_created_time_raw})=extract(year from now())  then ${id} end;;
  }


  measure: Cur_Month_Leads {
    type: count_distinct
    sql:case when extract(month from ${deal_created_time_raw})= extract(month from now())
      and extract(year from ${deal_created_time_raw})=extract(year from now()) then ${id} end;;



  }



  measure: Prev_Month_Deals{
    type: count_distinct
    sql:case when extract(month from ${deal_created_time_raw})= extract(month from now())-1
              and extract(year from ${deal_created_time_raw})=extract(year from now()) and ${is_deal}='true'
    then ${id} end;;
    drill_fields:[partner_company_name,Deal_email_id,
      Deal_first_name,Deal_last_name
    ]
  }



  measure: Cur_Month_Deals{
    type: count_distinct
    sql:case when extract(month from ${deal_created_time_raw})= extract(month from now())
                      and extract(year from ${deal_created_time_raw} )=extract(year from now())  and ${is_deal}='true'
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

  measure: Cur_Month_Leads_Percentage{
    type: number
    sql:coalesce(round((${leads_deals.Cur_Month_Leads}-${leads_deals.Prev_Month_Leads})
    /NULLIF(${leads_deals.Prev_Month_Leads},0)::numeric,2),1)*100 ;;
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


  measure: Cur_Year_Leads {
    type: count_distinct
    sql:case when extract(year from ${deal_created_time_raw})= extract(year from now())
      then ${id} end;;


  }

  measure: Prev_Year_Leads {
    type: count_distinct
    sql:case when extract(year from ${deal_created_time_raw})= extract(year from now())-1
      then ${id} end;;

  }


  measure: Previous_year_percentage_change_Leads {
    type: number
    sql:coalesce(round((${leads_deals.Cur_Year_Leads}-${leads_deals.Prev_Year_Leads})
      /NULLIF(${leads_deals.Prev_Year_Leads},0)::numeric,2),1)*100  ;;
  }

  measure: Previous_year_percentage_change_Deals {
    type: number
    sql:coalesce(round((${Cur_Year_Deals}-${Prev_Year_Deals})
      /NULLIF(${Prev_Year_Deals},0)::numeric,2),1)*100  ;;
  }




    measure: Current_Quarter_Leads {
      type: count_distinct
      sql: CASE
          WHEN extract(quarter from ${deal_created_time_raw} ):: character varying= extract(quarter from now()):: character varying
            AND
              extract(year from ${deal_created_time_raw}):: character varying = extract(year from now()):: character varying


            THEN ${id} end
;;
    }


    measure: Previous_Quarter_Leads {
      type: count_distinct
      sql:  CASE
          WHEN extract(quarter from ${deal_created_time_raw} )= extract(quarter from now())-1            AND
              extract(year from ${deal_created_time_raw})= extract(year from now())


            THEN ${id} end
                ;;
    }

  measure: Current_Quarter_Deals{
    type: count_distinct
    sql: CASE
          WHEN extract(quarter from ${deal_created_time_raw} ):: character varying= extract(quarter from now()):: character varying
            AND
              extract(year from ${deal_created_time_raw}):: character varying = extract(year from now()):: character varying
            AND ${is_deal}='true'


            THEN ${id} end
;;
  }


  measure: Previous_Quarter_Deals {
    type: count_distinct
    sql:  CASE
          WHEN extract(quarter from ${deal_created_time_raw} )= extract(quarter from now())-1            AND
              extract(year from ${deal_created_time_raw})= extract(year from now())
     AND ${is_deal}='true'

            THEN ${id} end
                ;;
  }

  measure: Current_Qtr_Lead_percentage {
  type: number
  sql: coalesce(round((${leads_deals.Current_Quarter_Leads}-(${leads_deals.Previous_Quarter_Leads})
  /NULLIF(${leads_deals.Previous_Quarter_Leads},0)::numeric,2),1)/100 ;;
}

  measure: Current_Qtr_Deal_percentage {
  type: number
  sql: coalesce(round(((${leads_deals.Current_Quarter_Deals}-${leads_deals.Previous_Quarter_Deals})
  /NULLIF(${leads_deals.Previous_Quarter_Deals},0)::numeric,2),1)/100 ;;
}



 measure: Prev_Year_Deals{
    type: count_distinct
    sql:case when extract(year from ${deal_created_time_raw})= extract(year from now())-1
              and extract(year from ${deal_created_time_date})=extract(year from now()) and ${is_deal}='true'
    then ${id} end;;



  }
  measure: Cur_Year_Deals{
    type: count_distinct
    sql:case when extract(year from ${deal_created_time_raw})= extract(year from now())
                      and extract(year from ${deal_created_time_date} )=extract(year from now())
                      and ${is_deal}='true'
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
    label: "Campaign Name"
    sql: ${TABLE}."Redistributed Campaign Name" ;;
  }

  dimension: redistributed_campaign_type {
    type: string
    label: "Campaign Type"
    sql: ${TABLE}."Redistributed Campaign Type" ;;

  }

  dimension: redistributed_cam_schedule_type {
    type: string
    label: "Redistributed Cam Schedule Type"
    sql: ${TABLE}."Redistributed Cam Schedule Type" ;;
  }

  dimension_group: redistributed_cam_created_time {
    type: time
    label: "Created Time"
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
    label: "Lead Created"
    sql: ${TABLE}."Deal Created Time" ;;
   # drill_fields: [deal_created_time_month,deal_created_time_week]
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


  dimension: Lead_firstname {
    type: string
    label: "Lead First_Name"
    sql: ${TABLE}."Deal First Name" ;;
  }

  dimension: Lead_lastname {
    type: string
    label: "Lead Last_Name"
    sql: ${TABLE}."Deal Last Name" ;;
  }

  dimension: Lead_emailid {
    type: string
    label: "Lead Email_ID"
    sql: ${TABLE}."Deal Email ID" ;;
  }

  dimension: Lead_phonenumber {
    type: string
    label: "Lead Phone_Number"
    sql: ${TABLE}."Deal Phone Number" ;;
  }

  set: detail {
    fields: [
      company_name,
      Deal_company,
      campaign_name,
      Deal_first_name,
      Deal_last_name,
      Deal_email_id,
      Deal_phone_number,
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
      deal_company,
      Lead_firstname,
      Lead_lastname,
      Lead_phonenumber,
      Lead_emailid

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
                xa_user_d.status as status,

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
                  a.action_name as Nurture_Name,

          (select cast(count(distinct user_id) as character varying) totalvendors1 from xamplify_test.xa_user_d
           where user_id in (select distinct user_id from xamplify_test.xa_user_role_d where role_id in (2,13))
           and user_id not in (select user_id from xamplify_test.xa_user_d  where company_id in
           ('231', '130', '265', '266', '313', '391', '280', '281', '303', '307', '311', '357', '320', '331', '334', '356',
          '270', '368', '370', '369', '372', '376', '380', '382', '398', '215', '273', '410', '413', '415', '374', '389', '322',
          '332', '333', '335', '367', '349', '358', '359', '362', '371', '378',
           '379', '381', '385', '386', '388', '393', '395', '401', '414', '384', '421', '424', '326'))),

           (select cast(count(distinct user_id)as character varying) totalvendors2 from xamplify_test.xa_user_d
           where user_id in (select distinct user_id from xamplify_test.xa_user_role_d where role_id in (2,13))
           and user_id not in (select user_id from xamplify_test.xa_user_d  where company_id in
           ('231', '130', '265', '266', '313', '391', '280', '281', '303', '307', '311', '357', '320', '331',
          '334', '356', '270', '368', '370', '369', '372', '376', '380', '382', '398', '215', '273', '410', '413',
          '415', '374', '389', '322', '332', '333', '335', '367', '349', '358', '359', '362', '371', '378',
           '379', '381', '385', '386', '388', '393', '395', '401', '414', '384', '421', '424', '326'))
           and company_id is not null)

                FROM xamplify_test.xa_user_d xa_user_d
                  LEFT JOIN xamplify_test.xa_campaign_d as xa_campaign_d ON (xa_user_d.user_id =xa_campaign_d.customer_id)
                  LEFT JOIN (select * from xamplify_test.xa_company_d where xa_company_d.company_id not in(231,130,265,266,313,391,280,281,303,307,311,357,320,326,331,334,356,270,368,370,369,372,376,
                  380,382,398,215,273,410,413,415,374,389,322,332,333,335,367,349,358,359,362,371,378,379,381,385,386,388,393,395,401,414,384,421,424)) xa_company_d ON (xa_user_d.company_id = xa_company_d.company_id)
                  --LEFT JOIN xamplify_test.xa_campaign_d xa_campaign_d1 ON (xa_campaign_d.campaign_id = xa_campaign_d1.parent_campaign_id)

                  left JOIN (select * from xamplify_test.xa_drip_email_history_d where xa_drip_email_history_d.action_id>=22 and xa_drip_email_history_d.action_id<=36) xa_drip_email_history_d ON (xa_user_d.user_id = xa_drip_email_history_d.user_id)
                  full join (select * from xamplify_test.xa_action_type_d
              where xa_action_type_d.action_id in (22,25,26,27,28,29,30,31,32,33,34,35,36)) a on (xa_drip_email_history_d.action_id=a.action_id)
                  left JOIN xamplify_test.xa_emailtemplates_d xa_emailtemplates_d ON (xa_drip_email_history_d.email_template_id = xa_emailtemplates_d.id)
                  left JOIN xamplify_test.xa_user_role_d xa_user_role_d ON (xa_user_d.user_id = xa_user_role_d.user_id)

 ;;
  }

  parameter: Category_Selector {
    label: "Category_Selector"
    #description: "This filter applies only for Quarter,Month,Week Report "
    allowed_value: { value: "vendor_welcome"}
    allowed_value: { value: "vendor_removal_warning"}
    allowed_value: { value: "vendor_churn_farewell_nurture" }
    allowed_value: { value: "vendor_adding_partner_nurture" }
    allowed_value: { value: "vendor_incomplete_profile"}
    allowed_value: { value:"vendor_inactive_support_nurture#1"}
    allowed_value: { value: "vendor_inactive_support_nurture#2"}
    allowed_value: { value: "vendor_complete_profile_success_nurture#1"}
    allowed_value: { value: "vendor_success_nurture#2"}
    allowed_value: { value: "vendor_first_campaign_nurture#2"}
    allowed_value: { value: "vendor_first_campaign_nurture#3"}
    allowed_value: { value: "vendor_first_campaign_nurture#1"}
    allowed_value: { value:"vendor_first_campaign_congrats"}

  }



  measure: vendors_with_nurtures{
    type: count_distinct
    sql:case when (${role_id}=2 or ${role_id}=13) and ${company_id_xa_company_d} is not null
        and  ${action_name_a}={% parameter Category_Selector  %}
        then ${company_id_xa_company_d} end;;
  }

  measure: vendors_without_nurtures1{
    type: number
    sql: ${Vendor_stats}-${vendors_with_nurtures} ;;
  }



  measure: count {
    type: count
    drill_fields: [detail*]
  }
  measure: Name {
    type: count_distinct
    sql: ${name};;
    drill_fields: [company_name,email_id,created_time,datereg_time,name,subject,sent_time]
  }

  measure: Active_Nurtures{
    type: count_distinct

    sql: ${action_id_a} ;;
    drill_fields: [action_name_a]
  }

  measure: Pie_count{
    type: count_distinct
    sql: ${company_id_xa_company_d} ;;
    drill_fields: [company_name,email_id,created_time,datereg_time,status]
  }

  measure: Vendor_nurtures{
    type: count_distinct
    sql: ${action_name_a} ;;
    drill_fields: [action_name_a]
  }

  measure: Inactive_nurtures {
    type: count_distinct
    sql: ${action_name_a} ;;
    drill_fields: [action_name_a]
  }

  measure: Nurture_companies {
    type: count_distinct
    sql:  case when (${action_id_a}>=21 and ${action_id_a}<=37) then ${user_id} end;;
    filters: {
      field: name
      value:  "-NULL"
    }

    drill_fields: [company_name,email_id,name,subject,sent_time]
  }

  measure: Vendors_without_Nurtures{
    type: count_distinct
    sql: ${user_id};;
    filters: {
      field: name
      value:  "NULL"
    }
    drill_fields: [company_name,email_id,created_time,datereg_time,status]
  }


  measure: Vendor_stats {
    type: count_distinct
    sql: case when (${role_id}=2 or ${role_id}=13) then ${user_id} end;;

    drill_fields: [company_name,email_id,created_time,datereg_time]

    link:{
      label:"With Nurture Details"
      url: "https://stratappspartner.looker.com/dashboards/46"

    }

    link:{
      label:"Without Nurture Details"
      url: "https://stratappspartner.looker.com/dashboards/47"

    }

    #link:{
    # label:"With Nurture Details"
    #  url: "https://stratappspartner.looker.com/looks/97?"
    #  icon_url: "http://www.looker.com/favicon.ico"
    #}

    #link:{
    #  label:"Without Nurture Details"
    # url: "https://stratappspartner.looker.com/looks/98?"
    #icon_url: "http://www.looker.com/favicon.ico"
    #}
  }


  measure: Campaigns {
    type: count_distinct
    sql: ${campaign_id_xa_campaign_d} ;;
    drill_fields: [company_name,email_id,campaign_name,created_time,launch_time]
  }


  measure: Vendor_stats_1 {
    type: count_distinct
    sql: case when (${role_id}=2 or ${role_id}=13) then ${user_id} end;;
    filters: {
      field: campaign_id_xa_campaign_d
      value:  "-NULL"
    }
    drill_fields: [company_name,email_id,created_time,datereg_date,name,
      subject,sent_time]
  }

  measure: Vendor_stats_2 {
    type: count_distinct
    sql: case when (${role_id}=2 or ${role_id}=13) then ${user_id} end;;
    filters: {
      field: campaign_id_xa_campaign_d
      value:  "NULL"
    }
    drill_fields: [company_name,email_id,created_time,datereg_time,name,subject,sent_time]
  }


  measure: launch {
    type: count_distinct

    sql: ${launch_raw} ;;
  }

  measure: Inactive_vendors{
    type: count_distinct
    sql: ${user_id} ;;
    drill_fields: [email_id,created_time,datereg_time,name,subject,sent_time]

  }

  measure: Vendor_stats_do{
    type: count_distinct
    sql: case when (${role_id}=2 or ${role_id}=13) and ${company_id_xa_user_d} not in( 231,130,265,266,313,391,
          280,281,303,307,311,357,
          320,326,331,334,356,270,
          368,370,369,372,376,380,
          382,398,215,273,410,413,
          415,374,389,322,332,333,
          335,367,349,358,359,362,
          371,378,379,381,385,386,
          388,393,395,401,414,384,421,424)then ${user_id} end;;
    filters: {
      field: company_id_xa_user_d
      value:  "-NULL"
    }

    drill_fields: [company_id_xa_company_d,company_name,email_id,created_time,datereg_time]
    link:{
      label:"With Nurture Details"
      url: "https://stratappspartner.looker.com/dashboards/46"

    }

    link:{
      label:"Without Nurture Details"
      url: "https://stratappspartner.looker.com/dashboards/47"

    }
  }

  measure: Inactive_vendors_do{
    type: count_distinct
    sql: ${user_id} ;;
    filters: {
      field: company_id_xa_user_d
      value:  "NULL"
    }
    drill_fields: [email_id,created_time,datereg_time,name,subject,sent_time]

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
  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: lastname {
    type: string
    sql: ${TABLE}.lastname ;;
  }
  dimension: Full_Name {
    type: string
    label: "Full Name"
    sql: concat(${firstname},' ',${lastname}) ;;
  }

  dimension_group: datereg {
    type: time
    label: "Registered"
    sql: ${TABLE}.datereg ;;
  }

  dimension_group: datelastlogin {
    type: time
    sql: ${TABLE}.datelastlogin ;;
  }


  dimension_group: created {
    type: time
    label: "Created"
    sql: ${TABLE}.created_time ;;
  }

  dimension: mobile_number {
    type: string
    sql: ${TABLE}.mobile_number ;;
  }
  dimension: company_id_xa_user_d {
    type: string
    label: "User_Company_Id"
    sql: ${TABLE}.User_Company_Id ;;
  }


  dimension: campaign_id_xa_campaign_d {
    type: string
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

  dimension_group: launch {
    type: time
    label: "Launch"
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
    label: "Nurture_Name"
    sql: ${TABLE}.Nurture_Name ;;


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

  dimension_group: sent {
    type: time
    label: "Sent"
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

  dimension: totalvendors1 {
    type: string
    sql: ${TABLE}.totalvendors1 ;;
  }
  dimension: totalvendors2 {
    type: string
    sql: ${TABLE}.totalvendors2 ;;
  }
  #dimension: action_name_Category {
  # type: string
  #sql:
  #CASE
  #when ${action_name_a}='vendor_welcome' THEN 'Welcome Nurtures'
  #when ${action_name_a}='vendor_complete_profile_success_nurture#1' THEN 'Company Profile Nurtures'
  #when ${action_name_a}='vendor_incomplete_profile' THEN 'Company Profile Nurtures'
  #when ${action_name_a}='vendor_inactive_support_nurture#1' THEN 'Company Profile Nurtures'
  #when ${action_name_a}='vendor_inactive_support_nurture#2' THEN 'Company Profile Nurtures'
  #when ${action_name_a}='vendor_adding_partner_nurture' THEN 'OnBoard Partner Nurtures'
  #when ${action_name_a}='vendor_first_campaign_congrats' THEN 'Campaign Nurtures'
  #when ${action_name_a}='vendor_first_campaign_nurture#1' THEN 'Campaign Nurtures'
  #when ${action_name_a}='vendor_first_campaign_nurture#2' THEN 'Campaign Nurtures'
  #when ${action_name_a}='vendor_first_campaign_nurture#3' THEN 'Campaign Nurtures'
  #when ${action_name_a}='vendor_success_nurture#2' THEN 'Campaign Nurtures'
  #when ${action_name_a}='vendor_removal_warning' THEN 'Removal warning Nurtures'
  #when ${action_name_a}='vendor_churn_farewell_nurture' THEN 'Removal warning Nurtures'
  #END ;;

  #drill_fields: [company_name,created_time_date,datereg_date]




  # link:{
  #  label:"{{value}} With Nurture Details"
  # url: "https://stratappspartner.looker.com/looks/97?&f[vendor_nurtures.action_name_Category]={{ value | encode_uri }}"
  #icon_url: "http://www.looker.com/favicon.ico"
  #}
  #link:{
  # label:"{{value}} Without Nurture Details"
  #url: "https://stratappspartner.looker.com/looks/98?&f[vendor_nurtures.action_name_Category]=-{{ value | encode_uri }}"
  #icon_url: "http://www.looker.com/favicon.ico"
  #}


  #}




  set: detail {
    fields: [
      user_id,
      email_id,
      firstname,
      lastname,
      status,
      datereg_time,
      datelastlogin_time,
      created_time,
      mobile_number,
      company_id_xa_user_d,
      campaign_id_xa_campaign_d,
      customer_id,
      campaign_name,
      campaign_type,
      created_time_xa_campaign_d_time,
      launch_time,
      parent_campaign_id,
      is_launched,
      company_id_xa_company_d,
      company_name,
      user_id_xa_drip_email_history_d,
      sent_time,
      name,
      type,
      subject,
      role_id,
      action_id_xa_drip_email_history_d,
      action_id_a,
      action_type_a,
      action_name_a,
      Full_Name,
      totalvendors1,
      totalvendors2

    ]
  }
}


explore:partner_nurtures  {}
view: partner_nurtures {
  derived_table: {
    sql:
    select * from (SELECT   xa_user_d.user_id AS user_id,

                            xa_company_d.company_id AS company_id,
                            xa_company_d.company_name AS company_name,

                            xa_partnership.partner_id as partner_id,
                            xa_partnership.partner_company_id as partner_company_id,

                            xa_user_role_d.role_id AS role_id,

                            xa_campaign_d.campaign_id AS campaign_id,
                            xa_campaign_d.customer_id AS customer_id,
                            xa_campaign_d.campaign_name AS Campaign_Name,
                            xa_campaign_d.created_time AS created_time_Pc,
                            xa_campaign_d.launch_time AS Launch_Time,
                            xa_campaign_d.parent_campaign_id AS parent_campaign_id,

                            -- xa_campaign_d1.campaign_id AS TM_campaign_id,
                            xa_campaign_d1.customer_id AS TM_customer_id,
                            --xa_campaign_d1.campaign_name AS TM_Campaign_Name,
                           -- xa_campaign_d1.created_time AS TM_Created_time_Tc,
                           -- xa_campaign_d1.launch_time AS TM_Launch_Time,
                           -- xa_campaign_d1.parent_campaign_id AS TM_parent_campaign_id,

                            xa_drip_email_history_d.name as Nurture_Name,
                            xa_drip_email_history_d.subject as Nurture_Subject,
                            xa_drip_email_history_d.sent_time as Nurture_Sent_Time,

                             a.action_id as action_id,
                            a.action_name as Nuture_Name,

                            xa_user_d1.email_id AS Partner_Email,
                            xa_user_d1.firstname AS firstname_p,
                            xa_user_d1.lastname AS lastname_p,
                            xa_user_d1.datereg AS Datereg,
                            xa_user_d1.datelastlogin AS Datelastlogin,
                            xa_user_d1.created_time AS Created_Time,
                            xa_user_d1.status as Status,

                            xa_company_d1.company_id AS company_id_P,
                            xa_company_d1.company_name AS Partner_Company_Name,

                            t.team_member_id as team_member_id,
                            t.email_id as Email_id,
                            t.created_time as TM_Created_Time,
                            t.firstname as TM_firstname,
                            t.lastname as TM_lastname,
                            t.status as TM_Status,

                            xa_drip_email_history_d1.name as TM_Nurture_Name,
                            xa_drip_email_history_d1.subject as TM_Nurture_Subject,
                            xa_drip_email_history_d1.sent_time as TM_Nurture_Sent_Time,

                            a1.action_id as TM_action_id,
                            a1.action_name as TM_action_name,
    cast(round(avg(totalPartner1) over(partition by xa_company_d.company_id )) as character varying) as totalPartner1,
    cast(round(avg(totalPartner2) over(partition by xa_company_d.company_id )) as character varying) as totalPartner2

                  FROM xamplify_test.xa_user_d xa_user_d
                  LEFT JOIN (select c.company_id,c.company_name from xamplify_test.xa_company_d c, xamplify_test.xa_user_d  u,xamplify_test.xa_user_role_d r
                           where u.company_id=c.company_id
                           and u.user_id=r.user_id
                           and r.role_id in(2,13) and c.company_id not in(231,130,265,266,313,391,280,281,303,307,311,357,320,326,331,334,356,270,368,370,369,372,376,
                           380,382,398,215,273,410,413,415,374,389,322,332,333,335,367,349,358,359,362,371,378,379,381,385,386,388,393,395,401,414,384,421,424)
                           ) xa_company_d ON (xa_user_d.company_id = xa_company_d.company_id)

                left join xamplify_test.xa_partnership_d xa_partnership on (xa_user_d.user_id =xa_partnership.created_by)

                left JOIN xamplify_test.xa_user_role_d xa_user_role_d ON (xa_user_d.user_id = xa_user_role_d.user_id)

                left join xamplify_test.xa_campaign_d xa_campaign_d ON (xa_partnership.partner_id = xa_campaign_d.customer_id)

                left join (select d.user_id,d.sent_time,d.action_id,e.name,e.subject from xamplify_test.xa_drip_email_history_d d,xamplify_test.xa_emailtemplates_d e
                            where d.email_template_id=e.id and d.action_id>=37 and d.action_id<=48) xa_drip_email_history_d ON (xa_partnership.partner_id = xa_drip_email_history_d.user_id)
                            full join (select * from xamplify_test.xa_action_type_d
                            where xa_action_type_d.action_id >= 37 and xa_action_type_d.action_id <= 48) a on (xa_drip_email_history_d.action_id=a.action_id)

                left join xamplify_test.xa_user_d xa_user_d1 on (xa_partnership.partner_id=xa_user_d1.user_id)

                left join (select distinct company_id, company_name from xamplify_test.xa_company_d) xa_company_d1
                           on (xa_partnership.partner_company_id=xa_company_d1.company_id)
                left join  (select vendor_company_id, count(distinct partner_id ) as totalPartner1
                             from xamplify_test.xa_partnership_d
                            where vendor_company_id not in (231,130,265,266,313,391,280,281,303,307,311,357,320,326,331,334,356,270,368,370,369,372,376,
                           380,382,398,215,273,410,413,415,374,389,322,332,333,335,367,349,358,359,362,371,378,379,381,385,386,388,393,395,401,414,384,421,424)
                            group by 1) e on (e.vendor_company_id=xa_company_d.company_id)
                left join (select vendor_company_id, count(distinct   partner_id ) as totalPartner2
                           from xamplify_test.xa_partnership_d
                            where partner_id  is not null and
                            partner_company_id is not null
                           and vendor_company_id not in (231,130,265,266,313,391,280,281,303,307,311,357,320,326,331,334,356,270,368,370,369,372,376,
                           380,382,398,215,273,410,413,415,374,389,322,332,333,335,367,349,358,359,362,371,378,379,381,385,386,388,393,395,401,414,384,421,424)
                           group by 1)f  on (f.vendor_company_id=xa_company_d.company_id)

              left join  xamplify_test.xa_team_member_d t on (t.org_admin_id=xa_partnership.partner_id)
              left join  (select distinct customer_id from xamplify_test.xa_campaign_d) xa_campaign_d1 ON (t.team_member_id = xa_campaign_d1.customer_id)

              left join (select d.user_id,d.sent_time,d.action_id,e.name,e.subject from xamplify_test.xa_drip_email_history_d d,xamplify_test.xa_emailtemplates_d e
                           where d.email_template_id=e.id and d.action_id>=37 and d.action_id<=48) xa_drip_email_history_d1 ON (t.team_member_id = xa_drip_email_history_d1.user_id)
                         full join (select * from xamplify_test.xa_action_type_d
                         where xa_action_type_d.action_id >= 37 and xa_action_type_d.action_id <= 48) a1 on (xa_drip_email_history_d1.action_id=a1.action_id)
                          )a
                             ;;
  }

  parameter: Category_Selector {
    label: "Category_Selector"
    #description: "This filter applies only for Quarter,Month,Week Report "
    allowed_value: { value: "partner_benefit_of_adding_vendor"}
    allowed_value: { value: "partner_first_campaign_congrats" }
    allowed_value: { value: "partner_incomplete_profile" }
    allowed_value: { value: "partner_redistribution_nurture#1" }
    allowed_value: { value: "partner_redistribution_nurture#2"}
    allowed_value: { value: "partner_redistribution_nurture#3"}
    allowed_value: { value: "partner_second_campaign_congrats"}
    allowed_value: { value: "partner_signup_nurture#1"}
    allowed_value: { value: "partner_special_incentive"}
    allowed_value: { value: "partner_success_nurture#1"}
    allowed_value: { value: "partner_training_instruction"}
    allowed_value: { value: "partner_welcome"}

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

  measure: Active_partners_with_Nurtures {
    type: count_distinct

    sql:
    case when ${partner_company_id_xa_partnership} is not null
    and ${action_name_a}= {% parameter Category_Selector  %}
    then
    ${partner_id_xa_partnership}
    end
    ;;

    }
    measure:Active_partners_without_Nurtures {
      type: number
      sql: ${partner_companies_d}-${Active_partners_with_Nurtures} ;;
      drill_fields: [partner_id_xa_partnership]
      link: {
        label: "Active partners without nurture Details"
        url: "https://stratappspartner.looker.com/dashboards/38?
        &f[partner_nurtures.Company_Name]={{ filters['partner_nurtures.Company_Name'] | url_encode }}
        &f[partner_nurtures.Category_Selector]={{ _filters['partner_nurtures.Category_Selector'] | url_encode }}"

      }

    }


    measure: count {
      type: count
      drill_fields: [detail*]
    }
    measure: Partner_Nurture {
      type: count_distinct
      sql: ${action_id_a};;
      drill_fields: [action_name_a]

    }
    measure: Nurture_Count{
      type: count_distinct
      sql: ${name_xa_drip_email_history_d1};;
      drill_fields: [name_xa_drip_email_history_d1,subject_xa_drip_email_history_d1,
        sent_time_xa_drip_email_history_d1_time]

    }
    measure: Active_Nurture {
      type: count_distinct
      sql: ${name_xa_drip_email_history_d};;
      drill_fields: [name_xa_drip_email_history_d,subject_xa_drip_email_history_d]

    }

    measure: Total_Partners{
      type: count_distinct
      sql: ${partner_id_xa_partnership};;
      drill_fields: [company_name_xa_company_d1,email_id_xa_user_d1,Full_Name,
        created_time_xa_user_d1_time,
        datereg_xa_user_d1_time,status_xa_user_d1
      ]
    }

    measure: partner_companies {
      type: count_distinct
      sql:case when  ${partner_company_id_xa_partnership} is not null then   ${partner_id_xa_partnership} end;;

      filters:[customer_id_xa_campaign_d: "-NULL",totalPartner2: "-NULL"]

      drill_fields: [company_name_xa_company_d1,email_id_xa_user_d1,Full_Name,created_time_xa_user_d1_time,
        datereg_xa_user_d1_time,status_xa_user_d1,name_xa_drip_email_history_d,
        subject_xa_drip_email_history_d,sent_time_xa_drip_email_history_d_time
      ]

    }

    measure: partner_companies_1 {
      type: count_distinct
      sql:case when  ${partner_company_id_xa_partnership} is not null then   ${partner_id_xa_partnership} end;;

      filters:[customer_id_xa_campaign_d: "NULL",totalPartner2: "-NULL"]

      drill_fields: [company_name_xa_company_d1,email_id_xa_user_d1,Full_Name,created_time_xa_user_d1_time,
        datereg_xa_user_d1_time,status_xa_user_d1,name_xa_drip_email_history_d,
        subject_xa_drip_email_history_d,sent_time_xa_drip_email_history_d_time
      ]

    }

    measure: partner_companies_d {
      type: count_distinct
      sql:case when  ${partner_company_id_xa_partnership} is not null then   ${partner_id_xa_partnership} end;;
      filters: [totalPartner1: "-NULL",partner_company_id_xa_partnership1: "-NULL"]
      drill_fields: [company_name_xa_company_d1,email_id_xa_user_d1,Full_Name,created_time_xa_user_d1_time,
        datereg_xa_user_d1_time,status_xa_user_d1,name_xa_drip_email_history_d,
        subject_xa_drip_email_history_d,sent_time_xa_drip_email_history_d_time
      ]
      link:{
        label:"With Nurture Details"
        url: "https://stratappspartner.looker.com/dashboards/32?Company%20Name={{_filters['partner_nurtures.company_name'] | url_encode }}"

      }


      link: {
        label: "Without Nurture Details"
        url: "https://stratappspartner.looker.com/dashboards/38?Company%20Name={{ _filters['partner_nurtures.company_name'] | url_encode }}
        &f[partner_nurtures.Category_Selector]={{ _filters['partner_nurtures.Category_Selector'] | url_encode }}"

      }


    }
    measure: partner_without_companies {
      type: count_distinct
      sql:case when  ${partner_company_id_xa_partnership} is  null then   ${partner_id_xa_partnership} end;;
      filters: [totalPartner1: "-NULL",partner_company_id_xa_partnership1: "NULL"]
      drill_fields: [company_name_xa_company_d1,email_id_xa_user_d1,Full_Name,created_time_xa_user_d1_time,
        datereg_xa_user_d1_time,status_xa_user_d1,name_xa_drip_email_history_d,
        subject_xa_drip_email_history_d,sent_time_xa_drip_email_history_d_time
      ]

    }



    measure: Active_Partners{
      type: count_distinct
      sql: ${partner_id_xa_partnership};;
      drill_fields: [company_name_xa_company_d1,email_id_xa_user_d1,created_time_xa_user_d1_date,datereg_xa_user_d1_date]

    }
    measure: Partners_with_nurture{
      type: count_distinct
      sql: case when ${name_xa_drip_email_history_d} is not null and ${partner_company_id_xa_partnership} is not null then ${partner_id_xa_partnership} end;;
     # filters: {
      #  field: name_xa_drip_email_history_d
       # value:  "-NULL"
      #}
      filters: [name_xa_drip_email_history_d: "-NULL", totalPartner2: "-NULL"]
      drill_fields: [company_name_xa_company_d1,email_id_xa_user_d1,Full_Name,
        created_time_xa_user_d1_time,datereg_xa_user_d1_time,status_xa_user_d1]

    }
    measure: Partners_without_nurture{
      type: count_distinct
      sql: case when ${name_xa_drip_email_history_d} is null and ${partner_company_id_xa_partnership} is not null then ${partner_id_xa_partnership} end;;
     # filters: {
      #  field: name_xa_drip_email_history_d
       # value:  "NULL"
      #}
      filters: [name_xa_drip_email_history_d: "NULL", totalPartner2: "-NULL"]
      drill_fields:[company_name_xa_company_d1,email_id_xa_user_d1,Full_Name,
        created_time_xa_user_d1_time,datereg_xa_user_d1_time,datelastlogin_xa_user_d1_time,
        status_xa_user_d1]

    }
    measure: Name {
      type: count_distinct
      sql: ${name_xa_drip_email_history_d};;
      drill_fields: [company_name_xa_company_d1,created_time_xa_user_d1_time,
        datereg_xa_user_d1_time,name_xa_drip_email_history_d,
        subject_xa_drip_email_history_d,sent_time_xa_drip_email_history_d_raw]
    }



    measure: Partners_count{
      type: count_distinct
      sql: ${partner_id_xa_partnership};;
      drill_fields:[company_name_xa_company_d1,Full_Name,email_id_xa_user_d1,
        name_xa_drip_email_history_d,subject_xa_drip_email_history_d,
        sent_time_xa_drip_email_history_d1_time]

    }

    measure: Campaigns {
      type: count_distinct
      sql: ${campaign_id_xa_campaign_d} ;;
      drill_fields: [company_name_xa_company_d1,email_id_xa_user_d1,
        campaign_name_xa_campaign_d,created_time_xa_campaign_d_time
        ,launch_time_xa_campaign_d_time]
    }

    measure: Team_members{
      type: count_distinct
      sql: ${team_member_id} ;;
      drill_fields: [TM_Full_Name,email_id_t,created_time_t_time,status_t,
        name_xa_drip_email_history_d1,
        subject_xa_drip_email_history_d1,sent_time_xa_drip_email_history_d1_time]
    }


    dimension: looker_image {
      type: string
      sql: ${TABLE}.homepage_url;;
      html: <img src="https://www.google.com/search?q=transparent+horizontal+line+logos&" /> ;;
    }



    measure: Total_Partners_do{

      type: string

      sql:CAST( ${Total_Partners} as Character Varying );;

    }



    dimension: user_id {
      type: number
      sql: ${TABLE}.user_id ;;
    }
    dimension: company_id {
      type: number
      sql: ${TABLE}.company_id ;;
    }
    dimension: company_name {
      type: string
      sql: ${TABLE}.company_name ;;
    }

    dimension: partner_id_xa_partnership {
      type: number
      sql: ${TABLE}.partner_id ;;
    }

    dimension: partner_company_id_xa_partnership {
      type: number
      label: "partner_company_id"
      sql: ${TABLE}.partner_company_id ;;
    }
  dimension: partner_company_id_xa_partnership1 {
    type: string
    label: "partner_company_id1"
    sql: ${TABLE}.partner_company_id ;;
  }
    dimension: role_id {
      type: number
      sql: ${TABLE}.role_id ;;
    }
    dimension: campaign_id_xa_campaign_d {
      type: number
      label: "campaign_id"
      sql: ${TABLE}.campaign_id ;;
    }

    dimension: customer_id_xa_campaign_d {
      type: string
      label: "customer_id"
      sql: ${TABLE}.customer_id ;;
    }

    dimension: campaign_name_xa_campaign_d {
      type: string
      label: "Campaign_Name"
      sql: ${TABLE}.Campaign_Name ;;
    }
    dimension_group: created_time_xa_campaign_d {
      type: time
      label: "Created"
      sql: ${TABLE}.created_time_Pc ;;
    }
    dimension_group: launch_time_xa_campaign_d {
      type: time
      label: "Launch"
      sql: ${TABLE}.Launch_Time ;;
    }
    dimension: parent_campaign_id_xa_campaign_d {
      type: number
      label: "parent_campaign_id"
      sql: ${TABLE}.parent_campaign_id ;;
    }
    dimension: campaign_id_xa_campaign_d1 {
      type: number
      label: "TM_campaign_id"
      sql: ${TABLE}.TM_campaign_id ;;
    }

    dimension: customer_id_xa_campaign_d1 {
      type: number
      label: "TM_customer_id"
      sql: ${TABLE}.TM_customer_id ;;
    }

    dimension: campaign_name_xa_campaign_d1 {
      type: string
      label: "TM_Campaign_Name"
      sql: ${TABLE}.TM_Campaign_Name ;;
    }
    dimension_group: created_time_xa_campaign_d1 {
      type: time
      label: "Created "
      sql: ${TABLE}.TM_Created_time_Tc ;;
    }
    dimension_group: launch_time_xa_campaign_d1 {
      type: time
      label: "Launched"
      sql: ${TABLE}.TM_Launch_Time ;;
    }
    dimension: parent_campaign_id_xa_campaign_d1 {
      type: number
      label: "TM_parent_campaign_id_cam1"
      sql: ${TABLE}.TM_parent_campaign_id_cam1 ;;
    }
    dimension: name_xa_drip_email_history_d {
      type: string
      label: "Nurture_Name"
      sql: ${TABLE}.Nurture_Name ;;
    }
    dimension: subject_xa_drip_email_history_d{
      type: string
      label: "Nurture_Subject"
      sql: ${TABLE}.Nurture_Subject ;;
    }
    dimension_group: sent_time_xa_drip_email_history_d {
      type: time
      label: "Nurture Sent"
      sql: ${TABLE}.Nurture_Sent_Time ;;
    }
    dimension: action_id_a {
      type: number
      label: "action_id"
      sql: ${TABLE}.action_id ;;
    }
    dimension: action_name_a {
      type: string
      label: "Nuture_Name"
      sql: ${TABLE}.Nuture_Name ;;
    }
    dimension: email_id_xa_user_d1 {
      type: string
      label: "Partner_Email"
      sql: ${TABLE}.Partner_Email ;;
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
      label: "Registered"
      sql: ${TABLE}.Datereg ;;
    }
    dimension_group: datelastlogin_xa_user_d1 {
      type: time
      label: "Datelastlogin"
      sql: ${TABLE}.Datelastlogin ;;
    }
    dimension_group: created_time_xa_user_d1 {
      type: time
      label: "Created"
      sql: ${TABLE}.Created_Time ;;
    }
    dimension: status_xa_user_d1 {
      type: string
      label: "Status"
      sql: ${TABLE}.Status ;;
    }
    dimension: company_id_xa_company_d1 {
      type: number
      label: "company_id_P"
      sql: ${TABLE}.company_id_P ;;
    }
    dimension: company_name_xa_company_d1 {
      type: string
      label: "Partner_Company_Name"
      sql: ${TABLE}.Partner_Company_Name ;;
    }
    dimension: team_member_id {
      type: number
      sql: ${TABLE}.team_member_id ;;
    }
    dimension: email_id_t {
      type: string
      label: "Email_id"
      sql: ${TABLE}.Email_id ;;
    }
    dimension_group: created_time_t {
      type: time
      label: "Team Member Created"
      sql: ${TABLE}.TM_Created_Time ;;
    }
    dimension: firstname_t {
      type: string
      label: "TM_firstname"
      sql: ${TABLE}.TM_firstname ;;
    }

    dimension: lastname_t {
      type: string
      label: "TM_lastname"
      sql: ${TABLE}.TM_lastname ;;
    }
    dimension: status_t {
      type: string
      label: "TM_Status"
      sql: ${TABLE}.TM_Status ;;
    }
    dimension: name_xa_drip_email_history_d1 {
      type: string
      label: "Nurture Name"
      sql: ${TABLE}.TM_Nurture_Name ;;
    }
    dimension: subject_xa_drip_email_history_d1{
      type: string
      label: "Nurture Subject"
      sql: ${TABLE}.TM_Nurture_Subject ;;
    }
    dimension_group: sent_time_xa_drip_email_history_d1 {
      type: time
      label: "Nuture Sent"
      sql: ${TABLE}.TM_Nurture_Sent_Time ;;
    }

    dimension: action_id_a1 {
      type: number
      label: "TM_action_id"
      sql: ${TABLE}.TM_action_id ;;
    }
    dimension: action_name_a1 {
      type: string
      label: "TM_action_name"
      sql: ${TABLE}.TM_action_name ;;
    }


    dimension: Full_Name {
      type: string
      label: "Full Name"
      sql: concat(${firstname_xa_user_d1},' ',${lastname_xa_user_d1}) ;;
    }

    dimension: TM_Full_Name {
      type: string
      label: "Team member Name"
      sql: concat(${firstname_t},' ',${lastname_t}) ;;
    }

    dimension: totalPartner1 {
      type: string
      sql: ${TABLE}.totalPartner1 ;;
    }
    dimension: totalPartner2 {
      type: string
      sql: ${TABLE}.totalPartner2 ;;
    }



    # link:{
    #  label:"{{value}} With Nurture Details"
    # url: "https://stratappspartner.looker.com/looks/101?&f[partner_nurtures.company_name]={{ _filters['Vendor%20Company%20Name'] | url_encode }}
    #&f[partner_nurtures.action_name_a]={{ value | encode_uri }}"
    #icon_url: "http://www.looker.com/favicon.ico"
    #  }

    #    link:{
    #     label:"{{value}} Without Nurture Details"
    #    url: "https://stratappspartner.looker.com/looks/102?&f[partner_nurtures.action_name_a]=-{{ value | encode_uri }}"
    #   icon_url: "http://www.looker.com/favicon.ico"
    #}



    # link:{
    #  label:"{{value}} With Nurture"
    # url: "https://stratappspartner.looker.com/dashboards/32?action_name_a={{ value |  encode_uri }}"
    # icon_url: "http://www.looker.com/favicon.ico"
    #}

    #link:{
    #label:"{{value}} Without Nurture"
    # url: "https://stratappspartner.looker.com/dashboards/33?action_name_a=-{{ value |  encode_uri }} "
    # icon_url: "http://www.looker.com/favicon.ico"
    #}






    set: detail {
      fields: [
        user_id,
        company_id,
        company_name,
        partner_id_xa_partnership,
        partner_company_id_xa_partnership,
        role_id,
        campaign_id_xa_campaign_d,
        customer_id_xa_campaign_d,
        campaign_name_xa_campaign_d,
        created_time_xa_campaign_d_time,
        launch_time_xa_campaign_d_time,
        parent_campaign_id_xa_campaign_d,
        campaign_id_xa_campaign_d1,
        customer_id_xa_campaign_d1,
        campaign_name_xa_campaign_d1,
        created_time_xa_campaign_d1_time,
        launch_time_xa_campaign_d1_time,
        parent_campaign_id_xa_campaign_d1,
        name_xa_drip_email_history_d,
        subject_xa_drip_email_history_d,
        sent_time_xa_drip_email_history_d_time,
        action_id_a,
        action_name_a,
        email_id_xa_user_d1,
        firstname_xa_user_d1,
        lastname_xa_user_d1,
        datereg_xa_user_d1_time,
        datelastlogin_xa_user_d1_time,
        created_time_xa_user_d1_time,
        status_xa_user_d1,
        company_id_xa_company_d1,
        company_name_xa_company_d1,
        team_member_id,
        email_id_t,
        created_time_t_time,
        firstname_t,
        lastname_t,
        Full_Name,
        TM_Full_Name,
        status_t,
        name_xa_drip_email_history_d1,
        subject_xa_drip_email_history_d1,
        sent_time_xa_drip_email_history_d1_time,
        action_id_a1,
        action_name_a1,
        totalPartner1,
        totalPartner2

      ]
    }
  }
explore:team_members  {}
view: team_members {
  derived_table: {
    sql:( select
          "Vendor Users".datereg as "Teammember Datereg",
          "Vendor Users".datelastlogin as "Teammember Lastlogin",
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
          "Partner Company".company_name as "Partner Company Name",
          "Partner Users" .email_id as "Partner EmailID",
          "Partner Users" .email_id as "Contact EmailID",
          "Partner Users".firstname as "Partner FirstName",
          "Partner Users".lastname as "Partner LastName",
          "Partner Users".state as "State",
          "Partner Users".country as "Country",
          "Partner Users".city as "City",
          "Team Member".team_member_id as "Team_member ID",
          "Team Member".id as "Team ID",
          "Team Member".email_id as "Team_member email_id",
          "Team Member".firstname as "Team_member Firstname",
          "Team Member".lastname as "Team_member Lastname",
          "Team Member".status as "Team_member status",
          "Team Member".created_time as "Team_member Created Time",
          "Team Member".company_id as "Team_member company_id",
      "Team Member".Role as "User Role",
          "Userlist".created_time as "Userlist Createdtime",
          "Userlist".is_partner_userlist as "Is Partner UserList",
          "Userlist".listby_partner_id as "List by Partner ID",
          "Userlist".user_list_id as "User List ID",
          "Userlist".user_list_name as "User List Name",
          "user".datereg as "user datereg",
          "user".datelastlogin as "user datelastlogin",
          ur.role_id as "Role_id",
          r.description as "Role Description",
          r.role as Role,
      "Contacts".listby_partner_id as "Contact User ID",
    "Contacts".first_name as "Contact First Name",
    "Contacts".last_name as "Contact Last Name" ,
    "Contacts".contact_company as "Conatact Company" ,
    "Contacts".email_id as "Contact Email ID",
    "Contacts".address as "Contact Adress",
    "Contacts".city as "Contact City",
    "Contacts".state as "Contact State",
    "Contacts".zip_code as "Contact Zip Code",
    "Contacts".country as "Contact Country",
    "Contacts".mobile_number as "Contact Mobile Number"

            from

(select distinct
         tm.team_member_id as "team_member_id",
         tm.id,
          tm.email_id ,
          tm.firstname,
          tm.lastname,
          tm.status ,
          tm.created_time,
          tm.company_id ,
          'TeamMember' as Role

from
 xamplify_test.xa_team_member_d tm
left join xamplify_test.xa_user_role_d ur on ur.user_id=tm.team_member_id
left join xamplify_test.xa_user_d ud on ud.user_id=tm.team_member_id
 left join xamplify_test.xa_role_d r on r.role_id=ur.role_id
 left join xamplify_test.xa_company_d cd on cd.company_id=ud.company_id
where team_member_id not in
 (select distinct user_id from xamplify_test.xa_user_role_d where role_id=2)

union all
select  distinct
    ud.user_id "team_member_id" ,
    tm.id,
  ud.email_id,
    ud.firstname,
  ud.lastname,
  ud.status,
  ud.created_time,
  ud.company_id,
     'OrgAdmin' as "Role"
from xamplify_test.xa_user_d ud left join xamplify_test.xa_company_d cd
 on cd.company_id=ud.company_id
 left join xamplify_test.xa_team_member_d tm on (tm.team_member_id=ud.user_id)
left join xamplify_test.xa_user_role_d ur on ur.user_id=ud.user_id
left join xamplify_test.xa_role_d r on ur.role_id=r.role_id
where ur.role_id=2 )  "Team Member"
            left join xamplify_test.xa_user_d "Vendor Users" on("Team Member".company_id="Vendor Users".company_id)
            left join  xamplify_test.xa_user_d "user" on("user".user_id="Team Member".team_member_id)
            inner join xamplify_test.xa_user_role_d ur on(ur.user_id="Vendor Users".user_id )
            left join xamplify_test.xa_role_d r on (ur.role_id=r.role_id)
            left JOIN xamplify_test.xa_company_d "Vendor Company" ON ("Team Member".company_id = "Vendor Company".company_id)
            left JOIN xamplify_test.xa_user_list_d "Userlist" ON ("Userlist".customer_id = "Team Member".team_member_id)
            left JOIN xamplify_test.xa_user_d "Partner Users" ON ("Userlist".listby_partner_id = "Partner Users".user_id)
            left JOIN xamplify_test.xa_company_d "Partner Company" ON ("Partner Users".company_id = "Partner Company".company_id)
            left  join xamplify_test.xa_campaign_d "Vendor Campaign" on ("Vendor Campaign".customer_id="Team Member".team_member_id)
            left join (select * from
(select distinct listby_partner_id ,
    first_name,
    last_name ,
    contact_company ,
    email_id,
    address,
    city,
    state,
    zip_code,
    country,
    mobile_number,
    company_name ,ROW_NUMBER () OVER (PARTITION BY listby_partner_id order by 1,2,3,4,5,6,7,8,9,10 desc nulls last) as row_number1
from xamplify_test.xa_user_list_d where is_partner_userlist='false') c
where row_number1=1) "Contacts" on ("Contacts".listby_partner_id="Partner Users".user_id)
            where ur.role_id in(2,13)

      )
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: Vendor_schedule_type {
    type: string
    label: "Vendor Campaign Schedule Type"
    sql: case when ${vendor_cam_schedule_type}='NOW' then 'LAUNCHED'
            when ${vendor_cam_schedule_type}='SAVE' then 'SAVE'
            when ${vendor_cam_schedule_type}='SCHEDULE' then 'SCHEDULE'
            end;;
  }




  measure: Partners {
    type: count_distinct
    sql: case when ${is_partner_user_list}=true then ${list_by_partner_id} end ;;
    drill_fields: [user_list_name,userlist_created_time,partner_email_id,
      partner_company_name,Partner_Name]
  }

  measure: Contacts {
    type: count_distinct
    sql: case when ${is_partner_user_list}=false then ${list_by_partner_id} end;;


  }

  measure: Partners_KPI {
    type: count_distinct
    sql: case when ${is_partner_user_list}=true then ${list_by_partner_id} end;;
    drill_fields: [partner_company_name,partner_email_id,Partner_Name]
  }

  measure: Contacts_KPI {
    type: count_distinct
    sql: case when ${is_partner_user_list}=false then ${list_by_partner_id} end;;
    drill_fields: [Contact_Email_ID,Conatact_Company,Contact_First_Name,Contact_Last_Name,Contact_City
      ,Contact_State,Contact_Adress,Contact_Country,Contact_Zip_Code,Contact_Mobile_Number]
  }

  measure: Campaigns {
    type: count_distinct
    sql: ${vendor_campaign_id} ;;
    drill_fields: [vendor_campaign_name,vendor_campaign_type,
      Vendor_schedule_type,vendor_cam_launch_time]
  }

  measure: Team_members {
    type: number
    sql: ${Team_members1};;

    drill_fields: [email_id,Role,Team_MemberName,
      status,datereg_date,datelastlogin_date]

  }



  measure: Team_members1 {
    type: count_distinct
    sql: ${team_member_id} ;;
    drill_fields: [email_id,Team_MemberName,
      status,roles]

  }


  measure: Org_Admin {
    type: count_distinct
    sql: case when ${roles}='OrgAdmin' then ${team_member_id} end ;;
    drill_fields: [Org_Admin_Email_id,Org_Admin_Name,roles]
  }


  dimension: Org_Admin_Email_id {
    type: string
    label: "Email_id"
    sql: case when ${roles}='OrgAdmin' then  ${email_id} end ;;
}

  dimension: Org_Admin_Name {
    type: string
    label: "Org_Admin_Name"
    sql: case when ${roles}='OrgAdmin' then  ${Team_MemberName} end ;;
  }




  dimension: Contact_User_ID {
    type: number
    label: "Contact User ID"
    sql: ${TABLE}."Contact User ID" ;;
  }

  dimension: Contact_First_Name {
    type: string
    label: "Contact First Name"
    sql: ${TABLE}."Contact First Name" ;;
  }
  dimension: Contact_Last_Name {
    type: string
    label: "Contact Last Name"
    sql: ${TABLE}."Contact Last Name" ;;
  }
  dimension: Conatact_Company {
    type: string
    label: "Conatact Company"
    sql: ${TABLE}."Conatact Company";;
  }
  dimension: Contact_Email_ID {
    type: string
    label: "Contact Email ID"
    sql: ${TABLE}."Contact Email ID";;
  }

  dimension: Contact_Adress {
    type: string
    label: "Contact Adress"
    sql: ${TABLE}."Contact Adress";;
  }
  dimension: Contact_City {
    type: string
    label: "Contact City"
    sql: ${TABLE}."Contact City";;
  }
  dimension: Contact_State {
    type: string
    label: "Contact State"
    sql: ${TABLE}."Contact State";;
  }
  dimension: Contact_Zip_Code{
    type: string
    label: "Contact Zip Code"
    sql: ${TABLE}."Contact Zip Code";;
  }
  dimension: Contact_Country{
    type: string
    label: "Contact Country"
    sql: ${TABLE}."Contact Country";;
  }
  dimension: Contact_Mobile_Number{
    type: string
    label: "Contact Mobile Number"
    sql: ${TABLE}."Contact Mobile Number";;
  }



  dimension: Team_MemberName{
    type:  string
    label: "Team_Member_Name"
    sql:  concat(${team_member_firstname} , ${team_member_lastname})  ;;

  }




  dimension: Partner_Name{
    type: string
    label: "Partner Name"
    sql: case when ${is_partner_user_list}=true then
    concat(${partner_first_name},' ' , ${partner_last_name}) end ;;
  }

  dimension: Contact_Name{
    type: string
    label: "Contact Name"
    sql:concat(${partner_first_name}, ${partner_last_name});;
  }
  dimension: vendor_cam_schedule_type {
    type: string
    label: "Campaign Schedule Type"
    sql: ${TABLE}."Vendor Cam Schedule Type" ;;
  }


  dimension_group: team_member_datereg {
    type: time
    label: "Team_member Datereg"
    sql: ${TABLE}."Team_member Datereg" ;;
  }

  dimension_group: team_member_lastlogin {
    type: time
    label: "Team_member Lastlogin"
    sql: ${TABLE}."Team_member Lastlogin" ;;
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

  dimension_group: vendor_cam_launch{
    type: time
    label: "Campaign Launch"
    sql: ${TABLE}."Vendor Cam Launch Time" ;;
  }

  dimension: vendor_campaign_type {
    type: string
    label: "Campaign Type"
    sql: ${TABLE}."Vendor Campaign Type" ;;
  }

  dimension: Contact_User_ID1 {
    type: number
    label: "Contact User ID"
    sql: ${TABLE}."Contact User ID" ;;
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

  dimension: partner_email_id {
    type: string
    label: "Partner EmailID"
    sql: ${TABLE}."Partner EmailID" ;;
  }

  dimension: contact_email_id {
    type: string
    label: "Contact EmailID"
    sql: ${TABLE}."Contact EmailID" ;;
  }

  dimension: partner_first_name {
    type: string
    label: "Partner FirstName"
    sql: ${TABLE}."Partner FirstName" ;;
  }

  dimension: partner_last_name {
    type: string
    label: "Partner LastName"
    sql: ${TABLE}."Partner LastName" ;;
  }

  dimension: Contact_first_name {
    type: string
    label: "FirstName"
    sql: ${TABLE}."Partner FirstName" ;;
  }

  dimension: Contact_last_name {
    type: string
    label: "LastName"
    sql: ${TABLE}."Partner LastName" ;;
  }

  dimension: State {
    type: string
    label: "State"
    sql: ${TABLE}."State" ;;
  }

  dimension: Country {
    type: string
    label: "Country"
    sql: ${TABLE}."Country" ;;
  }

  dimension: City {
    type: string
    label: "City"
    sql: ${TABLE}."City" ;;
  }

  dimension: team_member_id {
    type: number
    label: "Team_member ID"
    sql: ${TABLE}."Team_member ID" ;;
  }

  dimension: roles{
    type:string
    label: "Role"
    sql: ${TABLE}."User Role" ;;
  }
  dimension: team_id {
    type: number
    label: "Team ID"
    sql: ${TABLE}."Team ID" ;;
  }

  dimension: email_id {
    type: string
    label: "Email_Id"
    sql: ${TABLE}."Team_member email_id" ;;
  }

  dimension: team_member_firstname {
    type: string
    label: "Firstname"
    sql: ${TABLE}."Team_member Firstname" ;;
  }

  dimension: team_member_lastname {
    type: string
    label: "Lastname"
    sql: ${TABLE}."Team_member Lastname" ;;
  }

  dimension: status {
    type: string
    label: "Status"
    sql: ${TABLE}."Team_member status" ;;
  }

  dimension_group: team_member_created_time {
    type: time
    label: "Created Time"
    sql: ${TABLE}."Team_member Created Time" ;;
  }

  dimension: team_member_company_id {
    type: number
    label: "Team_member company_id"
    sql: ${TABLE}."Team_member company_id" ;;
  }

  dimension_group: userlist_created {
    type: time
    label: "Userlist Created"
    sql: ${TABLE}."Userlist Createdtime" ;;
  }

  dimension: is_partner_user_list {
    type: string
    label: "Is Partner UserList"
    sql: ${TABLE}."Is Partner UserList" ;;
  }

  dimension: list_by_partner_id {
    type: number
    label: "List by Partner ID"
    sql: ${TABLE}."List by Partner ID" ;;
  }

  dimension: user_list_id {
    type: number
    label: "User List ID"
    sql: ${TABLE}."User List ID" ;;
  }

  dimension: user_list_name {
    type: string
    label: "User List Name"
    sql: ${TABLE}."User List Name" ;;
  }

  dimension_group: datereg {
    type: time
    label: "DateReg"
    sql: ${TABLE}."user datereg" ;;

  }

  dimension_group: datelastlogin {
    type: time
    label: "Date LastLogin"
    sql: ${TABLE}."user datelastlogin" ;;

  }

  dimension: role_id {
    type: number
    label: "Role_id"
    sql: ${TABLE}."Role_id" ;;
  }

  dimension: description{
    type: string
    label: "Role Description"
    sql: ${TABLE}."Role Description" ;;
  }

  dimension: Role{
    type: string
    label: "Role"
    sql: ${TABLE}."Role" ;;
  }



  set: detail {
    fields: [
      team_member_datereg_time,
      team_member_lastlogin_time,
      vendor_campaign_id,
      vendor_campaign_name,
      vendor_company_id,
      vendor_company_name,
      vendor_cam_is_launched,
      vendor_cam_launch_time,
      vendor_campaign_type,
      vendor_cam_schedule_type,
      vendor_cam_created_time_time,
      partner_company_id,
      partner_company_name,
      partner_email_id,
      contact_email_id,
      partner_first_name,
      partner_last_name,
      Contact_first_name,
      Contact_last_name,
      State,
      Country,
      City,
      team_member_id,
      team_id,
      email_id,
      team_member_firstname,
      team_member_lastname,
      status,
      team_member_created_time_time,
      team_member_company_id,
      roles,
      userlist_created_time,
      is_partner_user_list,
      list_by_partner_id,
      user_list_id,
      user_list_name,
      datereg_date,
      datelastlogin_date,
      role_id,
      description,
      Role,
      Contact_User_ID1,
      Contact_First_Name,
      Contact_Last_Name,
      Conatact_Company,
      Contact_Email_ID,
      Contact_Adress,
      Contact_City,
      Contact_State,
      Contact_Zip_Code,
      Contact_Country,
      Contact_Mobile_Number,
      Org_Admin,
      Org_Admin_Email_id,
      Org_Admin_Name



    ]
  }
}



explore: email_templates {}
view: email_templates {
  derived_table: {
    sql: select
      et. created_time as "Emailtemplate created time",
      et.id as "Emailtemplate ID",
      et .name as "Emailtemplate name",
      et.type as "Emailtemplate Type",
      et.subject as "Emailtemplate Subject",
      t.team_member_id as "Teammember ID",
      t.email_id as "Teammember email_id",
      t.firstname as "Teammember Firstname",
      t.lastname as "Teammember Lastname",
      t.status as "Teammember status",
      t.created_time as "Teammember Created Time",
      t.company_id as "Teammember company_id",
      c.company_id as "Vendor Company ID",
      c.company_name as "Vendor Company Name",
      u.user_id as "Vendor User ID",
      c.email_id as "Email ID",
      u.firstname as "First Name",
      u.lastname as "Last Name",
      u.datereg as "DateReg",
      u.datelastlogin as "Date LastLogin",
      c.country as "Country",
      "Social Connection". id as "Social Connection ID",
      "Social Connection".profile_name as "Social Connection Name",
      "Social Connection" .source as "Social Connection Source",
      "Videofiles".  id as "Video ID",
      "Videofiles".customer_id as "Video Customer ID",
      "Videofiles".title as "Video Title",
      "Videofiles".created_time as "Video Created Time",
       cam.campaign_id as "Campaign ID",
       cam.campaign_name as "Campaign Name",
       cam.campaign_type as "Campaign Type",
       cam.campaign_schedule_type as "Campaign Schedule Type",
       cam.launch_time as "Campaign Launch Time",
      cam1.campaign_id as "Email Template Campaign",
      cam1.campaign_name as "Email Template Campaign Name",
      cam1.campaign_schedule_type as "Email Template Schedule Type",
      cam1.campaign_type as "Email Template Campaign Type",
      cam1.launch_time as "Email Template Campaign Launch Time"






      from
      xamplify_test.xa_team_member_d t
      left join xamplify_test.xa_user_d u on(t.company_id=u.company_id)
      left join xamplify_test.xa_company_d c on (t.company_id=c.company_id)
      left join xamplify_test.xa_user_role_d ur on (u.user_id=ur.user_id)
      left join xamplify_test.xa_emailtemplates_d et on (t.team_member_id=et.user_id)
      left join xamplify_test.xa_videofiles_d "Videofiles" on(t.team_member_id="Videofiles".customer_id)
      left join xamplify_test.xa_socialconn_d "Social Connection" on(t.team_member_id="Social Connection".user_id)
      left join xamplify_test.xa_campaign_d cam on(t.team_member_id=cam.customer_id)
      left join xamplify_test.xa_campaign_d cam1 on (cam1.email_template_id=et.id)
      where ur.role_id in(2,13)
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: Vendor_schedule_type {
    type: string
    label: "Vendor Campaign Schedule Type"
    sql: case when ${campaign_schedule_type}='NOW' then 'LAUNCHED'
            when ${campaign_schedule_type}='SAVE' then 'SAVE'
            when${campaign_schedule_type}'SCHEDULE' then 'SCHEDULE'
            end;;
  }

  dimension: Email_template_schedule_type {
    type: string
    label: "Campaign Schedule Type"
    sql: case when ${Email_Template_campaign_schedule_type}='NOW' then 'LAUNCHED'
            when ${Email_Template_campaign_schedule_type}='SAVE' then 'SAVE'
            when ${Email_Template_campaign_schedule_type}'SCHEDULE' then 'SCHEDULE'
            end;;
  }



  measure: email_templates {
    type: count_distinct
    sql: ${emailtemplate_id} ;;
    drill_fields: [teammember_name,emailtemplate_name,emailtemplate_created_time,Campaigns_count]
  }
  measure: Video_files {
    type:count_distinct
    sql: ${video_id} ;;
    drill_fields: [video_title,video_created_time]
  }

  measure: Social_Share {
    type: count_distinct
    sql: ${social_connection_id} ;;
    drill_fields: [social_connection_source,social_connection_name]
  }

  measure: Campaigns {
    type: count_distinct
    sql: ${campaign_id} ;;
    drill_fields: [campaign_name,campaign_type,campaign_schedule_type,campaign_launch_time]
  }


  measure: Teammembers {
    type: count_distinct
    sql: ${teammember_id} ;;
    drill_fields: [teammember_name,teammember_email_id,teammember_created_time_date,teammember_status]
  }

  measure: Campaigns_count{
    type: count_distinct
    label: "# Campaigns"
    sql: ${campaign_template} ;;
    drill_fields: [campaign_templateName,Email_Template_campaign_type,
     Email_Template_campaign_schedule_type,Email_campaign_launch_time]
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

  dimension_group: video_created {
    type: time
    label: "Video Created"
    sql: ${TABLE}."Video Created Time" ;;
  }

  dimension: social_connection_id {
    type: number
    label: "Social Connection ID"
    sql: ${TABLE}."Social Connection ID" ;;
  }

  dimension: social_connection_name {
    type: string
    label: "Social Connection Name"
    sql: ${TABLE}."Social Connection Name" ;;
  }

  dimension: social_connection_source {
    type: string
    label: "Source"
    sql: ${TABLE}."Social Connection Source" ;;
  }



  dimension: teammember_name {
    type: string
    label: "Teammember Name"
    sql: concat(${teammember_firstname},${teammember_lastname}) ;;
  }


  dimension_group: emailtemplate_created {
    type: time
    label: "Created"
    sql: ${TABLE}."Emailtemplate created time" ;;
  }

  dimension: emailtemplate_id {
    type: number
    label: "Emailtemplate ID"
    sql: ${TABLE}."Emailtemplate ID" ;;
  }

  dimension: emailtemplate_name {
    type: string
    label: "Email_Template Name"
    sql: ${TABLE}."Emailtemplate name" ;;
  }

  dimension: emailtemplate_type {
    type: string
    label: "Type"
    sql: ${TABLE}."Emailtemplate Type" ;;
  }

  dimension: emailtemplate_subject {
    type: string
    label: "Emailtemplate Subject"
    sql: ${TABLE}."Emailtemplate Subject" ;;
  }

  dimension: teammember_id {
    type: number
    label: "Teammember ID"
    sql: ${TABLE}."Teammember ID" ;;
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

  dimension: vendor_user_id {
    type: number
    label: "Vendor User ID"
    sql: ${TABLE}."Vendor User ID" ;;
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

  dimension_group: date_reg {
    type: time
    sql: ${TABLE}."DateReg" ;;
  }

  dimension_group: date_last_login {
    type: time
    label: "Date LastLogin"
    sql: ${TABLE}."Date LastLogin" ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}."Country" ;;
  }
  dimension: campaign_id {
    type: number
    label: "Campaign ID"
    sql: ${TABLE}."Campaign ID" ;;
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

  dimension: campaign_schedule_type {
    type: string
    label: "Campaign Schedule Type"
    sql: ${TABLE}."Campaign Schedule Type" ;;
  }

  dimension_group: campaign_launch {
    type: time
    label: "Campaign Launch"
    sql: ${TABLE}."Campaign Launch Time" ;;
  }

  dimension: campaign_template {
    type: string
    label: "Email Template Campaign"
    sql: ${TABLE}. "Email Template Campaign" ;;
  }

  dimension: campaign_templateName {
    type: string
    label: "Campaign Name"
    sql: ${TABLE}."Email Template Campaign Name" ;;
  }

  dimension:Email_Template_campaign_schedule_type  {
    type: string
    label: "Campaign Schedule Type"
    sql: ${TABLE}."Email Template Schedule Type" ;;
  }

  dimension: Email_Template_campaign_type {
    type: string
    label: "Campaign Type"
    sql: ${TABLE}."Email Template Campaign Type" ;;
  }

  dimension_group: Email_campaign_launch {
    type: time
    label: "Campaign Launch"
    sql: ${TABLE}."Email Template Campaign Launch Time" ;;
  }



  set: detail {
    fields: [
      emailtemplate_created_time,
      emailtemplate_id,
      emailtemplate_name,
      emailtemplate_type,
      emailtemplate_subject,
      teammember_id,
      teammember_email_id,
      teammember_firstname,
      teammember_lastname,
      teammember_status,
      teammember_created_time_time,
      teammember_company_id,
      vendor_company_id,
      vendor_company_name,
      vendor_user_id,
      email_id,
      first_name,
      last_name,
      date_reg_time,
      date_last_login_time,
      country,
      video_id,
      video_customer_id,
      video_title,
      video_created_time,
      social_connection_id,
      social_connection_name,
      social_connection_source,
      campaign_id,
      campaign_name,
      campaign_type,
      campaign_schedule_type,
      campaign_launch_time,
      campaign_template,
      campaign_templateName,
      Email_Template_campaign_schedule_type,
      Email_Template_campaign_type,
      Email_campaign_launch_time
    ]
  }
}




explore: partner_team_members {}
view: partner_team_members {
  derived_table: {
    sql: select
      vendor_company.company_id as "Vendor Company Id",
      vendor_company.company_name as "Vendor Company Name",
      partner_company.company_id as "Partner Company Id",
      partner_company.company_name as "Partner Company Name",
      ud1.user_id as "Partner user_id",
    ul.listby_partner_id as "Partner Users",
    ul.is_partner_userlist as "Is Partner Userlist",
      ud1.email_id as "Partner Email ID",
      ud1.datereg as "Partner Datereg",
      ud1.firstname as "Partner Firstname",
      ud1.lastname as "Partner Lastname",
      tm1.team_member_id as "Team Member ID",
      tm1.email_id as "Team Member Email Id",
      tm1.firstname as "Team Member First Name",
      tm1.lastname as "Team Member Last Name",
      tm1.status as "Team Member Status",
      tm1.created_time as "Team Member Created Time",
      tm1.Role as "User Role",
      ud2.user_id "partner",
      c.campaign_id as "Campaign Id",
      c.campaign_name as "Campaign Name",
      c.campaign_type as "Campaign Type",
      c.campaign_schedule_type as "Campaign Schedule Type",
      c.launch_time as "Campaign Launch Time",
      el.id as "View Id",
      el.user_id as "User Id",
      el.action_id as "Action Id",
      el.time as "Time",
      ur.role_id as "User Role ID"

      from


      xamplify_test.xa_user_d ud left join xamplify_test.xa_company_d vendor_company on
      ud.company_id=vendor_company.company_id
      left join xamplify_test.xa_user_list_d ul on ud.user_id=ul.customer_id
      left join xamplify_test.xa_user_d ud1 on ul.listby_partner_id=ud1.user_id
      left join xamplify_test.xa_company_d partner_company on partner_company.company_id=ud1.company_id
      left join xamplify_test.xa_user_d ud2 on(partner_company.company_id=ud2.company_id)
      left join (select
          tm.team_member_id as "team_member_id",
          tm.email_id ,
          tm.firstname,
          tm.lastname,
          tm.status ,
          tm.created_time,
          'TeamMember' as Role
from xamplify_test.xa_team_member_d tm
where team_member_id in
(select distinct user_id
from xamplify_test.xa_user_role_d
where user_id in
(select distinct  user_id
from xamplify_test.xa_user_d
where company_id in
(select distinct company_id
from xamplify_test.xa_user_d
where user_id in
(select distinct listby_partner_id
from xamplify_test.xa_user_list_d where is_partner_userlist=true
and customer_id in
(select distinct user_id from xamplify_test.xa_user_d ))))
 and user_id not in (select user_id from xamplify_test.xa_user_role_d where role_id =2))

 union all
 (select distinct
          ud.user_id as "team_member_id",
          ud.email_id ,
          ud.firstname,
          ud.lastname,
          ud.status ,
          ud.created_time,
          'OrgAdmin' as Role

from xamplify_test.xa_user_role_d ur
inner join
 xamplify_test.xa_user_d ud on(ud.user_id=ur.user_id)
where ud.company_id in
(select distinct company_id
from xamplify_test.xa_user_d
where user_id in
(select distinct listby_partner_id
from xamplify_test.xa_user_list_d where is_partner_userlist=true
and customer_id in
(select distinct user_id from xamplify_test.xa_user_d )))  and ur.role_id =2))
    tm1 on tm1.team_member_id=ud2.user_id
      left join xamplify_test.xa_campaign_d c on(c.customer_id=tm1.team_member_id)
      --left join xamplify_test.xa_campaign_user_userlist_d cul on(cul.campaign_id=c.campaign_id)
      left join xamplify_test.xa_user_role_d  ur on(ur.user_id=c.customer_id)
      left join xamplify_test.xa_emaillog_d el on(c.campaign_id=el.campaign_id)
      where ul.is_partner_userlist= true
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }
  dimension: Vendor_schedule_type {
    type: string
    label: "Vendor Campaign Schedule Type"
    sql: case when ${campaign_schedule_type}='NOW' then 'LAUNCHED'
            when ${campaign_schedule_type}='SAVE' then 'SAVE'
            when${campaign_schedule_type}'SCHEDULE' then 'SCHEDULE'
            end;;
  }

  measure: Campaigns {
    type: count_distinct
    sql:  ${campaign_id};;
    drill_fields: [campaign_name,campaign_type,campaign_schedule_type,campaign_launch_time]
  }

  measure: Team_members {
    type: count_distinct
    sql: ${team_member_id} ;;
    drill_fields: [team_member_email_id,Team_member_name,team_member_status,user_role]
  }

  measure:Views {
    type: count_distinct
    sql: ${time_minute} ;;

  }
  measure: Partners {
    type: count_distinct
    sql: ${partner_user_id} ;;
    drill_fields: [partner_company_name,partner_email_id,partner_firstname,partner_lastname]
  }

  dimension: Partner_Name{
    type: string
    sql: concat (${partner_firstname},${partner_lastname} ;;
  }

  dimension: Team_member_name {
    type: string
    label: "Team Member Name"
    sql: concat(${team_member_first_name}, ${team_member_last_name}) ;;
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

  dimension: partner_user_id {
    type: number
    label: "Partner user_id"
    sql: ${TABLE}."Partner user_id" ;;
  }

  dimension: partner_users {
    type: number
    label: "Partner Users"
    sql: ${TABLE}."Partner Users" ;;
  }

  dimension: is_partner_userlist {
    type: string
    label: "Is Partner Userlist"
    sql: ${TABLE}."Is Partner Userlist" ;;
  }

  dimension: partner_email_id {
    type: string
    label: "Partner Email ID"
    sql: ${TABLE}."Partner Email ID" ;;
  }

  dimension_group: partner_datereg {
    type: time
    label: "Partner Datereg"
    sql: ${TABLE}."Partner Datereg" ;;
  }

  dimension: partner_firstname {
    type: string
    label: "Firstname"
    sql: ${TABLE}."Partner Firstname" ;;
  }

  dimension: partner_lastname {
    type: string
    label: "Lastname"
    sql: ${TABLE}."Partner Lastname" ;;
  }

  dimension: team_member_id {
    type: number
    label: "Team Member ID"
    sql: ${TABLE}."Team Member ID" ;;
  }

  dimension: team_member_email_id {
    type: string
    label: "Email Id"
    sql: ${TABLE}."Team Member Email Id" ;;
  }

  dimension: team_member_first_name {
    type: string
    label: "Team Member First Name"
    sql: ${TABLE}."Team Member First Name" ;;
  }

  dimension: team_member_last_name {
    type: string
    label: "Team Member Last Name"
    sql: ${TABLE}."Team Member Last Name" ;;
  }

  dimension: team_member_status {
    type: string
    label: "Team Member Status"
    sql: ${TABLE}."Team Member Status" ;;
  }

  dimension_group: team_member_created{
    type: time
    label: "Team Member Created"
    sql: ${TABLE}."Team Member Created Time" ;;
  }

  dimension: user_role {
    type: string
    label: "User Role"
    sql: ${TABLE}."User Role" ;;
  }

  dimension: partner {
    type: number
    sql: ${TABLE}."partner" ;;
  }

  dimension: campaign_id {
    type: number
    label: "Campaign Id"
    sql: ${TABLE}."Campaign Id" ;;
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

  dimension: campaign_schedule_type {
    type: string
    label: "Campaign Schedule Type"
    sql: ${TABLE}."Campaign Schedule Type" ;;
  }

  dimension_group: campaign_launch {
    type: time
    label: "Campaign Launch"
    sql: ${TABLE}."Campaign Launch Time" ;;
  }

  dimension: view_id {
    type: number
    label: "View Id"
    sql: ${TABLE}."View Id" ;;
  }

  dimension: user_id {
    type: number
    label: "User Id"
    sql: ${TABLE}."User Id" ;;
  }

  dimension: action_id {
    type: number
    label: "Action Id"
    sql: ${TABLE}."Action Id" ;;
  }

  dimension_group: time {
    type: time
    sql: ${TABLE}."Time" ;;
  }

  dimension: user_role_id {
    type: number
    label: "User Role ID"
    sql: ${TABLE}."User Role ID" ;;
  }

  set: detail {
    fields: [
      vendor_company_id,
      vendor_company_name,
      partner_company_id,
      partner_company_name,
      partner_user_id,
      partner_users,
      is_partner_userlist,
      partner_email_id,
      partner_datereg_time,
      partner_firstname,
      partner_lastname,
      team_member_id,
      team_member_email_id,
      team_member_first_name,
      team_member_last_name,
      team_member_status,
      team_member_created_time,
      user_role,
      partner,
      campaign_id,
      campaign_name,
      campaign_type,
      campaign_schedule_type,
      campaign_launch_time,
      view_id,
      user_id,
      action_id,
      time_time,
      user_role_id
    ]
  }
}





explore: partner_team_member_contacts  {}
view: partner_team_member_contacts {
  derived_table: {
    sql:  select vendor_company.company_id as "vendor company id",
          ul1.is_partner_userlist as "is partner userlist",
          vendor_company.company_name as "Vendor Company Name",
          partner_company.company_id as "partner company id",
          partner_company.company_name as "Partner Company Name",
          partner_company.email_id as "Contact Email Id",
          ul1.listby_partner_id as "listby partner id",
          ul1.created_time as "list created time",
          ul1.user_list_name as "user list name",
          ul1.user_list_id as "user list id",
          tm1.firstname as"Team member Firstname",
          tm1.lastname as "Team memberLastname",
          tm1.email_id as "Team member email_id",
    "Contacts".listby_partner_id as "Contact User ID",
    "Contacts".first_name as "Contact First Name",
    "Contacts".last_name as "Contact Last Name" ,
    "Contacts".contact_company as "Conatact Company" ,
    "Contacts".email_id as "Contact Email ID",
    "Contacts".address as "Contact Adress",
    "Contacts".city as "Contact City",
    "Contacts".state as "Contact State",
    "Contacts".zip_code as "Contact Zip Code",
    "Contacts".country as "Contact Country",
    "Contacts".mobile_number as "Contact Mobile Number"

           from

          xamplify_test.xa_user_d ud left join xamplify_test.xa_company_d vendor_company on
          ud.company_id=vendor_company.company_id
          left join xamplify_test.xa_user_list_d ul on ud.user_id=ul.customer_id
          left join xamplify_test.xa_user_d ud1 on ul.listby_partner_id=ud1.user_id
          left join xamplify_test.xa_company_d partner_company on partner_company.company_id=ud1.company_id
            left join xamplify_test.xa_user_d ud2 on(partner_company.company_id=ud2.company_id)
      left join xamplify_test.xa_team_member_d tm1 on tm1.team_member_id=ud2.user_id
      left join xamplify_test.xa_user_list_d ul1 on(ul1.customer_id=tm1.team_member_id)
    left join (select * from
(select distinct listby_partner_id ,
    first_name,
    last_name ,
    contact_company ,
    email_id,
    address,
    city,
    state,
    zip_code,
    country,
    mobile_number,
    company_name ,ROW_NUMBER () OVER (PARTITION BY listby_partner_id order by 1,2,3,4,5,6,7,8,9,10 desc nulls last) as row_number1
from xamplify_test.xa_user_list_d where is_partner_userlist='false') c
where row_number1=1) "Contacts" on ("Contacts".listby_partner_id=ul1.listby_partner_id)
      where ul.is_partner_userlist= true
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: Contacts {
    type: count_distinct
    sql: (case when ${is_partner_userlist}=false then ${listby_partner_id} end) ;;
    drill_fields: [Contact_Email_ID,Conatact_Company,Contact_First_Name,Contact_Last_Name,Contact_City
      ,Contact_State,Contact_Adress,Contact_Country,Contact_Zip_Code,Contact_Mobile_Number]
  }


  measure: Contact {
    type: count_distinct
    sql: (case when ${is_partner_userlist}=false then ${listby_partner_id} end) ;;

}
  dimension: Contact_User_ID {
    type: number
    label: "Contact User ID"
    sql: ${TABLE}."Contact User ID" ;;
  }

  dimension: Contact_First_Name {
    type: string
    label: "Contact First Name"
    sql: ${TABLE}."Contact First Name" ;;
  }
  dimension: Contact_Last_Name {
    type: string
    label: "Contact Last Name"
    sql: ${TABLE}."Contact Last Name" ;;
  }
  dimension: Conatact_Company {
    type: string
    label: "Conatact Company"
    sql: ${TABLE}."Conatact Company";;
  }
  dimension: Contact_Email_ID {
    type: string
    label: "Contact Email ID"
    sql: ${TABLE}."Contact Email ID";;
  }

  dimension: Contact_Adress {
    type: string
    label: "Contact Adress"
    sql: ${TABLE}."Contact Adress";;
  }
  dimension: Contact_City {
    type: string
    label: "Contact City"
    sql: ${TABLE}."Contact City";;
  }
  dimension: Contact_State {
    type: string
    label: "Contact State"
    sql: ${TABLE}."Contact State";;
  }
  dimension: Contact_Zip_Code{
    type: string
    label: "Contact Zip Code"
    sql: ${TABLE}."Contact Zip Code";;
  }
  dimension: Contact_Country{
    type: string
    label: "Contact Country"
    sql: ${TABLE}."Contact Country";;
  }
  dimension: Contact_Mobile_Number{
    type: string
    label: "Contact Mobile Number"
    sql: ${TABLE}."Contact Mobile Number";;
  }
  dimension: Team_Member_Name {
    type: string
    sql: concat(${teammember_firstname},${teammember_lastname} ;;
  }

  dimension: vendor_company_id {
    type: number
    label: "vendor company id"
    sql: ${TABLE}."vendor company id" ;;
  }

  dimension: is_partner_userlist {
    type: string
    label: "is partner userlist"
    sql: ${TABLE}."is partner userlist" ;;
  }

  dimension: vendor_company_name {
    type: string
    label: "Vendor Company Name"
    sql: ${TABLE}."Vendor Company Name" ;;
  }

  dimension: partner_company_id {
    type: number
    label: "partner company id"
    sql: ${TABLE}."partner company id" ;;
  }

  dimension: partner_company_name {
    type: string
    label: "Partner Company Name"
    sql: ${TABLE}."Partner Company Name" ;;
  }

  dimension: contact_email_id {
    type: string
    label: "Contact Email Id"
    sql: ${TABLE}."Contact Email Id" ;;
  }

  dimension: listby_partner_id {
    type: number
    label: "listby partner id"
    sql: ${TABLE}."listby partner id" ;;
  }

  dimension_group: list_created{
    type: time
    label: "List Created"
    sql: ${TABLE}."list created time" ;;
  }


  dimension: user_list_name {
    type: string
    label: "User List Name"
    sql: ${TABLE}."user list name" ;;
  }

  dimension: user_list_id {
    type: number
    label: "user list id"
    sql: ${TABLE}."user list id" ;;
  }

  dimension: teammember_firstname {
    type: string
    label: "Team member Firstname"
    sql: ${TABLE}. "Team member Firstname";;
  }

  dimension: teammember_lastname{
    type: string
    label: "Team member Lastname"
    sql: ${TABLE}."Team member Lastname" ;;
  }

  dimension: teammember_email_id {
    type: string
    label: "Team member email_id"
    sql: ${TABLE}."Team member email_id" ;;
  }

  set: detail {
    fields: [
      vendor_company_id,
      is_partner_userlist,
      vendor_company_name,
      partner_company_id,
      partner_company_name,
      contact_email_id,
      listby_partner_id,
      list_created_time,
      user_list_name,
      user_list_id,
      teammember_firstname,
      teammember_lastname,
      teammember_email_id,
      Contact_User_ID,
      Contact_First_Name,
      Contact_Last_Name,
      Conatact_Company,
      Contact_Email_ID,
      Contact_Adress,
      Contact_City,
      Contact_State,
      Contact_Zip_Code,
      Contact_Country,
      Contact_Mobile_Number
    ]
  }
}


explore: email_auto_respones {}
#persist_with: xamplify_default_datagroup
view: email_auto_respones {
  derived_table: {
    sql: select * from xamplify_test.v_responses
       ;;
  }

  parameter: Parameter_Selector {
    label: "Parameter_Selector"

    allowed_value: { value: "Total_Recipients"}
    allowed_value: { value: "Active_Recipients" }
    allowed_value: {value:"Email_NotOpened"}


  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }



  measure: Total_Recipients {
    type: count_distinct
    sql: ${total_recipients} ;;
  }


  measure: Active_Recipients {
    type: count_distinct
    sql: ${active_recipients} ;;
  }

  measure: Email_Opened {
    type: count_distinct
    sql: ${email_Opened_time_minute};;
    drill_fields: [campaign_name,subject,email_Opened_time_minute]
    filters: [email_Opened_time_minute: "-NULL"]
  }

  measure: param {
    type:number
    sql: case when {% parameter Parameter_Selector  %}='Total_Recipients'
             then ${Total_Recipients}
             when {% parameter Parameter_Selector  %}='Active_Recipients'
            then ${Active_Recipients}
            when {% parameter Parameter_Selector %}='Email_NotOpened'
            then ${Email_NotOpened}
            end
            ;;
  }
  measure: param1 {
    type: number
    sql:  case when {% parameter Parameter_Selector  %}='Active_Recipients'
             then ${Website_Responses_EmailOpened}
             when {% parameter Parameter_Selector  %}='Email_NotOpened'
             then ${Website_Visit_Autoresponses}
            end
    ;;
  }

  measure: Email_Clicked{
    type: count_distinct
    sql: ${email_clicked_time_minute} ;;
    drill_fields: [campaign_name,clicked_url_names,email_clicked_time_time]
    filters: [email_clicked_time_time:   "-NULL"]
  }
  measure: Email_Autoresponses {
    type: count_distinct
    sql: ${email_auto_responses} ;;
    drill_fields: [campaign_name,Reason,email_response_reply_in_days,
     email_response_reply_time_time]
  filters: [email_response_reply_time_time: "-NULL"]

  }

  measure: Email_AutoResponses_Opened{
    type: count_distinct
    sql: ${email_auto_responses_opened} ;;
    drill_fields:[campaign_name,Reason,email_response_reply_in_days,
      email_response_reply_time_time,email_auto_responses_opened_time_time,
      Email_AutoResponses_Opened]
    filters: [email_auto_responses_opened_time_time: "-NULL"]
  }

  measure: Website_Visit_Autoresponses{
    type: count_distinct
    sql: ${website_auto_responses} ;;
    drill_fields: [campaign_name,When_To_Send_Email,website_response_reply_in_days,
      website_response_reply_time_time]
    filters: [website_response_reply_time_time: "-NULL"]

  }

  measure: Website_Responses_EmailOpened {
    type: count_distinct
    sql: ${website_auto_responses_opened} ;;
    drill_fields: [campaign_name,When_To_Send_Email,website_response_reply_in_days,
      website_response_reply_time_time,website_auto_responses_opened_time_time,
      Website_Responses_EmailOpened]
    filters: [website_auto_responses_opened_time_time: "-NULL"]
  }

  measure: Campaign_Email_Sent {
    type: count_distinct
    sql: ${campaign_email_sent_id} ;;
    drill_fields: [campaign_name,campaign_email_sent_time_time]
    filters: [campaign_email_sent_time_time: "-NULL"]

  }

  measure: Email_Autoresponses_Sent {
    type: count_distinct
    sql: ${email_response_sent_time_id} ;;
    drill_fields: [campaign_name,Reason,email_response_reply_in_days,
      email_response_sent_time_time,
      Email_Autoresponses_Sent]
    filters: [email_response_sent_time_time: "-NULL"]
  }


  measure: Web_Autoresponses_Sent{
    type: count_distinct
    sql: ${website_response_sent_time_id} ;;
    drill_fields: [campaign_name,When_To_Send_Email,website_response_reply_in_days,
      website_response_reply_time_time,website_response_sent_time_time]
    filters: [website_response_sent_time_time: "-NULL"]

  }


  measure: Active_Recipients_Percent{
    type: number
    sql: Round(100.00* ${Active_Recipients}/NULLIF (${Total_Recipients},0)) ;;
    value_format: "0\%"
  }

  measure: Email_NotOpened {
    type: number
    sql: ${Total_Recipients}-${Active_Recipients} ;;
  }

  measure: Email_NotOpened_Percent{
    type: number
    sql:  Round(100.00* ${Email_NotOpened}/NULLIF(${Total_Recipients},0)) ;;
    value_format: "0\%"
  }

  measure:Campaigns{
    type: count_distinct
    sql: ${campaign_id} ;;
    drill_fields: [campaign_name,launch_time_time,
      campaign_email_sent_time_time]
  }

  dimension: Reason{
    type: string
    sql: case when ${email_response_reason}=0 then 'Email is Not Opened'
              when ${email_response_reason}=13 then 'Email is Opened'
              when ${email_response_reason}=16 then 'Send immediately after email is opened'
              end
              ;;
  }

  dimension: When_To_Send_Email{
    type: string
    sql:  case when ${website_response_reason}=19 then 'Send if Not Clicked'
               when ${website_response_reason}=20 then 'Send immediately after clicked'
               when ${website_response_reason}=21 then 'Schedule'
               end
               ;;

    }

  dimension: vendor_company_name {
    type: string
    label: "Vendor Company Name"
    sql: ${TABLE}."Vendor Company Name" ;;
    suggest_persist_for: "2 hours"
  }

  dimension: partner_company_name {
    type: string
    label: "Partner Company Name"
    sql: ${TABLE}."Partner Company Name" ;;
    suggest_persist_for: "2 hours"
  }

  dimension: campaign_id {
    type: number
    label: "Campaign ID"
    sql: ${TABLE}."Campaign ID" ;;
  }

  dimension: campaign_name {
    type: string
    label: "Campaign Name"
    sql: ${TABLE}."Campaign Name" ;;
    suggest_persist_for: "2 hours"
  }

  dimension_group: launch_time {
    type: time
    label: "Launch"
    sql: ${TABLE}."Launch Time" ;;
  }

  dimension: total_recipients {
    type: number
    label: "#Total Recipients"
    sql: ${TABLE}."#Total Recipients" ;;
  }



  dimension: email_id {
    type: string
    label: "Email ID"
    sql: ${TABLE}."Email ID" ;;
    drill_fields: [first_name,last_name,phone,address,country,state,city]
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

  dimension: company_name {
    type: string
    label: "Company Name"
    sql: ${TABLE}."Company Name" ;;
  }

  dimension: phone {
    type: string
    sql: ${TABLE}."Phone" ;;
  }

  dimension: address {
    type: string
    sql: ${TABLE}."Address" ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}."City" ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}."State" ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}."Country" ;;
  }

  dimension: active_recipients {
    type: number
    label: "#Active Recipients"
    sql: ${TABLE}."#Active Recipients" ;;
  }


  dimension : email_opened_views {
    type: number
    label: "#Email Opened (Views)"
    sql: ${TABLE}."#Email Opened (Views)" ;;
  }


  dimension: email_clicked {
    type: number
    label: "#Email Clicked"
    sql: ${TABLE}."#Email Clicked" ;;
  }

  dimension_group: email_Opened_time {
    type: time
    label: "Email Opened"
    sql: ${TABLE}."#Email Opened Time" ;;

  }

  dimension_group: email_clicked_time {
    type: time
    label: "Email Clicked"
    sql: ${TABLE}."#Email Clicked Time" ;;
  }

  dimension: email_auto_responses {
    type: number
    label: "#Email Auto Responses"
    sql: ${TABLE}."#Email Auto Responses" ;;
  }

  dimension: email_response_reason {
    type: number
    label: "Email Response Reason"
    sql: ${TABLE}."Email Response Reason" ;;
  }

  dimension: email_response_reply_in_days {
    type: number
    label: "Email Response Reply In Days"
    sql: ${TABLE}."Email Response Reply In Days" ;;
  }

  dimension_group: email_response_reply_time {
    type: time
    label: "Email Response Reply"
    sql: ${TABLE}."Email Response Reply Time" ;;
  }

  dimension: email_auto_responses_opened {
    type: number
    label: "#Email Auto Responses Opened"
    sql: ${TABLE}."#Email Auto Responses Opened" ;;
  }

  dimension_group: email_auto_responses_opened_time {
    type: time
    label: "Email Auto Responses Opened"
    sql: ${TABLE}."Email Auto Responses Opened Time" ;;
  }

  dimension: email_response_sent_time_id {
    type: number
    label: "#Email Response Sent Time ID"
    sql: ${TABLE}."#Email Response Sent Time ID" ;;
  }

  dimension_group: email_response_sent_time {
    type: time
    label: "Email Response Sent"
    sql: ${TABLE}."Email Response Sent Time" ;;
  }

  dimension: website_auto_responses {
    type: number
    label: "#Website Auto Responses"
    sql: ${TABLE}."#Website Auto Responses" ;;
  }

  dimension: website_response_reason {
    type: number
    label: "Website Response Reason"
    sql: ${TABLE}."Website Response Reason" ;;
  }

  dimension: website_response_reply_in_days {
    type: number
    label: "Website Response Reply In Days"
    sql: ${TABLE}."Website Response Reply In Days" ;;
  }

  dimension_group: website_response_reply_time {
    type: time
    label: "Website Response Reply"
    sql: ${TABLE}."Website Response Reply Time" ;;
  }

  dimension: website_auto_responses_opened {
    type: number
    label: "#Website Auto Responses Opened"
    sql: ${TABLE}."#Website Auto Responses Opened" ;;
  }

  dimension_group: website_auto_responses_opened_time {
    type: time
    label: "Website Auto Responses Opened"
    sql: ${TABLE}."Website Auto Responses Opened Time" ;;
  }

  dimension: website_response_sent_time_id {
    type: number
    label: "#Website Response Sent Time ID"
    sql: ${TABLE}."#Website Response Sent Time ID" ;;
  }

  dimension_group: website_response_sent_time {
    type: time
    label: "Website Response Sent"
    sql: ${TABLE}."Website Response Sent Time" ;;
  }

  dimension: campaign_email_sent_id {
    type: number
    label: "#Campaign Email Sent Id"
    sql: ${TABLE}."#Campaign Email Sent Id" ;;
  }

  dimension_group: campaign_email_sent_time {
    type: time
    label: "Campaign Email Sent"
    sql: ${TABLE}."Campaign Email Sent Time" ;;
  }

  dimension: subject {
    type: string
    sql: ${TABLE}."Subject" ;;
  }

  dimension: clicked_url_names {
    type: string
    label: "Clicked URL Names"
    sql: ${TABLE}."Clicked URL Names" ;;
  }

  set: detail {
    fields: [
      vendor_company_name,
      partner_company_name,
      campaign_id,
      campaign_name,
      launch_time_time,
      total_recipients,
      email_id,
      first_name,
      last_name,
      company_name,
      phone,
      address,
      city,
      state,
      country,
      active_recipients,
      email_opened_views,
      email_clicked,
      email_Opened_time_time,
      email_clicked_time_time,
      email_auto_responses,
      email_response_reason,
      email_response_reply_in_days,
      email_response_reply_time_time,
      email_auto_responses_opened,
      email_auto_responses_opened_time_time,
      email_response_sent_time_id,
      email_response_sent_time_time,
      website_auto_responses,
      website_response_reason,
      website_response_reply_in_days,
      website_response_reply_time_time,
      website_auto_responses_opened,
      website_auto_responses_opened_time_time,
      website_response_sent_time_id,
      website_response_sent_time_time,
      campaign_email_sent_id,
      campaign_email_sent_time_time,
      subject,
      clicked_url_names
    ]
  }
}



explore:auto_responses_summary  {}
view: auto_responses_summary {
  derived_table: {
    sql: select * from xamplify_test.v_responses
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: Total_Recipients{
    type: count_distinct
    sql: ${total_recipients} ;;
  }


  measure: Active_Recipients {
    type: count_distinct
    sql: ${active_recipients} ;;
  }

  measure: Email_Opened {
    type: count_distinct
    sql: ${email_opened_views} ;;
  }

  measure: Email_Clicked {
    type: count_distinct
    sql: ${email_clicked} ;;
  }

  measure: Email_Auto_Responses {
    type: count_distinct
    sql: ${email_auto_responses} ;;
  }

  measure: Email_Auto_Responses_Opened {
    type: count_distinct
    sql: ${email_auto_responses_opened} ;;
    drill_fields: [Reason,email_response_reply_in_days,email_response_reply_time_date,Email_Auto_Response_Opened_time_minute]
    link:{
      label:"Email Auto Responses Opened"
      url: "https://stratappspartner.looker.com/dashboards/53?Vendor%20Company%20Name={{_filters['auto_responses_summary.vendor_company_name'] | url_encode }}
      &Partner%20Company%20Name={{_filters['auto_responses_summary.partner_company_name'] | url_encode }}
      &Campaign%20Name={{ _filters['auto_responses_summary.campaign_name'] | url_encode }}"
    }
  }
   measure: Campaign_Email_Sent {
     type: count_distinct
    sql: ${campaign_email_sent_id} ;;
   }

  measure: Website_Auto_Responses {
    type:  count_distinct
    sql: ${website_auto_responses} ;;
  }

  measure: Website_Auto_Responses_Opened {
    type: count_distinct
    sql: ${website_auto_responses_opened} ;;
    drill_fields: [When_To_Send_Email,website_response_reply_in_days,website_response_reply_time_date,Website_Auto_Response_Opened_time_minute]
    link:{
      label:"Website Auto Responses Opened"
      url: "https://stratappspartner.looker.com/dashboards/54?Vendor%20Company%20Name={{_filters['auto_responses_summary.vendor_company_name'] | url_encode }}
      &Partner%20Company%20Name={{_filters['auto_responses_summary.partner_company_name'] | url_encode }}
      &Campaign%20Name={{ _filters['auto_responses_summary.campaign_name'] | url_encode }}"
      }
  }

  measure: Website_Auto_Responses_Sent {
    type: count_distinct
    sql: ${website_response_sent_time_id} ;;
  }

  measure: Email_Auto_Respoonses_Sent {
    type: count_distinct
    sql: ${email_response_sent_time_id} ;;
  }


  measure: Active_Recipients_Percent{
    type: number
    sql: Round(100.00* ${Active_Recipients}/NULLIF (${Total_Recipients},0)) ;;
    value_format: "0\%"
  }

  measure: Email_Not_Opened {
    type: number
    sql: ${Total_Recipients}-${Active_Recipients} ;;
  }

  measure: Email_Not_Opened_Percent{
    type: number
   sql:  Round(100.00* ${Email_Not_Opened}/NULLIF(${Total_Recipients},0)) ;;
  value_format: "0\%"
  }



  measure:Campaigns{
    type: count_distinct
    sql: ${campaign_id} ;;
    drill_fields: [partner_company_name,campaign_name,launch_time_date]
  }

  dimension: Reason{
    type: string
    sql: case when ${email_response_reason}=0 then 'Email is Not Opened'
              when ${email_response_reason}=13 then 'Email is Opened'
              when ${email_response_reason}=16 then 'Send immediately after email is opened ' end
              ;;
  }

  dimension: When_To_Send_Email{
    type: string
    sql:  case when ${website_response_reason}=19 then 'Send if Not Clicked'
               when ${website_response_reason}=20 then 'Send immediately after clicked'
               when ${website_response_reason}=21 then 'Schedule'
               end
               ;;

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

    link:{
      label:"Partner User Analytics"
      url: "https://stratappspartner.looker.com/dashboards/48?Vendor%20Company%20Name={{_filters['auto_responses_summary.vendor_company_name'] | url_encode }}&Partner%20Company%20Name={{ value | encode_uri }}"
      icon_url: "http://www.looker.com/favicon.ico"
    }

  }

  dimension: campaign_id {
    type: number
    label: "Campaign ID"
    sql: ${TABLE}."Campaign ID" ;;
  }

  dimension: campaign_name {
    type: string
    label: "Campaign Name"
    sql: ${TABLE}."Campaign Name" ;;
    link:{
      label:"Campaign User Analytics"
      url: "https://stratappspartner.looker.com/dashboards/48?Vendor%20Company%20Name={{_filters['auto_responses_summary.vendor_company_name'] | url_encode }}&Partner%20Company%20Name={{_filters['auto_responses_summary.partner_company_name'] | url_encode }}&Campaign%20Name={{ value | encode_uri }}"
    }

  }

  dimension_group: launch_time {
    type: time
    label: "Launch Time"
    sql: ${TABLE}."Launch" ;;
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

  dimension : email_opened_views {
    type: number
    label: "#Email Opened (Views)"
    sql: ${TABLE}."#Email Opened (Views)" ;;
  }


  dimension: email_clicked {
    type: number
    label: "#Email Clicked"
    sql: ${TABLE}."#Email Clicked" ;;
  }

  dimension_group: email_Opened_time {
    type: time
    label: "Email Opened"
    sql: ${TABLE}."#Email Opened Time" ;;

  }

  dimension_group: email_clicked_time {
    type: time
    label: "Email Clicked"
    sql: ${TABLE}."#Email Clicked Time" ;;
  }


  dimension: email_auto_responses {
    type: number
    label: "#Email Auto Responses"
    sql: ${TABLE}."#Email Auto Responses" ;;
  }

  dimension: email_response_reason {
    type: number
    label: "Email Response Reason"
    sql: ${TABLE}."Email Response Reason" ;;
  }

  dimension: email_response_reply_in_days {
    type: number
    label: "Email Response Reply In Days"
    sql: ${TABLE}."Email Response Reply In Days" ;;
  }

  dimension_group: email_response_reply_time {
    type: time
    label: "Email Response Reply"
    sql: ${TABLE}."Email Response Reply Time" ;;
  }

  dimension: email_auto_responses_opened {
    type: number
    label: "#Email Auto Responses Opened"
    sql: ${TABLE}."#Email Auto Responses Opened" ;;
  }

  dimension: email_response_sent_time_id {
    type: number
    label: "#Email Response Sent Time ID"
    sql: ${TABLE}."#Email Response Sent Time ID" ;;
  }

  dimension: website_auto_responses {
    type: number
    label: "#Website Auto Responses"
    sql: ${TABLE}."#Website Auto Responses" ;;
  }

  dimension: website_response_reason {
    type: number
    label: "Website Response Reason"
    sql: ${TABLE}."Website Response Reason" ;;
  }

  dimension: website_response_reply_in_days {
    type: number
    label: "Website Response Reply In Days"
    sql: ${TABLE}."Website Response Reply In Days" ;;
  }

  dimension_group: website_response_reply_time {
    type: time
    label: "Website Response Reply"
    sql: ${TABLE}."Website Response Reply Time" ;;
  }

  dimension: website_auto_responses_opened {
    type: number
    label: "#Website Auto Responses Opened"
    sql: ${TABLE}."#Website Auto Responses Opened" ;;
  }

  dimension: website_response_sent_time_id {
    type: number
    label: "#Website Response Sent Time ID"
    sql: ${TABLE}."#Website Response Sent Time ID" ;;
  }

  dimension: campaign_email_sent_id {
    type: number
    label: "#Campaign Email Sent Id"
    sql: ${TABLE}."#Campaign Email Sent Id" ;;
  }

  dimension_group: Email_Auto_Response_Opened_time {
    type: time
    label: "Auto Responses Opened"
    sql: ${TABLE}."Email Auto Responses Opened Time" ;;
  }

  dimension_group: Website_Auto_Response_Opened_time {
    type: time
    label: "Website Responses Opened"
    sql: ${TABLE}."Website Auto Responses Opened Time" ;;
  }



  set: detail {
    fields: [
      vendor_company_name,
      partner_company_name,
      campaign_id,
      campaign_name,
      launch_time_time,
      total_recipients,
      active_recipients,
      email_opened_views,
      email_clicked,
      email_Opened_time_time,
      email_clicked_time_time,
      email_auto_responses,
      email_response_reason,
      email_response_reply_in_days,
      email_response_reply_time_time,
      email_auto_responses_opened,
      email_response_sent_time_id,
      website_auto_responses,
      website_response_reason,
      website_response_reply_in_days,
      website_response_reply_time_time,
      website_auto_responses_opened,
      website_response_sent_time_id,
      campaign_email_sent_id,
      Email_Auto_Response_Opened_time_date,
      Website_Auto_Response_Opened_time_date
    ]
  }
}

explore: partner_analytics {}
view: partner_analytics {
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
      order by 1,2
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: Total_Redistributed_Campaigns{
    type: count_distinct
    sql: ${campaign_id};;
    drill_fields: [campaign_name,campaign_type,launch_time_time]
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
    label: "Registered"
    sql: ${TABLE}."Registered Date" ;;
  }

  dimension_group: last_login_date {
    type: time
    label: "Last Login"
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
    label: "Second Campaign Launch"
    sql: ${TABLE}."Second Campaign Launch Time" ;;
  }

  dimension: recent_campaign_name {
    type: string
    label: "Recent Campaign Name"
    sql: ${TABLE}."Recent Campaign Name" ;;
  }

  dimension_group: recent_campaign_launch_time {
    type: time
    label: "Recent Campaign Launch"
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
    sql: ${TABLE}."Launch" ;;
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

explore:  partner_analytics_details  {}
view: partner_analytics_details {
  derived_table: {
    sql: select
      cp.company_name as "Vendor Company Name",
      cp1.company_name as "Partner Company Name",
      c.campaign_id,
      c.campaign_name as "Redistributed Campaign Name",
      c.launch_time as "Redistributed Date",
      c.is_launched as "Is_Launched",
      cul.user_id as "#Total Recipients",
      el.user_id as "#Active Recipients",
       case when el.action_id = 13 and el.url_id is null and el.reply_id is null and el.video_id is null
      then el.user_id end "#Email Opened",
      case when (el.action_id = 14 or el.action_id = 15) and el.url_id is null and el.reply_id is null
      then el.user_id end "#Email Clicked",
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
      and c.is_launched=true
      and c.launch_time is not null
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: Total_Recipients {
    type: count_distinct
    sql: ${total_recipients} ;;
  }

  measure: Active_Recipients {
    type: count_distinct
    sql: ${active_recipients} ;;
  }

  measure: Email_Opened {
    type: count_distinct
    sql: ${email_opened} ;;
  }
  measure: Email_clicked {
    type: count_distinct
    sql: ${email_clicked} ;;
  }
  measure: Auto_Responses_Opened {
    type: count_distinct
    sql: ${auto_responses_opened} ;;
  }

  measure: Leads {
    type: count_distinct
    sql: ${leads} ;;
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
    label: "Redistributed"
    sql: ${TABLE}."Redistributed Date" ;;

  }

  dimension: is_launched {
    type: string
    label: "Is_Launched"
    sql: ${TABLE}."Is_Launched" ;;
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
    label: "#Email Opened"
    sql: ${TABLE}."#Email Opened" ;;
  }

  dimension: email_clicked {
    type: number
    label: "#Email Clicked"
    sql: ${TABLE}."#Email Clicked" ;;
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
      is_launched,
      total_recipients,
      active_recipients,
      email_opened,
      email_clicked,
      auto_responses_opened,
      leads
    ]
  }
}


explore: vendor_partners1 {}
view: vendor_partners1 {
  derived_table: {
    sql:with a as (
      select * from (
      select * from (
with pc1 as(
select  v_com,customer_id,company_id,p_com,user_id,email_id,firstname,lastname,datereg,datelastlogin
,campaign_name as first_campaign_name,launch_time as first_campaign_launch_time,"OrgAdmin",is_launched from (
select distinct xcp.company_name as v_com ,xc1.customer_id,xup1.user_id,xup1.email_id,xup1.firstname,xup1.lastname,xup1.datereg,xup1.datelastlogin
,xup1.company_id,xcp1.company_name as p_com,xc1.campaign_name,xc1.launch_time,"OrgAdmin".email_id as "OrgAdmin",xc1.is_launched
,row_number()over(partition by xup1.company_id order by xc1.launch_time) rn
from xamplify_test."xa_campaign_d" xc
LEFT JOIN xamplify_test."xa_user_d" "xup" ON (xc."customer_id" = "xup"."user_id")
LEFT JOIN xamplify_test."xa_company_d" "xcp" ON ("xup"."company_id" = "xcp"."company_id")
LEFT JOIN xamplify_test."xa_campaign_d" "xc1" ON ("xc"."campaign_id" = "xc1"."parent_campaign_id")
left JOIN xamplify_test."xa_user_d" "xup1" ON ("xc1"."customer_id" = "xup1"."user_id")
LEFT JOIN xamplify_test."xa_company_d" "xcp1" ON ("xup1"."company_id" = "xcp1"."company_id")
left join (select * from xamplify_test.xa_user_d where user_id in
       (select user_id from xamplify_test.xa_user_role_d where role_id=12  )) "OrgAdmin" On("OrgAdmin".company_id="xcp1"."company_id")
  where xc1.is_launched='true'
) fc where rn = 1),
pc2 as (
select  v_com,customer_id,company_id,p_com,user_id,email_id,firstname,lastname,datereg,datelastlogin
,campaign_name as second_campaign_name,launch_time as second_campaign_launch_time from (
select distinct xcp.company_name as v_com ,xc1.customer_id,xup1.user_id,xup1.email_id,xup1.firstname,xup1.lastname,xup1.datereg,xup1.datelastlogin
,xup1.company_id,xcp1.company_name as p_com,xc1.campaign_name,xc1.launch_time
,row_number()over(partition by xup1.company_id order by xc1.launch_time) rn
from xamplify_test."xa_campaign_d" xc
LEFT JOIN xamplify_test."xa_user_d" "xup" ON (xc."customer_id" = "xup"."user_id")
LEFT JOIN xamplify_test."xa_company_d" "xcp" ON ("xup"."company_id" = "xcp"."company_id")
LEFT JOIN xamplify_test."xa_campaign_d" "xc1" ON ("xc"."campaign_id" = "xc1"."parent_campaign_id")
left JOIN xamplify_test."xa_user_d" "xup1" ON ("xc1"."customer_id" = "xup1"."user_id")
LEFT JOIN xamplify_test."xa_company_d" "xcp1" ON ("xup1"."company_id" = "xcp1"."company_id")
  where xc1.is_launched='true'
) sc where rn = 2
order by p_com),
pc3 as (
select v_com,customer_id,company_id,p_com,user_id,email_id,firstname,lastname,datereg,datelastlogin
,campaign_name as recent_campaign_name,launch_time as recent_campaign_launch_time from (
select distinct xcp.company_name as v_com ,xc1.customer_id,xup1.user_id,xup1.email_id,xup1.firstname,xup1.lastname,xup1.datereg,xup1.datelastlogin
,xup1.company_id,xcp1.company_name as p_com,xc1.campaign_name,xc1.launch_time
,row_number()over(partition by xup1.company_id order by xc1.launch_time desc) rn
from xamplify_test."xa_campaign_d" xc
LEFT JOIN xamplify_test."xa_user_d" "xup" ON (xc."customer_id" = "xup"."user_id")
LEFT JOIN xamplify_test."xa_company_d" "xcp" ON ("xup"."company_id" = "xcp"."company_id")
LEFT JOIN xamplify_test."xa_campaign_d" "xc1" ON ("xc"."campaign_id" = "xc1"."parent_campaign_id")
left JOIN xamplify_test."xa_user_d" "xup1" ON ("xc1"."customer_id" = "xup1"."user_id")
LEFT JOIN xamplify_test."xa_company_d" "xcp1" ON ("xup1"."company_id" = "xcp1"."company_id")
  where xc1.is_launched='true'
) rc where rn = 1
order by p_com)
select distinct pc1.v_com as "Vendor Company Name",pc1.company_id,pc1.p_com as "Partner Company Name",pc1.user_id as "User ID" ,pc1.email_id as "Email ID"
,pc1.firstname as "First Name",pc1.lastname "Last Name",pc1.datereg as "Registered Date",pc1.datelastlogin as "Last Login Date"
  ,pc1."OrgAdmin",pc1."is_launched"
,pc1.first_campaign_name as "First Campaign Name",pc1.first_campaign_launch_time as "First Campaign Launch Time"
,pc2.second_campaign_name as "Second Campaign Name",pc2.second_campaign_launch_time as "Second Campaign Launch Time"
,pc3.recent_campaign_name as "Recent Campaign Name",pc3.recent_campaign_launch_time as "Recent Campaign Launch Time"
from pc1 left join pc2 on pc1.company_id = pc2.company_id
left join pc3 on (pc3.company_id = pc2.company_id or pc3.company_id=pc1.company_id)
order by pc1.v_com,pc1.p_com) total
      union all
      select * from (
      with a as (
      select distinct xp.vendor_company_id,xcp.company_name as v_com,xp.partner_company_id,xcp1.company_name as p_com,xup1.user_id,xup1.email_id
      ,xup1.firstname,xup1.lastname,xup1.datereg,xup1.datelastlogin
      from xt_user_profile xup
      left join xamplify_test.xa_company_d xcp on xcp.company_id = xup.company_id
      left join xamplify_test.xa_partnership_d xp on xp.vendor_company_id = xcp.company_id
      left join xamplify_test.xa_user_d xup1 on xup1.user_id = xp.partner_id
      left join xamplify_test.xa_company_d xcp1 on xcp1.company_id = xup1.company_id
      where xcp1.company_id is not null
      ),
      b as (
      select xc.vendor_organization_id,xup.company_id,xc.campaign_id,xc.is_launched
      from xamplify_test.xa_campaign_d xc
      left join xamplify_test.xa_user_d xup on xup.user_id = xc.customer_id
      where xc.parent_campaign_id is not null
      and is_launched='false'
      and company_id not in (select company_id from xamplify_test.xa_campaign_d c inner join xamplify_test.xa_user_d up
                 on (c.customer_id=up.user_id) where parent_campaign_id is not null
    and is_launched='true')
      union
            select distinct ud.company_id,ud1.company_id,null::integer,null::boolean
      from xamplify_test.xa_user_d ud inner join xamplify_test.xa_user_list_d ul
      on(ud.user_id=ul.customer_id)
      inner join xamplify_test.xa_user_d ud1 on(ud1.user_id=ul.listby_partner_id)
      and ud1.company_id not in (select company_id from xamplify_test.xa_campaign_d c inner join xamplify_test.xa_user_d up
                 on (c.customer_id=up.user_id) where parent_campaign_id is not null
    and is_launched='true') )
      select distinct a.v_com,a.partner_company_id,a.p_com,a.user_id,a.email_id,a.firstname,a.lastname,a.datereg,a.datelastlogin,null::text,b.is_launched
      ,null::text,null::timestamp,null::text,null::timestamp,null::text,null::timestamp
      from a inner join b on a.partner_company_id = b.company_id and a.vendor_company_id = b.vendor_organization_id
      where a.partner_company_id is not null
      and b.campaign_id is null
      ) as inactive
      union all
      select distinct xcp.company_name,xcp1.company_id,xcp1.company_name,xup1.user_id,xup1.email_id,xup1.firstname,xup1.lastname,xup1.datereg,xup1.datelastlogin
     ,null::text,null::boolean,null::text,null::timestamp,null::text,null::timestamp,null::text,null::timestamp
      from xamplify_test.xa_partnership_d xp
      left join xamplify_test.xa_company_d xcp on xcp.company_id = xp.vendor_company_id
      left join xamplify_test.xa_user_d xup1 on xup1.user_id = xp.partner_id
      left join xamplify_test.xa_company_d xcp1 on xcp1.company_id = xup1.company_id
      where partner_company_id is null
      ) as incomplete
      ),
      b as (
      select  xup.company_id,xc.campaign_id,xc.campaign_name,xc.campaign_type,xc.launch_time
      from xamplify_test.xa_campaign_d xc
      left join xamplify_test.xa_user_d xup on xc.customer_id = xup.user_id
      where xc.is_nurture_campaign and xc.parent_campaign_id is not null
      )
      select distinct a.*,b.campaign_id,b.campaign_name as "Campaign Name",b.campaign_type as "Campaign Type",b.launch_time as "Launch Time"
      from a left join b on a.company_id = b.company_id
      order by 1,2
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }
  measure: Active_Partners{
    type: count_distinct
    sql: case when ${campaign_id} is not null then ${company_id} end  ;;
    drill_fields: [partner_company_name,Patner_Email_ID,Redistributed_campaigns,recent_campaign_name,
      recent_campaign_launch_time,first_campaign_name,first_campaign_launch_time]
  }

  measure: InActive_Partners{
    type: count_distinct
    sql: case when ${campaign_id} is  null then ${company_id} end  ;;
    drill_fields:[partner_company_name,first_name,last_name,email_id,registered_date_time]
  }

  measure: Total_Partners{
    type: count_distinct
    sql: ${user_id} ;;
    drill_fields: [user_id,partner_company_name,first_name,last_name,email_id,registered_date_time]
  }

  measure:Partners_with_companies{
    type: count_distinct
    sql: case when ${company_id} is not null then ${user_id} end  ;;
    drill_fields:[partner_company_name,first_name,last_name,email_id,registered_date_time]
  }
  measure:Partners_without_companies{
    type: count_distinct
    sql: case when ${company_id} is  null then ${user_id} end  ;;
    drill_fields: [user_id,partner_company_name,first_name,last_name,email_id,registered_date_time]
  }
  measure: Redistributed_campaigns{
    type: count_distinct
    sql: ${campaign_name};;
    drill_fields: [campaign_name,campaign_type,launch_time_time]
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
  dimension: is_launched {
    type: string
    label: "is_launched"
    sql: ${TABLE}."is_launched" ;;
  }

  dimension: user_id {
    type: string
    label: "User ID"
    sql: ${TABLE}."User ID" ;;
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
    label: "Registered"
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

  dimension_group: first_campaign_launch {
    type: time
    label: "First Campaign Launch"
    sql: ${TABLE}."First Campaign Launch Time" ;;
  }

  dimension: second_campaign_name {
    type: string
    label: "Second Campaign Name"
    sql: ${TABLE}."Second Campaign Name" ;;
  }

  dimension_group: second_campaign_launch {
    type: time
    label: "Second Campaign Launch"
    sql: ${TABLE}."Second Campaign Launch Time" ;;
  }

  dimension: recent_campaign_name {
    type: string
    label: "Recent Campaign Name"
    sql: ${TABLE}."Recent Campaign Name" ;;
  }

  dimension_group: recent_campaign_launch {
    type: time
    label: "Recent Campaign Launch"
    sql: ${TABLE}."Recent Campaign Launch Time" ;;
  }
  dimension: Patner_Email_ID{
    type: string
    sql: ${TABLE}."OrgAdmin" ;;
  }

  dimension: campaign_id {
    type: string
    sql: ${TABLE}."campaign_id" ;;
  }

  dimension: campaign_name {
    type: string
    label: "Campaign Name"
    sql: ${TABLE}."Campaign Name" ;;
     link:{

      label:"{{value}} Partner Dashboard"
      url: "https://stratappspartner.looker.com/dashboards/16?Vendor%20Company%20Name={{_filters['vendor_partners1.vendor_company_name'] | encode_uri }}&Campaign%20Name={{ value | encode_uri }}"
      icon_url: "http://www.looker.com/favicon.ico"
    }

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
      first_campaign_launch_time,
      second_campaign_name,
      second_campaign_launch_time,
      recent_campaign_name,
      recent_campaign_launch_time,
      campaign_id,
      campaign_name,
      campaign_type,
      launch_time_time,
      Patner_Email_ID,
      is_launched,
      user_id
    ]
  }
}
explore:sendgrid  {}
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
      inner join xamplify_test.xa_campaign_user_userlist_d cuul on (cuul.campaign_id=ca1.campaign_id)
      left join xamplify_test.xa_sendgrid_d sg on (sg.user_id=cuul.user_id)
      left join xamplify_test.xa_user_d ud3 on (ud3.user_id=cuul.user_id)
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }
  measure: Redistributed_Campaigns{
    type: count_distinct
    sql: ${redistributed_campaign_id} ;;
  }

  measure: Total_Recipients{
    type: count_distinct
    sql: ${partner_recieved_users} ;;
  }
  measure: Bounce_users {
    type: count_distinct
    sql: case when ${bounce}=true then ${send_grid_users}  end;;
  }
  measure: Block_users {
    type: count_distinct
    sql: case when ${block}=true then ${send_grid_users}  end;;
  }
  measure: Spam_users {
    type: count_distinct
    sql: case when ${spam}=true then ${send_grid_users}  end;;
  }
  measure: Invalid_Users{
    type: count_distinct
    sql: case when ${is_email_valid}=false then ${partner_recieved_users}  end;;
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

explore:sendgrid1  {}
view: sendgrid1 {
  derived_table: {
    sql:select
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
      sp.email "Spamed Email",
      ud3.email_id "User Email",
      bl.reason "Blocked Reason",
      bo.reason "Bounced Reason",
      cuul.user_id as "Contact User ID",
cuul1.contact_company as "Contact Company",
cuul1.email_id as "Contact Email ID",
cuul1.contact_first_name as "Contact First Name",
cuul1.contact_last_name as "Contact Last Name",
cuul1.contact_mobile_number as "Contact Mobile Number",
cuul1.contact_country as "Contact Country",
cuul1.contact_state as "Contact State",
cuul1.contact_city as "Contact City",
cuul1.contact_zip as "Contact Zip Code"
      from xamplify_test.xa_user_d ud
      left outer join xamplify_test.xa_company_d cp on(ud.company_id=cp.company_id)
      left outer join xamplify_test.xa_campaign_d ca on(ca.customer_id=ud.user_id)
      left outer join xamplify_test.xa_campaign_d ca1 on(ca1.parent_campaign_id=ca.campaign_id)
      left outer join xamplify_test.xa_user_d ud1 on(ud1.user_id=ca1.customer_id)
      left outer join xamplify_test.xa_company_d cp1 on(cp1.company_id=ud1.company_id)
      left outer join
      xamplify_test.xa_campaign_user_userlist_d
      cuul on (cuul.campaign_id=ca1.campaign_id)
    left outer join (select distinct user_id,
 max(contact_company) "contact_company",max(email_id) "email_id",max(contact_first_name) "contact_first_name",
           max(contact_last_name)"contact_last_name",max(contact_mobile_number)"contact_mobile_number",
max(contact_country)"contact_country",max(contact_state)"contact_state",max(contact_city)"contact_city",
           max(contact_zip)"contact_zip"
      from
      xamplify_test.xa_campaign_user_userlist_d group by 1)cuul1 on(
                                      cuul.user_id=cuul1.user_id)
      left outer join xamplify_test.xa_user_d ud3 on(ud3.user_id=cuul1.user_id)
      left outer join xamplify_test.xa_bounce_d bo on(bo.email=ud3.email_id)
     left outer join xamplify_test.xa_block_d bl on (bl.email=ud3.email_id)
     left outer join xamplify_test.xa_spam_d sp on (sp.email=ud3.email_id)
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }
  measure: Blocked_User{
    type: count_distinct
    sql: case when ${Blocked}<=3 then ${blocked_email} end ;;
    drill_fields: [blocked_email,partner_company_name,redistributed_campaign_name,
      redistributed_launch_time_time,blocked_time_time,Blocked_Reason]
  }
  measure: Spam_User{
    type: count_distinct
    sql: case when  ${Spamed}<=3 then ${spamed_email} end ;;
    drill_fields: [spamed_email,partner_company_name,redistributed_campaign_name,
      redistributed_launch_time_time,spamed_time_time]
  }
  measure: Bounced_User{
    type: count_distinct
    sql: case when  ${Bounced}<=3 then ${bounced_email} end ;;
    drill_fields: [bounced_email,partner_company_name,redistributed_campaign_name,
      redistributed_launch_time_time,bounced_time_time,Bounced_Reason]
  }
  measure: Total_User {
    type: count_distinct
    sql:
     ${contact_user_id}  ;;
    drill_fields: [User_Email,partner_company_name,contact_mobile_number,contact_country,contact_state,
                   contact_city]



  }

  dimension: Blocked {
    type: number
    sql: case when ${redistributed_launch_time_raw} <=${blocked_time_raw}
     then ( DATE_PART('year',age(${blocked_time_raw},${redistributed_launch_time_raw}))*12*30*24+
    date_part('month',age(${blocked_time_raw},${redistributed_launch_time_raw}))*30*24+

    DATE_PART('day',age(${blocked_time_raw},${redistributed_launch_time_raw}))*24+
DATE_PART('hour', age(${blocked_time_raw},${redistributed_launch_time_raw}) ) ) end;;

  }
  dimension: Bounced {
    type: number
    sql: case when ${redistributed_launch_time_raw}<=${bounced_time_raw}
           then (DATE_PART('year',age(${bounced_time_raw},${redistributed_launch_time_raw}))*12*30*24+
          DATE_PART('month',age(${bounced_time_raw},${redistributed_launch_time_raw}))*24*30+
          DATE_PART('day',age(${bounced_time_raw},${redistributed_launch_time_raw}))*24+
      DATE_PART('hour', age(${bounced_time_raw},${redistributed_launch_time_raw}) ) ) end;;

    }
  dimension: Spamed {
    type: number
    sql: case when ${redistributed_launch_time_raw}<=${spamed_time_raw}
           then (  DATE_PART('year',age(${spamed_time_raw},${redistributed_launch_time_raw}))*24*30*12+
          DATE_PART('month',age(${spamed_time_raw},${redistributed_launch_time_raw}))*24*30+
          DATE_PART('day',age(${spamed_time_raw},${redistributed_launch_time_raw}))*24+
      DATE_PART('hour',age( ${spamed_time_raw},${redistributed_launch_time_raw})) ) end;;

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
    label: "Redistributed Launch"
    sql: ${TABLE}."Redistributed Launch time" ;;
  }

  dimension: partner_recieved_users {
    type: number
    label: "Partner Recieved Users"
    sql: ${TABLE}."Partner Recieved Users" ;;
  }

  dimension_group: bounced_time {
    type: time
    label: "Bounced"
    sql: ${TABLE}."Bounced time" ;;
  }

  dimension: bounced_email {
    type: string
    label: "Bounced Email"
    sql: ${TABLE}."Bounced Email" ;;
  }

  dimension_group: blocked_time {
    type: time
    label: "Blocked"
    sql: ${TABLE}."Blocked time" ;;
  }

  dimension: blocked_email {
    type: string
    label: "Blocked Email"
    sql: ${TABLE}."Blocked Email" ;;
  }

  dimension_group: spamed_time {
    type: time
    label: "Spam"
    sql: ${TABLE}."Spamed time" ;;
  }

  dimension: spamed_email {
    type: string
    label: "Spam Email"
    sql: ${TABLE}."Spamed Email" ;;
  }

  dimension: User_Email {
    type: string
    label: "User Email"
    sql: ${TABLE}."User Email" ;;
  }
  dimension: Status {
    type: string
    sql: ${TABLE}."Status"
      ;;
      }

  dimension:Blocked_Reason  {
    type: string
    sql: ${TABLE}."Blocked Reason"
      ;;
  }
  dimension:Bounced_Reason  {
    type: string
    sql: ${TABLE}."Bounced Reason"
      ;;
  }

  dimension_group:Spam_Time {
    type: time
    label: "Spam_"
    sql: ${TABLE}."Spam Time" ;;
  }
  dimension_group:Bounce_Time {
    type: time
    label: "Bounce_"
    sql: ${TABLE}."Bounce Time" ;;
  }
  dimension_group:Block_Time {
    type: time
    label: "Block_"
    sql: ${TABLE}."Block Time" ;;
  }
  dimension: contact_user_id {
    type: number
    label: "Contact User ID"
    sql: ${TABLE}."Contact User ID" ;;
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
      spamed_email,
      User_Email,
      Status,
      Blocked_Reason,
      Bounced_Reason,
      Block_Time_time,
      Bounce_Time_time,
      Spam_Time_time,
      contact_user_id,

        contact_company,
        email_id,
        contact_first_name,
        contact_last_name,
        contact_mobile_number,
        contact_country,
        contact_state,
        contact_city,
        contact_zip,
    ]
  }
}
