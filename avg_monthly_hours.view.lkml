include: "*.view" # include all the views

view: avg_monthly_hours {
  derived_table: {
    sql: select round(sum(extract(hour from total_duration))/4) "Avg Monthly Hours"
       from hr_data_coe.emp_checkin where emplid='SA0320086'
       ;;
  }


   dimension: avg_monthly_hours {
    type: number
   label: "Avg Monthly Hours"
    sql: ${TABLE}."Avg Monthly Hours" ;;
  }
set: detail {
    fields: [avg_monthly_hours]
  }
  drill_fields: [detail*]
}
