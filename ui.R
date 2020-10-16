
dashboardPage(
  dashboardHeader(title = "Rail carloads vs. Stock prices", titleWidth = 300),
  dashboardSidebar(width = 300, 
                   sidebarUserPanel("Hong C. Kim",
                                    image = 'data:image/jpeg;base64,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'),
                   sidebarMenu(
                     menuItem("Intro", tabName = "intro", icon = icon("book")),
                     menuItem("Class 1 Rails", tabName = "rails", icon = icon("train")),
                     menuItem("US Rails vs. Canadian Rails", tabName = "uscad", icon = icon("balance-scale")),
                     menuItem("Conclusion", tabName = "conclusion", icon = icon("sticky-note")),
                     menuItem("About Me", tabName = "aboutme", icon = icon("question-circle")))
                   ),
  dashboardBody(
    shinyDashboardThemes(
      theme = 'purple_gradient'
    ), 
    tabItems(
      tabItem(tabName = "intro", 
              fluidRow(h2("Background on Rails"), 
                      box("If Warren Buffet were stuck in a deserted island and could only have
                          access to one economic indicator, he was quoted to choose rail carloads (he owns 
                          Burlington Northern, one of the largest railroads in the US). While  
                          rails only constitute mid-to-high single digit percentage of the US transportation 
                          spend, because they move such diverse types of freight from coal to grain to
                          automobiles, the amount of carloads moved by rails represent an excellent indicator
                          of the US economy. The frequency of data availability also makes it attractive
                          since class 1 rails (largest railroads in the US) are required to report weekly 
                          how many carloads they move each week.", 
                          width = 12), 
                      br()
                      ), 
              fluidRow(h2("Economic Relationship"), 
                       box("Consistent with Buffet's claims, the plot below shows a clear relationship between
                          rail carloads and ISM Manufacturing Index, which is one of the most important metrics
                          for the US economy.", 
                          plotOutput('CarloadISM'), 
                          br(), 
                          "Directly plotting rail carloads vs. GDP shows a less clear relationship as below but 
                          this is due to the short timeframe (only 13 quarterly data used below). With more data,
                          there will be a clear relationship.",
                          plotOutput('CarloadGDP'), 
                          width = 12),
                       br()
                       ), 
              fluidRow(h2("Goal"), 
                       box("Given the importance of rails to the US economy, it is no surprise that the rail stocks
                           have a wide investor base.", tags$u(tags$b("The goal of this project is to identify trading 
                           opportunities based on the relationship between carloads and rail stock prices under 
                           different macro environment.")), "This is a common analysis hedge funds do on the rails
                           and this web app will automate the analysis.", 
                           width = 12), 
                       br()
                       )
              ),
      tabItem(tabName = "rails", 
              fluidRow(selectizeInput("rail_selected", 
                                      "Which Rail? (BNSF is private so will only show carloads)", 
                                      unique(df_main$Name))),
              fluidRow(h2("Single Rail Analysis"),
                       "Green area: ISM >= 50, Red area: ISM < 50",
                       box(plotOutput('RelToSelf'), width = 12)),
              fluidRow(h2("Vs. IYT (transportation index)"),
                       "Green area: ISM >= 50, Red area: ISM < 50",
                       box(plotOutput('RelToIYT'), width = 12)),
              fluidRow(h2("Vs. XLI (industrials index)"),
                       "Green area: ISM >= 50, Red area: ISM < 50",
                       box(plotOutput('RelToXLI'), width = 12)),
              fluidRow(h2("Vs. S&P500"),
                       "Green area: ISM >= 50, Red area: ISM < 50",
                       box(plotOutput('RelToSPY'), width = 12))
              ), 
      tabItem(tabName = "uscad", 
              fluidRow(h2("US rails (CSX, NSC, UNP) vs. Canadian rails (CP, CNI)"),
                       "Green area: ISM >= 50, Red area: ISM < 50",
                       br(),
                       "Caveat: Canadian rail volumes only reflect the US portion.",
                       box(plotOutput('uscad.analysis1'), width = 12), 
                       br()), 
              fluidRow(box(plotOutput('uscad.analysis2'), width = 12))
              ),
      tabItem(tabName = "conclusion", 
              fluidRow(h2("Conclusion"),
                       box("Before making any conclusion, it's important to keep in mind that it's hard to lose 
                           from buying the rails per the chart below.",
                           br(),
                           plotOutput('railhistory'),
                           "Over the past 3 years, most rails have outperformed the S&P500 index. In fact, the
                           sector has outperformed the S&P500 index 16 out of the last 17 years. This is because 
                           Class 1 rails are essentially duopolies (2 in Canada, 2 in the Eastern US, and 2 in the 
                           Western US) with great pricing power, consistent margin expansion, and solid free cash
                           flow generation. That said, this project will still aid in picking the best time to 
                           buy the rails and narrow down which one has the highest chance of becoming a successful
                           investment.", 
                           br(), 
                           width = 12))
              ),
      tabItem(tabName = "aboutme", 
              fluidRow(h2("Hong C. Kim"), 
                       box(img(src = 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxAQDRAQEBANEBANDQ0NDQkJDQ8IEA4NIB0iIiAdHx8kKDQsJCYxJx8fLTItMStAMDAwIytJQTMtNzQ2MC0BCgoKDg0NFRAQFTcZFxorKzcrNzcxLTE3NysrNzcrNzI3KysrKys4KysrLSszNywrLSsrNy0tKy0rKy0rKys3K//AABEIAMgAyAMBIgACEQEDEQH/xAAcAAACAgMBAQAAAAAAAAAAAAAAAQIEAwUGBwj/xAA9EAABAwIEAwQJAgQFBQAAAAABAAIDBBEFEiExBkFREyJhcQcyQlKBkaGx8GLBI3LR8TNDU4LhFBUkY5L/xAAaAQACAwEBAAAAAAAAAAAAAAAAAQIDBAUG/8QAJREAAgIBBAIDAQADAAAAAAAAAAECAxEEEiExQVETYXEiBTIz/9oADAMBAAIRAxEAPwDRAKYCQUgF1DAMBTASAUgECGAmAgJpgCE0BACTSQgBoCi94AuSANNSbIBHIg+WqWREkki4dQgG+2vlqmMaEXQmIEWQhAxFIhMpJARKiVMqJCAIEKJCmVEhIDGU0yEIGSAUgkFIIESCkEgmmA00kIENCSEADj+brRYtxC2I2aQ4j2Rdp+yz8R4mIISAf4klwxn7rz4ucXkm5JOviVmut28I0VV55Zs8Qxt8t7taG6aNu3RUmPJF2m1t2i+yTmEX0aQeTSLhNrSSAL39lw3A6LG5N9mlRx0iZe47vJtr3iSpQ1LmG8b3NJ9xxCwGJx5He3xWJ8ZB2ISz9jx9G9o+I54z3ndoANWSWdceB3XVYVjEVQ3umzvahcbOH9V5tm+5WSKQtcHNJa5pBDm6WKurulHvkqnUpHqya03D+MCoYc1hIy2Zu1x1W4W+MlJZRkaaeGCRQhSIgolSSKAIEJEKRSKQzGUKRCEAAUwoBTCAJBNIJoENCSLoAFWxCtZBGZH7C22pJVlcjx1UH+HHbu6vv1KhZLbFsnCOZYOdra108zpH89m+63orNBRPmcGRxukkdawabWCxYThzppGMb60jgLdB1Xt3DGARUsYDAC+wL5bXJK419239OtRRv/DjMM9HMhAdOQ0n2GnPYre0/o9jbtdxuCNF30TD0V2KNY/lnLybfhhHwcS3gWANOgubX81Vr+A4Ht0Av1XoU0fkqz2KLnNPsahFro8Kx7gmWF12jM0X9Vc3U4XJHqWm1/JfQ9fACLEfuuM4sw1phdYAEg8hurq9Q84ZTZp1jKPJ6erdBM17Dq22bazuoXotDVtmja9pBDgDoQ6x6LzStYWuIN9Nr6rqeBakmOSMkd0hzR4FdfTT5wcm+HGTqkISW4yAgoQgBFIppFAyJQgoSAApBRCaAJJqKaYDQkmgBrj+OIv4kLveDhzXXhcxxq3/AAD0c8fDRU3/APNllP8AuixwJSjt81tcoAPgvW8POwtt6y4DgWkAYJDzByhdbUY2ym3Bde9wzXKPFedu/qR6Cn+IcnUxN1+SuxMXK4TxfRyuA7QNJt65DdV1tNURubdrmkdRqlGGOxylnoJIyQqj9FtM7bclzmO4/TU4JkdqL91rS4lSlD0RjL2OoF1zeMxZmOHgVpq3jmSZ1qaPTXWQE3VumxQTXa5pa+wJYbkfBVuEo8linGXB5VxBTBsjr9Tsr3AjTeY8hlHxVnjqiLXiQDuvvf8AmS4GZ/DmPV7R9F19I90kzkaqO1NHToQhdQ5wJIKSAGhJCBiKEFCQEQmkEwgBppITAkhJNADWh4wivTtd/pyAnyOi3qxVMcb2GOR2USAtBymTVU3yjGt7i2iEpWJRLWEV8UNHE5zgCYxlZcZnEdFrqLGZKh0jYaduXO5r6mtfkbm5gAAk/BWeHcIY6jfC8BweZGPuBewJsR5KxTcMvbDHBFI5oY138QWD3EuJK4GYpv2dz+nj0SbwvI4doG07L+y1sjW38FewnH30D2xVLQI5HFrKmMl7A7obqqzg4sqO3E8rBdjjDG15JcB719irmLUGaBgkLpDnjyvDQw5wbgolNY55JRg/w6XGOKI4Kd0pDyGtLh3TqVydLSTVpEtQ4xAjM2KINcY276k6fRdVxLhTH4cW2BswFwsDmHMLWswsSxD1y1xBdGCGg6bHwVUZ4/Sxwz+GixCjohdja1xdbXJVRNeD5AWC5qaaqpaqJglfOyoOWnzNZnz3FwT8d129PwVTMa4Nic3O0Ndd4NwpRYM2Fwa25DLG7u9qrPlS+yr42/pnIcZB/wD0pErG3a4ESQnM2/iDqFU4Qgy0xdp35HHSx0Gi6ziqmDoHtI9dhI56hamkhLY2NawNYGl2ewBcP7kLTpL9jXHZRqaN6fPRmQkhd04YJFCEDBCSECAoSKEDIgp3UQmkBIFNRTQAwmoppgNWKGBr5WBw9oZT4qvdNpIIIJBFiHDSxVV1fyQcS2ix12KXo3OGQZJpGbAuzNA00K6aClAsSCf5dwVyNPVWkjkJ1kDmyW0GYLtcKqw62y81ZFxeGeijJSWUZAG23c63sFhBWGoos5a54tlcC1nqgfBbd8zWtJttfZahlUZc/aHIQe7HfL3eSqkTibSeMGEA7G4I30VKGkLdY7bAFtxqFZdVR9iLubYDe4WlqsRhcWthkaZbjSN2oCkxRybkQuP+WAernaLBNRWuXb7nkstLXOHdfuLd7qpYhVDITfkmsYFymcRxTbsyelx10WvnkAgiYAQRmuCMpy6LLjlQXFo5doPHRUZ5Mz3O943XQ0NLlNPwjFrLlGtryyF0kIuu4cMEkXQgYroSQgQyhJCBkAU1EKSQxp3UU0CHdMKKaYEkXSQkAF1iD0IXUYZKWlp5Gy5Z4uCOq3eA1YLcjtxey5H+Rrw1JHW/x9mU4s7aKUEa625LQ8Q4c2pIsCC08rhbKiIe2wPIfNaUiaOrkbU9oIH2dTy0nTS4dzB38FyonTK3/YJgA0PeWH2HEGwV2DDIoLODomuG7sw3W+poKKwPecczjZ93HLeyoYwIRG4QxtBc1zRJINACd7eFlYwTy8YZXZijJX9nHIySRvKJwflHirFeDbKdCQ3ToVU4I4fjpWSP9aSZxdJM4Zb+A6BTxGtGZzidiSq3jPAddnNY4AJGtHK5KoqVVLnlc4+Sx3XodFBxpWfJwdZPda/od0JIWwyAkglJADSuhCAAoSuhAEAVK6gCndIZK6d1EJoESQldF0ASQldK6AJXUe37NwdewJAv0KV0qendUTiCMXc2J87+fdGw8ySs+qipVPJfppONiwdFhWMFjwSe6bXt1XV1UYmYDa+g8FwUuHFoBbexA+C3/D+Mlto5d23AdycF5yS8o9DFtG0DJYxZoJHkCsjKR8gu9p/3G62AqmOHdI6721SdiLGjUjS/O+qfOCTsZhq3iGE3OwPzXAV1Y59wL2NzdbjH8T7UiNp0J7x6+CpilAaDZKKx2QfJoae+QX31v53WS6y1cHZiInTtu2Lb8y12v3Cwr0tElKuODzt8WrJZJJJIVxUO6V0rougBoJUUEoACU1FCAIAqQKgCmCkMmE7qN0XTAldF1G6qz17G6XzH3WapNpdhhstlywz1bGC7nAeG5Wrlr3u0Fmj9PeKpSMJ1Nz4nqqnb6LFX7L8uNEmzGf7nn9l13ogYH1FXI43eGRAE9Lm/2C4QR2C6f0WV4ixIMJs2oDojy724+ot8VRY3JclsEovg9E4jouyf2gbeKb3R6knMfHf5rma2AHVm69O7JsjHRSC7Hi3keq8/4gwuSmkLemrH8ntXIuq2vK6Oxp7VJbX2a2B8uwJ05ajRWHMc5pzOP2UKWcOtyIK2fZ5tbdNAqmzRhGmp6Il9/wDnRbWqjDI7nkNupU8zYzc8ln4dpXVlWHO/wach7ujncgiKcpYISkorJq/SJhjmYZC5uktF2cpIt6zvWH1XnVJxMCQJGEH3ozm+i9X9IlRegqj/AKjmsHlcf0XgrhY+S7NUnCOEcW1KUss7unrY5PUe0n3fVPyWe65CnaHtB2I3I01V6KqmZoHB46Sa6ea1Rt9md1+joLp3WqhxZp0eCw9T32/NXmShwuCCDzBBVikmVuLRnukoZk8yYhkoUSUIAiCndYnPAFybAc9tFqa3GbaRtJ3HaO0CjKSXZNRb6N26QAXJAHU6KhU4xG3QHMfBaCSSSQ95xN/hos0FMB4qp2t9E1BeS3JXvk6ge6O6k2O+9x5aKcTB+aLLZV99kiLWgDRQkH3CyFYZTr8/BAyZbp8FDD5HRzNe02c1zXNcOThqFkZssUgsfFAH0LhNeKiminboJGNdbfK7mPgbq9itHFUU+WQhp9iTctcuF9FOIh9LLATrE4SsH6Dv9R9V17HZndQ3QLNOK6Zog32jjKrAKiG7zGTGLntYy2QZevVYTXtY3S916T2w5jbS1hsvMMeo+zqpIwDlDszNCO6dQsNtOzlHRpvc+H2a2ad8r+ZLiGtYOZXqeFUAoqHLpmDC6R3vSHdcrwjRCN5qHtBygthB17/M/D91v66oc+5JdZwLS3W1lbRDC3Mo1NmXtRxvpEJGHMHvzMB+RK8aqI7O+fgvYvSVJajp2nczF3XQNP8AVeW1MWbUbrfHo58uynTPynwO62kTriy1RsAb300t4q7RuOUX3+akRLJaohtjdpLT+k2WUBQ+fNMDLHXvHrAO8R3SrcNex2l7Ho7Ra1QkaLKSsaIuCZv86FzmGVZZOYye6/YHk5JWxnlEHHBexqezWtHtEk+QWtZqLJ40/NNYey0D47rDTvv5jkqJvMi2KwizFFY/byVtjbLGx3dBHL7LN2m3P5oAd/wKOZSuoEoAyNKxzwh2/K9nNOUgqTT+bqD3/m6AIQveCGnvDW0gsNPELPIzT83UWDosgQBvuAq3s66JpcWsncYH200dt9bL2uKmyCw5bL52iJa4EEggghw0s7kV9EcP14qqOCfnLE1zh0dz+t1TYvJbW/BebHdt2/FviuV4uoblkttW9x3ly/f5rqm3a642O4VfHacSU0gGpMbi3zGoVFkd0Wi+qW2aZqOHaiGSnIIAkpm2cLn1eRCbG57nkfstZhVAYqfOdJKq3d2yxb/nmt/Qw9y3RFedqyO3G94PLfScHNkhbd2XLK4MJuAdBouCG6730rP/APMjZ7lM2/mXH/hcExaodIyS7Iz04PeGpA0uscTtdRqFbvpoVWlIAvbXTwUhFxjtPwKL0odk3hMRheVjmdofL6qEztVjcb2HUtCAKtY/LKCN2uB+KSxVxvIfElCrb5JpIszS5pXO6kkeSyNFnAj4rADZwKsyNIs4ajmFIRZbvpz5JxycunmdFFrgRcLE51neakRLbX9VNx0+XRV+SyxvuLIAk0rG8Wf4P+jlIHVTkbmbbnuD0KAJtU2lYIH3APzHip31/CgDKeq9d9EOI56KSAnWmmNh/wCt+o+uZeQtXY+izEeyxLsye7VROZb9Y1H2PzUZrKJReGe1XWOoIY0k+r+6d7hY6tufK3zJWcvNa2DtH9oegDW7ZWq1SCwI8SrccAa1V4hYu8HFGBHinpKmzYnP+gRMH/yP3JXHt3W94un7SuqncjUSgeQNh9lo2BaV0UPsboxe40PhssFWfVHVw+StAaKnMCX/AMunxQIvQbeaUrrD5qUHqhVcRfZqYFCSXvKcR1Hhd30VRhuVbiNsxPstPzURlGXS5PrG9ghAbclx21sEKOCRkeCPJbKkfpY/gQhSQmSkgLTdvqndqwTHY9ChCYjM13n9koXnNbVCEAZjv8vBZmH83QhMRAizr8nfDvKTnoQgDIxytYZXGCpgmH+TNG8217t9fohCT6Bdn0ZBKHbbEAg+CzW1J8kIWc0EpXWaqMkgb2hOwbmPlZCEAfONZKXOLju5xcfMlVwkhaSgyk2BJ2APyVNovvubk+aEIEbCEd3b+61OKy8vNCEn0C7KEAVltsh8XfRNCiiTKc8nIbnQBCEKLJJcH//Z'),
                          "Hong is a data science fellow at New York City Data Science Academy (NYCDSA)
                          with expected graduation date of December 2020. His domain expertise lies in 
                          the US equity market, where he spent 7 years in the hedge fund industry investing
                          in the industrials sector (specifically automobile and transportation companies).
                          He hopes to complement his investing skillsets with data science to become a better
                          investor and find unqiue ways to outperform the ever more competitive stock market.", 
                          br(),
                          br(), 
                          tags$b("LinkedIn: "), 
                          tags$u(tags$a(href = "https://www.linkedin.com/in/hong-c-kim/", 
                                        "https://www.linkedin.com/in/hong-c-kim/")), 
                          br(),
                          tags$b("GitHub: "),
                          tags$u(tags$a(href = "https://github.com/hckim1991", 
                                        "https://github.com/hckim1991")), 
                          br(),
                          tags$b("Email: "), 
                          tags$u("hk486@cornell.edu"), 
                          width = 12) 
                       )
              )
      )
    )
  )

  