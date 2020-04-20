view: partner_nurtures {
  derived_table: {
    sql: SELECT "xa_user_d"."user_id" AS "user_id",
        "xa_user_d"."email_id" AS "email_id",
        "xa_user_d"."firstname" AS "firstname",
        "xa_user_d"."lastname" AS "lastname",
        "xa_user_d"."datereg" AS "datereg",
        "xa_user_d"."created_time" AS "created_time",
        "xa_user_d"."company_id" AS "company_id",
        "xa_company_d"."company_id" AS "company_id (xa_company_d)",
        "xa_company_d"."company_name" AS "company_name",
        "xa_campaign_d1"."campaign_id" AS "campaign_id (xa_campaign_d1)",
        "xa_campaign_d1"."customer_id" AS "customer_id (xa_campaign_d1)",
        "xa_campaign_d1"."campaign_name" AS "campaign_name (xa_campaign_d1)",
        "xa_campaign_d1"."campaign_type" AS "campaign_type (xa_campaign_d1)",
        "xa_campaign_d1"."created_time" AS "created_time (xa_campaign_d1)",
        "xa_campaign_d1"."launch_time" AS "launch_time (xa_campaign_d1)",
        "xa_campaign_d1"."parent_campaign_id" AS "parent_campaign_id (xa_campaign_d1)",
        "xa_campaign_d1"."is_launched" AS "is_launched (xa_campaign_d1)",
        "xa_campaign_user_userlist_d"."campaign_id" AS "campaign_id (xa_campaign_user_userlist_d)",
        "xa_campaign_user_userlist_d"."user_id" AS "user_id (xa_campaign_user_userlist_d)",
        "xa_campaign_user_userlist_d"."email_id" AS "email_id (xa_campaign_user_userlist_d)",
        "xa_campaign_user_userlist_d"."partner_company_name" AS "partner_company_name",
        "xa_campaign_user_userlist_d"."partner_first_name" AS "partner_first_name",
        "xa_campaign_user_userlist_d"."partner_last_name" AS "partner_last_name",
        "xa_campaign_user_userlist_d"."contact_user_id" AS "contact_user_id",
        "xa_campaign_user_userlist_d"."contact_first_name" AS "contact_first_name",
        "xa_campaign_user_userlist_d"."contact_last_name" AS "contact_last_name",
        "xa_campaign_user_userlist_d"."contact_company" AS "contact_company",
        "xa_campaign_user_userlist_d"."contact_mobile_number" AS "contact_mobile_number",
        "xa_drip_email_history_d"."sent_time" AS "sent_time",
        "xa_emailtemplates_d"."name" AS "name",
        CAST("xa_emailtemplates_d"."subject" AS TEXT) AS "subject",
        "xa_user_d1"."user_id" AS "user_id (xa_user_d1)",
        "xa_user_d1"."email_id" AS "email_id (xa_user_d1)",
        "xa_user_d1"."firstname" AS "firstname (xa_user_d1)",
        "xa_user_d1"."lastname" AS "lastname (xa_user_d1)",
        "xa_user_d1"."datereg" AS "datereg (xa_user_d1)",
        "xa_user_d1"."created_time" AS "created_time (xa_user_d1)",
        "xa_user_d1"."company_id" AS "company_id (xa_user_d1)",
        "xa_company_d1"."company_id" AS "company_id (xa_company_d1)",
        "xa_company_d1"."company_name" AS "company_name (xa_company_d1)",
        "xa_user_role_d"."user_id" AS "user_id (xa_user_role_d)",
        "xa_user_role_d"."role_id" AS "role_id"
      FROM "xamplify_test"."xa_user_d" "xa_user_d"
        left JOIN "xamplify_test"."xa_campaign_d" "xa_campaign_d" ON ("xa_user_d"."user_id" = "xa_campaign_d"."customer_id")
        left JOIN "xamplify_test"."xa_campaign_d" "xa_campaign_d1" ON ("xa_campaign_d"."campaign_id" = "xa_campaign_d1"."parent_campaign_id")
        LEFT JOIN "xamplify_test"."xa_company_d" "xa_company_d" ON ("xa_user_d"."company_id" = "xa_company_d"."company_id")
        left JOIN "xamplify_test"."xa_user_d" "xa_user_d1" ON ("xa_campaign_d1"."customer_id" = "xa_user_d1"."user_id")
        LEFT JOIN "xamplify_test"."xa_company_d" "xa_company_d1" ON ("xa_user_d1"."company_id" = "xa_company_d1"."company_id")
        left JOIN "xamplify_test"."xa_drip_email_history_d" "xa_drip_email_history_d" ON ("xa_user_d1"."user_id" = "xa_drip_email_history_d"."user_id")
        INNER JOIN "xamplify_test"."xa_emailtemplates_d" "xa_emailtemplates_d" ON ("xa_drip_email_history_d"."email_template_id" = "xa_emailtemplates_d"."id")
        LEFT JOIN "xamplify_test"."xa_campaign_user_userlist_d" "xa_campaign_user_userlist_d" ON ("xa_campaign_d1"."campaign_id" = "xa_campaign_user_userlist_d"."campaign_id")
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

  dimension: company_id {
    type: number
    sql: ${TABLE}."company_id" ;;
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

  dimension: campaign_id_xa_campaign_d1 {
    type: number
    label: "campaign_id (xa_campaign_d1)"
    sql: ${TABLE}."campaign_id (xa_campaign_d1)" ;;
  }

  dimension: customer_id_xa_campaign_d1 {
    type: number
    label: "customer_id (xa_campaign_d1)"
    sql: ${TABLE}."customer_id (xa_campaign_d1)" ;;
  }

  dimension: campaign_name_xa_campaign_d1 {
    type: string
    label: "campaign_name (xa_campaign_d1)"
    sql: ${TABLE}."campaign_name (xa_campaign_d1)" ;;
  }

  dimension: campaign_type_xa_campaign_d1 {
    type: string
    label: "campaign_type (xa_campaign_d1)"
    sql: ${TABLE}."campaign_type (xa_campaign_d1)" ;;
  }

  dimension_group: created_time_xa_campaign_d1 {
    type: time
    label: "created_time (xa_campaign_d1)"
    sql: ${TABLE}."created_time (xa_campaign_d1)" ;;
  }

  dimension_group: launch_time_xa_campaign_d1 {
    type: time
    label: "launch_time (xa_campaign_d1)"
    sql: ${TABLE}."launch_time (xa_campaign_d1)" ;;
  }

  dimension: parent_campaign_id_xa_campaign_d1 {
    type: number
    label: "parent_campaign_id (xa_campaign_d1)"
    sql: ${TABLE}."parent_campaign_id (xa_campaign_d1)" ;;
  }

  dimension: is_launched_xa_campaign_d1 {
    type: string
    label: "is_launched (xa_campaign_d1)"
    sql: ${TABLE}."is_launched (xa_campaign_d1)" ;;
  }

  dimension: campaign_id_xa_campaign_user_userlist_d {
    type: number
    label: "campaign_id (xa_campaign_user_userlist_d)"
    sql: ${TABLE}."campaign_id (xa_campaign_user_userlist_d)" ;;
  }

  dimension: user_id_xa_campaign_user_userlist_d {
    type: number
    label: "user_id (xa_campaign_user_userlist_d)"
    sql: ${TABLE}."user_id (xa_campaign_user_userlist_d)" ;;
  }

  dimension: email_id_xa_campaign_user_userlist_d {
    type: string
    label: "email_id (xa_campaign_user_userlist_d)"
    sql: ${TABLE}."email_id (xa_campaign_user_userlist_d)" ;;
  }

  dimension: partner_company_name {
    type: string
    sql: ${TABLE}."partner_company_name" ;;
  }

  dimension: partner_first_name {
    type: string
    sql: ${TABLE}."partner_first_name" ;;
  }

  dimension: partner_last_name {
    type: string
    sql: ${TABLE}."partner_last_name" ;;
  }

  dimension: contact_user_id {
    type: number
    sql: ${TABLE}."contact_user_id" ;;
  }

  dimension: contact_first_name {
    type: string
    sql: ${TABLE}."contact_first_name" ;;
  }

  dimension: contact_last_name {
    type: string
    sql: ${TABLE}."contact_last_name" ;;
  }

  dimension: contact_company {
    type: string
    sql: ${TABLE}."contact_company" ;;
  }

  dimension: contact_mobile_number {
    type: string
    sql: ${TABLE}."contact_mobile_number" ;;
  }

  dimension_group: sent_time {
    type: time
    sql: ${TABLE}."sent_time" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."name" ;;
  }

  dimension: subject {
    type: string
    sql: ${TABLE}."subject" ;;
  }

  dimension: user_id_xa_user_d1 {
    type: number
    label: "user_id (xa_user_d1)"
    sql: ${TABLE}."user_id (xa_user_d1)" ;;
  }

  dimension: email_id_xa_user_d1 {
    type: string
    label: "email_id (xa_user_d1)"
    sql: ${TABLE}."email_id (xa_user_d1)" ;;
  }

  dimension: firstname_xa_user_d1 {
    type: string
    label: "firstname (xa_user_d1)"
    sql: ${TABLE}."firstname (xa_user_d1)" ;;
  }

  dimension: lastname_xa_user_d1 {
    type: string
    label: "lastname (xa_user_d1)"
    sql: ${TABLE}."lastname (xa_user_d1)" ;;
  }

  dimension_group: datereg_xa_user_d1 {
    type: time
    label: "datereg (xa_user_d1)"
    sql: ${TABLE}."datereg (xa_user_d1)" ;;
  }

  dimension_group: created_time_xa_user_d1 {
    type: time
    label: "created_time (xa_user_d1)"
    sql: ${TABLE}."created_time (xa_user_d1)" ;;
  }

  dimension: company_id_xa_user_d1 {
    type: number
    label: "company_id (xa_user_d1)"
    sql: ${TABLE}."company_id (xa_user_d1)" ;;
  }

  dimension: company_id_xa_company_d1 {
    type: number
    label: "company_id (xa_company_d1)"
    sql: ${TABLE}."company_id (xa_company_d1)" ;;
  }

  dimension: company_name_xa_company_d1 {
    type: string
    label: "company_name (xa_company_d1)"
    sql: ${TABLE}."company_name (xa_company_d1)" ;;
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
      company_id,
      company_id_xa_company_d,
      company_name,
      campaign_id_xa_campaign_d1,
      customer_id_xa_campaign_d1,
      campaign_name_xa_campaign_d1,
      campaign_type_xa_campaign_d1,
      created_time_xa_campaign_d1_time,
      launch_time_xa_campaign_d1_time,
      parent_campaign_id_xa_campaign_d1,
      is_launched_xa_campaign_d1,
      campaign_id_xa_campaign_user_userlist_d,
      user_id_xa_campaign_user_userlist_d,
      email_id_xa_campaign_user_userlist_d,
      partner_company_name,
      partner_first_name,
      partner_last_name,
      contact_user_id,
      contact_first_name,
      contact_last_name,
      contact_company,
      contact_mobile_number,
      sent_time_time,
      name,
      subject,
      user_id_xa_user_d1,
      email_id_xa_user_d1,
      firstname_xa_user_d1,
      lastname_xa_user_d1,
      datereg_xa_user_d1_time,
      created_time_xa_user_d1_time,
      company_id_xa_user_d1,
      company_id_xa_company_d1,
      company_name_xa_company_d1,
      user_id_xa_user_role_d,
      role_id
    ]
  }
}
