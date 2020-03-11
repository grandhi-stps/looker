view: cv_shortlisted {
  derived_table: {
    sql: select  count(distinct case when cv_short_listed='Yes' then applicant_id end)
      from hr_data_coe.ats_jobseeker
       ;;
  }

  measure: count {
    type: number
    sql: ${TABLE}."count" ;;

 }
}
