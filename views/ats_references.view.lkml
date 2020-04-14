view: ats_references {
  sql_table_name: hr_data_coe.ats_references ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: applicant_id {
    type: number
    sql: ${TABLE}."applicant_id" ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}."email" ;;
  }

  dimension: phone {
    type: string
    sql: ${TABLE}."phone" ;;
  }

  dimension: reference_name {
    type: string
    sql: ${TABLE}."reference_name" ;;
  }

  dimension: type_of_reference {
    type: string
    sql: ${TABLE}."type_of_reference" ;;
  }

  dimension: years_known {
    type: number
    sql: ${TABLE}."years_known" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, reference_name]
  }
}
