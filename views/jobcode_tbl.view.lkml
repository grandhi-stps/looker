view: jobcode_tbl {
  sql_table_name: hr_data_coe.jobcode_tbl ;;

  dimension: ben_family {
    type: string
    sql: ${TABLE}."ben_family" ;;
  }

  dimension: ben_family_descr {
    type: string
    sql: ${TABLE}."ben_family_descr" ;;
  }

  dimension: dual_jobcode {
    type: string
    sql: ${TABLE}."dual_jobcode" ;;
  }

  dimension: eg_academic_rank {
    type: string
    sql: ${TABLE}."eg_academic_rank" ;;
  }

  dimension: eg_academic_rank_descr {
    type: string
    sql: ${TABLE}."eg_academic_rank_descr" ;;
  }

  dimension: eg_rank_ipeds {
    type: string
    sql: ${TABLE}."eg_rank_ipeds" ;;
  }

  dimension: eg_rank_ipeds_descr {
    type: string
    sql: ${TABLE}."eg_rank_ipeds_descr" ;;
  }

  dimension: eg_track_flag {
    type: string
    sql: ${TABLE}."eg_track_flag" ;;
  }

  dimension: flsa_min_rt {
    type: number
    sql: ${TABLE}."flsa_min_rt" ;;
  }

  dimension: flsa_status {
    type: string
    sql: ${TABLE}."flsa_status" ;;
  }

  dimension: flsa_status_descrshort {
    type: string
    sql: ${TABLE}."flsa_status_descrshort" ;;
  }

  dimension: ipedsscode {
    type: string
    sql: ${TABLE}."ipedsscode" ;;
  }

  dimension: ipedsscode_descr {
    type: string
    sql: ${TABLE}."ipedsscode_descr" ;;
  }

  dimension: job_class_lvl {
    type: string
    sql: ${TABLE}."job_class_lvl" ;;
  }

  dimension: job_class_series {
    type: string
    sql: ${TABLE}."job_class_series" ;;
  }

  dimension: job_family {
    type: string
    sql: ${TABLE}."job_family" ;;
  }

  dimension: job_family_descr {
    type: string
    sql: ${TABLE}."job_family_descr" ;;
  }

  dimension: jobcode {
    type: string
    sql: ${TABLE}."jobcode" ;;
  }

  dimension: jobcode_descr {
    type: string
    sql: ${TABLE}."jobcode_descr" ;;
  }

  dimension: jobcode_eff_status {
    type: string
    sql: ${TABLE}."jobcode_eff_status" ;;
  }

  dimension_group: jobcode_effdt {
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
    sql: ${TABLE}."jobcode_effdt" ;;
  }

  dimension_group: jobcode_end {
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
    sql: ${TABLE}."jobcode_end_date" ;;
  }

  dimension: jobcode_mgt_comm_cd {
    type: string
    sql: ${TABLE}."jobcode_mgt_comm_cd" ;;
  }

  dimension: jobcode_mgt_comm_descr {
    type: string
    sql: ${TABLE}."jobcode_mgt_comm_descr" ;;
  }

  dimension: jobcode_paygroup {
    type: string
    sql: ${TABLE}."jobcode_paygroup" ;;
  }

  dimension: jobcode_paygroup_descr {
    type: string
    sql: ${TABLE}."jobcode_paygroup_descr" ;;
  }

  dimension: jobgroup {
    type: string
    sql: ${TABLE}."jobgroup" ;;
  }

  dimension: jobgroup_descr {
    type: string
    sql: ${TABLE}."jobgroup_descr" ;;
  }

  dimension: license_cert {
    type: string
    sql: ${TABLE}."license_cert" ;;
  }

  dimension: max_rt_annual {
    type: number
    sql: ${TABLE}."max_rt_annual" ;;
  }

  dimension: max_rt_hourly {
    type: number
    sql: ${TABLE}."max_rt_hourly" ;;
  }

  dimension: max_rt_monthly {
    type: number
    sql: ${TABLE}."max_rt_monthly" ;;
  }

  dimension: mid_rt_annual {
    type: number
    sql: ${TABLE}."mid_rt_annual" ;;
  }

  dimension: mid_rt_hourly {
    type: number
    sql: ${TABLE}."mid_rt_hourly" ;;
  }

  dimension: mid_rt_monthly {
    type: number
    sql: ${TABLE}."mid_rt_monthly" ;;
  }

  dimension: min_rt_annual {
    type: number
    sql: ${TABLE}."min_rt_annual" ;;
  }

  dimension: min_rt_hourly {
    type: number
    sql: ${TABLE}."min_rt_hourly" ;;
  }

  dimension: min_rt_monthly {
    type: number
    sql: ${TABLE}."min_rt_monthly" ;;
  }

  dimension: reg_temp {
    type: string
    sql: ${TABLE}."reg_temp" ;;
  }

  dimension: reg_temp_descrshort {
    type: string
    sql: ${TABLE}."reg_temp_descrshort" ;;
  }

  dimension: regental_approval {
    type: string
    sql: ${TABLE}."regental_approval" ;;
  }

  dimension: sal_admin_plan {
    type: string
    sql: ${TABLE}."sal_admin_plan" ;;
  }

  dimension: sal_admin_plan_descr {
    type: string
    sql: ${TABLE}."sal_admin_plan_descr" ;;
  }

  dimension: sal_grade {
    type: string
    sql: ${TABLE}."sal_grade" ;;
  }

  dimension: sal_grade_descr {
    type: string
    sql: ${TABLE}."sal_grade_descr" ;;
  }

  dimension: union_cd {
    type: string
    sql: ${TABLE}."union_cd" ;;
  }

  dimension: union_descr {
    type: string
    sql: ${TABLE}."union_descr" ;;
  }

  dimension: us_soc_cd {
    type: string
    sql: ${TABLE}."us_soc_cd" ;;
  }

  dimension: us_soc_descr {
    type: string
    sql: ${TABLE}."us_soc_descr" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
