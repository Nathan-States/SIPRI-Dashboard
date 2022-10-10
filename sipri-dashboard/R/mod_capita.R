#' trend UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList 
mod_capita_ui <- function(id) {
  ns <- NS(id)
  fullPage::fullContainer(
    pageContainer(
      h2("Per Capita Comparison", class = "light dark-shadow"),
      h4("x = GDP per Capita | y = Military Spending per Capita", class = "light"),
      echarts4r::echarts4rOutput(ns("capita"), width = "100%", height = "520px")
    )
  )
}

mod_capita_server <- function(input, output, session) {
  ns <- session$ns
  
  # Read in CSVs as Different Files 
  dfGDP2021 <- readr::read_csv("sipri-military-expenditure.csv") %>%
    dplyr::filter(year == 2021) %>%
    dplyr::filter(metric %in% c("GDP Capita")) %>%
    dplyr::select(Country, amount)
      
  dfMSP2021 <- readr::read_csv("sipri-military-expenditure.csv") %>%
    dplyr::filter(year == 2021) %>%
    dplyr::filter(metric %in% c("Military Capita Spending")) %>%
    dplyr::select(Country, amount)
  
  # Join Dataframes  
  dfJoined <- dplyr::left_join(dfGDP2021, dfMSP2021, by = "Country") %>%
    tidyr::drop_na()
  
  # Render Output 
  output$capita <- echarts4r::renderEcharts4r({
    dfJoined %>%
      echarts4r::e_charts(amount.x) %>%
      echarts4r::e_scatter(
        amount.y, 
        bind = Country,
        scale = NULL,
        symbol = "arrow",
        symbol_size = 15
      ) %>%
      echarts4r::e_x_axis(
        formatter = e_axis_formatter("currency", currency = "USD"),
        nameLocation = "end",
        nameTextStyle = list(
          color = "#ffffff",
          fontSize = 11.95
        )
      ) %>%
      echarts4r::e_y_axis(
        formatter = e_axis_formatter("currency", currency = "USD"),
        nameLocation = "middle",
        nameGap = 100,
        nameTextStyle = list(
          color = "#ffffff",
          fontSize = 11.95
        )
      ) %>%
      echarts4r::e_axis_labels(
        x = "GDP Per Capita",
        y = "Military Spending Per Capita"
      ) %>%
      echarts4r::e_hide_grid_lines() %>%
      echarts4r::e_legend(show = FALSE) %>%
      echarts4r::e_color(
        "rgba(250, 249, 250, 0.65)",
        background = "rgba(0, 0, 0, 0)"
      ) %>%
      echarts4r::e_datazoom() %>%
      echarts4r::e_tooltip(
        backgroundColor = "rgba(30, 30, 30, 0.5)",
        borderColor = "rgba(0, 0, 0, 0)",
        textStyle = list(
          color = "#ffffff"
        ),
        formatter = htmlwidgets::JS(
          "function(params) { 
            return('<strong>' + params.name + 
              '</strong><br />GDP per Capita: $' + params.value[0] + 
              '<br />Military Spending per Capita: $' + params.value[1])
          }"
        )
      ) 
  })
}
