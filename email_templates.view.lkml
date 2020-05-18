
view: email_templates {
  derived_table: {
    sql: select
      et. created_time as "Emailtemplate created time",
         et.id as "Emailtemplate ID",
         et .name as "Emailtemplate name",
        et.type as "Emailtemplate Type",
        et.subject as "Emailtemplate Subject",
         r.role_id as "User Role",
        r.description as "Role description",
       t.team_member_id as "Teammember ID",
          t.email_id as "Teammember email_id",
          t.firstname as "Teammember Firstname",
          t.lastname as "Teammember Lastname",
          t.status as "Teammember status",
          t.created_time as "Teammember Created Time",
          t.company_id as "Teammember company_id",
        c.company_id as "Vendor Company ID",
        c.company_name as "Vendor Company Name",
        u.user_id as "Vendor User ID",
        cam.campaign_id as "Campaign ID",
        cam.campaign_name as "Campaign Name",
        c.email_id as "Email ID",
        u.firstname as "First Name",
        u.lastname as "Last Name",
        u.datereg as "DateReg",
        u.datelastlogin as "Date LastLogin",
        c.country as "Country"


      from xamplify_test.xa_team_member_d t
      inner join xamplify_test.xa_user_role_d up on(t.team_member_id=up.user_id)
      left join xamplify_test.xa_role_d r on(up.role_id=r.role_id)
      inner join xamplify_test.xa_emailtemplates_d et on (t.team_member_id=et.user_id)
      inner join xamplify_test.xa_company_d c on (t.company_id=c.company_id)
      inner join xamplify_test.xa_user_d u on(t.team_member_id=u.user_id)
      inner join xamplify_test.xa_campaign_d cam on(t.team_member_id=cam.customer_id)
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension_group: emailtemplate_created_time {
    type: time
    label: "Emailtemplate created time"
    sql: ${TABLE}."Emailtemplate created time" ;;
  }

  dimension: emailtemplate_id {
    type: number
    label: "Emailtemplate ID"
    sql: ${TABLE}."Emailtemplate ID" ;;
  }

  dimension: emailtemplate_name {
    type: string
    label: "Emailtemplate name"
    sql: ${TABLE}."Emailtemplate name" ;;
  }

  dimension: emailtemplate_type {
    type: string
    label: "Emailtemplate Type"
    sql: ${TABLE}."Emailtemplate Type" ;;
  }

  dimension: emailtemplate_subject {
    type: string
    label: "Emailtemplate Subject"
    sql: ${TABLE}."Emailtemplate Subject" ;;
  }

  dimension: user_role {
    type: number
    label: "User Role"
    sql: ${TABLE}."User Role" ;;
  }

  dimension: role_description {
    type: string
    label: "Role description"
    sql: ${TABLE}."Role description" ;;
  }

  dimension: teammember_id {
    type: number
    label: "Teammember ID"
    sql: ${TABLE}."Teammember ID" ;;
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

  dimension: vendor_user_id {
    type: number
    label: "Vendor User ID"
    sql: ${TABLE}."Vendor User ID" ;;
  }

  dimension: campaign_id {
    type: number
    label: "Campaign ID"
    sql: ${TABLE}."Campaign ID" ;;
  }

  dimension: campaign_name {
    type: string
    label: "Campaign Name"
    sql: ${TABLE}."Campaign Name" ;;
  }

  dimension: email_id {
    type: string
    label: "Email ID"
    sql: ${TABLE}."Email ID" ;;
  }

  dimension: first_name {
    type: string
    label: "First Name"
    sql: ${TABLE}."First Name" ;;
  }

  dimension: last_name {
    type: string
    label: "Last Name"
    sql: ${TABLE}."Last Name" ;;
  }

  dimension_group: date_reg {
    type: time
    sql: ${TABLE}."DateReg" ;;
  }

  dimension_group: date_last_login {
    type: time
    label: "Date LastLogin"
    sql: ${TABLE}."Date LastLogin" ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}."Country" ;;
  }

  set: detail {
    fields: [
      emailtemplate_created_time_time,
      emailtemplate_id,
      emailtemplate_name,
      emailtemplate_type,
      emailtemplate_subject,
      user_role,
      role_description,
      teammember_id,
      teammember_email_id,
      teammember_firstname,
      teammember_lastname,
      teammember_status,
      teammember_created_time_time,
      teammember_company_id,
      vendor_company_id,
      vendor_company_name,
      vendor_user_id,
      campaign_id,
      campaign_name,
      email_id,
      first_name,
      last_name,
      date_reg_time,
      date_last_login_time,
      country
    ]
  }
}
