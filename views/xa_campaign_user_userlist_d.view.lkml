view: xa_campaign_user_userlist_d {
  sql_table_name: xamplify_test.xa_campaign_user_userlist_d ;;
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

  dimension: company_name {
    type: string
    sql: ${TABLE}."company_name" ;;
  }

  dimension: email_id {
    type: string
    sql: ${TABLE}."email_id" ;;
  }

  dimension: firstname {
    type: string
    sql: ${TABLE}."firstname" ;;
  }

  dimension: lastname {
    type: string
    sql: ${TABLE}."lastname" ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}."user_id" ;;
  }

  dimension: user_list_id {
    type: number
    sql: ${TABLE}."user_list_id" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, company_name, firstname, lastname]
  }
}
