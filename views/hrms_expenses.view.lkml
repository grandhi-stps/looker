view: hrms_expenses {
  sql_table_name: hr_data_coe.hrms_expenses ;;

  dimension: bonus {
    type: string
    sql: ${TABLE}."bonus" ;;
  }

  dimension: emplid {
    type: string
    sql: ${TABLE}."emplid" ;;
  }

  dimension: misc {
    type: string
    sql: ${TABLE}."misc" ;;
  }

  dimension: recruitment_cost {
    type: string
    sql: ${TABLE}."recruitment_cost" ;;
  }

  dimension: training_cost {
    type: string
    sql: ${TABLE}."training_cost" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
