view: ats_employment_history {
  sql_table_name: hr_data_coe.ats_employment_history ;;

  dimension: applicant_id {
    type: number
    sql: ${TABLE}."applicant_id" ;;
  }

  dimension: eh_address {
    type: string
    sql: ${TABLE}."eh_address" ;;
  }

  dimension: eh_id {
    type: string
    sql: ${TABLE}."eh_id" ;;
  }

  dimension: eh_state {
    type: string
    sql: ${TABLE}."eh_state" ;;
  }

  dimension: perviouscompanyname {
    type: string
    sql: ${TABLE}."perviouscompanyname" ;;
  }

  dimension: reasonforleaving {
    type: string
    sql: ${TABLE}."reasonforleaving" ;;
  }

  dimension: responsbileduties {
    type: string
    sql: ${TABLE}."responsbileduties" ;;
  }

  dimension: salaryfinalrateofpay {
    type: number
    sql: ${TABLE}."salaryfinalrateofpay" ;;
  }

  dimension: salarystartrateofpay {
    type: number
    sql: ${TABLE}."salarystartrateofpay" ;;
  }

  dimension_group: serviceenddate {
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
    sql: ${TABLE}."serviceenddate" ;;
  }

  dimension_group: servicestartdate {
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
    sql: ${TABLE}."servicestartdate" ;;
  }

  dimension: supervisor {
    type: string
    sql: ${TABLE}."supervisor" ;;
  }

  dimension: supervisor_title {
    type: string
    sql: ${TABLE}."supervisor_title" ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}."title" ;;
  }

  measure: count {
    type: count
    drill_fields: [perviouscompanyname]
  }
}
