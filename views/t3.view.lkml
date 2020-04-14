view: t3 {
  sql_table_name: hr_data_coe.t3 ;;

  dimension: acct_id {
    type: number
    sql: ${TABLE}."acct_id" ;;
  }

  dimension: avg_work_duration {
    type: string
    sql: ${TABLE}."avg_work_duration" ;;
  }

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

  dimension: evaluation_level {
    type: string
    sql: ${TABLE}."evaluation_level" ;;
  }

  dimension: satisfaction_level {
    type: string
    sql: ${TABLE}."satisfaction_level" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."status" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
