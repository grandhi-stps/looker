view: vendor_partners {
  derived_table: {
    sql: select
      ul.listby_partner_id  "Total Partners",
            c.company_name as "Vendor Company Name",
            c1.company_name as "Partner Company Name",
            ud1.company_id as "Partner Company ID",
            ul.is_partner_userlist as "is_partner_userlist",
          cam.launch_time as "Launch Time" ,
          ud1.email_id as "Partner Email ID",
          ud1.firstname as "Partner Firstname",
          ud1.lastname as "Partner Lastname",
          ud.created_time as "Partner CreatedTime",
          ud1.datereg as "Datereg",
          ud1.status as"Status",
          ud2.company_id as "Company_id"
          from
            xamplify_test.xa_user_d ud
            left join (select distinct c.company_id,c.company_name from xamplify_test.xa_company_d c, xamplify_test.xa_user_d  u,xamplify_test.xa_user_role_d r
                                   where u.company_id=c.company_id
                                   and u.user_id=r.user_id
                                   and r.role_id in(2,13) and c.company_id not in(231,130,265,266,313,391,280,281,303,307,311,357,320,326,331,334,356,270,368,370,369,372,376,
                                   380,382,398,215,273,410,413,415,374,389,322,332,333,335,367,349,358,359,362,371,378,379,381,385,386,388,393,395,401,414,384,421,424)) as c
                          on(ud.company_id=c.company_id)
          left join  xamplify_test.xa_campaign_d cam on(ud.user_id=cam.customer_id)
          left join  xamplify_test.xa_campaign_d cam1 on(cam.campaign_id=cam1.parent_campaign_id)
          left join xamplify_test.xa_user_list_d ul on(ud.user_id=ul.customer_id)
          left join xamplify_test.xa_user_d ud2 on (ud2.user_id=ul.listby_partner_id)
          left join xamplify_test.xa_user_d ud1 on(ud1.user_id=cam1.customer_id)
          left join xamplify_test.xa_company_d c1 on(ud1.company_id=c1.company_id)
            --where ud.company_id=399
            where ul.is_partner_userlist= true
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: total_partners {
    type: number
    label: "Total Partners"
    sql: ${TABLE}."Total Partners" ;;
  }

  dimension: vendor_company_name {
    type: string
    label: "Vendor Company Name"
    sql: ${TABLE}."Vendor Company Name" ;;
  }

  dimension: partner_company_name {
    type: string
    label: "Partner Company Name"
    sql: ${TABLE}."Partner Company Name" ;;
  }

  dimension: partner_company_id {
    type: number
    label: "Partner Company ID"
    sql: ${TABLE}."Partner Company ID" ;;
  }

  dimension: is_partner_userlist {
    type: string
    sql: ${TABLE}."is_partner_userlist" ;;
  }

  dimension_group: launch_time {
    type: time
    label: "Launch Time"
    sql: ${TABLE}."Launch Time" ;;
  }

  dimension: partner_email_id {
    type: string
    label: "Partner Email ID"
    sql: ${TABLE}."Partner Email ID" ;;
  }

  dimension: partner_firstname {
    type: string
    label: "Partner Firstname"
    sql: ${TABLE}."Partner Firstname" ;;
  }

  dimension: partner_lastname {
    type: string
    label: "Partner Lastname"
    sql: ${TABLE}."Partner Lastname" ;;
  }

  dimension_group: partner_created_time {
    type: time
    label: "Partner CreatedTime"
    sql: ${TABLE}."Partner CreatedTime" ;;
  }

  dimension_group: datereg {
    type: time
    sql: ${TABLE}."Datereg" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."Status" ;;
  }

  dimension: company_id {
    type: number
    sql: ${TABLE}."Company_id" ;;
  }

  set: detail {
    fields: [
      total_partners,
      vendor_company_name,
      partner_company_name,
      partner_company_id,
      is_partner_userlist,
      launch_time_time,
      partner_email_id,
      partner_firstname,
      partner_lastname,
      partner_created_time_time,
      datereg_time,
      status,
      company_id
    ]
  }
}
