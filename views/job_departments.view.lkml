view: job_departments {
  sql_table_name: hr_data_coe.job_departments ;;

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}."country" ;;
  }

  dimension: departmentcode {
    type: string
    sql: ${TABLE}."departmentcode" ;;
  }

  dimension: departmentname {
    type: string
    sql: ${TABLE}."departmentname" ;;
  }

  dimension: deptid {
    type: number
    value_format_name: id
    sql: ${TABLE}."deptid" ;;
  }

  measure: count {
    type: count
    drill_fields: [departmentname]
  }
}
