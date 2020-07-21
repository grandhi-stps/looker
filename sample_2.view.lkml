view: sample_2 {
  derived_table: {
    sql: select * from xamplify_test.xa_campaign_d limit 100
      ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: campaign_id {
    type: number
    sql: ${TABLE}."campaign_id" ;;
  }

  dimension: customer_id {
    type: number
    sql: ${TABLE}."customer_id" ;;
  }

  dimension: campaign_name {
    type: string
    sql: ${TABLE}."campaign_name" ;;
  }

  dimension: campaign_type {
    type: string
    sql: ${TABLE}."campaign_type" ;;
  }

  dimension: campaign_schedule_type {
    type: string
    sql: ${TABLE}."campaign_schedule_type" ;;
  }

  dimension_group: created_time {
    type: time
    sql: ${TABLE}."created_time" ;;
  }

  dimension_group: launch_time {
    type: time
    sql: ${TABLE}."launch_time" ;;
  }

  dimension: parent_campaign_id {
    type: number
    sql: ${TABLE}."parent_campaign_id" ;;
  }

  dimension: is_launched {
    type: string
    sql: ${TABLE}."is_launched" ;;
  }

  dimension: to_partner {
    type: string
    sql: ${TABLE}."to_partner" ;;
  }

  dimension: vendor_organization_id {
    type: number
    sql: ${TABLE}."vendor_organization_id" ;;
  }

  dimension: email_template_id {
    type: number
    sql: ${TABLE}."email_template_id" ;;
  }

  dimension: is_nurture_campaign {
    type: string
    sql: ${TABLE}."is_nurture_campaign" ;;
  }

  dimension: created_time_key {
    type: number
    sql: ${TABLE}."created_time_key" ;;
  }

  set: detail {
    fields: [
      campaign_id,
      customer_id,
      campaign_name,
      campaign_type,
      campaign_schedule_type,
      created_time_time,
      launch_time_time,
      parent_campaign_id,
      is_launched,
      to_partner,
      vendor_organization_id,
      email_template_id,
      is_nurture_campaign,
      created_time_key
    ]
  }
}
