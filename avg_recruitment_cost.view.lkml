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
