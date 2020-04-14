view: ats_about_us {
  sql_table_name: hr_data_coe.ats_about_us ;;

  dimension: abt_id {
    type: number
    sql: ${TABLE}."abt_id" ;;
  }

  dimension: applicant_id {
    type: number
    sql: ${TABLE}."applicant_id" ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}."source" ;;
  }

  measure: count {
    type: count
    drill_fields: [abt_id,applicant_id,source]
  }
}
