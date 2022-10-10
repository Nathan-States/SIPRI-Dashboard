#' global UI Function
#' 
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' 
#' @noRd
#'  
#' @importFrom shiny NS tagList
mod_global_ui <- function(id){
  ns <- NS(id)
  fullPage::pageContainer( 
    pageContainer(
      h2("Spending around the world.", class = "light dark-shadow"),
      h4("Amounts converted to USD. Amounts not adjusted for inflation.", class = "light"),
      echarts4r::echarts4rOutput(ns("global"), width = "100%", height = "61vh"),
      br(),br(),
      p("NOTE: Countries with unknown defense spending are shown with expenditures of $0. Mouse scroll to zoom.", class = "light"),
      uiOutput(ns("desc"))
    )
  )
}

#' global Server Function
#' 
#' @noRd
mod_global_server <- function(input, output, session){
  ns <- session$ns
  
  # Read in CSV 
  dfSIPRI <- readr::read_csv("sipri-military-expenditure.csv") %>%
    echarts4r::e_country_names(Country, country, type = "country.name")%>%
    dplyr::select(Country, year, amount, metric) %>%
    dplyr::filter(metric == "USD Current")
  
  # Render Output 
  output$global <- echarts4r::renderEcharts4r({
    dfSIPRI %>%
      dplyr::group_by(year) %>%
      echarts4r::e_charts(Country, timeline = TRUE) %>%
      echarts4r::e_map(
        amount,  
        roam = TRUE,
        name = "Country"
      ) %>%
      echarts4r::e_visual_map(
        amount, 
        top = "middle",
        type = "continuous",
        textStyle = list(color = "#ffffff"),
        outOfRange = list(
          color = "#f8f8f8"
        ),
        inRange = list(
          color = c("#247BA0", "#B2DBBF", "#ca9afa", "#00cef0")
        ),
        show = FALSE
      ) %>%
      echarts4r::e_visual_map_range(
        selected = list(0, 800000000000)
      ) %>%
      echarts4r::e_color(background = "rgba(0, 0, 0, 0)") %>%
      echarts4r::e_timeline_opts(
        playInterval = 600, 
        currentIndex = 71,
        symbolSize = 4, 
        label = list(
          color = "#f8f8f8"
        ),
        checkpointStyle = list(
          color = "#f8f8f8"
        ),
        lineStyle = list(
          color = "#f8f8f8"
        ),
        controlStyle = list(
          color = "#f8f8f8",
          borderColor = "#f8f8f8"
        )
      ) %>%
      echarts4r::e_tooltip(
        formatter = e_tooltip_choro_formatter("currency", currency = "USD"),
        backgroundColor = "rgba(40, 40, 40, 0.5)",
        borderColor = "rgba(0, 0, 0, 0)",
        textStyle = list(
          color = "#ffffff"
        )
      ) 
  })
}  
