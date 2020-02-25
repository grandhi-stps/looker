view: ats_education {
  sql_table_name: hr_data_coe.ats_education ;;

  dimension: applicant_id {
    type: number
    sql: ${TABLE}."applicant_id" ;;
  }

  dimension: degree_achieved {
    type: string
    sql: ${TABLE}."degree_achieved" ;;
  }

  dimension: edu_city {
    type: string
    sql: ${TABLE}."edu_city" ;;
  }

  dimension: edu_country {
    type: string
    sql: ${TABLE}."edu_country" ;;
  }

  dimension: edu_id {
    type: string
    sql: ${TABLE}."edu_id" ;;
  }

  dimension: edu_state {
    type: string
    sql: ${TABLE}."edu_state" ;;
  }

  dimension: end_date {
    type: string
    sql: ${TABLE}."end_date" ;;
  }

  dimension: school_name {
    type: string
    sql: ${TABLE}."school_name" ;;
  }

  dimension: start_date {
    type: string
    sql: ${TABLE}."start_date" ;;
  }

  measure: count {
    type: count
    drill_fields: [school_name]
  }
}
