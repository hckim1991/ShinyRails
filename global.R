
library(tidyverse)
library(quantmod)
library(shiny)
library(shinydashboard)
library(dashboardthemes)
library(scales)
library(RColorBrewer)
library(zoo)

#Read carload data
#Source: https://www.stb.gov/stb/railserviceissues/rail_service_reports.html
carloads = read.csv('C:/Users/hk486/OneDrive/Desktop/NYDSA/Bootcamp/Projects/Shiny/Rails/EP724 Data.csv')

#Convert columns do dates
for (i in 7:ncol(carloads)) {
  colnames(carloads)[i] = as.character(as.Date(colnames(carloads)[i], "X%m.%d.%Y"))
}
colnames(carloads)[1] = 'Name'

#Make sure all numbers are of numeric type (not character)
carloads[, 7:ncol(carloads)] = mutate_at(carloads[, 7:ncol(carloads)], 1:(ncol(carloads)-6), 
                                       function(x) {as.numeric(str_replace_all(x, ',', ''))})

#Filter for carloads, sum up carloads by railroad, transpose, then clean up column names
carloads_temp = carloads %>%
  filter(Measure == 'Weekly Carloads By 22 Commodity Categories' & carloads$Sub.Variable == 'Total') %>%
  group_by(Name) %>%
  summarize_at(6:(ncol(carloads)-1), sum) %>%
  t()

colnames(carloads_temp) = carloads_temp[1, ]

matchname = function(x) {#Change column names to be consistent with stock tickers
  return(ifelse(x == 'CN', 'CNI', 
                ifelse(x == 'KCS', 'KSU', 
                       ifelse(x == 'NS', 'NSC', 
                              ifelse(x == 'UP', 'UNP', x)))))
}

colnames(carloads_temp) = sapply(colnames(carloads_temp), matchname)

carloads_temp = carloads_temp[-1, ]
carloads_temp = as.data.frame(carloads_temp) #Convert back to data frame since it's a matrix currently
carloads_temp = carloads_temp %>%
  mutate(Date = rownames(carloads_temp))
carloads_temp = mutate_at(carloads_temp, 1:7, as.numeric)

#Final clean up of carloads data to stack by railroad
carloads_final = arrange(pivot_longer(carloads_temp, 1:7, names_to = 'Name', values_to = 'Carloads'), Name)
carloads_final$Date = as.Date(carloads_final$Date)
carloads_final$Date = carloads_final$Date - 5 #Subtract 5 days to be consistent with stocks data below

#Supplementary carload data for the intro section
carloads_type = carloads %>%
  filter(Measure == 'Weekly Carloads By 22 Commodity Categories' & carloads$Sub.Variable == 'Total') %>%
  group_by(Variable) %>%
  summarize_at(6:(ncol(carloads)-1), sum) %>%
  select(-1) %>%
  rowSums()

carloads_name = carloads %>%
  filter(Measure == 'Weekly Carloads By 22 Commodity Categories' & carloads$Sub.Variable == 'Total') %>%
  group_by(Variable) %>%
  summarize_at(6:(ncol(carloads)-1), sum) %>%
  select(1)

carloads_by_type = data.frame(Segment = carloads_name, Total = carloads_type)

#Load stock prices
start = as.Date(carloads_temp$Date[1])
end = as.Date(carloads_temp$Date[nrow(carloads_temp)])
getSymbols(c('^GSPC', 'IYT', 'XLI', 'CSX', 'CNI', 'CP', 'KSU', 'NSC', 'UNP'), 
           from = start - 5, to = end - 5, return.class = 'data.frame')

#Cbind datasets and create new columns for relative prices
stocks = cbind(GSPC, IYT, XLI, CSX, CNI, CP, KSU, NSC, UNP)
stocks = stocks %>%
  mutate(Date = as.Date(rownames(stocks))) %>%
  select(Date, contains('.Close')) %>%
  mutate(CSX.SandP = CSX.Close / GSPC.Close, 
         CSX.IYT = CSX.Close / IYT.Close,
         CSX.XLI = CSX.Close / XLI.Close,
         CNI.SandP = CNI.Close / GSPC.Close,
         CNI.IYT = CNI.Close / IYT.Close,
         CNI.XLI = CNI.Close / XLI.Close,
         CP.SandP = CP.Close / GSPC.Close,
         CP.IYT = CP.Close / IYT.Close,
         CP.XLI = CP.Close / XLI.Close,
         KSU.SandP = KSU.Close / GSPC.Close,
         KSU.IYT = KSU.Close / IYT.Close,
         KSU.XLI = KSU.Close / XLI.Close,
         NSC.SandP = NSC.Close / GSPC.Close,
         NSC.IYT = NSC.Close / IYT.Close,
         NSC.XLI = NSC.Close / XLI.Close,
         UNP.SandP = UNP.Close / GSPC.Close,
         UNP.IYT = UNP.Close / IYT.Close,
         UNP.XLI = UNP.Close / XLI.Close) %>%
  select(-(2:4))
stocks = stocks[, c('Date', sort(colnames(stocks)[2:ncol(stocks)]))]

#Final clean up of stock data to stack by railroad (not possible to use pivot_longer here)
stocks_final = data.frame(Name = c(), Date = c(), Price = c(), 
                          Relative.To.IYT = c(), Relative.To.XLI = c(), Relative.To.SPY = c())
for (i in seq(2, ncol(stocks), 4)) {
  temp = data.frame(Name = rep(str_sub(colnames(stocks)[i], 1, str_locate(colnames(stocks)[i], '\\.')[1]-1), 
                               nrow(stocks)),
                    Date = stocks$Date, 
                    Price = stocks[, i],
                    Relative.To.IYT = stocks[, i+1],
                    Relative.To.XLI = stocks[, i+3], 
                    Relative.To.SPY = stocks[, i+2])
  stocks_final = rbind(stocks_final, temp)
}

#Join stocks_final with carloads_final 
df_main = left_join(carloads_final, stocks_final, by = c('Name', 'Date'))

#Create data frames for US vs. Canadian rail analysis
temp_CSX = df_main %>% filter(Name == 'CSX') %>% select(1, 3:4)
temp_NSC = df_main %>% filter(Name == 'NSC') %>% select(1, 3:4)
temp_UNP = df_main %>% filter(Name == 'UNP') %>% select(1, 3:4)
df_US = inner_join(inner_join(temp_CSX, temp_NSC, by = 'Date'), temp_UNP, by = 'Date')
df_US = df_US %>% 
  mutate(Carloads_US = Carloads.x + Carloads.y + Carloads, 
         Price_US = (Price.x + Price.y + Price) / 3,
         YoY_US = Carloads_US / lag(Carloads_US, 52) - 1) %>%
  select(Date, Carloads_US, Price_US, YoY_US)

temp_CNI = df_main %>% filter(Name == 'CNI') %>% select(1, 3:4)
temp_CP = df_main %>% filter(Name == 'CP') %>% select(1, 3:4)
df_CAD = inner_join(temp_CNI, temp_CP, by = 'Date')
df_CAD = df_CAD %>%
  mutate(Carloads_CAD = Carloads.x + Carloads.y, 
         Price_CAD = (Price.x + Price.y) / 2, 
         YoY_CAD = Carloads_CAD / lag(Carloads_CAD, 52) - 1) %>%
  select(Date, Carloads_CAD, Price_CAD, YoY_CAD)

df_USCAD = inner_join(df_US, df_CAD, by = 'Date')
df_USCAD = df_USCAD %>%
  mutate(Relative.Carloads = Carloads_US / Carloads_CAD, 
         Relative.Price = Price_US / Price_CAD, 
         Relative.YoY = YoY_US - YoY_CAD) %>%
  select(Date, Relative.Carloads, Relative.Price, Relative.YoY)

#Variables to scale the second axis of US rails vs. Canadian rails analysis
scale_uc1 = (max(df_USCAD$Relative.Carloads) - min(df_USCAD$Relative.Carloads)) / 
  (max(df_USCAD$Relative.Price, na.rm = T) - min(df_USCAD$Relative.Price, na.rm = T))  
translation_uc1 = min(df_USCAD$Relative.Carloads)
scale_uc2 = (max(df_USCAD$Relative.YoY, na.rm = T) - min(df_USCAD$Relative.YoY, na.rm = T)) / 
  (max(df_USCAD$Relative.Price, na.rm = T) - min(df_USCAD$Relative.Price, na.rm = T))  
translation_uc2 = min(df_USCAD$Relative.YoY, na.rm = T)

#Pull GDP data for the Intro section and cbind with carloads
getSymbols('GDP', src = 'FRED')
GDP = as.data.frame(GDP)
GDP_final = cbind(rownames(GDP), GDP)
rownames(GDP_final) = NULL
GDP_final = GDP_final %>% 
  rename(Date = 'rownames(GDP)') %>%
  filter(Date > '2000-01-01') %>%
  mutate(Date = str_c(format(as.Date(Date), '%y'), quarters(as.Date(Date)))) %>%
  group_by(Date) %>%
  summarize(GDP = sum(GDP))

carloads_GDP = carloads_temp %>%  
  mutate(Total = BNSF + CNI + CP + CSX + KSU + NSC + UNP, 
         Date = str_c(format(as.Date(Date), '%y'), quarters(as.Date(Date)))) %>%
  select(Date, Total) %>%
  group_by(Date) %>%
  summarize(Total = sum(Total)) %>%
  inner_join(GDP_final, by = 'Date')

#Variables to scale the second axis of carloads vs. GDP plot
scale_cg = (max(carloads_GDP[-1, ]$Total) - min(carloads_GDP[-1, ]$Total)) / 
  (max(carloads_GDP[-1, ]$GDP) - min(carloads_GDP[-1, ]$GDP))  
translation_cg = min(carloads_GDP[-1, ]$Total)

#ISM data analysis
#Source: https://www.thefinancials.com/ShowEvent.aspx?s=ismmfg&pid=free&section=usecon
ISM = read.csv('C:/Users/hk486/OneDrive/Desktop/NYDSA/Bootcamp/Projects/Shiny/Rails/ISM.csv') 
ISM = rownames_to_column(ISM)
colnames(ISM) = ISM[1, ]
ISM = ISM[-1, ]
ISM[, 2] = as.numeric(ISM[, 2]) * 100 
ISM[, 1] = as.Date(ISM[, 1], '%m/%d/%Y')


carloads_ISM = carloads_temp %>% 
  mutate(Total = BNSF + CNI + CP + CSX + KSU + NSC + UNP, 
         Date = as.Date(format(as.Date(Date), '%Y-%m-01'))) %>%
  select(Date, Total) %>%
  group_by(Date) %>%
  summarize(Total = sum(Total)) %>%
  inner_join(ISM, by = 'Date')

#Variables to scale the second axis of carloads vs. ISM plot
scale_ci = (max(carloads_ISM[-1, ]$Total) - min(carloads_ISM[-1, ]$Total)) / 
  (max(carloads_ISM[-1, ]$Last) - min(carloads_ISM[-1, ]$Last))  
translation_ci = min(carloads_ISM[-1, ]$Total)

#ISM vs. GDP data
ISMGDP = ISM %>%
  mutate(Date = str_c(format(Date, '%y'), quarters(Date))) %>%
  group_by(Date) %>%
  summarize(ISM = mean(Last)) %>%
  inner_join(GDP_final, by = 'Date')

#Variables to scale the second axis of ISM vs. GDP plot
scale_ig = (max(ISMGDP$ISM) - min(ISMGDP$ISM)) / 
  (max(ISMGDP$GDP) - min(ISMGDP$GDP))  
translation_ig = min(ISMGDP$ISM)
