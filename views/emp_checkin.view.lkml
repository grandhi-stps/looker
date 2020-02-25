view: emp_checkin {
  sql_table_name: hr_data_coe.emp_checkin ;;

  dimension_group: date {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."date" ;;
  }

  dimension: emplid {
    type: string
    sql: ${TABLE}."emplid" ;;
  }

  dimension: empname {
    type: string
    sql: ${TABLE}."empname" ;;
  }

  dimension_group: intime {
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
    sql: ${TABLE}."intime" ;;
  }

  dimension: intime_id {
    type: number
    sql: ${TABLE}."intime_id" ;;
  }

  dimension_group: late_by {
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
    sql: ${TABLE}."late_by" ;;
  }

  dimension: late_by_num {
    type: number
    sql: ${TABLE}."late_by_num" ;;
  }

  dimension: location {
    type: string
    sql: ${TABLE}."location" ;;
  }

  dimension_group: outtime {
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
    sql: ${TABLE}."outtime" ;;
  }

  dimension: outtime_id {
    type: number
    sql: ${TABLE}."outtime_id" ;;
  }

  dimension_group: overtime {
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
    sql: ${TABLE}."overtime" ;;
  }

  dimension: overtime_num {
    type: number
    sql: ${TABLE}."overtime_num" ;;
  }

  dimension: remarks {
    type: string
    sql: ${TABLE}."remarks" ;;
  }

  dimension: shift {
    type: string
    sql: ${TABLE}."shift" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."status" ;;
  }

  dimension_group: total_duration {
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
    sql: ${TABLE}."date";;
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
