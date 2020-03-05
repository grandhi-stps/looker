view: early_outs_by_dept_name {
  derived_table: {
    sql: select jd.departmentname,
      case when   (job_end_dt-job_effdt)::numeric/365<=1 then '0-1 yrs'
           when (job_end_dt-job_effdt)::numeric/365>1 and (job_end_dt-job_effdt)::numeric/365<=3 then '1-3 yrs'
         when  (job_end_dt-job_effdt)::numeric/365>3 then '3+ yrs'
         end,
        count(emplid)
      from hr_data_coe.job j inner join hr_data_coe.job_departments jd
      on j.dept_id=jd.deptid
      where job_end_dt is not null
      group by 1,2
      order by 1,2 desc
       ;;
  }

  dimension: departmentname {
    type: string
    sql: ${TABLE}."departmentname" ;;
  }

  dimension: case {
    type: string
    sql: ${TABLE}."case" ;;
  }

  dimension: count {
    type: number
    sql: ${TABLE}."count" ;;
  }

  set: detail {
    fields: [departmentname, case, count]
  }
}
