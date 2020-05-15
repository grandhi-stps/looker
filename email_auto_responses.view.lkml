view: email_auto_responses {
  derived_table: {
    sql: select distinct
      "Vendor Company Name", "Partner Company Name", "Campaign Name", "Launch Time",
      count(distinct "Total Recipients") "Total Recipients",
      count(distinct "Active Recipients") "Active Recipients",
      count(distinct "#Email Opened (Views)") "#Email Opened (Views)",
      "Subject"
      ,count(distinct "#Email Clicked") "#Email Clicked",
      "Clicked URL Names"
      ,count(distinct "#Email Auto Responses") "#Email Auto Responses"
      ,"Reason"
      ,"Reply In Days"
      ,"Email Reply Time"
      ,count(distinct "#Email Auto Responses Opened") "#Email Auto Responses Opened"
      ,count(distinct "#Website Visit Auto Responses") "#Website Visit Auto Responses"
      ,"Web Reason"
      ,"Web Reply In Days"
      ,"Web Reply Time"
      ,count(distinct "#Website Responses Email Opened") "#Website Responses Email Opened"
      ,count(distinct campaign_email_sent_id) as "#Total Emails Sent"
      ,campaign_email_sent_time as "Campaign Email Sent Time"
      ,count(distinct email_response_id) as "#Email Auto Responses Sent"
      ,email_response_sent_time as "Email Auto Responses Sent Time"
      ,count(distinct website_response_id) as "#Web Auto Responses Sent"
      ,website_response_sent_time "Web Auto Responses Sent Time"
      ,"Email ID"
      ,"First Name"
      ,"Last Name"
      ,"Company Name"
      ,"Phone"
      ,"Address"
      ,"City"
      ,"State"
      ,"Country"
      from (
      select
      xa_company_d.company_name as "Vendor Company Name",
      xt_company_profile1.company_name as "Partner Company Name",
      xt_campaign1.campaign_name as "Campaign Name",
      xt_campaign1.launch_time as "Launch Time",
      xa_campaign_user_userlist_d.user_id as "Total Recipients",
      up.email_id as "Email ID",
      xt_email_log1.user_id "Active Recipients",
      case when xt_email_log1.action_id = 13 and xt_email_log1.url_id is null and xt_email_log1.reply_id is null then date_trunc('minute',xt_email_log1.time) end "#Email Opened (Views)",
      case when (xt_email_log1.action_id = 14 or xt_email_log1.action_id = 15) and xt_email_log1.url_id is null and xt_email_log1.reply_id is null then date_trunc('minute',xt_email_log1.time) end as "#Email Clicked"
      ,null "#Email Auto Responses"
      ,null "Reason"
      ,null "Reply In Days"
      ,null "#Email Auto Responses Opened"
      ,null as "#Website Visit Auto Responses"
      ,null as "Web Reason"
      ,null as "Web Reply In Days"
      ,null as "#Website Responses Email Opened"
      ,null::integer as campaign_email_sent_id
      ,null::timestamp as campaign_email_sent_time
      ,null::integer as email_response_id
      ,null::timestamp as email_response_sent_time
      ,null::integer as website_response_id
      ,null::timestamp as website_response_sent_time
      ,uul.first_name as "First Name"
      ,uul.last_name as "Last Name"
      ,uul.contact_company as "Company Name"
      ,uul.mobile_number as "Phone"
      ,uul.address as "Address"
      ,uul.city as "City"
      ,uul.state as "State"
      ,uul.country as "Country"
      ,string_agg(distinct xt_email_log1.subject,' ,') as "Subject"
      ,string_agg(distinct xt_email_log1.clicked_url,' ,') as "Clicked URL Names"
      ,null::timestamp as "Email Reply Time"
      ,null::timestamp as "Web Reply Time"
      from
      "xamplify_test"."xa_campaign_d" "xa_campaign_d"
      LEFT JOIN "xamplify_test"."xa_user_d" "xa_user_d" ON ("xa_campaign_d"."customer_id" = "xa_user_d"."user_id")
      LEFT JOIN "xamplify_test"."xa_company_d" "xa_company_d" ON ("xa_user_d"."company_id" = "xa_company_d"."company_id")
      LEFT JOIN "xamplify_test"."xa_campaign_d" "xt_campaign1" ON ("xa_campaign_d"."campaign_id" = "xt_campaign1"."parent_campaign_id")
      LEFT JOIN "xamplify_test"."xa_user_d" "xt_user_profile1" ON ("xt_campaign1"."customer_id" = "xt_user_profile1"."user_id")
      LEFT JOIN "xamplify_test"."xa_company_d" "xt_company_profile1" ON ("xt_user_profile1"."company_id" = "xt_company_profile1"."company_id")
      LEFT JOIN "xamplify_test"."xa_campaign_user_userlist_d" "xa_campaign_user_userlist_d" ON ("xt_campaign1"."campaign_id" = "xa_campaign_user_userlist_d"."campaign_id")
      join "xamplify_test".xa_user_list_d uul on uul.user_list_id = "xa_campaign_user_userlist_d".user_list_id
      and uul.listby_partner_id = "xa_campaign_user_userlist_d".user_id
      join "xamplify_test".xa_user_d up on up.user_id = "xa_campaign_user_userlist_d".user_id
      LEFT JOIN "xamplify_test"."xa_emaillog_d" "xt_email_log1" ON (("xt_campaign1"."campaign_id" = "xt_email_log1"."campaign_id") AND ("xa_campaign_user_userlist_d"."user_id" = "xt_email_log1"."user_id"))
      group by 1,2,3,4,5,6,7,8,9,23,24,25,26,27,28,29,30,31
      union all  --auto responses
      select
      xa_company_d.company_name as "Vendor Company Name",
      xt_company_profile1.company_name as "Partner Company Name",
      xt_campaign1.campaign_name as "Campaign Name",
      xt_campaign1.launch_time as "Launch Time",
      null as "total",
      null as "Email ID",
      null as active,
      null as "#Email Opened (Views)",
      null as "#Email Clicked",
      xa_campaign_replies_d.id "#Email Auto Responses",
      xa_campaign_replies_d.reply_action_id as "Reason",
      xa_campaign_replies_d.reply_in_days as "Reply In Days",
      case when xt_email_log2.action_id = 13 and xt_email_log2.reply_id is not null and xt_email_log2.url_id is null then xt_email_log2.id end as "#Email Auto Responses Opened",
      xa_campaign_clicked_urls_d.id "#Website Visit Auto Responses",
      xa_campaign_clicked_urls_d.action_id as "Web Reason",
      xa_campaign_clicked_urls_d.reply_in_days as "Web Reply In Days",
      case when xa_emaillog_d.action_id = 13 and xa_emaillog_d.url_id is not null and xa_emaillog_d.reply_id is null then xa_emaillog_d.id end "#Website Responses Email Opened"
      ,null as campaign_email_sent_id
      ,null as campaign_email_sent_time
      ,null as email_response_id
      ,null as email_response_sent_time
      ,null as website_response_id
      ,null as website_response_sent_time
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,xa_campaign_replies_d.reply_time as "Email Reply Time"
      ,xa_campaign_clicked_urls_d.reply_time as "Web Reply Time"
      from
      "xamplify_test"."xa_campaign_d" "xa_campaign_d"
      LEFT JOIN "xamplify_test"."xa_user_d" "xa_user_d" ON ("xa_campaign_d"."customer_id" = "xa_user_d"."user_id")
      LEFT JOIN "xamplify_test"."xa_company_d" "xa_company_d" ON ("xa_user_d"."company_id" = "xa_company_d"."company_id")
      LEFT JOIN "xamplify_test"."xa_campaign_d" "xt_campaign1" ON ("xa_campaign_d"."campaign_id" = "xt_campaign1"."parent_campaign_id")
      LEFT JOIN "xamplify_test"."xa_user_d" "xt_user_profile1" ON ("xt_campaign1"."customer_id" = "xt_user_profile1"."user_id")
      LEFT JOIN "xamplify_test"."xa_company_d" "xt_company_profile1" ON ("xt_user_profile1"."company_id" = "xt_company_profile1"."company_id")
      --LEFT JOIN "xamplify_test"."xa_campaign_user_userlist_d" "xa_campaign_user_userlist_d" ON ("xt_campaign1"."campaign_id" = "xa_campaign_user_userlist_d"."campaign_id")
      LEFT JOIN "xamplify_test"."xa_campaign_replies_d" "xa_campaign_replies_d" ON ("xt_campaign1"."campaign_id" = "xa_campaign_replies_d"."campaign_id")
      LEFT JOIN "xamplify_test"."xa_campaign_clicked_urls_d" "xa_campaign_clicked_urls_d" ON ("xt_campaign1"."campaign_id" = "xa_campaign_clicked_urls_d"."campaign_id")
      left JOIN "xamplify_test"."xa_emaillog_d" "xt_email_log2" ON ("xa_campaign_replies_d"."id" = "xt_email_log2"."reply_id") and xt_email_log2.campaign_id = xt_campaign1.campaign_id
      LEFT JOIN "xamplify_test"."xa_emaillog_d" "xa_emaillog_d" ON ("xa_campaign_clicked_urls_d"."id" = "xa_emaillog_d"."url_id") and xa_emaillog_d.campaign_id = xt_campaign1.campaign_id
      union all  --campaign emails
      select
      xa_company_d.company_name as "Vendor Company Name",
      xt_company_profile1.company_name as "Partner Company Name",
      xt_campaign1.campaign_name as "Campaign Name",
      xt_campaign1.launch_time as "Launch Time"
      ,null as total
      ,null as "Email ID"
      ,null as active
      ,null as "#Email Opened (Views)"
      ,null as "#Email Clicked"
      ,null as "#Email Auto Responses"
      ,null as "Reason"
      ,null as "Reply In Days"
      ,null as "#Email Auto Responses Opened"
      ,null as "#Website Visit Auto Responses"
      ,null as "Web Reason"
      ,null as "Web Reply In Days"
      ,null as "#Website Responses Email Opened"
      ,eh.id as "campaign_email_sent_id"
      ,eh.sent_time as campaign_email_sent_time
      ,null as website_response_id
      ,null as website_response_sent_time
      ,null as website_response_id
      ,null as website_response_sent_time
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null::timestamp as "Email Reply Time"
      ,null::timestamp as "Web Reply Time"
      from xt_campaign "xa_campaign_d"
      LEFT JOIN "xamplify_test"."xa_user_d" "xa_user_d" ON ("xa_campaign_d"."customer_id" = "xa_user_d"."user_id")
      LEFT JOIN "xamplify_test"."xa_company_d" "xa_company_d" ON ("xa_user_d"."company_id" = "xa_company_d"."company_id")
      LEFT JOIN "xamplify_test"."xa_campaign_d" "xt_campaign1" ON ("xa_campaign_d"."campaign_id" = "xt_campaign1"."parent_campaign_id")
      LEFT JOIN "xamplify_test"."xa_user_d" "xt_user_profile1" ON ("xt_campaign1"."customer_id" = "xt_user_profile1"."user_id")
      LEFT JOIN "xamplify_test"."xa_company_d" "xt_company_profile1" ON ("xt_user_profile1"."company_id" = "xt_company_profile1"."company_id")
      left join "xamplify_test".xa_campaign_emails_history_d eh on xt_campaign1.campaign_id = eh.campaign_id
       -- where xt_company_profile.company_id = 399
      union all  --email responses sent logs
      select
      xa_company_d.company_name as "Vendor Company Name",
      xt_company_profile1.company_name as "Partner Company Name",
      xt_campaign1.campaign_name as "Campaign Name",
      xt_campaign1.launch_time as "Launch Time"
      ,null as total
      ,null as "Email ID"
      ,null as active
      ,null as "#Email Opened (Views)"
      ,null as "#Email Clicked"
      ,null as "#Email Auto Responses"
      ,null as "Reason"
      ,null as "Reply In Days"
      ,null as "#Email Auto Responses Opened"
      ,null as "#Website Visit Auto Responses"
      ,null as "Web Reason"
      ,null as "Web Reply In Days"
      ,null as "#Website Responses Email Opened"
      ,null as  "campaign_email_sent_id"
      ,null as  campaign_email_sent_time
      ,esl.id as email_response_id
      ,esl.sent_time as email_response_sent_time
      ,null as website_response_id
      ,null as website_response_sent_time
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null::timestamp as "Email Reply Time"
      ,null::timestamp as "Web Reply Time"
      from xt_campaign "xa_campaign_d"
      LEFT JOIN "xamplify_test"."xa_user_d" "xa_user_d" ON ("xa_campaign_d"."customer_id" = "xa_user_d"."user_id")
      LEFT JOIN "xamplify_test"."xa_company_d" "xa_company_d" ON ("xa_user_d"."company_id" = "xa_company_d"."company_id")
      LEFT JOIN "xamplify_test"."xa_campaign_d" "xt_campaign1" ON ("xa_campaign_d"."campaign_id" = "xt_campaign1"."parent_campaign_id")
      LEFT JOIN "xamplify_test"."xa_user_d" "xt_user_profile1" ON ("xt_campaign1"."customer_id" = "xt_user_profile1"."user_id")
      LEFT JOIN "xamplify_test"."xa_company_d" "xt_company_profile1" ON ("xt_user_profile1"."company_id" = "xt_company_profile1"."company_id")
      LEFT JOIN "xamplify_test"."xa_campaign_replies_d" "xa_campaign_replies_d" ON ("xt_campaign1"."campaign_id" = "xa_campaign_replies_d"."campaign_id")
      left join "xamplify_test".xa_campaign_email_sent_log_d esl on esl.reply_id = xa_campaign_replies_d.id
      union all  --website responses sent logs
      select
      xa_company_d.company_name as "Vendor Company Name",
      xt_company_profile1.company_name as "Partner Company Name",
      xt_campaign1.campaign_name as "Campaign Name",
      xt_campaign1.launch_time as "Launch Time"
      ,null as total
      ,null as "Email ID"
      ,null as active
      ,null as "#Email Opened (Views)"
      ,null as "#Email Clicked"
      ,null as "#Email Auto Responses"
      ,null as "Reason"
      ,null as "Reply In Days"
      ,null as "#Email Auto Responses Opened"
      ,null as "#Website Visit Auto Responses"
      ,null as "Web Reason"
      ,null as "Web Reply In Days"
      ,null as "#Website Responses Email Opened"
      ,null as  "campaign_email_sent_id"
      ,null as   campaign_email_sent_time
      ,null as email_response_id
      ,null as email_response_sent_time
      ,esl.id as website_response_id
      ,esl.sent_time as website_response_sent_time
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null
      ,null::timestamp as "Email Reply Time"
      ,null::timestamp as "Web Reply Time"
      from xt_campaign "xa_campaign_d"
      LEFT JOIN "xamplify_test"."xa_user_d" "xa_user_d" ON ("xa_campaign_d"."customer_id" = "xa_user_d"."user_id")
      LEFT JOIN "xamplify_test"."xa_company_d" "xa_company_d" ON ("xa_user_d"."company_id" = "xa_company_d"."company_id")
      LEFT JOIN "xamplify_test"."xa_campaign_d" "xt_campaign1" ON ("xa_campaign_d"."campaign_id" = "xt_campaign1"."parent_campaign_id")
      LEFT JOIN "xamplify_test"."xa_user_d" "xt_user_profile1" ON ("xt_campaign1"."customer_id" = "xt_user_profile1"."user_id")
      LEFT JOIN "xamplify_test"."xa_company_d" "xt_company_profile1" ON ("xt_user_profile1"."company_id" = "xt_company_profile1"."company_id")
      LEFT JOIN "xamplify_test"."xa_campaign_clicked_urls_d" "xa_campaign_clicked_urls_d" ON ("xt_campaign1"."campaign_id" = "xa_campaign_clicked_urls_d"."campaign_id")
      left join xt_campaign_email_sent_log esl on esl.click_id = xa_campaign_clicked_urls_d.id
           )a
        -- where "Partner Company Name" is not null
       --and "Partner Company Name" = '26 Connect'
      group by
      "Vendor Company Name","Partner Company Name", "Campaign Name", "Launch Time"
      ,"Subject"
      ,"Clicked URL Names"
      ,"Reason"
      ,"Reply In Days"
      ,"Email Reply Time"
      ,"Web Reason"
      ,"Web Reply In Days"
      ,"Web Reply Time"
      ,campaign_email_sent_time
      ,email_response_sent_time
      ,website_response_sent_time
      ,"Email ID"
      ,"First Name"
      ,"Last Name"
      ,"Company Name"
      ,"Phone"
      ,"Address"
      ,"City"
      ,"State"
      ,"Country"
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: Total {
    type: sum
    sql: ${total_recipients} ;;
  }


  measure: Active_Recipients_Percent{
    type: number
    sql: Round(100.00* ${active_recipients}/NULLIF(${total_recipients},0)) ;;
    value_format: "0\%"
  }

  measure: Email_NotOpened {
    type: number
    sql: ${total_recipients}-${active_recipients} ;;
  }

  measure: Email_NotOpened_Percent{
    type: number
    sql:  Round(100.00* ${Email_NotOpened}/NULLIF(${total_recipients},0)) ;;
    value_format: "0\%"
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

  dimension: campaign_name {
    type: string
    label: "Campaign Name"
    sql: ${TABLE}."Campaign Name" ;;
  }

  dimension_group: launch_time {
    type: time
    label: "Launch Time"
    sql: ${TABLE}."Launch Time" ;;
  }

  dimension: total_recipients {
    type: number
    label: "Total Recipients"
    sql: ${TABLE}."Total Recipients" ;;
  }

  dimension: active_recipients {
    type: number
    label: "Active Recipients"
    sql: ${TABLE}."Active Recipients" ;;
  }

  dimension: email_opened_views {
    type: number
    label: "#Email Opened (Views)"
    sql: ${TABLE}."#Email Opened (Views)" ;;
  }

  dimension: subject {
    type: string
    sql: ${TABLE}."Subject" ;;
  }

  dimension: email_clicked {
    type: number
    label: "#Email Clicked"
    sql: ${TABLE}."#Email Clicked" ;;
  }

  dimension: clicked_url_names {
    type: string
    label: "Clicked URL Names"
    sql: ${TABLE}."Clicked URL Names" ;;
  }

  dimension: email_auto_responses {
    type: number
    label: "#Email Auto Responses"
    sql: ${TABLE}."#Email Auto Responses" ;;
  }

  dimension: reason {
    type: number
    sql: ${TABLE}."Reason" ;;
  }

  dimension: reply_in_days {
    type: number
    label: "Reply In Days"
    sql: ${TABLE}."Reply In Days" ;;
  }

  dimension_group: email_reply_time {
    type: time
    label: "Email Reply Time"
    sql: ${TABLE}."Email Reply Time" ;;
  }

  dimension: email_auto_responses_opened {
    type: number
    label: "#Email Auto Responses Opened"
    sql: ${TABLE}."#Email Auto Responses Opened" ;;
  }

  dimension: website_visit_auto_responses {
    type: number
    label: "#Website Visit Auto Responses"
    sql: ${TABLE}."#Website Visit Auto Responses" ;;
  }

  dimension: web_reason {
    type: number
    label: "Web Reason"
    sql: ${TABLE}."Web Reason" ;;
  }

  dimension: web_reply_in_days {
    type: number
    label: "Web Reply In Days"
    sql: ${TABLE}."Web Reply In Days" ;;
  }

  dimension_group: web_reply_time {
    type: time
    label: "Web Reply Time"
    sql: ${TABLE}."Web Reply Time" ;;
  }

  dimension: website_responses_email_opened {
    type: number
    label: "#Website Responses Email Opened"
    sql: ${TABLE}."#Website Responses Email Opened" ;;
  }

  dimension: total_emails_sent {
    type: number
    label: "#Total Emails Sent"
    sql: ${TABLE}."#Total Emails Sent" ;;
  }

  dimension_group: campaign_email_sent_time {
    type: time
    label: "Campaign Email Sent Time"
    sql: ${TABLE}."Campaign Email Sent Time" ;;
  }

  dimension: email_auto_responses_sent {
    type: number
    label: "#Email Auto Responses Sent"
    sql: ${TABLE}."#Email Auto Responses Sent" ;;
  }

  dimension_group: email_auto_responses_sent_time {
    type: time
    label: "Email Auto Responses Sent Time"
    sql: ${TABLE}."Email Auto Responses Sent Time" ;;
  }

  dimension: web_auto_responses_sent {
    type: number
    label: "#Web Auto Responses Sent"
    sql: ${TABLE}."#Web Auto Responses Sent" ;;
  }

  dimension_group: web_auto_responses_sent_time {
    type: time
    label: "Web Auto Responses Sent Time"
    sql: ${TABLE}."Web Auto Responses Sent Time" ;;
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

  set: detail {
    fields: [
      vendor_company_name,
      partner_company_name,
      campaign_name,
      launch_time_time,
      total_recipients,
      active_recipients,
      email_opened_views,
      subject,
      email_clicked,
      clicked_url_names,
      email_auto_responses,
      reason,
      reply_in_days,
      email_reply_time_time,
      email_auto_responses_opened,
      website_visit_auto_responses,
      web_reason,
      web_reply_in_days,
      web_reply_time_time,
      website_responses_email_opened,
      total_emails_sent,
      campaign_email_sent_time_time,
      email_auto_responses_sent,
      email_auto_responses_sent_time_time,
      web_auto_responses_sent,
      web_auto_responses_sent_time_time,
      email_id,
      first_name,
      last_name,
      company_name,
      phone,
      address,
      city,
      state,
      country
    ]
  }
}
