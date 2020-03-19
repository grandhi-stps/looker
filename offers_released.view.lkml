view: offers_released {
  derived_table: {
    sql: select count(case when offerdate is not null then applicant_id end)
      from hr_data_coe.job_interviews
       ;;
  }
  dimension: applicant_id {
    type: number
    sql: ${TABLE}."applicant_id" ;;
  }

  dimension: applicant_name {
    type: string
    sql: ${TABLE}."applicant_name" ;;
  }
  dimension: role {
    type: string
    sql: ${TABLE}."role" ;;
  }
  dimension: count {
    drill_fields: [detail*]
    type: number
    sql: ${TABLE}."count" ;;
  }

  set: detail {
    fields: [count,applicant_id,applicant_name,role]
  }
}
