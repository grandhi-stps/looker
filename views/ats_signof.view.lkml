view: ats_signof {
  sql_table_name: hr_data_coe.ats_signof ;;
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

  dimension_group: e_signatue {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."e_signatue_date" ;;
  }

  dimension: e_signature {
    type: string
    sql: ${TABLE}."e_signature" ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
