view: dept_wise_openings_placed {
  derived_table: {
    sql: select jd.departmentname,sum(vacancy) "Openings",count( case when hiredate is not null then applicant_id end) "Candidate Placed"
      from hr_data_coe.job_tech jt inner join hr_data_coe.job_departments jd
      on jt.deptid=jd.deptid
      inner join hr_data_coe.job_interviews ji
      on ji.applicant_id=jt.techid
      group by 1
      order by 2 desc
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: departmentname {
    type: string
    sql: ${TABLE}."departmentname" ;;
  }

  measure: openings {
    type: number
    sql: ${TABLE}."Openings" ;;
  }

  measure: candidate_placed {
    type: number
    label: "Candidate Placed"
    sql: ${TABLE}."Candidate Placed" ;;
  }

  set: detail {
    fields: [departmentname, openings, candidate_placed]
  }
}
