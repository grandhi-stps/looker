view: date_m {
  sql_table_name: hr_data_coe.date_m ;;

  dimension: cal_month {
    type: number
    sql: ${TABLE}."cal_month" ;;
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

  dimension: day_of_month {
    type: number
    sql: ${TABLE}."day_of_month" ;;
  }

  dimension: day_of_week {
    type: number
    sql: ${TABLE}."day_of_week" ;;
  }

  dimension: day_of_year {
    type: number
    sql: ${TABLE}."day_of_year" ;;
  }

  dimension: five_qtr_ago {
    type: string
    sql: ${TABLE}."five_qtr_ago" ;;
  }

  dimension: four_qtr_ago {
    type: string
    sql: ${TABLE}."four_qtr_ago" ;;
  }

  dimension: month_name {
    type: string
    sql: ${TABLE}."month_name" ;;
  }

  dimension: one_qtr_ago {
    type: string
    sql: ${TABLE}."one_qtr_ago" ;;
  }

  dimension: quarter_end {
    type: string
    sql: ${TABLE}."quarter_end" ;;
  }

  dimension: six_qtr_ago {
    type: string
    sql: ${TABLE}."six_qtr_ago" ;;
  }

  dimension: three_qtr_ago {
    type: string
    sql: ${TABLE}."three_qtr_ago" ;;
  }

  dimension: two_qtr_ago {
    type: string
    sql: ${TABLE}."two_qtr_ago" ;;
  }

  dimension: year_month {
    type: number
    sql: ${TABLE}."year_month" ;;
  }

  dimension: yearqtr {
    type: string
    sql: ${TABLE}."yearqtr" ;;
  }

  dimension: yrqtr_num {
    type: number
    sql: ${TABLE}."yrqtr_num" ;;
  }

  measure: count {
    type: count
    drill_fields: [month_name]
  }
}
