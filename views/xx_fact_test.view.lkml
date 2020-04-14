view: xx_fact_test {
  sql_table_name: xamplify_test.xx_fact_test ;;

  dimension: campaign_id {
    type: number
    sql: ${TABLE}."campaign_id" ;;
  }

  dimension: company_id {
    type: number
    sql: ${TABLE}."company_id" ;;
  }

  dimension: date_key {
    type: number
    sql: ${TABLE}."date_key" ;;
  }

  dimension: role_id {
    type: number
    sql: ${TABLE}."role_id" ;;
  }

  dimension: socialconn_id {
    type: number
    sql: ${TABLE}."socialconn_id" ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}."user_id" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
