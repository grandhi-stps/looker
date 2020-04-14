view: xa_campaign_d {
  sql_table_name: xamplify_test.xa_campaign_d ;;

  dimension: campaign_id {
    type: number
    sql: ${TABLE}."campaign_id" ;;
  }
  dimension: campaign_name {
    type: string
    sql: ${TABLE}."campaign_name" ;;
  }


  dimension: campaign_schedule_type {
    type: string
    sql: ${TABLE}."campaign_schedule_type" ;;
  }
  dimension: views {
    type: number
    sql: c.campaign_name  COUNT (DISTINCT CASE WHEN campaign_type <> 'VIDEO' AND el.action_id =13 THEN TIME::TEXT
WHEN campaign_type = 'VIDEO' AND xl.action_id >=1 AND xl.action_id <=10 THEN session_id
END) AS views
FROM xa_campaign_d C
LEFT JOIN xa_email_log_d el on (c.campaign_id = el.campaign_id)
LEFT JOIN xa_xtremand_log_d xl ON (c.campaign_id = xl.campaign_id);;
  }

  dimension: campaign_type {
    type: string
    sql: ${TABLE}."campaign_type" ;;
  }


  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."created_time" ;;
  }

  dimension: created_time_key {
    type: number
    sql: ${TABLE}."created_time_key" ;;
  }

  dimension: customer_id {
    type: number
    sql: ${TABLE}."customer_id" ;;
  }

  dimension: is_launched {
    type: yesno
    sql: ${TABLE}."is_launched" ;;
  }

  dimension_group: launch {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."launch_time" ;;
  }

  dimension: parent_campaign_id {
    type: number
    sql: ${TABLE}."parent_campaign_id" ;;
  }

  dimension: to_partner {
    type: yesno
    sql: ${TABLE}."to_partner" ;;
  }

  dimension: vendor_organization_id {
    type: number
    sql: ${TABLE}."vendor_organization_id" ;;
  }

  measure: count {
    type: count
    drill_fields: [campaign_name]
  }
}
