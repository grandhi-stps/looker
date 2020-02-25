view: ats_additional_info {
  sql_table_name: hr_data_coe.ats_additional_info ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: acct_id {
    type: number
    sql: ${TABLE}."acct_id" ;;
  }

  dimension_group: avail_start {
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
    sql: ${TABLE}."avail_start_date" ;;
  }

  dimension: haveworkedwithus {
    type: string
    sql: ${TABLE}."haveworkedwithus" ;;
  }

  dimension: highereducationlevel {
    type: string
    sql: ${TABLE}."highereducationlevel" ;;
  }

  dimension_group: intrestedin {
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
    sql: ${TABLE}."intrestedin" ;;
  }

  dimension: previouspositionsdetails {
    type: string
    sql: ${TABLE}."previouspositionsdetails" ;;
  }

  dimension: realtivesworked {
    type: string
    sql: ${TABLE}."realtivesworked" ;;
  }

  dimension: relativedetails {
    type: string
    sql: ${TABLE}."relativedetails" ;;
  }

  dimension: sponshorshiprequired {
    type: string
    sql: ${TABLE}."sponshorshiprequired" ;;
  }

  dimension: workauthorization {
    type: string
    sql: ${TABLE}."workauthorization" ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
