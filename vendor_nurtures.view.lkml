view: vendor_nurtures {
  derived_table: {
    sql: SELECT "xa_user_d"."user_id" AS "user_id",
        "xa_user_d"."email_id" AS "email_id",
        "xa_user_d"."firstname" AS "firstname",
        "xa_user_d"."lastname" AS "lastname",
        "xa_user_d"."datereg" AS "datereg",
        "xa_user_d"."created_time" AS "created_time",
        "xa_user_d"."mobile_number" AS "mobile_number",
        "xa_user_d"."company_id" AS "company_id",
        "xa_user_d"."datereg_key" AS "datereg_key",
        "xa_campaign_d"."campaign_id" AS "campaign_id (xa_campaign_d)",
        "xa_campaign_d"."customer_id" AS "customer_id",
        "xa_campaign_d"."campaign_name" AS "campaign_name",
        "xa_campaign_d"."campaign_type" AS "campaign_type",
        "xa_campaign_d"."created_time" AS "created_time (xa_campaign_d)",
        "xa_campaign_d"."launch_time" AS "launch_time",
        "xa_campaign_d"."parent_campaign_id" AS "parent_campaign_id",
        "xa_campaign_d"."is_launched" AS "is_launched",
        "xa_company_d"."company_id" AS "company_id (xa_company_d)",
        "xa_company_d"."company_name" AS "company_name",
        "xa_drip_email_history_d"."id" AS "id (xa_drip_email_history_d)",
        "xa_drip_email_history_d"."email_template_id" AS "email_template_id",
        "xa_drip_email_history_d"."user_id" AS "user_id (xa_drip_email_history_d)",
        "xa_drip_email_history_d"."sent_time" AS "sent_time",
        "xa_emailtemplates_d"."id" AS "id (xa_emailtemplates_d)",
        "xa_emailtemplates_d"."user_id" AS "user_id (xa_emailtemplates_d)",
        "xa_emailtemplates_d"."name" AS "name",
        "xa_emailtemplates_d"."created_time" AS "created_time (xa_emailtemplates_d)",
        "xa_emailtemplates_d"."type" AS "type",
          CAST("xa_emailtemplates_d"."subject" AS TEXT) AS "subject",
        "xa_user_role_d"."user_id" AS "user_id (xa_user_role_d)",
        "xa_user_role_d"."role_id" AS "role_id"
      FROM "xamplify_test"."xa_user_d" "xa_user_d"
        LEFT JOIN "xamplify_test"."xa_campaign_d" "xa_campaign_d" ON ("xa_user_d"."user_id" = "xa_campaign_d"."customer_id")
        LEFT JOIN "xamplify_test"."xa_company_d" "xa_company_d" ON ("xa_user_d"."company_id" = "xa_company_d"."company_id")
        LEFT JOIN "xamplify_test"."xa_campaign_d" "xa_campaign_d1" ON ("xa_campaign_d"."campaign_id" = "xa_campaign_d1"."parent_campaign_id")
        LEFT JOIN "xamplify_test"."xa_campaign_user_userlist_d" "xa_campaign_user_userlist_d" ON ("xa_campaign_d"."campaign_id" = "xa_campaign_user_userlist_d"."campaign_id")
        left JOIN "xamplify_test"."xa_drip_email_history_d" "xa_drip_email_history_d" ON ("xa_user_d"."user_id" = "xa_drip_email_history_d"."user_id")
        INNER JOIN "xamplify_test"."xa_emailtemplates_d" "xa_emailtemplates_d" ON ("xa_drip_email_history_d"."email_template_id" = "xa_emailtemplates_d"."id")
        left JOIN "xamplify_test"."xa_user_role_d" "xa_user_role_d" ON ("xa_user_d"."user_id" = "xa_user_role_d"."user_id")
        and "xa_company_d"."company_id"=399
        and  "xa_user_role_d"."role_id" in(2,13)
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

  dimension_group: created_time {
    type: time
    sql: ${TABLE}."created_time" ;;
  }

  dimension: mobile_number {
    type: string
    sql: ${TABLE}."mobile_number" ;;
  }

  dimension: company_id {
    type: number
    sql: ${TABLE}."company_id" ;;
  }

  dimension: datereg_key {
    type: number
    sql: ${TABLE}."datereg_key" ;;
  }

  dimension: campaign_id_xa_campaign_d {
    type: number
    label: "campaign_id (xa_campaign_d)"
    sql: ${TABLE}."campaign_id (xa_campaign_d)" ;;
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

  dimension_group: created_time_xa_campaign_d {
    type: time
    label: "created_time (xa_campaign_d)"
    sql: ${TABLE}."created_time (xa_campaign_d)" ;;
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

  dimension: company_id_xa_company_d {
    type: number
    label: "company_id (xa_company_d)"
    sql: ${TABLE}."company_id (xa_company_d)" ;;
  }

  dimension: company_name {
    type: string
    sql: ${TABLE}."company_name" ;;
  }

  dimension: id_xa_drip_email_history_d {
    type: number
    label: "id (xa_drip_email_history_d)"
    sql: ${TABLE}."id (xa_drip_email_history_d)" ;;
  }

  dimension: email_template_id {
    type: number
    sql: ${TABLE}."email_template_id" ;;
  }

  dimension: user_id_xa_drip_email_history_d {
    type: number
    label: "user_id (xa_drip_email_history_d)"
    sql: ${TABLE}."user_id (xa_drip_email_history_d)" ;;
  }

  dimension_group: sent_time {
    type: time
    sql: ${TABLE}."sent_time" ;;
  }

  dimension: id_xa_emailtemplates_d {
    type: number
    label: "id (xa_emailtemplates_d)"
    sql: ${TABLE}."id (xa_emailtemplates_d)" ;;
  }

  dimension: user_id_xa_emailtemplates_d {
    type: number
    label: "user_id (xa_emailtemplates_d)"
    sql: ${TABLE}."user_id (xa_emailtemplates_d)" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."name" ;;
  }

  dimension_group: created_time_xa_emailtemplates_d {
    type: time
    label: "created_time (xa_emailtemplates_d)"
    sql: ${TABLE}."created_time (xa_emailtemplates_d)" ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}."type" ;;
  }

  dimension: subject {
    type: string
    sql: ${TABLE}."subject" ;;
  }

  dimension: user_id_xa_user_role_d {
    type: number
    label: "user_id (xa_user_role_d)"
    sql: ${TABLE}."user_id (xa_user_role_d)" ;;
  }

  dimension: role_id {
    type: number
    sql: ${TABLE}."role_id" ;;
  }

  set: detail {
    fields: [
      user_id,
      email_id,
      firstname,
      lastname,
      datereg_time,
      created_time_time,
      mobile_number,
      company_id,
      datereg_key,
      campaign_id_xa_campaign_d,
      customer_id,
      campaign_name,
      campaign_type,
      created_time_xa_campaign_d_time,
      launch_time_time,
      parent_campaign_id,
      is_launched,
      company_id_xa_company_d,
      company_name,
      id_xa_drip_email_history_d,
      email_template_id,
      user_id_xa_drip_email_history_d,
      sent_time_time,
      id_xa_emailtemplates_d,
      user_id_xa_emailtemplates_d,
      name,
      created_time_xa_emailtemplates_d_time,
      type,
      subject,
      user_id_xa_user_role_d,
      role_id
    ]
  }
}
