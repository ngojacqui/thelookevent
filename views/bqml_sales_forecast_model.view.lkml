view: bqml_sales_forecast_model {

  derived_table: {
    datagroup_trigger: your_datagroup_name
    sql_create:
             CREATE OR REPLACE MODEL
                  ${SQL_TABLE_NAME}
              OPTIONS (
                MODEL_TYPE = 'ARIMA_PLUS_XREG',
                time_series_timestamp_col = 'created_date',
                time_series_data_col = 'total_sale_price')
                  AS
                  SELECT
                     * FROM ${bqml_input_data.SQL_TABLE_NAME};;
  }
}
