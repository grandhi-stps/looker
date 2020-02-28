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




######Rectuitment dashboard Model##########


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

}
