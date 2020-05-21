view: team_members {
  derived_table: {
    sql: select
          "Vendor Users".datereg as "Teammember Datereg",
          "Vendor Users".datelastlogin as "Teammember Lastlogin",
          "Vendor Campaign".campaign_id as "Vendor Campaign ID",
          "Vendor Campaign".campaign_name as "Vendor Campaign Name",
          "Vendor Company".company_id as "Vendor Company ID",
          "Vendor Company".company_name as "Vendor Company Name",
          "Vendor Campaign".is_launched "Vendor Cam Is Launched",
          "Vendor Campaign".launch_time "Vendor Cam Launch Time",
          "Vendor Campaign".campaign_type "Vendor Campaign Type",
          "Vendor Campaign".campaign_schedule_type "Vendor Cam Schedule Type",
          "Vendor Campaign".created_time "Vendor Cam Created Time",
          "Partner Company".company_id "Partner Company ID",
          "Partner Company".company_name as "Partner Company Name",
          "Partner Users" .email_id as "Partner EmailID",
          "Partner Users" .email_id as "Contact EmailID",
          "Partner Users".firstname as "Partner FirstName",
          "Partner Users".lastname as "Partner LastName",
          "Team Member".team_member_id as "Teammember ID",
          "Team Member".id as "Team ID",
          "Team Member".email_id as "Teammember email_id",
          "Team Member".firstname as "Teammember Firstname",
          "Team Member".lastname as "Teammember Lastname",
          "Team Member".status as "Teammember status",
          "Team Member".created_time as "Teammember Created Time",
          "Team Member".company_id as "Teammember company_id",
          "Userlist".created_time as "Userlist Createdtime",
          "Userlist".is_partner_userlist as "Is Partner UserList",
          "Userlist".listby_partner_id as "List by Partner ID",
          "Userlist".user_list_id as "User List ID",
          "Userlist".user_list_name as "User List Name"

            from
            xamplify_test.xa_team_member_d "Team Member"
            left join xamplify_test.xa_user_d "Vendor Users" on("Team Member".company_id="Vendor Users".company_id)
            inner join xamplify_test.xa_user_role_d ur on(ur.user_id="Vendor Users".user_id )
            left JOIN xamplify_test.xa_company_d "Vendor Company" ON ("Team Member".company_id = "Vendor Company".company_id)
            left JOIN xamplify_test.xa_user_list_d "Userlist" ON ("Userlist".customer_id = "Team Member".team_member_id)
            left JOIN xamplify_test.xa_user_d "Partner Users" ON ("Userlist".listby_partner_id = "Partner Users".user_id)
            left JOIN xamplify_test.xa_company_d "Partner Company" ON ("Partner Users".company_id = "Partner Company".company_id)
            left  join xamplify_test.xa_campaign_d "Vendor Campaign" on ("Vendor Campaign".customer_id="Team Member".team_member_id)
            where ur.role_id in(2,13)
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension_group: teammember_datereg {
    type: time
    label: "Teammember Datereg"
    sql: ${TABLE}."Teammember Datereg" ;;
  }

  dimension_group: teammember_lastlogin {
    type: time
    label: "Teammember Lastlogin"
    sql: ${TABLE}."Teammember Lastlogin" ;;
  }

  dimension: vendor_campaign_id {
    type: number
    label: "Vendor Campaign ID"
    sql: ${TABLE}."Vendor Campaign ID" ;;
  }

  dimension: vendor_campaign_name {
    type: string
    label: "Vendor Campaign Name"
    sql: ${TABLE}."Vendor Campaign Name" ;;
  }

  dimension: vendor_company_id {
    type: number
    label: "Vendor Company ID"
    sql: ${TABLE}."Vendor Company ID" ;;
  }

  dimension: vendor_company_name {
    type: string
    label: "Vendor Company Name"
    sql: ${TABLE}."Vendor Company Name" ;;
  }

  dimension: vendor_cam_is_launched {
    type: string
    label: "Vendor Cam Is Launched"
    sql: ${TABLE}."Vendor Cam Is Launched" ;;
  }

  dimension_group: vendor_cam_launch_time {
    type: time
    label: "Vendor Cam Launch Time"
    sql: ${TABLE}."Vendor Cam Launch Time" ;;
  }

  dimension: vendor_campaign_type {
    type: string
    label: "Vendor Campaign Type"
    sql: ${TABLE}."Vendor Campaign Type" ;;
  }

  dimension: vendor_cam_schedule_type {
    type: string
    label: "Vendor Cam Schedule Type"
    sql: ${TABLE}."Vendor Cam Schedule Type" ;;
  }

  dimension_group: vendor_cam_created_time {
    type: time
    label: "Vendor Cam Created Time"
    sql: ${TABLE}."Vendor Cam Created Time" ;;
  }

  dimension: partner_company_id {
    type: number
    label: "Partner Company ID"
    sql: ${TABLE}."Partner Company ID" ;;
  }

  dimension: partner_company_name {
    type: string
    label: "Partner Company Name"
    sql: ${TABLE}."Partner Company Name" ;;
  }

  dimension: partner_email_id {
    type: string
    label: "Partner EmailID"
    sql: ${TABLE}."Partner EmailID" ;;
  }

  dimension: contact_email_id {
    type: string
    label: "Contact EmailID"
    sql: ${TABLE}."Contact EmailID" ;;
  }

  dimension: partner_first_name {
    type: string
    label: "Partner FirstName"
    sql: ${TABLE}."Partner FirstName" ;;
  }

  dimension: partner_last_name {
    type: string
    label: "Partner LastName"
    sql: ${TABLE}."Partner LastName" ;;
  }

  dimension: teammember_id {
    type: number
    label: "Teammember ID"
    sql: ${TABLE}."Teammember ID" ;;
  }

  dimension: team_id {
    type: number
    label: "Team ID"
    sql: ${TABLE}."Team ID" ;;
  }

  dimension: teammember_email_id {
    type: string
    label: "Teammember email_id"
    sql: ${TABLE}."Teammember email_id" ;;
  }

  dimension: teammember_firstname {
    type: string
    label: "Teammember Firstname"
    sql: ${TABLE}."Teammember Firstname" ;;
  }

  dimension: teammember_lastname {
    type: string
    label: "Teammember Lastname"
    sql: ${TABLE}."Teammember Lastname" ;;
  }

  dimension: teammember_status {
    type: string
    label: "Teammember status"
    sql: ${TABLE}."Teammember status" ;;
  }

  dimension_group: teammember_created_time {
    type: time
    label: "Teammember Created Time"
    sql: ${TABLE}."Teammember Created Time" ;;
  }

  dimension: teammember_company_id {
    type: number
    label: "Teammember company_id"
    sql: ${TABLE}."Teammember company_id" ;;
  }

  dimension_group: userlist_createdtime {
    type: time
    label: "Userlist Createdtime"
    sql: ${TABLE}."Userlist Createdtime" ;;
  }

  dimension: is_partner_user_list {
    type: string
    label: "Is Partner UserList"
    sql: ${TABLE}."Is Partner UserList" ;;
  }

  dimension: list_by_partner_id {
    type: number
    label: "List by Partner ID"
    sql: ${TABLE}."List by Partner ID" ;;
  }

  dimension: user_list_id {
    type: number
    label: "User List ID"
    sql: ${TABLE}."User List ID" ;;
  }

  dimension: user_list_name {
    type: string
    label: "User List Name"
    sql: ${TABLE}."User List Name" ;;
  }

  set: detail {
    fields: [
      teammember_datereg_time,
      teammember_lastlogin_time,
      vendor_campaign_id,
      vendor_campaign_name,
      vendor_company_id,
      vendor_company_name,
      vendor_cam_is_launched,
      vendor_cam_launch_time_time,
      vendor_campaign_type,
      vendor_cam_schedule_type,
      vendor_cam_created_time_time,
      partner_company_id,
      partner_company_name,
      partner_email_id,
      contact_email_id,
      partner_first_name,
      partner_last_name,
      teammember_id,
      team_id,
      teammember_email_id,
      teammember_firstname,
      teammember_lastname,
      teammember_status,
      teammember_created_time_time,
      teammember_company_id,
      userlist_createdtime_time,
      is_partner_user_list,
      list_by_partner_id,
      user_list_id,
      user_list_name
    ]
  }
}
