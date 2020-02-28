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
