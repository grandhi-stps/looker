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
