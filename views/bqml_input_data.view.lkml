# If necessary, uncomment the line below to include explore_source.
include: "/models/thelook_ecommerce.model.lkml"

view: bqml_input_data {
  derived_table: {
    explore_source: order_items {
      column: total_sale_price {}
      column: count {}
      column: created_date {}
      column: brand { field: products.brand }
      column: category { field: products.category }
      column: department { field: products.department }
      column: country { field: users.country }
    }
  }
  dimension: total_sale_price {
    description: "Total revenue from order items"
    value_format: "$#,##0.00"
    type: number
  }
  dimension: count {
    description: "Number of order items"
    type: number
  }
  dimension: created_date {
    description: "Date and time the item was added to the order"
    type: date
  }
  dimension: brand {
    description: ""
  }
  dimension: category {
    description: ""
  }
  dimension: department {
    description: ""
  }
  dimension: country {
    description: ""
  }
}
