view: xa_company_d {
  sql_table_name: xamplify_test.xa_company_d ;;

  dimension: company_id {
    type: number
    sql: ${TABLE}."company_id" ;;
  }

  dimension: company_name {
    type: string
    sql: ${TABLE}."company_name" ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}."country" ;;
  }

  dimension: email_id {
    type: string
    sql: ${TABLE}."email_id" ;;
  }

  dimension: phone {
    type: string
    sql: ${TABLE}."phone" ;;
  }

  measure: count {
    type: count
    drill_fields: [company_name]
  }
}
