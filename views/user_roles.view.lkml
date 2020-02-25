view: user_roles {
  sql_table_name: hr_data_coe.user_roles ;;
  drill_fields: [user_role_id]

  dimension: user_role_id {
    primary_key: yes
    type: number
    sql: ${TABLE}."user_role_id" ;;
  }

  dimension: rolename {
    type: string
    sql: ${TABLE}."rolename" ;;
  }

  measure: count {
    type: count
    drill_fields: [user_role_id, rolename, users.count]
  }
}
