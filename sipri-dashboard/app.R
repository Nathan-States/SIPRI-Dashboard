# Import Libraries ----
library(shiny)
library(tidyverse)
library(fullPage)
library(echarts4r)
library(echarts4r.maps)
library(here)
library(typedjs)
library(htmlwidgets)
library(lubridate)
library(emo)

# Set Directory ----
here::set_here()

# Server ---- 
app_server <- function(input, output, session) {
  
  echarts4r::e_common(
    font_family = "Roboto Mono",
    theme = "echarts-theme-states.json"
  )
  
  output$title <- typedjs::renderTyped({
    typedjs::typed("Global Military Expenditure Dashboard", typeSpeed = 22, smartBackspace = TRUE)
  })
  
  callModule(mod_global_server, "global")
  callModule(mod_comp_server, "comp")
  callModule(mod_capita_server, "capita")
}

# UI ----
app_ui <- function() {
  options <- list(easing = "linear", scrollHorizontally = FALSE)
  tagList(
    tags$head(includeCSS("style.css")),
    fullPage::pagePiling(
      sections.color = c("#868b8e", "#2f2f2f", "#faf6f2", "#353d42", "#2f2f2f"),
      opts = options,
      menu = c(
        "Home" = "home",
        "Global Comparison" = "Global",
        "Direct Comparison" = "Comparison",
        "Per Capita Comparison" = "Capita",
        "About" = "about"
      ),
      fullPage::pageSectionImage(
        center = TRUE,
        img = "https://images.unsplash.com/photo-1547234843-4ec3943c856c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=874&q=80",
        menu = "home",
        h1(typedjs::typedOutput("title"), class = "header dark dark-shadow"),
        h3(
          class = "light footer",
          "Photo by", tags$a("Juli Kosolapova", href = "https://unsplash.com/@yuli_superson", class = "link")
        )
      ),
      fullPage::pageSection(
        center = TRUE,
        menu = "Global",
        mod_global_ui("global")
      ),
      fullPage::pageSection(
        center = TRUE,
        menu = "Comparison",
        mod_comp_ui("comp")
      ), 
      fullPage::pageSection(
        center = TRUE,
        menu = "Capita",
        mod_capita_ui("capita")
      ),
      fullPage::pageSection(
        center = TRUE,
        menu = "about",
        h1("About", class = "header dark-shadow"),
        h2(
          class = "dark dark-shadow",
          tags$a("Source Code", href = "google.com", target = "_blank", class = "link"),
          "|",
          tags$a("Data From SIPRI", href = "https://sipri.org/", target = "_blank", class = "link")
        ),
        br(),br(),
        h1(emo::ji("international")),
        h3(
          class = "light footer",
          "Created by", tags$a("Nathan States", href = "google.com", target = "_blank", class = "link")
        )
      )
    )
  )
}

shinyApp(app_ui, app_server)
