view: ats_acknowledgment {
  sql_table_name: hr_data_coe.ats_acknowledgment ;;

  dimension: ac_id {
    type: number
    sql: ${TABLE}."ac_id" ;;
  }

  dimension: accknowledgment {
    type: string
    sql: ${TABLE}."accknowledgment" ;;
  }

  dimension: applicant_id {
    type: number
    sql: ${TABLE}."applicant_id" ;;
  }

  measure: count {
    type: count
    drill_fields: [ac_id,accknowledgment,applicant_id]
  }
}
