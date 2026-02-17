
view: bqml_sales_and_historical {
  derived_table: {
    sql: {% raw %} WITH
        -- 1. Get the Historical Data
        historical_data AS (
          SELECT
            DATE(created_date) as created_date,
            SUM(total_sale_price) as actual_sales,
            brand AS brand,
            NULL as forecast_sales, -- Placeholder for forecast columns
            NULL as lower_bound,
            NULL as upper_bound
          FROM
            `jacqui-lags-pbl.bqml_test.sales_daily`
          WHERE
            created_date >= '2022-01-01' AND
            brand IN ("Levi's",'Calvin Klein','Ray-Ban')
          GROUP BY
            1,3
        ),

        -- 2. Get the Forecast Data
        forecast_data AS (
          SELECT
            DATE(forecast_timestamp) as created_date,
            NULL as actual_sales, -- Placeholder for historical columns
            brand as brand,
            forecast_value as forecast_sales,
            prediction_interval_lower_bound as lower_bound,
            prediction_interval_upper_bound as upper_bound
          FROM
            ML.FORECAST(
              MODEL `jacqui-lags-pbl.bqml_test.sales_forecast_model`,
              STRUCT(90 AS horizon, 0.8 AS confidence_level)
            )
        )

      -- 3. Combine them
      SELECT * FROM historical_data
      UNION ALL
      SELECT * FROM forecast_data {% endraw %} ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: created_date {
    type: date
    datatype: date
    sql: ${TABLE}.created_date ;;
  }

  dimension: actual_sales {
    type: number
    sql: ${TABLE}.actual_sales ;;
  }

  dimension: forecast_sales {
    type: number
    sql: ${TABLE}.forecast_sales ;;
  }

  dimension: lower_bound {
    type: number
    sql: ${TABLE}.lower_bound ;;
  }

  dimension: upper_bound {
    type: number
    sql: ${TABLE}.upper_bound ;;
  }
  measure: sum_actual_sales {
    type: sum
    value_format_name: usd
    sql: ${actual_sales} ;;
  }
  measure: sum_forecast_sales {
    type: sum
    value_format_name: usd
    sql: ${forecast_sales} ;;
  }

  set: detail {
    fields: [
        created_date,
  actual_sales,
  forecast_sales,
  lower_bound,
  upper_bound
    ]
  }
}
