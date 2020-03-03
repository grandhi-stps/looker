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
