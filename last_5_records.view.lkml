view: last_5_records {
  derived_table: {
    sql: SELECT distinct
         xa_user_d.user_id AS user_id,
         xa_company_d.company_name AS company_name,
                  xa_user_d.email_id AS email_id,
                  xa_user_d.firstname AS firstname,
                  xa_user_d.lastname AS lastname,
                  xa_user_d.datereg AS datereg,
                  xa_user_d.datelastlogin AS datelastlogin,
                  xa_user_d.created_time AS created_time,
                 xa_user_d.mobile_number AS mobile_number,

                  xa_campaign_d.campaign_id AS campaign_id_d,
                 xa_campaign_d.customer_id AS customer_id,
                  xa_campaign_d.campaign_name AS campaign_name,
                 xa_campaign_d.campaign_type AS campaign_type,
                  xa_campaign_d.created_time AS created_time_d,
                  xa_campaign_d.launch_time AS launch_time,
                  xa_campaign_d.parent_campaign_id AS parent_campaign_id,
                  xa_campaign_d.is_launched AS is_launched,
                  xa_company_d.company_id AS company_id,

                  xa_drip_email_history_d.user_id AS user_id_drip,
                  xa_drip_email_history_d.sent_time AS sent_time,
                  xa_emailtemplates_d.name AS name,
                  xa_emailtemplates_d.type AS type,
                    CAST(xa_emailtemplates_d.subject AS TEXT) AS subject,
                  xa_user_role_d.role_id AS role_id,
                  xa_drip_email_history_d.action_id as action_id_drip,
                 a.action_type as action_type_a,
                  a.action_id as action_id_a,
                  a.action_name as action_name_a

                FROM xamplify_test.xa_user_d xa_user_d
                  LEFT JOIN (select * from (select campaign_id,customer_id,created_time,campaign_name,campaign_type,
                      launch_time,parent_campaign_id,is_launched,RANK () OVER (
    PARTITION BY customer_id
    ORDER BY launch_time asc
  ) rank
    from xamplify_test.xa_campaign_d) a
    where a.rank<=5  ) as  xa_campaign_d ON (xa_user_d.user_id =xa_campaign_d.customer_id)
                  LEFT JOIN (select * from xamplify_test.xa_company_d where xa_company_d.company_id not in(231,130,265,266,313,391,280,281,303,307,311,357,320,326,331,334,356,270,368,370,369,372,376,
                  380,382,398,215,273,410,413,415,374,389,322,332,333,335,367,349,358,359,362,371,378,379,381,385,386,388,393,395,401,414,384,421,424)) xa_company_d ON (xa_user_d.company_id = xa_company_d.company_id)
                  LEFT JOIN xamplify_test.xa_campaign_d xa_campaign_d1 ON (xa_campaign_d.campaign_id = xa_campaign_d1.parent_campaign_id)
                  LEFT JOIN xamplify_test.xa_campaign_user_userlist_d xa_campaign_user_userlist_d ON (xa_campaign_d.campaign_id = xa_campaign_user_userlist_d.campaign_id)
                  left JOIN (select * from xamplify_test.xa_drip_email_history_d where xa_drip_email_history_d.action_id>=22 and xa_drip_email_history_d.action_id<=36) xa_drip_email_history_d ON (xa_user_d.user_id = xa_drip_email_history_d.user_id)
                  full join (select * from xamplify_test.xa_action_type_d
              where xa_action_type_d.action_id >= 22 and xa_action_type_d.action_id <= 36) a on (xa_drip_email_history_d.action_id=a.action_id)
                  left JOIN xamplify_test.xa_emailtemplates_d xa_emailtemplates_d ON (xa_drip_email_history_d.email_template_id = xa_emailtemplates_d.id)
                  left JOIN xamplify_test.xa_user_role_d xa_user_role_d ON (xa_user_d.user_id = xa_user_role_d.user_id)
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}."user_id" ;;
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

  dimension_group: datereg {
    type: time
    sql: ${TABLE}."datereg" ;;
  }

  dimension_group: datelastlogin {
    type: time
    sql: ${TABLE}."datelastlogin" ;;
  }

  dimension_group: created_time {
    type: time
    sql: ${TABLE}."created_time" ;;
  }

  dimension: mobile_number {
    type: string
    sql: ${TABLE}."mobile_number" ;;
  }

  dimension: campaign_id_d {
    type: number
    sql: ${TABLE}."campaign_id_d" ;;
  }

  dimension: customer_id {
    type: number
    sql: ${TABLE}."customer_id" ;;
  }

  dimension: campaign_name {
    type: string
    sql: ${TABLE}."campaign_name" ;;
  }

  dimension: campaign_type {
    type: string
    sql: ${TABLE}."campaign_type" ;;
  }

  dimension_group: created_time_d {
    type: time
    sql: ${TABLE}."created_time_d" ;;
  }

  dimension_group: launch_time {
    type: time
    sql: ${TABLE}."launch_time" ;;
  }

  dimension: parent_campaign_id {
    type: number
    sql: ${TABLE}."parent_campaign_id" ;;
  }

  dimension: is_launched {
    type: string
    sql: ${TABLE}."is_launched" ;;
  }

  dimension: company_id {
    type: number
    sql: ${TABLE}."company_id" ;;
  }

  dimension: user_id_drip {
    type: number
    sql: ${TABLE}."user_id_drip" ;;
  }

  dimension_group: sent_time {
    type: time
    sql: ${TABLE}."sent_time" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."name" ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}."type" ;;
  }

  dimension: subject {
    type: string
    sql: ${TABLE}."subject" ;;
  }

  dimension: role_id {
    type: number
    sql: ${TABLE}."role_id" ;;
  }

  dimension: action_id_drip {
    type: number
    sql: ${TABLE}."action_id_drip" ;;
  }

  dimension: action_type_a {
    type: string
    sql: ${TABLE}."action_type_a" ;;
  }

  dimension: action_id_a {
    type: number
    sql: ${TABLE}."action_id_a" ;;
  }

  dimension: action_name_a {
    type: string
    sql: ${TABLE}."action_name_a" ;;
  }

  set: detail {
    fields: [
      user_id,
      company_name,
      email_id,
      firstname,
      lastname,
      datereg_time,
      datelastlogin_time,
      created_time_time,
      mobile_number,
      campaign_id_d,
      customer_id,
      campaign_name,
      campaign_type,
      created_time_d_time,
      launch_time_time,
      parent_campaign_id,
      is_launched,
      company_id,
      user_id_drip,
      sent_time_time,
      name,
      type,
      subject,
      role_id,
      action_id_drip,
      action_type_a,
      action_id_a,
      action_name_a
    ]
  }
}
