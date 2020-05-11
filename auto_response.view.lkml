view: auto_response {
  derived_table: {
    sql: select
      "Campaign Clicked".action_id as "Clicked Action ID",
      "Campaign Clicked".id as "Clicked ID",
      "Campaign Reply".id as "Campaign Reply ID",
      "Campaign Reply".reply_action_id as "Campaign Reply Action ID",
      "Campaign Reply".reply_in_days as "Campaign reply in days",
      "Campaign Reply".reply_time as "Campaign reply time",
      "Received Campaigns".user_id as "Received Campaign User id",
      "Redistributed Campaign".campaign_id as "Redistributed Campaign ID",
      "Redistributed Campaign".campaign_name as "Redistributed Campaign Name",
      "Redistributed Campaign".is_launched as "Redistributed Campaign islaunched",
      "Redistributed Campaign".launch_time as "Redistributed Campaign launch time",
      "Company".company_name as "Company Name",
      "View".id as "View ID",
      "View".action_id as "View action ID",
      "View".url_id as "View URL ID",
      "Email Clicked View".id as "Email Clicked View ID",
      "Email Clicked View".action_id as "Email Clicked View action ID",
      "Email Clicked View".reply_id as "Email Clicked View reply id",
      "Email Clicked View".url_id as "Email Clicked View url id",
      "Email Clicked View".user_id as "Email Clicked View user ID",
      "Email Reply View".action_id as "Email Reply View action ID",
      "Email Reply View".id as "Email Reply View ID",
      "Email Reply View".reply_id as "Email Reply View reply ID"


      from xamplify_test.xa_campaign_d "Campaign"
      left join xamplify_test.xa_campaign_d "Redistributed Campaign" on("Campaign".campaign_id="Redistributed Campaign".parent_campaign_id)
      left join xamplify_test.xa_user_d ud on("Campaign".customer_id=ud.user_id)
      left join xamplify_test.xa_campaign_clicked_urls_d "Campaign Clicked" on("Redistributed Campaign".campaign_id="Campaign Clicked".campaign_id)
      left join xamplify_test.xa_camapaign_replies_d "Campaign Reply" on ("Redistributed Campaign".campaign_id="Campaign Reply".campaign_id)
      left join xamplify_test.xa_campaign_user_userlist_d "Received Campaigns" on("Redistributed Campaign".campaign_id="Received Campaigns".campaign_id)
      left join xamplify_test.xa_emaillog_d "View" on("Redistributed Campaign".campaign_id="View".campaign_id)
                                and ("Received Campaigns".user_id="View".user_id)
      left join xamplify_test.xa_user_d "user" on("Redistributed Campaign".customer_id="user".user_id)
      left join xamplify_test.xa_emaillog_d "Email Clicked View" on("Campaign Clicked".id="Email Clicked View".url_id)
      left join xamplify_test.xa_emaillog_d "Email Reply View" on ("Campaign Reply".id="Email Reply View".reply_id)
      left join xamplify_test.xa_company_d "Company" on("user".company_id="Company".company_id)
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: clicked_action_id {
    type: number
    label: "Clicked Action ID"
    sql: ${TABLE}."Clicked Action ID" ;;
  }

  dimension: clicked_id {
    type: number
    label: "Clicked ID"
    sql: ${TABLE}."Clicked ID" ;;
  }

  dimension: campaign_reply_id {
    type: number
    label: "Campaign Reply ID"
    sql: ${TABLE}."Campaign Reply ID" ;;
  }

  dimension: campaign_reply_action_id {
    type: number
    label: "Campaign Reply Action ID"
    sql: ${TABLE}."Campaign Reply Action ID" ;;
  }

  dimension: campaign_reply_in_days {
    type: number
    label: "Campaign reply in days"
    sql: ${TABLE}."Campaign reply in days" ;;
  }

  dimension_group: campaign_reply_time {
    type: time
    label: "Campaign reply time"
    sql: ${TABLE}."Campaign reply time" ;;
  }

  dimension: received_campaign_user_id {
    type: number
    label: "Received Campaign User id"
    sql: ${TABLE}."Received Campaign User id" ;;
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

  dimension: redistributed_campaign_islaunched {
    type: string
    label: "Redistributed Campaign islaunched"
    sql: ${TABLE}."Redistributed Campaign islaunched" ;;
  }

  dimension_group: redistributed_campaign_launch_time {
    type: time
    label: "Redistributed Campaign launch time"
    sql: ${TABLE}."Redistributed Campaign launch time" ;;
  }

  dimension: company_name {
    type: string
    label: "Company Name"
    sql: ${TABLE}."Company Name" ;;
  }

  dimension: view_id {
    type: number
    label: "View ID"
    sql: ${TABLE}."View ID" ;;
  }

  dimension: view_action_id {
    type: number
    label: "View action ID"
    sql: ${TABLE}."View action ID" ;;
  }

  dimension: view_url_id {
    type: number
    label: "View URL ID"
    sql: ${TABLE}."View URL ID" ;;
  }

  dimension: email_clicked_view_id {
    type: number
    label: "Email Clicked View ID"
    sql: ${TABLE}."Email Clicked View ID" ;;
  }

  dimension: email_clicked_view_action_id {
    type: number
    label: "Email Clicked View action ID"
    sql: ${TABLE}."Email Clicked View action ID" ;;
  }

  dimension: email_clicked_view_reply_id {
    type: number
    label: "Email Clicked View reply id"
    sql: ${TABLE}."Email Clicked View reply id" ;;
  }

  dimension: email_clicked_view_url_id {
    type: number
    label: "Email Clicked View url id"
    sql: ${TABLE}."Email Clicked View url id" ;;
  }

  dimension: email_clicked_view_user_id {
    type: number
    label: "Email Clicked View user ID"
    sql: ${TABLE}."Email Clicked View user ID" ;;
  }

  dimension: email_reply_view_action_id {
    type: number
    label: "Email Reply View action ID"
    sql: ${TABLE}."Email Reply View action ID" ;;
  }

  dimension: email_reply_view_id {
    type: number
    label: "Email Reply View ID"
    sql: ${TABLE}."Email Reply View ID" ;;
  }

  dimension: email_reply_view_reply_id {
    type: number
    label: "Email Reply View reply ID"
    sql: ${TABLE}."Email Reply View reply ID" ;;
  }

  set: detail {
    fields: [
      clicked_action_id,
      clicked_id,
      campaign_reply_id,
      campaign_reply_action_id,
      campaign_reply_in_days,
      campaign_reply_time_time,
      received_campaign_user_id,
      redistributed_campaign_id,
      redistributed_campaign_name,
      redistributed_campaign_islaunched,
      redistributed_campaign_launch_time_time,
      company_name,
      view_id,
      view_action_id,
      view_url_id,
      email_clicked_view_id,
      email_clicked_view_action_id,
      email_clicked_view_reply_id,
      email_clicked_view_url_id,
      email_clicked_view_user_id,
      email_reply_view_action_id,
      email_reply_view_id,
      email_reply_view_reply_id
    ]
  }
}
