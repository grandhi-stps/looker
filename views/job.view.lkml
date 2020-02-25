view: job {
  sql_table_name: hr_data_coe.job ;;

  dimension: applicant_id {
    type: number
    sql: ${TABLE}."applicant_id" ;;
  }

  dimension: appt_dept_descr {
    type: string
    sql: ${TABLE}."appt_dept_descr" ;;
  }

  dimension: appt_dept_grp {
    type: string
    sql: ${TABLE}."appt_dept_grp" ;;
  }

  dimension: appt_dept_grp_campus_descr {
    type: string
    sql: ${TABLE}."appt_dept_grp_campus_descr" ;;
  }

  dimension: appt_deptid {
    type: string
    sql: ${TABLE}."appt_deptid" ;;
  }

  dimension_group: appt_end {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."appt_end_date" ;;
  }

  dimension: appt_next_higher_deptid {
    type: string
    sql: ${TABLE}."appt_next_higher_deptid" ;;
  }

  dimension: appt_period_descrshort {
    type: string
    sql: ${TABLE}."appt_period_descrshort" ;;
  }

  dimension_group: appt_start {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."appt_start_date" ;;
  }

  dimension: comp_annual_rt {
    type: string
    sql: ${TABLE}."comp_annual_rt" ;;
  }

  dimension: comp_change_amt {
    type: string
    sql: ${TABLE}."comp_change_amt" ;;
  }

  dimension: comp_change_pct {
    type: string
    sql: ${TABLE}."comp_change_pct" ;;
  }

  dimension: comp_frequency {
    type: string
    sql: ${TABLE}."comp_frequency" ;;
  }

  dimension: comp_frequency_descrshort {
    type: string
    sql: ${TABLE}."comp_frequency_descrshort" ;;
  }

  dimension: comp_hourly_rt {
    type: string
    sql: ${TABLE}."comp_hourly_rt" ;;
  }

  dimension: comp_monthly_rt {
    type: string
    sql: ${TABLE}."comp_monthly_rt" ;;
  }

  dimension: comprate {
    type: string
    sql: ${TABLE}."comprate" ;;
  }

  dimension: dept_id {
    type: number
    sql: ${TABLE}."dept_id" ;;
  }

  dimension: empl_rcd {
    type: number
    sql: ${TABLE}."empl_rcd" ;;
  }

  dimension: empl_status {
    type: string
    sql: ${TABLE}."empl_status" ;;
  }

  dimension: empl_status_descr {
    type: string
    sql: ${TABLE}."empl_status_descr" ;;
  }

  dimension: empl_type {
    type: string
    sql: ${TABLE}."empl_type" ;;
  }

  dimension: empl_type_descrshort {
    type: string
    sql: ${TABLE}."empl_type_descrshort" ;;
  }

  dimension: emplid {
    type: string
    sql: ${TABLE}."emplid" ;;
  }

  dimension: fte {
    type: string
    sql: ${TABLE}."fte" ;;
  }

  dimension_group: job_action_dt {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."job_action_dt" ;;
  }

  dimension_group: job_effdt {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."job_effdt" ;;
  }

  dimension_group: job_end_dt {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."job_end_dt" ;;
  }

  dimension_group: job_entry_dt {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."job_entry_dt" ;;
  }

  dimension: job_family {
    type: string
    sql: ${TABLE}."job_family" ;;
  }

  dimension: job_indicator {
    type: string
    sql: ${TABLE}."job_indicator" ;;
  }

  dimension: job_loc_descr {
    type: string
    sql: ${TABLE}."job_loc_descr" ;;
  }

  dimension: job_location {
    type: string
    sql: ${TABLE}."job_location" ;;
  }

  dimension: jobcode {
    type: string
    sql: ${TABLE}."jobcode" ;;
  }

  dimension: jobcode_descr {
    type: string
    sql: ${TABLE}."jobcode_descr" ;;
  }

  dimension: pay_ferquency {
    type: string
    sql: ${TABLE}."pay_ferquency" ;;
  }

  dimension: pay_frequency_descrshort {
    type: string
    sql: ${TABLE}."pay_frequency_descrshort" ;;
  }

  dimension: per_rat_id {
    type: string
    sql: ${TABLE}."per_rat_id" ;;
  }

  dimension: sal_grade {
    type: string
    sql: ${TABLE}."sal_grade" ;;
  }

  measure: salary {
    type: number
    sql: ${TABLE}."salary" ;;
  }

  dimension: supervisor_id {
    type: string
    sql: ${TABLE}."supervisor_id" ;;
  }

  dimension: supervisor_id1 {
    type: number
    value_format_name: id
    sql: ${TABLE}."supervisor_id1" ;;
  }

  dimension: supervisor_name {
    type: string
    sql: ${TABLE}."supervisor_name" ;;
  }

  dimension: termination_type {
    type: string
    sql: ${TABLE}."termination_type" ;;
  }

  dimension_group: terminationdate {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."terminationdate" ;;
  }

  dimension: work_schedule_text {
    type: string
    sql: ${TABLE}."work_schedule_text" ;;
  }

  measure: count {
    type: count
    drill_fields: [supervisor_name]
  }
}
