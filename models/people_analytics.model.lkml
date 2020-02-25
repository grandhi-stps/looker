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
}
