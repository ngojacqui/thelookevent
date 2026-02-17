view: bqml_sales_forecast_model {

  derived_table: {
    datagroup_trigger: your_datagroup_name
    sql_create:
             CREATE OR REPLACE
            MODEL
              `bqml_test.sales_forecast_model`
            OPTIONS (
              MODEL_TYPE = 'ARIMA_PLUS',
              time_series_timestamp_col = 'created_date',
              time_series_id_col = 'brand',
              time_series_data_col = 'total_sale_price')
          AS
          SELECT
            created_date,
            brand,
            total_sale_price
          FROM
            `bqml_test.sales_daily`
          WHERE
            created_date
            BETWEEN DATE('2022-01-01')
            AND CURRENT_DATE()
            AND brand IN ("Levi's",'Calvin Klein','Ray-Ban');;
  }
}
