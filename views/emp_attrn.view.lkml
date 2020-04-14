view: emp_attrn {
  sql_table_name: hr_data_coe.emp_attrn ;;

  dimension: emplid {
    type: string
    sql: ${TABLE}."emplid" ;;
  }

  dimension: left {
    type: number
    sql: ${TABLE}."left" ;;
  }

  dimension: predicted_left {
    type: number
    sql: ${TABLE}."predicted_left" ;;
  }

  dimension: satisfaction_level {
    type: number
    sql: ${TABLE}."satisfaction_level" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
