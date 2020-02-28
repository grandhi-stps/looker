view: hire_vs_left {
  derived_table: {
    sql: select extract(year from job_effdt) ,
      count(distinct case when hiredate  is not null then j.emplid end) hire,
      count(distinct case when terminationdate is not null then (emplid) end) leftcount
      from hr_data_coe.job j,hr_data_coe.job_interviews ji
      where j.applicant_id=ji.applicant_id
      group by extract(year from job_effdt)
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: date_part {
    type: number
    sql: ${TABLE}."date_part" ;;
  }

  dimension: hire {
    type: number
    sql: ${TABLE}."hire" ;;
  }

  dimension: leftcount {
    type: number
    sql: ${TABLE}."leftcount" ;;
  }

  set: detail {
    fields: [date_part, hire, leftcount]
  }
}
