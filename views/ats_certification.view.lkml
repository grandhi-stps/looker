view: ats_certification {
  sql_table_name: hr_data_coe.ats_certification ;;
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

  dimension: cert_year {
    type: number
    sql: ${TABLE}."cert_year" ;;
  }

  dimension: certificate_me {
    type: string
    sql: ${TABLE}."certificate_me" ;;
  }

  dimension: issuing_body {
    type: string
    sql: ${TABLE}."issuing_body" ;;
  }

  measure: count {
    type: count
    drill_fields: [id,applicant_id,cert_year,certificate_me,issuing_body]
  }
}
