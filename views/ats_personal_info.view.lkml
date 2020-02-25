view: ats_personal_info {
  sql_table_name: hr_data_coe.ats_personal_info ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}."id" ;;
  }

  dimension: applicant_id {
    type: number
    sql: ${TABLE}."applicant_id" ;;
  }

  dimension: bestmethodtocontact {
    type: string
    sql: ${TABLE}."bestmethodtocontact" ;;
  }

  dimension_group: dob {
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
    sql: ${TABLE}."dob" ;;
  }

  dimension: firstname {
    type: string
    sql: ${TABLE}."firstname" ;;
  }

  dimension: lastname {
    type: string
    sql: ${TABLE}."lastname" ;;
  }

  dimension: middle {
    type: string
    sql: ${TABLE}."middle" ;;
  }

  dimension: per_info_city {
    type: string
    sql: ${TABLE}."per_info_city" ;;
  }

  dimension: per_info_country {
    type: string
    sql: ${TABLE}."per_info_country" ;;
  }

  dimension: per_info_state {
    type: string
    sql: ${TABLE}."per_info_state" ;;
  }

  dimension: phonenumber {
    type: string
    sql: ${TABLE}."phonenumber" ;;
  }

  dimension: streetaddress {
    type: string
    sql: ${TABLE}."streetaddress" ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}."zipcode" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, firstname, lastname]
  }
}
