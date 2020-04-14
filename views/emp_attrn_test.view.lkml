view: emp_attrn_test {
  sql_table_name: hr_data_coe.emp_attrn_test ;;

  dimension_group: date {
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
    sql: ${TABLE}."date" ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}."department" ;;
  }

  dimension: emplid {
    type: string
    sql: ${TABLE}."emplid" ;;
  }

  dimension: empname {
    type: string
    sql: ${TABLE}."empname" ;;
  }

  dimension: emprank {
    type: number
    sql: ${TABLE}."emprank" ;;
  }

  dimension: intime_id {
    type: number
    sql: ${TABLE}."intime_id" ;;
  }

  dimension: last_evaluation {
    type: number
    sql: ${TABLE}."last_evaluation" ;;
  }

  dimension: late_by_num {
    type: number
    sql: ${TABLE}."late_by_num" ;;
  }

  dimension: outtime_id {
    type: number
    sql: ${TABLE}."outtime_id" ;;
  }

  dimension: overtime_num {
    type: number
    sql: ${TABLE}."overtime_num" ;;
  }

  dimension: total_duration_num {
    type: number
    sql: ${TABLE}."total_duration_num" ;;
  }

  measure: count {
    type: count
    drill_fields: [empname]
  }
}
