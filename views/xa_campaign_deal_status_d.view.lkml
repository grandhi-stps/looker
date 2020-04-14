view: xa_campaign_deal_status_d {
  sql_table_name: xamplify_test.xa_campaign_deal_status_d ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: created_by {
    type: number
    sql: ${TABLE}."created_by" ;;
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

  dimension: deal_id {
    type: number
    sql: ${TABLE}."deal_id" ;;
  }

  dimension: deal_status {
    type: string
    sql: ${TABLE}."deal_status" ;;
  }

  dimension: updated_by {
    type: number
    sql: ${TABLE}."updated_by" ;;
  }

  dimension_group: updated {
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
    sql: ${TABLE}."updated_time" ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
