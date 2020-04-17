view: nurture_campaigns {
  derived_table: {
    sql: with t1 as (
      select * from xamplify_test.xa_emailtemplates_d order by id limit 13
      ),
      t2 as (select * from xamplify_test.xa_drip_email_history_d)
      select t1.name,t1.subject,t2.user_id,u.email_id,u.firstname,u.lastname,c.company_name,t2.sent_time
      from t1
      left join t2 on (t1.id = t2.email_template_id)
      left join xamplify_test.xa_user_d u on (t2.user_id = u.user_id)
      left join xamplify_test.xa_company_d c on (u.company_id = c.company_id)
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: name {
    type: string
    sql: ${TABLE}."name" ;;
  }

  dimension: subject {
    type: string
    sql: ${TABLE}."subject" ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}."user_id" ;;
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

  dimension: company_name {
    type: string
    sql: ${TABLE}."company_name" ;;
  }

  dimension_group: sent_time {
    type: time
    sql: ${TABLE}."sent_time" ;;
  }

  set: detail {
    fields: [
      name,
      subject,
      user_id,
      email_id,
      firstname,
      lastname,
      company_name,
      sent_time_time
    ]
  }
}
