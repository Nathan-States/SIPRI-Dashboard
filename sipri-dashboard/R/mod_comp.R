#' global UI Function
#' 
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' 
#' @noRd
#'  
#' @importFrom shiny NS tagList
mod_comp_ui <- function(id){
  ns <- NS(id)
  fullPage::pageContainer(
    pageContainer(
      h2("Compare between countries"),
      br(),
      fluidRow(
        column(8, uiOutput(ns("country_select_generated"))),
        column(4, uiOutput(ns("metric_select_generated")))
      ),
      shinycssloaders::withSpinner(echarts4r::echarts4rOutput(ns("comp"), width = "100%", height = "460px"))
    )
  )
}

#' comp Server Function
#' 
#' @noRd
mod_comp_server <- function(input, output, session) {
  ns <- session$ns
  
  dfSIPRI <- readr::read_csv("sipri-military-expenditure.csv")
  
  dfSIPRI <- dfSIPRI %>%
    filter(metric != "GDP Capita")
  
  dfSIPRI$year <- as.character(dfSIPRI$year)
  
  dfSIPRI$year <- as.Date(dfSIPRI$year, format = "%Y")
  dfSIPRI$year <- substr(dfSIPRI$year, 1, 4)
  
  output$metric_select_generated <- renderUI({
    cnsA <- dfSIPRI %>%
      dplyr::distinct(metric) %>%
      dplyr::pull(metric)
    
    selectizeInput(
      ns("metric_select"),
      "Choose a metric",
      choices = cnsA,
      selected = c("GDP Percent")
    )
  })
  
  output$country_select_generated <- renderUI({
    cnsB <- dfSIPRI %>%
      dplyr::distinct(Country) %>%
      dplyr::pull(Country)
    
    selectizeInput(
      ns("country_select"),
      "Pick a country",
      choices = cnsB,
      selected = c("Japan", "Russia", "India", "United States"),
      multiple = TRUE,
      width = "100%"
    )
  })
  
  output$comp <- echarts4r::renderEcharts4r({
    req(input$country_select)
    
    validate(
      need(length(input$country_select) > 0, message = "Pick at least one country")
    )
    
    validate(
      need(length(input$metric_select) > 0, message = "Choose at least one metric")
    )
    
    dat <- dfSIPRI %>%
      dplyr::filter(
        Country %in% input$country_select,
        metric %in% input$metric_select
      ) %>%
      tidyr::pivot_wider(
        id_cols = c(Country, year),
        names_from = metric,
        values_from = amount
      )
    
    dat %>%
      dplyr::group_by(Country) %>%
      echarts4r::e_charts(year) %>%
      echarts4r::e_line_(input$metric_select) %>%
      echarts4r::e_hide_grid_lines(which = "x") %>%
      echarts4r::e_legend(type = "scroll") %>%
      e_color(
        c("#ff1654", "#247ba0", "#70c1b3", "#06142a", "#916c86", "#ef571e", "#f3cb15", "#5924a0"),
        "rgb(0, 0, 0, 0)"
      ) %>%
      echarts4r::e_toolbox(bottom = 0) %>% 
      echarts4r::e_toolbox_feature(feature = "dataView") %>%
      echarts4r::e_tooltip(
        backgroundColor = "rgba(30, 30, 30, 0.5)",
        borderColor = "rgba(0, 0, 0, 0)",
        textStyle = list(
          color = "#ffffff"
        ),
        trigger = "axis"
      )
  })
}
