view: job_tech {
  sql_table_name: hr_data_coe.job_tech ;;

  dimension: deptid {
    type: number
    value_format_name: id
    sql: ${TABLE}."deptid" ;;
  }

  dimension: job_indicator {
    type: string
    sql: ${TABLE}."job_indicator" ;;
  }

  dimension_group: postingdate {
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
    sql: ${TABLE}."postingdate" ;;
  }

  dimension: role {
    type: string
    sql: ${TABLE}."role" ;;
  }

  dimension: role_category {
    type: string
    sql: ${TABLE}."role_category" ;;
  }

  dimension: techid {
    type: number
    value_format_name: id
    sql: ${TABLE}."techid" ;;
  }

  dimension: vacancy {
    type: number
    sql: ${TABLE}."vacancy" ;;
  }

  dimension_group: vacancydate {
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
    sql: ${TABLE}."vacancydate" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
