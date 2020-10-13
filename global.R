
library(tidyverse)
library(quantmod)
library(shiny)
library(shinydashboard)
library(dashboardthemes)

#Read carload data
carloads = read.csv('C:/Users/hk486/OneDrive/Desktop/NYDSA/Bootcamp/Projects/Shiny/Rails/EP724 Data.csv')

#Convert columns do dates
for (i in 7:ncol(carloads)) {
  colnames(carloads)[i] = as.character(as.Date(colnames(carloads)[i], "X%m.%d.%Y"))
}
colnames(carloads)[1] = 'Name'

#Make sure all numbers are of numeric type (not character)
for (i in 7:ncol(carloads)) {
  if(class(carloads[, i][[1]]) == 'character') {
    carloads[, i] = as.numeric(str_replace_all(carloads[, i], ',', ''))
  }
}

#Filter for carloads, sum up carloads by railroad, transpose, then clean up column names
carloads = carloads %>%
  filter(Measure == 'Weekly Carloads By 22 Commodity Categories' & carloads$Sub.Variable == 'Total') %>%
  group_by(Name) %>%
  summarize_at(vars(6:(ncol(carloads)-1)), sum) %>%
  t()

colnames(carloads) = carloads[1, ]
colnames(carloads)[2] = str_replace(colnames(carloads)[2], 'CN', 'CNI')
colnames(carloads)[5] = str_replace(colnames(carloads)[5], 'KCS', 'KSU')
colnames(carloads)[6] = str_replace(colnames(carloads)[6], 'NS', 'NSC')
colnames(carloads)[7] = str_replace(colnames(carloads)[7], 'UP', 'UNP') #Change column names to be consistent with stock tickers

carloads = carloads[-1, ]
carloads = as.data.frame(carloads) #Convert back to data frame since it's a matrix currently
for (i in 1:ncol(carloads)) {
  carloads[, i] = as.numeric(carloads[, i])
} #Convert columns to numeric type 

#Final clean up of carloads data to stack by railroad
carloads_final = data.frame(Name = c(), Date = c(), Carloads = c())
for (i in 1:ncol(carloads)) {
  temp = data.frame(Name = rep(colnames(carloads)[i], nrow(carloads)), 
                    Date = as.Date(rownames(carloads)),
                    Carloads = carloads[, i])
  carloads_final = rbind(carloads_final, temp)
}
carloads_final$Date = carloads_final$Date - 5 #Subtract 5 days to be consistent with stocks data below

#Load stock prices
start = as.Date(rownames(carloads)[1])
end = as.Date(rownames(carloads)[nrow(carloads)])
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

#Final clean up of stock data to stack by railroad
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
temp_CSX = df_main %>% filter(Name == 'CSX') %>% select(2:4)
temp_NSC = df_main %>% filter(Name == 'NSC') %>% select(2:4)
temp_UNP = df_main %>% filter(Name == 'UNP') %>% select(2:4)
df_US = inner_join(inner_join(temp_CSX, temp_NSC, by = 'Date'), temp_UNP, by = 'Date')
df_US = df_US %>% 
  mutate(Carloads = Carloads.x + Carloads.y + Carloads, Price = (Price.x + Price.y + Price) / 3) %>%
  select(Date, Carloads, Price)

temp_CNI = df_main %>% filter(Name == 'CNI') %>% select(2:4)
temp_CP = df_main %>% filter(Name == 'CP') %>% select(2:4)
df_CAD = inner_join(temp_CNI, temp_CP, by = 'Date')
df_CAD = df_CAD %>%
  mutate(Carloads = Carloads.x + Carloads.y, Price = (Price.x + Price.y) / 2) %>%
  select(Date, Carloads, Price)

df_USCAD = inner_join(df_US, df_CAD, by = 'Date')
df_USCAD = df_USCAD %>%
  mutate(Relative.Carloads = Carloads.x / Carloads.y, Relative.Price = Price.x / Price.y) %>%
  select(Date, Relative.Carloads, Relative.Price)

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

carloads_GDP = carloads %>% rownames_to_column() %>% 
  mutate(Total = BNSF + CNI + CP + CSX + KSU + NSC + UNP) %>%
  rename(Date = rowname) %>%
  mutate(Date = str_c(format(as.Date(Date), '%y'), quarters(as.Date(Date)))) %>%
  select(Date, Total) %>%
  group_by(Date) %>%
  summarize(Total = sum(Total)) %>%
  inner_join(GDP_final, by = 'Date')

#Variables to scale the second axis of carloads vs. GDP plot
scale_cg = (max(carloads_GDP[-1, ]$Total) - min(carloads_GDP[-1, ]$Total)) / 
  (max(carloads_GDP[-1, ]$GDP) - min(carloads_GDP[-1, ]$GDP))  
translation_cg = min(carloads_GDP[-1, ]$Total) - min(carloads_GDP[-1, ]$GDP)

#ISM data analysis
ISM = read.csv('C:/Users/hk486/OneDrive/Desktop/NYDSA/Bootcamp/Projects/Shiny/Rails/ISM.csv') 
#Source: https://www.thefinancials.com/ShowEvent.aspx?s=ismmfg&pid=free&section=usecon
ISM = rownames_to_column(ISM)
colnames(ISM) = ISM[1, ]
ISM = ISM[-1, ]
ISM[, 2] = as.numeric(ISM[, 2]) * 100 
ISM[, 1] = as.Date(ISM[, 1], '%m/%d/%Y')


carloads_ISM = carloads %>% rownames_to_column() %>% 
  mutate(Total = BNSF + CNI + CP + CSX + KSU + NSC + UNP) %>%
  rename(Date = rowname) %>%
  mutate(Date = as.Date(format(as.Date(Date), '%Y-%m-01'))) %>%
  select(Date, Total) %>%
  group_by(Date) %>%
  summarize(Total = sum(Total)) %>%
  inner_join(ISM, by = 'Date')

#Variables to scale the second axis of carloads vs. GDP plot
scale_ci = (max(carloads_ISM[-1, ]$Total) - min(carloads_ISM[-1, ]$Total)) / 
  (max(carloads_ISM[-1, ]$Last) - min(carloads_ISM[-1, ]$Last))  
translation_ci = min(carloads_ISM[-1, ]$Total) - min(carloads_ISM[-1, ]$Last)
