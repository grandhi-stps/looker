view: ats_jobseeker {
  sql_table_name: hr_data_coe.ats_jobseeker ;;

  dimension: applicant_id {
    type: number
    sql: ${TABLE}."applicant_id" ;;
  }

  dimension: applicant_name {
    type: string
    sql: ${TABLE}."applicant_name" ;;
  }

  dimension_group: applied_dt {
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
    sql: ${TABLE}."applied_dt" ;;
  }

  dimension: applied_position {
    type: string
    sql: ${TABLE}."applied_position" ;;
  }

  dimension_group: candidate_rejection {
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
    sql: ${TABLE}."candidate_rejection_date" ;;
  }

  dimension: candidate_rejection_desc {
    type: string
    sql: ${TABLE}."candidate_rejection_desc" ;;
  }

  dimension_group: client_interview {
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
    sql: ${TABLE}."client_interview_date" ;;
  }

  dimension_group: client_rejection {
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
    sql: ${TABLE}."client_rejection_date" ;;
  }

  dimension: client_rejection_desc {
    type: string
    sql: ${TABLE}."client_rejection_desc" ;;
  }

  dimension: current_ctc {
    type: string
    sql: ${TABLE}."current_ctc" ;;
  }

  dimension: current_designation {
    type: string
    sql: ${TABLE}."current_designation" ;;
  }

  dimension: current_location {
    type: string
    sql: ${TABLE}."current_location" ;;
  }

  dimension: cv_short_listed {
    type: string
    sql: ${TABLE}."cv_short_listed" ;;
  }

  dimension: date_key {
    type: number
    sql: ${TABLE}."date_key" ;;
  }

  dimension: employment_type {
    type: string
    sql: ${TABLE}."employment_type" ;;
  }

  dimension: expected_ctc {
    type: string
    sql: ${TABLE}."expected_ctc" ;;
  }

  dimension: first_interview_type {
    type: string
    sql: ${TABLE}."first_interview_type" ;;
  }

  dimension: first_interviewer_name {
    type: string
    sql: ${TABLE}."first_interviewer_name" ;;
  }

  dimension: first_stage {
    type: string
    sql: ${TABLE}."first_stage" ;;
  }

  dimension: first_stage_status {
    type: string
    sql: ${TABLE}."first_stage_status" ;;
  }

  dimension: functional_area {
    type: string
    sql: ${TABLE}."functional_area" ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}."gender" ;;
  }

  dimension: ice_period {
    type: number
    sql: ${TABLE}."ice_period" ;;
  }

  dimension: industry {
    type: string
    sql: ${TABLE}."industry" ;;
  }

  dimension: job_id {
    type: string
    sql: ${TABLE}."job_id" ;;
  }

  dimension: relevant_exp {
    type: number
    sql: ${TABLE}."relevant_exp" ;;
  }

  dimension: role {
    type: string
    sql: ${TABLE}."role" ;;
  }

  dimension: role_category {
    type: string
    sql: ${TABLE}."role_category" ;;
  }

  dimension: salary {
    type: string
    sql: ${TABLE}."salary" ;;
  }

  dimension: second_interview_type {
    type: string
    sql: ${TABLE}."second_interview_type" ;;
  }

  dimension: second_interviewer_name {
    type: string
    sql: ${TABLE}."second_interviewer_name" ;;
  }

  dimension: second_stage {
    type: string
    sql: ${TABLE}."second_stage" ;;
  }

  dimension: second_stage_status {
    type: string
    sql: ${TABLE}."second_stage_status" ;;
  }

  dimension: third_interview_type {
    type: string
    sql: ${TABLE}."third_interview_type" ;;
  }

  dimension: third_interviewer_name {
    type: string
    sql: ${TABLE}."third_interviewer_name" ;;
  }

  dimension: third_stage {
    type: string
    sql: ${TABLE}."third_stage" ;;
  }

  dimension: third_stage_status {
    type: string
    sql: ${TABLE}."third_stage_status" ;;
  }

  dimension: total_exp {
    type: number
    sql: ${TABLE}."total_exp" ;;
  }

  measure: count {
    type: count
    drill_fields: [third_interviewer_name, second_interviewer_name, first_interviewer_name, applicant_name]
  }
}
