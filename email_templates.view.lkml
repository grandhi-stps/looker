view: email_templates {
  derived_table: {
    sql: select
      et. created_time as "Emailtemplate created time",
         et.id as "Emailtemplate ID",
         et .name as "Emailtemplate name",
         r.role_id as "User Role",
        r.description as "Role description",
        t.firstname as "Teammember FirstName",
        t.lastname as "Teammember LastName"

      from xamplify_test.xa_team_member_d t
      inner join xamplify_test.xa_user_role_d up on(t.team_member_id=up.user_id)
      left join xamplify_test.xa_role_d r on(up.role_id=r.role_id)
      inner join xamplify_test.xa_emailtemplates_d et on (t.team_member_id=et.user_id)
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

  dimension: teammember_first_name {
    type: string
    label: "Teammember FirstName"
    sql: ${TABLE}."Teammember FirstName" ;;
  }

  dimension: teammember_last_name {
    type: string
    label: "Teammember LastName"
    sql: ${TABLE}."Teammember LastName" ;;
  }

  set: detail {
    fields: [
      emailtemplate_created_time_time,
      emailtemplate_id,
      emailtemplate_name,
      user_role,
      role_description,
      teammember_first_name,
      teammember_last_name
    ]
  }
}
