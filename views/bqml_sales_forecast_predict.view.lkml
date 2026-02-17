view: bqml_sales_forecast_predict {
  derived_table: {
    # sql specifies the SQL SELECT statement that will be used to generate
    # this derived table as a CTE, or a subquery.
    sql:
      SELECT
        created_date,
        brand,
        total_sale_price,
        "history"                       AS `time_series_type`,
      FROM `jacqui-lags-pbl.bqml_test.sales_daily`
      UNION ALL
      SELECT
        created_date,
        brand,
        total_sale_price,
        "forecast"                      AS `time_series_type`,
      FROM ML.FORECAST(
        MODEL `bqml_test.sales_forecast`,
        STRUCT(52 AS `horizon`, 0.80 AS `confidence_level`)
      )
    ;;
  }

  dimension: load_type {
    type: string
    sql: ${TABLE}.load_type ;;
  }

  dimension_group: load_week {
    type: time
    # timeframes define the set of timeframe dimensions
    # the dimension_group will produce. (accessible in the Looker Explore UI)
    timeframes: [
      raw,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.load_week ;;
  }

  dimension: time_serie_type {
    type: string
    sql: ${TABLE}.time_serie_type ;;
  }

  measure: total_load_weight {
    type: number
    sql: SUM(${TABLE}.total_load_weight) ;;
  }

  measure: total_load_weight_lower_bound {
    type: number
    sql: SUM(${TABLE}.total_load_weight_lower_bound) ;;
  }

  measure: total_load_weight_upper_bound {
    type: number
    sql: SUM(${TABLE}.total_load_weight_upper_bound) ;;
  }
}
