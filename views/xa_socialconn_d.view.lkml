view: xa_socialconn_d {
  sql_table_name: xamplify_test.xa_socialconn_d ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: profile_name {
    type: string
    sql: ${TABLE}."profile_name" ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}."source" ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}."user_id" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, profile_name]
  }
}
