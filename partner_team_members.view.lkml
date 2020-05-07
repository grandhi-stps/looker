view: partner_team_members {
  derived_table: {
    sql: select vendor_company.company_id as "Vendor Company Id",
       vendor_company.company_name as "Vendor Company Name",
       partner_company.company_id as "Partner Company Id",
       partner_company.company_name as "Partner Company Name",
       tm1.team_member_id as "Team Member ID"
       --et.user_id



      from xamplify_test.xa_user_d ud left join xamplify_test.xa_company_d vendor_company on
      ud.company_id=vendor_company.company_id
      left join xamplify_test.xa_user_list_d ul on ud.user_id=ul.customer_id
      left join xamplify_test.xa_user_d ud1 on ul.listby_partner_id=ud1.user_id
      left join xamplify_test.xa_company_d partner_company on partner_company.company_id=ud1.company_id
      left join xamplify_test.xa_user_d ud2 on(partner_company.company_id=ud2.company_id)
      left join xamplify_test.xa_team_member_d tm1 on tm1.team_member_id=ud2.user_id
      left join xamplify_test.xa_campaign_d c on(c.customer_id=tm1.team_member_id)
      left join xamplify_test.xa_campaign_user_userlist_d cul on(cul.campaign_id=c.campaign_id)
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: vendor_company_id {
    type: number
    label: "Vendor Company Id"
    sql: ${TABLE}."Vendor Company Id" ;;
  }

  dimension: vendor_company_name {
    type: string
    label: "Vendor Company Name"
    sql: ${TABLE}."Vendor Company Name" ;;
  }

  dimension: partner_company_id {
    type: number
    label: "Partner Company Id"
    sql: ${TABLE}."Partner Company Id" ;;
  }

  dimension: partner_company_name {
    type: string
    label: "Partner Company Name"
    sql: ${TABLE}."Partner Company Name" ;;
  }

  dimension: team_member_id {
    type: number
    label: "Team Member ID"
    sql: ${TABLE}."Team Member ID" ;;
  }

  set: detail {
    fields: [vendor_company_id, vendor_company_name, partner_company_id, partner_company_name, team_member_id]
  }
}
