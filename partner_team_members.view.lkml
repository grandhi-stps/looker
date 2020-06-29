view: partner_team_members {
  derived_table: {
    sql: select
      vendor_company.company_id as "Vendor Company Id",
      vendor_company.company_name as "Vendor Company Name",
      partner_company.company_id as "Partner Company Id",
      partner_company.company_name as "Partner Company Name",
      ud1.user_id as "Partner user_id",
    ul.listby_partner_id as "Partner Users",
    ul.is_partner_userlist as "Is Partner Userlist",
      ud1.email_id as "Partner Email ID",
      ud1.datereg as "Partner Datereg",
      ud1.firstname as "Partner Firstname",
      ud1.lastname as "Partner Lastname",
      tm1.team_member_id as "Team Member ID",
      tm1.email_id as "Team Member Email Id",
      tm1.firstname as "Team Member First Name",
      tm1.lastname as "Team Member Last Name",
      tm1.status as "Team Member Status",
      tm1.created_time as "Team Member Created Time",
      tm1.Role as "User Role",
      ud2.user_id "partner",
      c.campaign_id as "Campaign Id",
      c.campaign_name as "Campaign Name",
      c.campaign_type as "Campaign Type",
      c.campaign_schedule_type as "Campaign Schedule Type",
      c.launch_time as "Campaign Launch Time",
      el.id as "View Id",
      el.user_id as "User Id",
      el.action_id as "Action Id",
      el.time as "Time",
      ur.role_id as "User Role ID"

      from


      xamplify_test.xa_user_d ud left join xamplify_test.xa_company_d vendor_company on
      ud.company_id=vendor_company.company_id
      left join xamplify_test.xa_user_list_d ul on ud.user_id=ul.customer_id
      left join xamplify_test.xa_user_d ud1 on ul.listby_partner_id=ud1.user_id
      left join xamplify_test.xa_company_d partner_company on partner_company.company_id=ud1.company_id
      left join xamplify_test.xa_user_d ud2 on(partner_company.company_id=ud2.company_id)
      left join (select
          tm.team_member_id as "team_member_id",
          tm.email_id ,
          tm.firstname,
          tm.lastname,
          tm.status ,
          tm.created_time,
          'TeamMember' as Role
from xamplify_test.xa_team_member_d tm
where team_member_id in
(select distinct user_id
from xamplify_test.xa_user_role_d
where user_id in
(select distinct  user_id
from xamplify_test.xa_user_d
where company_id in
(select distinct company_id
from xamplify_test.xa_user_d
where user_id in
(select distinct listby_partner_id
from xamplify_test.xa_user_list_d where is_partner_userlist=true
and customer_id in
(select distinct user_id from xamplify_test.xa_user_d ))))
 and user_id not in (select user_id from xamplify_test.xa_user_role_d where role_id =2))

 union all
 (select distinct
          ud.user_id as "team_member_id",
          ud.email_id ,
          ud.firstname,
          ud.lastname,
          ud.status ,
          ud.created_time,
          'OrgAdmin' as Role

from xamplify_test.xa_user_role_d ur
inner join
 xamplify_test.xa_user_d ud on(ud.user_id=ur.user_id)
where ud.company_id in
(select distinct company_id
from xamplify_test.xa_user_d
where user_id in
(select distinct listby_partner_id
from xamplify_test.xa_user_list_d where is_partner_userlist=true
and customer_id in
(select distinct user_id from xamplify_test.xa_user_d )))  and ur.role_id =2))
    tm1 on tm1.team_member_id=ud2.user_id
      left join xamplify_test.xa_campaign_d c on(c.customer_id=tm1.team_member_id)
      --left join xamplify_test.xa_campaign_user_userlist_d cul on(cul.campaign_id=c.campaign_id)
      left join xamplify_test.xa_user_role_d  ur on(ur.user_id=c.customer_id)
      left join xamplify_test.xa_emaillog_d el on(c.campaign_id=el.campaign_id)
      where ul.is_partner_userlist= true
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

  dimension: partner_user_id {
    type: number
    label: "Partner user_id"
    sql: ${TABLE}."Partner user_id" ;;
  }

  dimension: partner_users {
    type: number
    label: "Partner Users"
    sql: ${TABLE}."Partner Users" ;;
  }

  dimension: is_partner_userlist {
    type: string
    label: "Is Partner Userlist"
    sql: ${TABLE}."Is Partner Userlist" ;;
  }

  dimension: partner_email_id {
    type: string
    label: "Partner Email ID"
    sql: ${TABLE}."Partner Email ID" ;;
  }

  dimension_group: partner_datereg {
    type: time
    label: "Partner Datereg"
    sql: ${TABLE}."Partner Datereg" ;;
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

  dimension: team_member_id {
    type: number
    label: "Team Member ID"
    sql: ${TABLE}."Team Member ID" ;;
  }

  dimension: team_member_email_id {
    type: string
    label: "Team Member Email Id"
    sql: ${TABLE}."Team Member Email Id" ;;
  }

  dimension: team_member_first_name {
    type: string
    label: "Team Member First Name"
    sql: ${TABLE}."Team Member First Name" ;;
  }

  dimension: team_member_last_name {
    type: string
    label: "Team Member Last Name"
    sql: ${TABLE}."Team Member Last Name" ;;
  }

  dimension: team_member_status {
    type: string
    label: "Team Member Status"
    sql: ${TABLE}."Team Member Status" ;;
  }

  dimension_group: team_member_created_time {
    type: time
    label: "Team Member Created Time"
    sql: ${TABLE}."Team Member Created Time" ;;
  }

  dimension: user_role {
    type: string
    label: "User Role"
    sql: ${TABLE}."User Role" ;;
  }

  dimension: partner {
    type: number
    sql: ${TABLE}."partner" ;;
  }

  dimension: campaign_id {
    type: number
    label: "Campaign Id"
    sql: ${TABLE}."Campaign Id" ;;
  }

  dimension: campaign_name {
    type: string
    label: "Campaign Name"
    sql: ${TABLE}."Campaign Name" ;;
  }

  dimension: campaign_type {
    type: string
    label: "Campaign Type"
    sql: ${TABLE}."Campaign Type" ;;
  }

  dimension: campaign_schedule_type {
    type: string
    label: "Campaign Schedule Type"
    sql: ${TABLE}."Campaign Schedule Type" ;;
  }

  dimension_group: campaign_launch_time {
    type: time
    label: "Campaign Launch Time"
    sql: ${TABLE}."Campaign Launch Time" ;;
  }

  dimension: view_id {
    type: number
    label: "View Id"
    sql: ${TABLE}."View Id" ;;
  }

  dimension: user_id {
    type: number
    label: "User Id"
    sql: ${TABLE}."User Id" ;;
  }

  dimension: action_id {
    type: number
    label: "Action Id"
    sql: ${TABLE}."Action Id" ;;
  }

  dimension_group: time {
    type: time
    sql: ${TABLE}."Time" ;;
  }

  dimension: user_role_id {
    type: number
    label: "User Role ID"
    sql: ${TABLE}."User Role ID" ;;
  }

  set: detail {
    fields: [
      vendor_company_id,
      vendor_company_name,
      partner_company_id,
      partner_company_name,
      partner_user_id,
      partner_users,
      is_partner_userlist,
      partner_email_id,
      partner_datereg_time,
      partner_firstname,
      partner_lastname,
      team_member_id,
      team_member_email_id,
      team_member_first_name,
      team_member_last_name,
      team_member_status,
      team_member_created_time_time,
      user_role,
      partner,
      campaign_id,
      campaign_name,
      campaign_type,
      campaign_schedule_type,
      campaign_launch_time_time,
      view_id,
      user_id,
      action_id,
      time_time,
      user_role_id
    ]
  }
}
