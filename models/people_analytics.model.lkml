connection: "hr_data"

# include all the views
include: "/views/**/*.view"

datagroup: people_analytics_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: people_analytics_default_datagroup

explore: ats_about_us {}

explore: ats_acknowledgment {}

explore: ats_additional_info {}

explore: ats_certification {}

explore: ats_education {}

explore: ats_employment_history {}

explore: ats_jobseeker {}

explore: ats_personal_info {}

explore: ats_references {}

explore: ats_signof {}

explore: date_m {}

explore: emp_attrition {}

explore: emp_attrn {}

explore: emp_attrn_test {}

explore: emp_checkin {}

explore: emp_diversity {}

explore: hrms_expenses {}

explore: job {}

explore: job_departments {}

explore: job_interviews {}

explore: job_tech {}

explore: jobcode_tbl {}

explore: user_roles {}

explore: users {
  join: user_roles {
    type: left_outer
    sql_on: ${users.user_role_id} = ${user_roles.user_role_id} ;;
    relationship: many_to_one
  }
}




explore: Job {
  label: "1 Jobs data ,job seekers"
  view_name:job

  join: job_departments {
    relationship: many_to_one
    sql_on: ${job.dept_id}=${job_departments.deptid} ;;
  }
  join: emp_attrition {
    type: inner
    relationship: one_to_one
    sql_on: ${job.emplid}=${emp_attrition.emplid} ;;
  }
  join: ats_personal_info {
    relationship: one_to_one
    sql_on: ${job.applicant_id}=${ats_personal_info.applicant_id} ;;
  }
  join: emp_diversity {
    relationship: one_to_one
    sql_on: ${job.emplid}=${emp_diversity.emplid} ;;
  }
  join: ats_jobseeker {
    relationship: one_to_one
    sql_on: ${ats_jobseeker.applicant_id}=${job.applicant_id} ;;
  }
  join: emp_checkin {
    type: left_outer
    relationship: one_to_many
    sql_on: ${job.emplid}=${emp_checkin.emplid} ;;
  }
  join: monthly_hours {
    type:inner
    relationship: one_to_one
    sql_on:  ${job.emplid}=${emp_checkin.emplid} ;;
  }
}


  view: monthly_hours {
    derived_table: {
      sql: select round(sum(extract(hour from total_duration))/4) "Avg Monthly Hours"
               from hr_data_coe.emp_checkin where emplid='SA0320086'
               ;;
    }

    measure: count {
      type: count
      drill_fields: [detail*]
    }

    dimension: avg_monthly_hours {
      type: number
      label: "Avg Monthly Hours"
      sql: ${TABLE}."Avg Monthly Hours" ;;
    }


    set: detail {
      fields: [avg_monthly_hours]
    }
  }



############### 2 Work Force Dashboard  ##############

explore: atsjobseeker {
  label: "2 Work force"
  view_name:ats_jobseeker

  join: job{
    type: left_outer
    relationship: one_to_one
    sql_on: ${ats_jobseeker.applicant_id}=${job.applicant_id} ;;
  }
  join: ats_employment_history {
    type: left_outer
    relationship: one_to_one
    sql_on:${ats_jobseeker.applicant_id} =${ats_employment_history.applicant_id} ;;
  }
  join: hrms_expenses {
    type: left_outer
    relationship: one_to_one
    sql_on: ${job.emplid}=${hrms_expenses.emplid} ;;
  }
  join: job_departments {
    type: left_outer
    relationship: many_to_one
    sql_on: ${job.dept_id}=${job_departments.deptid} ;;
  }
  join: date_m {
    type: left_outer
    relationship: many_to_one
    sql_on: ${ats_jobseeker.date_key}=${date_m.date_key} ;;
  }
  join: ats_personal_info {
    type: left_outer
    relationship: one_to_one
    sql_on: ${ats_jobseeker.applicant_id}=${ats_personal_info.applicant_id} ;;
  }
  join: emp_diversity {
    type: left_outer
    relationship: one_to_one
    sql_on: ${job.emplid}=employe-${emp_diversity.emplid} ;;
  }
  join: job_tech {
    type: left_outer
    relationship: one_to_one
    sql_on: ${job.applicant_id}=job-${job_tech.techid} ;;
  }
  join: job_interviews{
    type: left_outer
    relationship: one_to_one
    sql_on: ${ats_jobseeker.applicant_id}=${job_interviews.applicant_id} ;;
  }
  join: leftcount {
    type: left_outer
    relationship: one_to_one
    sql_on: ${ats_jobseeker.applicant_id}=${job_interviews.applicant_id} ;;
  }
  join:hire_vs_left  {
    type: left_outer
    relationship: one_to_one
    sql_on: ${job.applicant_id}=${job_interviews.applicant_id} ;;
  }
}
view: leftcount {
  derived_table: {
    sql: SELECT
        COUNT(DISTINCT (job."emplid")) AS count_of_emplid
      FROM hr_data_coe.ats_jobseeker  AS ats_jobseeker
      LEFT JOIN hr_data_coe.job  AS job ON (ats_jobseeker."applicant_id")=(job."applicant_id")
      LEFT JOIN hr_data_coe.job_interviews  AS job_interviews ON (ats_jobseeker."applicant_id")=(job_interviews."applicant_id")

      WHERE (job."terminationdate"  IS NOT NULL) AND ((((job_interviews."hiredate" ) >= ((SELECT DATE_TRUNC('day', (DATE_TRUNC('year', DATE_TRUNC('day', CURRENT_TIMESTAMP)) + (-2 || ' year')::INTERVAL)))) AND (job_interviews."hiredate" ) < ((SELECT DATE_TRUNC('day', ((DATE_TRUNC('year', DATE_TRUNC('day', CURRENT_TIMESTAMP)) + (-2 || ' year')::INTERVAL) + (3 || ' year')::INTERVAL)))))))
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: count_of_emplid {
    type: number
    sql: ${TABLE}."count_of_emplid" ;;
  }

  set: detail {
    fields: [count_of_emplid]
  }
}

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




######################## 3   Rectuitment dashboard Model  ########################


explore: ats__jobseeker {
  label: "3 Recruitment emp"
  view_name:ats_jobseeker

  join: job{
    type: left_outer
    relationship: one_to_one
    sql_on: ${ats_jobseeker.applicant_id}=${job.applicant_id} ;;
  }
  join: job_interviews {
    type: left_outer
    relationship: one_to_one
    sql_on:${ats_jobseeker.applicant_id} =${job_interviews.applicant_id} ;;
  }
  join:ats_about_us{
    type: left_outer
    relationship: one_to_one
    sql_on: ${ats_jobseeker.applicant_id}=${ats_about_us.applicant_id} ;;
  }
  join: job_tech {
    type: left_outer
    relationship: one_to_one
    sql_on: ${ats_jobseeker.applicant_id}=${job_tech.techid} ;;
  }
  join: job_departments {
    type: left_outer
    relationship: many_to_one
    sql_on: ${job.dept_id}=${job_departments.deptid} ;;
  }
  join: hrms_expenses {
    type: left_outer
    relationship: one_to_one
    sql_on: ${job.emplid}=${hrms_expenses.emplid} ;;
  }
  join: ats_references {
    type: left_outer
    relationship: one_to_one
    sql_on: ${ats_references.applicant_id}=${ats_jobseeker.applicant_id} ;;
  }
  join:  CV_shortlisted {
    type: left_outer
    relationship: one_to_one
    sql_on: ${ats_jobseeker.applicant_id}=${job.applicant_id} ;;
  }
  join:  cv_interviewed {
    type: left_outer
    relationship: one_to_one
    sql_on: ${ats_jobseeker.applicant_id}=${job.applicant_id} ;;
  }
  join: offers_released {
    type: left_outer
    relationship: one_to_one
    sql_on: ${ats_jobseeker.applicant_id}=${job.applicant_id} ;;
  }
  join: acceptance_rate {
    type: left_outer
    relationship: one_to_one
    sql_on: ${ats_jobseeker.applicant_id}=${job.applicant_id} ;;
  }
  join: avg_recruitment_cost {
    type: left_outer
    relationship: one_to_one
    sql_on: ${job.emplid}=${hrms_expenses.emplid} ;;
}
  join: offer_released_vs_candidate_placed {
    type: left_outer
    relationship: one_to_one
    sql_on: ${ats_about_us.applicant_id}=${ats_jobseeker.applicant_id} ;;
  }
  join: dept_wise_openings_placed {
    type: left_outer
    relationship: one_to_one
    sql_on:${ats_jobseeker.applicant_id}=${job_tech.techid} ;;
    }
  join: source_of_references {
    type: left_outer
    relationship: one_to_one
    sql_on: ${ats_references.applicant_id}=${ats_jobseeker.applicant_id} ;;
  }

}
  view: CV_shortlisted {
    derived_table: {
      sql: select  count(distinct case when cv_short_listed='Yes' then applicant_id end)
              from hr_data_coe.ats_jobseeker
               ;;
    }

    dimension: count {
      type: number
      sql: ${TABLE}."count" ;;
    }

  }

view: cv_interviewed {
  derived_table: {
    sql: select count(distinct case when first_stage_status='Yes' then applicant_id end)
      from hr_data_coe.ats_jobseeker
       ;;
  }

  dimension: count {
    type: number
    sql: ${TABLE}."count" ;;
  }

  set: detail {
    fields: [count]
  }
}

view: offers_released {
  derived_table: {
    sql: select count(case when offerdate is not null then applicant_id end)
      from hr_data_coe.job_interviews
       ;;
  }

  dimension: count {
    type: number
    sql: ${TABLE}."count" ;;
  }

  set: detail {
    fields: [count]
  }

}
view: acceptance_rate {
  derived_table: {
    sql: select round((count(hiredate)::numeric/count(offerdate))*100)
      from hr_data_coe.job_interviews
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: round {
    type: number
    sql: ${TABLE}."round" ;;
  }

  set: detail {
    fields: [round]
  }
}
view: avg_recruitment_cost {
  derived_table: {
    sql: select round(avg(cast(recruitment_cost as integer))) from hr_data_coe.hrms_expenses
      ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: round {
    type: number
    sql: ${TABLE}."round" ;;
  }

  set: detail {
    fields: [round]
  }
  }
  view: offer_released_vs_candidate_placed {
  derived_table: {
    sql: select source,count(offerdate),round(cast(count(hiredate) as numeric)/count(offerdate)*100 )
      from hr_data_coe.ats_about_us au inner join hr_data_coe.job_interviews ji
      on ji.applicant_id=au.applicant_id
      group by 1
      order by 2 desc
       ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}."source" ;;
  }

  dimension: count {
    type: number
    sql: ${TABLE}."count" ;;
  }

  dimension: round {
    type: number
    sql: ${TABLE}."round" ;;
  }

  set: detail {
    fields: [source, count, round]
  }
}

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

  dimension: openings {
    type: number
    sql: ${TABLE}."Openings" ;;
  }

  dimension: candidate_placed {
    type: number
    label: "Candidate Placed"
    sql: ${TABLE}."Candidate Placed" ;;
  }

  set: detail {
    fields: [departmentname, openings, candidate_placed]
  }
}

view: source_of_references {
  derived_table: {
    sql: select type_of_reference ,count(hiredate) Hired,round((cast(count(distinct case when hiredate is not null then ji.applicant_id end) as numeric)/count(distinct re.applicant_id))*100) "Hired%"
       from hr_data_coe.ats_references re left outer join hr_data_coe.job_interviews ji
       on re.applicant_id=ji.applicant_id
       where type_of_reference<>'Vendor'
       group by 1
       order by 2 desc
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: type_of_reference {
    type: string
    sql: ${TABLE}."type_of_reference" ;;
  }

  dimension: hired {
    type: number
    sql: ${TABLE}."hired" ;;
  }

  dimension: hire {
    type: number
    sql: ${TABLE}."Hired%" ;;
  }

  set: detail {
    fields: [type_of_reference, hired, hired]
  }
}
