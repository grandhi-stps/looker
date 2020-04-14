view: job_interviews {
  sql_table_name: hr_data_coe.job_interviews ;;

  dimension_group: acceptancedate {
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
    sql: ${TABLE}."acceptancedate" ;;
  }

  dimension: applicant_id {
    type: number
    sql: ${TABLE}."applicant_id" ;;
  }

  dimension: deptid {
    type: number
    value_format_name: id
    sql: ${TABLE}."deptid" ;;
  }

  dimension: fullname {
    type: string
    sql: ${TABLE}."fullname" ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}."gender" ;;
  }

  dimension_group: hiredate {
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
    sql: ${TABLE}."hiredate" ;;
  }

  dimension: hiringanalyst {
    type: string
    sql: ${TABLE}."hiringanalyst" ;;
  }

  dimension_group: interviewdate {
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
    sql: ${TABLE}."interviewdate" ;;
  }

  dimension_group: offerdate {
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
    sql: ${TABLE}."offerdate" ;;
  }

  dimension_group: rejectdate {
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
    sql: ${TABLE}."rejectdate" ;;
  }

  measure: count {
    type: count
    drill_fields: [fullname]
  }
}
