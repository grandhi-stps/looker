include: "*.view" # include all the views

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
  dimension: role {
    type: string
    sql: ${TABLE}."role" ;;
  }
  dimension: applicant_id {
    type: number
    sql: ${TABLE}."applicant_id" ;;
  }

  dimension: applicant_name {
    type: string
    sql: ${TABLE}."applicant_name" ;;
  }
}
