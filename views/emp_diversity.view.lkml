view: emp_diversity {
  sql_table_name: hr_data_coe.emp_diversity ;;

  dimension: department {
    type: string
    sql: ${TABLE}."department" ;;
  }

  dimension: emplid {
    type: string
    sql: ${TABLE}."emplid" ;;
  }

  dimension: emprank {
    type: number
    sql: ${TABLE}."emprank" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
