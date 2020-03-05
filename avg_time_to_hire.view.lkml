view: avg_time_to_hire {
  derived_table: {
    sql: select abs( round(avg(hiredate-postingdate)))
      from hr_data_coe.job_interviews ji inner join hr_data_coe.job_tech jt
      on ji.applicant_id=jt.techid
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: abs {
    type: number
    sql: ${TABLE}."abs" ;;
  }

  set: detail {
    fields: [abs]
  }
}
