# Food-Science

The Shiny App for the course food science was designed to simulate a practical scenario. The lecturer presents a case of an inadequate heating treatment of a food-can. In cooperation with the lecturer, students can modify the heating curve by selecting the maximal core temperature and heating duration. Instantly, the F-value, a sterilization value for food cans, is calculated and displayed beside the heating curve. Afterwards, students have four possible answers to determine the degree of durability for their theoretical cans. The durability depends on the F-value the students achieved with their different temperature and heating duration combinations.


### Installation

Copy the folder www and all files (server.R and ui.R) in one folder named "Food-Science" on your desktop PC or server.
Make sure that following R-packages are installed:
```r
install.packages(shiny)
install.packages(shinydashboard)

```

The App can be run from R using the following code:

```r
library(shiny)
folder = "..\\Food-Science" ### specify the path on your desktop PC to the Food-Science folder
runApp(folder)
```
