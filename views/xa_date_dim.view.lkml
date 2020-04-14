view: xa_date_dim {
  sql_table_name: xamplify_test.xa_date_dim ;;

  dimension: cal_dayofqtr {
    type: number
    sql: ${TABLE}."cal_dayofqtr" ;;
  }

  dimension: cal_dayofweek {
    type: number
    sql: ${TABLE}."cal_dayofweek" ;;
  }

  dimension: cal_dayofyear {
    type: number
    sql: ${TABLE}."cal_dayofyear" ;;
  }

  dimension: cal_month {
    type: number
    sql: ${TABLE}."cal_month" ;;
  }

  dimension: cal_quarter {
    type: number
    sql: ${TABLE}."cal_quarter" ;;
  }

  dimension: cal_week {
    type: number
    sql: ${TABLE}."cal_week" ;;
  }

  dimension: cal_year {
    type: number
    sql: ${TABLE}."cal_year" ;;
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

  dimension: date_key {
    type: number
    sql: ${TABLE}."date_key" ;;
  }

  dimension: month_name {
    type: string
    sql: ${TABLE}."month_name" ;;
  }

  dimension: yearqtr {
    type: string
    sql: ${TABLE}."yearqtr" ;;
  }

  measure: count {
    type: count
    drill_fields: [month_name]
  }
}
