view: users {
  sql_table_name: hr_data_coe.users ;;

  dimension: enabled {
    type: number
    sql: ${TABLE}."enabled" ;;
  }

  dimension: password {
    type: string
    sql: ${TABLE}."password" ;;
  }

  dimension: user_role_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."user_role_id" ;;
  }

  dimension: username {
    type: string
    sql: ${TABLE}."username" ;;
  }

  measure: count {
    type: count
    drill_fields: [username, user_roles.rolename, user_roles.user_role_id]
  }
}
