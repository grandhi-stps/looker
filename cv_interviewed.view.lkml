view: cv_interviewed {
  derived_table: {
    sql: select count(distinct case when first_stage_status='Yes' then applicant_id end),*
      from hr_data_coe.ats_jobseeker
       ;;
  }

  dimension: count {
    drill_fields: [detail*]
    type: number
    sql: ${TABLE}."count" ;;
  }

  set: detail {
    fields: [count]
  }

}
