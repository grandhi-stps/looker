view: emp_attrition {
  sql_table_name: hr_data_coe.emp_attrition ;;

  dimension: average_monthly_hours {
    type: number
    sql: ${TABLE}."average_monthly_hours" ;;
  }

  dimension: emplid {
    type: string
    sql: ${TABLE}."emplid" ;;
  }

  dimension: last_evaluation {
    type: number
    sql: ${TABLE}."last_evaluation" ;;
  }

  dimension_group: last_promotion {
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
    sql: ${TABLE}."last_promotion_date" ;;
  }

  dimension: left1 {
    type: number
    sql: ${TABLE}."left1" ;;
  }

  dimension: milestone_year {
    type: number
    sql: ${TABLE}."milestone_year" ;;
  }

  dimension: predicted_left {
    type: number
    sql: ${TABLE}."predicted_left" ;;
  }

  dimension: promotion_last_5years {
    type: number
    sql: ${TABLE}."promotion_last_5years" ;;
  }

  dimension: rating_prior_year_1 {
    type: number
    sql: ${TABLE}."rating_prior_year_1" ;;
  }

  dimension: rating_prior_year_2 {
    type: number
    sql: ${TABLE}."rating_prior_year_2" ;;
  }

  dimension: rating_prior_year_3 {
    type: number
    sql: ${TABLE}."rating_prior_year_3" ;;
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
