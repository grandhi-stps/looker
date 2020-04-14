view: xa_role_d {
  sql_table_name: xamplify_test.xa_role_d ;;

  dimension: description {
    type: string
    sql: ${TABLE}."description" ;;
  }

  dimension: role {
    type: string
    sql: ${TABLE}."role" ;;
  }

  dimension: role_id {
    type: number
    sql: ${TABLE}."role_id" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
