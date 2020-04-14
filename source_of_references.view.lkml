view: source_of_references {
  derived_table: {
    sql: select type_of_reference ,count(hiredate) Hired,round((cast(count(distinct case when hiredate is not null then ji.applicant_id end) as numeric)/count(distinct re.applicant_id))*100) "Hired%"
       from hr_data_coe.ats_references re left outer join hr_data_coe.job_interviews ji
       on re.applicant_id=ji.applicant_id
       where type_of_reference<>'Vendor'
       group by 1
       order by 2 desc
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: type_of_reference {
    type: string
    sql: ${TABLE}."type_of_reference" ;;
  }

  dimension: hired {
    type: number
    sql: ${TABLE}."hired" ;;
  }

  dimension: hired% {
    type: number
    sql: ${TABLE}."Hired%" ;;
  }

  set: detail {
    fields: [type_of_reference, hired, hired%,]
  }
}
