view: xa_team_member_d {
  sql_table_name: xamplify_test.xa_team_member_d ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: company_id {
    type: number
    sql: ${TABLE}."company_id" ;;
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

  dimension: email_id {
    type: string
    sql: ${TABLE}."email_id" ;;
  }

  dimension: firstname {
    type: string
    sql: ${TABLE}."firstname" ;;
  }
  dimension: fullname {
    description: "adding this firstname and lastname"
    type: string
    sql: CONCAT(${TABLE}.firstname,' ', ${TABLE}.lastname) ;;
  }

  dimension: lastname {
    type: string
    sql: ${TABLE}."lastname" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."status" ;;
  }

  dimension: team_member_id {
    type: number
    sql: ${TABLE}."team_member_id" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, firstname, lastname]
  }
}
