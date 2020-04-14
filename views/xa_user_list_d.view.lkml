view: xa_user_list_d {
  sql_table_name: xamplify_test.xa_user_list_d ;;

  dimension: address {
    type: string
    sql: ${TABLE}."address" ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}."city" ;;
  }

  dimension: company_name {
    type: string
    sql: ${TABLE}."company_name" ;;
  }

  dimension: contact_company {
    type: string
    sql: ${TABLE}."contact_company" ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}."country" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."created_time" ;;
  }

  dimension: customer_id {
    type: number
    sql: ${TABLE}."customer_id" ;;
  }

  dimension: email_id {
    type: string
    sql: ${TABLE}."email_id" ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}."first_name" ;;
  }

  dimension: is_partner_userlist {
    type: yesno
    sql: ${TABLE}."is_partner_userlist" ;;
  }

  dimension: job_titile {
    type: string
    sql: ${TABLE}."job_titile" ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}."last_name" ;;
  }

  dimension: listby_partner_id {
    type: number
    sql: ${TABLE}."listby_partner_id" ;;
  }

  dimension: mobile_number {
    type: string
    sql: ${TABLE}."mobile_number" ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}."state" ;;
  }

  dimension: updated_by {
    type: number
    sql: ${TABLE}."updated_by" ;;
  }

  dimension: user_list_id {
    type: number
    sql: ${TABLE}."user_list_id" ;;
  }

  dimension: user_list_key {
    type: number
    sql: ${TABLE}."user_list_key" ;;
  }

  dimension: user_list_name {
    type: string
    sql: ${TABLE}."user_list_name" ;;
  }

  dimension: zip_code {
    type: zipcode
    sql: ${TABLE}."zip_code" ;;
  }

  measure: count {
    type: count
    drill_fields: [first_name, last_name, company_name, user_list_name]
  }
}
