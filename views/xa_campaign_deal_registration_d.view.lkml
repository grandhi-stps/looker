view: xa_campaign_deal_registration_d {
  sql_table_name: xamplify_test.xa_campaign_deal_registration_d ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: campaign_id {
    type: number
    sql: ${TABLE}."campaign_id" ;;
  }

  dimension: company {
    type: string
    sql: ${TABLE}."company" ;;
  }

  dimension: created_by {
    type: number
    sql: ${TABLE}."created_by" ;;
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

  dimension: deal_type {
    type: string
    sql: ${TABLE}."deal_type" ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}."email" ;;
  }

  dimension_group: estimated_closed {
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
    sql: ${TABLE}."estimated_closed_date" ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}."first_name" ;;
  }

  dimension: is_deal {
    type: yesno
    sql: ${TABLE}."is_deal" ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}."last_name" ;;
  }

  dimension: lead_city {
    type: string
    sql: ${TABLE}."lead_city" ;;
  }

  dimension: lead_country {
    type: string
    sql: ${TABLE}."lead_country" ;;
  }

  dimension: lead_id {
    type: number
    sql: ${TABLE}."lead_id" ;;
  }

  dimension: lead_state {
    type: string
    sql: ${TABLE}."lead_state" ;;
  }

  dimension: lead_street {
    type: string
    sql: ${TABLE}."lead_street" ;;
  }

  dimension: opportunity_amount {
    type: number
    sql: ${TABLE}."opportunity_amount" ;;
  }

  dimension: opportunity_role {
    type: string
    sql: ${TABLE}."opportunity_role" ;;
  }

  dimension: parent_campaign_id {
    type: number
    sql: ${TABLE}."parent_campaign_id" ;;
  }

  dimension: partner_company_id {
    type: number
    sql: ${TABLE}."partner_company_id" ;;
  }

  dimension: partner_company_name {
    type: string
    sql: ${TABLE}."partner_company_name" ;;
  }

  dimension: phone {
    type: string
    sql: ${TABLE}."phone" ;;
  }

  dimension: postal_code {
    type: string
    sql: ${TABLE}."postal_code" ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}."title" ;;
  }

  dimension_group: updated {
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
    sql: ${TABLE}."updated_time" ;;
  }

  dimension: website {
    type: string
    sql: ${TABLE}."website" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, last_name, first_name, partner_company_name]
  }
}
