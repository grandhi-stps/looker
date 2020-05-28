view: dimensions {
  derived_table: {
    sql: WITH auto_responses_summary AS (select * from xamplify_test.v_responses
       )
      SELECT
        auto_responses_summary."Partner Company Name"  AS "auto_responses_summary.partner_company_name",
        auto_responses_summary."Campaign Name"  AS "auto_responses_summary.campaign_name",
        COUNT(DISTINCT (auto_responses_summary."#Total Recipients"
      ) ) AS "auto_responses_summary.Total_Recipients",
        COUNT(DISTINCT (auto_responses_summary."#Active Recipients"
      ) ) AS "auto_responses_summary.Active_Recipients",
        Round(100.00* (COUNT(DISTINCT (auto_responses_summary."#Active Recipients"
      ) )
      )/NULLIF ((COUNT(DISTINCT (auto_responses_summary."#Total Recipients"
      ) )
      ),0))  AS "auto_responses_summary.Active_Recipients_Percent",
        COUNT(DISTINCT (auto_responses_summary."#Campaign Email Sent Id"
      ) ) AS "auto_responses_summary.Campaign_Email_Sent",
        COUNT(DISTINCT (auto_responses_summary."#Email Opened (Views)"
      ) ) AS "auto_responses_summary.Email_Opened",
        COUNT(DISTINCT (auto_responses_summary."#Email Clicked"
      ) ) AS "auto_responses_summary.Email_Clicked",
        (COUNT(DISTINCT (auto_responses_summary."#Total Recipients"
      ) )
      )-(COUNT(DISTINCT (auto_responses_summary."#Active Recipients"
      ) )
      )  AS "auto_responses_summary.Email_Not_Opened",
        COUNT(DISTINCT (auto_responses_summary."#Email Auto Responses"
      ) ) AS "auto_responses_summary.Email_Auto_Responses",
        COUNT(DISTINCT (auto_responses_summary."#Email Response Sent Time ID"
      ) ) AS "auto_responses_summary.Email_Auto_Respoonses_Sent",
        COUNT(DISTINCT (auto_responses_summary."#Email Auto Responses Opened"
      ) ) AS "auto_responses_summary.Email_Auto_Responses_Opened",
        COUNT(DISTINCT (auto_responses_summary."#Website Auto Responses"
      ) ) AS "auto_responses_summary.Website_Auto_Responses",
        COUNT(DISTINCT (auto_responses_summary."#Website Response Sent Time ID"
      ) ) AS "auto_responses_summary.Website_Auto_Responses_Sent",
        COUNT(DISTINCT (auto_responses_summary."#Website Auto Responses Opened"
      ) ) AS "auto_responses_summary.Website_Auto_Responses_Opened"
      FROM auto_responses_summary

      WHERE (((auto_responses_summary."Vendor Company Name") = 'Nextiva, Inc.')) AND (((auto_responses_summary."Partner Company Name") = '26 Connect'))
      GROUP BY 1,2
      ORDER BY 3 DESC
      LIMIT 500
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: auto_responses_summary_partner_company_name {
    type: string
    sql: ${TABLE}."auto_responses_summary.partner_company_name" ;;
  }

  dimension: auto_responses_summary_campaign_name {
    type: string
    sql: ${TABLE}."auto_responses_summary.campaign_name" ;;
  }

  dimension: auto_responses_summary_total_recipients {
    type: number
    sql: ${TABLE}."auto_responses_summary.Total_Recipients" ;;
  }

  dimension: auto_responses_summary_active_recipients {
    type: number
    sql: ${TABLE}."auto_responses_summary.Active_Recipients" ;;
  }

  dimension: auto_responses_summary_active_recipients_percent {
    type: number
    sql: ${TABLE}."auto_responses_summary.Active_Recipients_Percent" ;;
  }

  dimension: auto_responses_summary_campaign_email_sent {
    type: number
    sql: ${TABLE}."auto_responses_summary.Campaign_Email_Sent" ;;
  }

  dimension: auto_responses_summary_email_opened {
    type: number
    sql: ${TABLE}."auto_responses_summary.Email_Opened" ;;
  }

  dimension: auto_responses_summary_email_clicked {
    type: number
    sql: ${TABLE}."auto_responses_summary.Email_Clicked" ;;
  }

  dimension: auto_responses_summary_email_not_opened {
    type: number
    sql: ${TABLE}."auto_responses_summary.Email_Not_Opened" ;;
  }

  dimension: auto_responses_summary_email_auto_responses {
    type: number
    sql: ${TABLE}."auto_responses_summary.Email_Auto_Responses" ;;
  }

  dimension: auto_responses_summary_email_auto_respoonses_sent {
    type: number
    sql: ${TABLE}."auto_responses_summary.Email_Auto_Respoonses_Sent" ;;
  }

  dimension: auto_responses_summary_email_auto_responses_opened {
    type: number
    sql: ${TABLE}."auto_responses_summary.Email_Auto_Responses_Opened" ;;
  }

  dimension: auto_responses_summary_website_auto_responses {
    type: number
    sql: ${TABLE}."auto_responses_summary.Website_Auto_Responses" ;;
  }

  dimension: auto_responses_summary_website_auto_responses_sent {
    type: number
    sql: ${TABLE}."auto_responses_summary.Website_Auto_Responses_Sent" ;;
  }

  dimension: auto_responses_summary_website_auto_responses_opened {
    type: number
    sql: ${TABLE}."auto_responses_summary.Website_Auto_Responses_Opened" ;;
  }

  set: detail {
    fields: [
      auto_responses_summary_partner_company_name,
      auto_responses_summary_campaign_name,
      auto_responses_summary_total_recipients,
      auto_responses_summary_active_recipients,
      auto_responses_summary_active_recipients_percent,
      auto_responses_summary_campaign_email_sent,
      auto_responses_summary_email_opened,
      auto_responses_summary_email_clicked,
      auto_responses_summary_email_not_opened,
      auto_responses_summary_email_auto_responses,
      auto_responses_summary_email_auto_respoonses_sent,
      auto_responses_summary_email_auto_responses_opened,
      auto_responses_summary_website_auto_responses,
      auto_responses_summary_website_auto_responses_sent,
      auto_responses_summary_website_auto_responses_opened
    ]
  }
}
