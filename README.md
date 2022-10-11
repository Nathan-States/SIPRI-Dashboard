# SIPRI-Dashboard

This is a dashboard that displays military spending across all countries, covering several metrics such as USD, inflation-adjusted USD, GDP percent, GDP per capita, military spending per capita, and military spending as a function of total government expenditure. 

The dashboard can be accessed at: https://nathan-states.shinyapps.io/sipri-dashboard/

## Files 

The folder "old-data" contains `sipri.xlsx`, which is the raw Excel sheet provided by SIPRI when downloading the full dataset. `data-cleaning.R` goes through and makes the neccessary changes to convert the `.xlsx` into a usable `.csv`. 

"sipri-dashboard" is where the app itself is stored. The important files / folders are: 

* R: This contains three R files that build the three main slides of the dashboard. 
* `app.r`: The actual UI and server for building the website. 
* `sipri-military-expenditure.csv`: This is the updated `.csv` created from `data-cleaning.R`. 

## Tools Used 

* **RShiny**: Application was uploaded using `rsconnect` on [shinyapps.io](https://www.shinyapps.io/)
* **echarts4r**: This is a wrapper for [Apache ECharts](https://echarts.apache.org/en/index.html), an open-source interactive charting library. 
* **fullPage**: Also a wrapper for [fullpage.js](https://alvarotrigo.com/fullPage/), which allows for one page scrolling websites. 

### Data Source 

Data comes from the [Stockholm International Peace Research Institute](https://www.sipri.org/). You can access the full dataset [here](https://milex.sipri.org/sipri)

### Cover Photo

Photo by [Juli Kosolapova](https://unsplash.com/@yuli_superson)

---

Application was created solely by myself. I hold no affiliation with anyone else. 
