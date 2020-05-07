view: partner_team_member_contacts {
  derived_table: {
    sql: select vendor_company.company_id as "vendor company id",
          ul1.is_partner_userlist as "is partner userlist",
          vendor_company.company_name as "vendor company name",
          partner_company.company_id as "partner company id",
          partner_company.company_name as "partner company name",
          ul1.listby_partner_id as "listby partner id",
          ul1.created_time as "list created time",
          ul1.user_list_name as "user list name"



      from xamplify_test.xa_user_d ud left join xamplify_test.xa_company_d vendor_company on
      ud.company_id=vendor_company.company_id
      left join xamplify_test.xa_user_list_d ul on ud.user_id=ul.customer_id
      left join xamplify_test.xa_user_d ud1 on ul.listby_partner_id=ud1.user_id
      left join xamplify_test.xa_company_d partner_company on partner_company.company_id=ud1.company_id
      left join xamplify_test.xa_user_d ud2 on(partner_company.company_id=ud2.company_id)
      left join xamplify_test.xa_team_member_d tm1 on tm1.team_member_id=ud2.user_id
      left join xamplify_test.xa_user_list_d ul1 on(tm1.team_member_id=ul1.customer_id)
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: vendor_company_id {
    type: number
    label: "vendor company id"
    sql: ${TABLE}."vendor company id" ;;
  }

  dimension: is_partner_userlist {
    type: string
    label: "is partner userlist"
    sql: ${TABLE}."is partner userlist" ;;
  }

  dimension: vendor_company_name {
    type: string
    label: "vendor company name"
    sql: ${TABLE}."vendor company name" ;;
  }

  dimension: partner_company_id {
    type: number
    label: "partner company id"
    sql: ${TABLE}."partner company id" ;;
  }

  dimension: partner_company_name {
    type: string
    label: "partner company name"
    sql: ${TABLE}."partner company name" ;;
  }

  dimension: listby_partner_id {
    type: number
    label: "listby partner id"
    sql: ${TABLE}."listby partner id" ;;
  }

  dimension_group: list_created_time {
    type: time
    label: "list created time"
    sql: ${TABLE}."list created time" ;;
  }

  dimension: user_list_name {
    type: string
    label: "user list name"
    sql: ${TABLE}."user list name" ;;
  }

  set: detail {
    fields: [
      vendor_company_id,
      is_partner_userlist,
      vendor_company_name,
      partner_company_id,
      partner_company_name,
      listby_partner_id,
      list_created_time_time,
      user_list_name
    ]
  }
}
