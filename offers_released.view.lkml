view: offers_released {
  derived_table: {
    sql: select count(case when offerdate is not null then applicant_id end)
      from hr_data_coe.job_interviews
       ;;
  }

  dimension: count {
    drill_fields: [detail*]
    type: number
    sql: ${TABLE}."count" ;;
  }

  set: detail {
    fields: [count]
  }
}
