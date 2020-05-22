view: email_auto_respones {
  derived_table: {
    sql: select distinct
      "Vendor Company Name"
      ,"Partner Company Name"
      ,"Campaign ID"
      ,"Campaign Name"
      ,"Launch Time"
      ,"#Total Recipients"
      ,"Email ID"
      ,"First Name"
      ,"Last Name"
      ,"Company Name"
      ,"Phone"
      ,"Address"
      ,"City"
      ,"State"
      ,"Country"
      ,"#Active Recipients"
      ,"#Email Opened (Views)"
      ,"#Email Clicked"
      ,case when "Response Type"='Email' then "#Auto Responses" end as "#Email Auto Responses"
      ,case when "Response Type"='Email' then "Reason" end as "Email Response Reason"
      ,case when "Response Type"='Email' then "Reply In Days" end as "Email Response Reply In Days"
      ,case when "Response Type"='Email' then "Reply Time" end as "Email Response Reply Time"
      ,case when "Response Type"='Email' then "#Auto Responses Opened" end as "#Email Auto Responses Opened"
      ,case when "Response Type"='Email' then "Auto Responses Opened Time" end as "Email Auto Responses Opened Time"
      ,case when "Response Type"='Email' then "Response Sent Time ID" end as "#Email Response Sent Time ID"
      ,case when "Response Type"='Email' then "Response Sent Time" end as "Email Response Sent Time"
      ,case when "Response Type"='Website' then "#Auto Responses" end as "#Website Auto Responses"
      ,case when "Response Type"='Website' then "Reason" end as "Website Response Reason"
      ,case when "Response Type"='Website' then "Reply In Days" end as "Website Response Reply In Days"
      ,case when "Response Type"='Website' then "Reply Time" end as "Website Response Reply Time"
      ,case when "Response Type"='Website' then "#Auto Responses Opened" end as "#Website Auto Responses Opened"
      ,case when "Response Type"='Website' then "Auto Responses Opened Time" end as "Website Auto Responses Opened Time"
      ,case when "Response Type"='Website' then "Response Sent Time ID" end as "#Website Response Sent Time ID"
      ,case when "Response Type"='Website' then "Response Sent Time" end as "Website Response Sent Time"
      ,"#Campaign Email Sent Id"
      ,"Campaign Email Sent Time"
      ,"Subject"
      ,"Clicked URL Names"
      from (
      select distinct
      xa_company_d.company_name as "Vendor Company Name"
      ,xt_company_profile1.company_name as "Partner Company Name"
      ,xt_campaign1.campaign_id as "Campaign ID"
      ,xt_campaign1.campaign_name as "Campaign Name"
      ,xt_campaign1.launch_time as "Launch Time"
      ,xa_campaign_user_userlist_d.user_id as "#Total Recipients"
      ,up.email_id as "Email ID"
      ,xa_campaign_user_userlist_d.contact_first_name as "First Name"
      ,xa_campaign_user_userlist_d.contact_last_name as "Last Name"
      ,xa_campaign_user_userlist_d.contact_company as "Company Name"
      ,xa_campaign_user_userlist_d.contact_mobile_number as "Phone"
      ,xa_campaign_user_userlist_d.contact_address as "Address"
      ,xa_campaign_user_userlist_d.contact_city as "City"
      ,xa_campaign_user_userlist_d.contact_state as "State"
      ,xa_campaign_user_userlist_d.contact_country as "Country"
      ,xt_email_log1.user_id "#Active Recipients"
      ,case when xt_email_log1.action_id = 13 and xt_email_log1.url_id is null and xt_email_log1.reply_id is null then date_trunc('minute',xt_email_log1.time) end "#Email Opened (Views)"
      ,case when (xt_email_log1.action_id = 14 or xt_email_log1.action_id = 15) and xt_email_log1.url_id is null and xt_email_log1.reply_id is null then date_trunc('minute',xt_email_log1.time) end as "#Email Clicked"
      ,cr.id as "#Auto Responses"
      ,cr.reply_action_id as "Reason"
      ,cr.reply_in_days as "Reply In Days"
      ,cr.reply_time as "Reply Time"
      ,case when el.action_id = 13 and el.reply_id is not null and el.url_id is null then el.id end as "#Auto Responses Opened"
      ,case when el.action_id = 13 and el.reply_id is not null and el.url_id is null then el.time end as "Auto Responses Opened Time"
      ,eh.id as "#Campaign Email Sent Id"
      ,eh.sent_time as "Campaign Email Sent Time"
      ,esl.id as "Response Sent Time ID"
      ,esl.sent_time as "Response Sent Time"
      ,string_agg(distinct xt_email_log1.subject,' ,') as "Subject"
      ,string_agg(distinct xt_email_log1.clicked_url,' ,') as "Clicked URL Names"
      ,'Email' as "Response Type"
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
      LEFT JOIN "xamplify_test"."xa_emaillog_d" "xt_email_log1" ON (("xt_campaign1"."campaign_id" = "xt_email_log1"."campaign_id")
      AND ("xa_campaign_user_userlist_d"."user_id" = "xt_email_log1"."user_id"))
      left join xamplify_test.xa_campaign_emails_history_d eh on eh.campaign_id = xt_campaign1.campaign_id
      and eh.user_id = "xa_campaign_user_userlist_d"."user_id"
      left join xamplify_test.xa_campaign_replies_d cr on cr.campaign_id = "xt_campaign1"."campaign_id"
      and cr.user_id =  "xa_campaign_user_userlist_d"."user_id"
      left join xamplify_test.xa_emaillog_d el on el.reply_id = cr.id and el.user_id = cr.user_id
      and el.campaign_id = xt_campaign1.campaign_id
      left join xamplify_test.xa_campaign_email_sent_log_d esl on esl.reply_id = cr.id and cr.user_id = esl.user_id
      where xt_campaign1.is_launched
      group by  1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,31
      union all
      select distinct
      xa_company_d.company_name as "Vendor Company Name"
      ,xt_company_profile1.company_name as "Partner Company Name"
      ,xt_campaign1.campaign_id as "Campaign ID"
      ,xt_campaign1.campaign_name as "Campaign Name"
      ,xt_campaign1.launch_time as "Launch Time"
      ,xa_campaign_user_userlist_d.user_id as "#Total Recipients"
      ,up.email_id as "Email ID"
      ,xa_campaign_user_userlist_d.contact_first_name as "First Name"
      ,xa_campaign_user_userlist_d.contact_last_name as "Last Name"
      ,xa_campaign_user_userlist_d.contact_company as "Company Name"
      ,xa_campaign_user_userlist_d.contact_mobile_number as "Phone"
      ,xa_campaign_user_userlist_d.contact_address as "Address"
      ,xa_campaign_user_userlist_d.contact_city as "City"
      ,xa_campaign_user_userlist_d.contact_state as "State"
      ,xa_campaign_user_userlist_d.contact_country as "Country"
      ,xt_email_log1.user_id "#Active Recipients"
      ,case when xt_email_log1.action_id = 13 and xt_email_log1.url_id is null and xt_email_log1.reply_id is null then date_trunc('minute',xt_email_log1.time) end "#Email Opened (Views)"
      ,case when (xt_email_log1.action_id = 14 or xt_email_log1.action_id = 15) and xt_email_log1.url_id is null and xt_email_log1.reply_id is null then date_trunc('minute',xt_email_log1.time) end as "#Email Clicked"
      ,cu.id as "#Auto Responses"
      ,cu.action_id as "Reason"
      ,cu.reply_in_days as "Reply In Days"
      ,cu.reply_time as "Reply Time"
      ,case when el2.action_id = 13 and el2.reply_id is not null and el2.url_id is null then el2.id end as "#Auto Responses Opened"
      ,case when el2.action_id = 13 and el2.reply_id is not null and el2.url_id is null then el2.time end as "Auto Responses Opened Time"
      ,eh.id as "#Campaign Email Sent Id"
      ,eh.sent_time as "Campaign Email Sent Time"
      ,esl.id as "Response Sent Time ID"
      ,esl.sent_time as "Response Sent Time"
      ,string_agg(distinct xt_email_log1.subject,' ,') as "Subject"
      ,string_agg(distinct xt_email_log1.clicked_url,' ,') as "Clicked URL Names"
      ,'Website' as "Response Type"
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
      LEFT JOIN "xamplify_test"."xa_emaillog_d" "xt_email_log1" ON (("xt_campaign1"."campaign_id" = "xt_email_log1"."campaign_id")
      AND ("xa_campaign_user_userlist_d"."user_id" = "xt_email_log1"."user_id"))
      left join xamplify_test.xa_campaign_emails_history_d eh on eh.campaign_id = xt_campaign1.campaign_id
      and eh.user_id = "xa_campaign_user_userlist_d"."user_id"
      left join xamplify_test.xa_campaign_clicked_urls_d cu on cu.campaign_id = "xt_campaign1"."campaign_id"
      and cu.user_id =  "xa_campaign_user_userlist_d"."user_id"
      and cu.campaign_id = xa_campaign_user_userlist_d.campaign_id
      left join xamplify_test.xa_emaillog_d el2 on el2.url_id = cu.id and el2.user_id = cu.user_id
      and el2.campaign_id = xt_campaign1.campaign_id
      left join xamplify_test.xa_campaign_email_sent_log_d esl on esl.click_id = cu.id and cu.user_id = esl.user_id
      where xt_campaign1.is_launched
      group by  1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,31
      ) as foo
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
    label: "Campaign ID"
    sql: ${TABLE}."Campaign ID" ;;
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
    label: "#Total Recipients"
    sql: ${TABLE}."#Total Recipients" ;;
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

  dimension: active_recipients {
    type: number
    label: "#Active Recipients"
    sql: ${TABLE}."#Active Recipients" ;;
  }

  dimension_group: email_opened_views {
    type: time
    label: "#Email Opened (Views)"
    sql: ${TABLE}."#Email Opened (Views)" ;;
  }

  dimension_group: email_clicked {
    type: time
    label: "#Email Clicked"
    sql: ${TABLE}."#Email Clicked" ;;
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
    label: "Email Response Reply Time"
    sql: ${TABLE}."Email Response Reply Time" ;;
  }

  dimension: email_auto_responses_opened {
    type: number
    label: "#Email Auto Responses Opened"
    sql: ${TABLE}."#Email Auto Responses Opened" ;;
  }

  dimension_group: email_auto_responses_opened_time {
    type: time
    label: "Email Auto Responses Opened Time"
    sql: ${TABLE}."Email Auto Responses Opened Time" ;;
  }

  dimension: email_response_sent_time_id {
    type: number
    label: "#Email Response Sent Time ID"
    sql: ${TABLE}."#Email Response Sent Time ID" ;;
  }

  dimension_group: email_response_sent_time {
    type: time
    label: "Email Response Sent Time"
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
    label: "Website Response Reply Time"
    sql: ${TABLE}."Website Response Reply Time" ;;
  }

  dimension: website_auto_responses_opened {
    type: number
    label: "#Website Auto Responses Opened"
    sql: ${TABLE}."#Website Auto Responses Opened" ;;
  }

  dimension_group: website_auto_responses_opened_time {
    type: time
    label: "Website Auto Responses Opened Time"
    sql: ${TABLE}."Website Auto Responses Opened Time" ;;
  }

  dimension: website_response_sent_time_id {
    type: number
    label: "#Website Response Sent Time ID"
    sql: ${TABLE}."#Website Response Sent Time ID" ;;
  }

  dimension_group: website_response_sent_time {
    type: time
    label: "Website Response Sent Time"
    sql: ${TABLE}."Website Response Sent Time" ;;
  }

  dimension: campaign_email_sent_id {
    type: number
    label: "#Campaign Email Sent Id"
    sql: ${TABLE}."#Campaign Email Sent Id" ;;
  }

  dimension_group: campaign_email_sent_time {
    type: time
    label: "Campaign Email Sent Time"
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
      email_opened_views_time,
      email_clicked_time,
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
