library(shiny)
library(shinydashboard)
library(tidyverse)
library(forcats)
library(readr)
library(leaflet)
library(data.table)
library(tidyr)
library(stringr)
library(lubridate)

dashboardPage(
    dashboardHeader(title = "Green Room Certifications"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Home", tabName = "home"),
            menuItem("Campus-Wide", tabName = "cw"),
            menuItem("Interhouse", tabName = "hn"),
            menuItem("IntraHouse", tabName = "h"), 
            menuItem("Data", tabName = "data")
        )
    ),
    dashboardBody(
        tags$head(tags$style(HTML(
        '  /* body */
            .content-wrapper, .right-side {
                background-color: white;
            }
            /* navbar */
            .skin-blue .main-header .logo{
                background-color: #78a22f;
            }
            .skin-blue .main-header .navbar {
            background-color: #78a22f;
            }
        '
            )
          ),
        tags$link(rel = "stylesheet", type = "text/css", href = "prac.css")
        ),
        tabItems(
            tabItem("home",
                    fluidRow(tags$div(id = "whole"),
                      htmlTemplate("com.html", name = "component1")       
            )),
            tabItem("cw",
                fluidRow(
                    tags$div(style = "text-align:center;",
                             tags$h1("Let's Look at Campus Wide Certificates!"))
                    ,
                    tags$div(style = "padding-left:50px; padding-right:50px;padding-bottom:25px;",
                             tags$body("Wow! Harvard undergraduates are so sustainable! But if you would like 
                                       to see a breakdown of which houses or neighborhoods are the most sustainable go to the next page!"))
                ), 
                fluidRow(
                    column(width = 5,
                           plotOutput("camp_bar")
                         ),
                    column(width=5, 
                           plotOutput("pie")
                    ),
                    column(width = 2, tableOutput("cam")
                    )
                )
            ),
            tabItem("hn",
                fluidRow(
                    tags$div(style = "text-align:center;",
                             tags$h1("How do Houses or Neighborhoods Compare?"))
                    ,
                    tags$div(style = "padding-left:50px; padding-right:50px;padding-bottom:25px;",
                             tags$body("Understanding how your House / Neighborhood compares to 
                               the other Houses / Neighborhoods on campus can foster a 
                               friendly competitive spirit and encourage greater participation
                               as a whole. Use the graph below to figure out where your hours or hood ranks!"))
                ),
                fluidRow(
                    column(width = 6,
                           tabBox(width = NULL,
                               title = "",
                               # The id lets us use input$tabset1 on the server to find the current tab
                               id = "tabset1", height = "250px",
                               tabPanel("By House", plotOutput("h")),
                               tabPanel("By Neighborhood", plotOutput("ne"))
                           )), 
                    column(width = 3, 
                               tableOutput("housss")
                           ),
                    column(width = 3, 
                           tableOutput("neisss")
                           )
                    )
                ),
            tabItem("h",
                fluidRow(
                    tags$div(style = "text-align:center;",
                             tags$h1("How do Buildings or Floors Compare?"))
                    ,
                    tags$div(style = "padding-left:50px; padding-right:50px;padding-bottom:25px;",
                             tags$body("You can dig even deeper by understanding how each floor 
                               or building in a specific house is doing. There can be prizes or competitions within
                               a single House to encourage house residents to get certified!"))
                ), 
                fluidRow(
                    column(width = 7,
                          tabBox(width = NULL,
                            title = "",
                            # The id lets us use input$tabset1 on the server to find the current tab
                            id = "tab", height = "250px",
                            tabPanel("By Building", plotOutput("build")),
                            tabPanel("By Floor", plotOutput("floor"))
                        ) 
                ), 
                column(width = 5, 
                       box(width = NULL,
                           selectInput("hus", "House", choices = c("Leverett","Cabot",
                            "Eliot","Mather", "Kirkland", "Pfoho","Adams","Winthrop","Currier","Quincy","Lowell","Dunster"))
                       ),
                       tableOutput("intra"),
                       box(width = NULL, 
                           radioButtons('bs', 'Building', choices = c("Main","Not Main"),selected = "Main")
                          ), 
                       tableOutput("int")
                )
            )
        ),
        tabItem("data",
            fluidRow(
                tags$div(style = "text-align:center;",
                         tags$h1("Database Set-Up"))
                ,
                tags$div(style = "padding-left:50px; padding-right:50px;padding-bottom:25px;",
                         tags$body("Here is what my dummy database looks like. I thought that each
                               observation in the database should be a unique room that has been certified. 
                               That means there is no information about rooms that haven't signed up to be certified nor is 
                               there any information about the students (name, class) in a room that has been certified. 
                               This can limiting in some ways. For example, unless one knew exactly how many rooms were in 
                               each entryway on each floor in each building... one doesn't have any information about participation 
                               percentages. Also, the only way to reach that student (for an award or something) is to physically find 
                               her room, as opposed to emailing her. I don't pretend to understand--from a security standpoint--how 
                               / OFS would build and maintain a database like this...but this is my rudimentry attempt to showcase what
                               could be done for the Green Rooms Certification project."))
            ), 
            fluidRow(
            tags$div(style = "padding-left:50px; padding-right:50px;",
                DT::dataTableOutput("table"),
                tags$div(
                  tags$body("Here is real data, which is collected, processes, and cleaned directly from a download from the
                            Qualtrics survey data. From this point,determine what total points would equal what level certification. But I will leave that to someone else.
                            To get more rows, I would have to personlly take the survey multiple times.
                            I didn't control for a lot of the user errors that could occur if a real user was taking the survey (for example, errors and mispelling)
                            but that is a lot of work that could be dealt with later!")),
                DT::dataTableOutput("act"))
            )
        )
    )
))
