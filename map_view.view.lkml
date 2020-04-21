view: map_view {
  derived_table: {
    sql: with
      a as (select cp.company_name, el.country,el.state,max(el.latitude||','||el.longitude) as location
      from xamplify_test.xa_user_d ud left outer join xamplify_test.xa_campaign_d ca
      on (ca.customer_id=ud.user_id) left outer join xamplify_test.xa_company_d cp
      on (cp.company_id=ud.company_id) left outer join xamplify_test.xa_campaign_d ca1
      on(ca1.parent_campaign_id=ca.campaign_id) left outer join xamplify_test.xa_campaign_user_userlist_d cuul
      on(cuul.campaign_id=ca1.campaign_id) left outer join xamplify_test.xa_emaillog_d el
      on (el.campaign_id=cuul.campaign_id and el.user_id=cuul.user_id)
      where  ca1.is_nurture_campaign='true'
      and el.ip_address is not null

      group by 1,2,3
      order by 1,2,3),
      b as (select cp.company_name,el.country,el.state,count(distinct el.user_id) cnt
      from xamplify_test.xa_user_d ud left outer join xamplify_test.xa_campaign_d ca
      on (ca.customer_id=ud.user_id) left outer join xamplify_test.xa_company_d cp
      on (cp.company_id=ud.company_id) left outer join xamplify_test.xa_campaign_d ca1
      on(ca1.parent_campaign_id=ca.campaign_id) left outer join xamplify_test.xa_campaign_user_userlist_d cuul
      on(cuul.campaign_id=ca1.campaign_id) left outer join xamplify_test.xa_emaillog_d el
      on (el.campaign_id=cuul.campaign_id and el.user_id=cuul.user_id)
      where ca1.is_nurture_campaign='true'
      and el.ip_address is not null

      group by 1,2,3
      order by 1,2,3)


      select a.company_name,a.country,a.state
      ,substring(a.location,1,(POSITION(',' IN a.location)-1)) "Latitude"
      ,substring(a.location,(POSITION(',' IN a.location)+1)) "Longitude"
      ,sum(b.cnt)
      from a,b
      where (a.country=b.country and a.state=b.state and a.company_name=b.company_name)
      --and a.company_name='Nextiva, Inc.'
      group by 1,2,3,4,5
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: company_name {
    type: string
    sql: ${TABLE}."company_name" ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}."country" ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}."state" ;;
  }

  dimension: latitude {
    type: string
    sql: ${TABLE}."Latitude" ;;
  }

  dimension: longitude {
    type: string
    sql: ${TABLE}."Longitude" ;;
  }

  dimension: sum {
    type: number
    sql: ${TABLE}."sum" ;;
  }

  dimension: location {
    type: location
    sql_latitude: ${TABLE}."latitude" ;;
    sql_longitude: ${TABLE}."longitude" ;;
  }

  set: detail {
    fields: [
      company_name,
      country,
      state,
      latitude,
      longitude,
      sum,
      location
    ]
  }
}
