

wind$DateTime<-ymd_hms(wind$DateTime)
wind$year<-year(wind$DateTime)
wind$month<-month(wind$DateTime)
wind$day<-day(wind$DateTime)
wind$hour<-hour(wind$DateTime)


wind$grouped_wind<- if_else(wind$Wind_Dir>=0 & wind$Wind_Dir<=22, 0, if_else(
  wind$Wind_Dir>22 & wind$Wind_Dir<=68, 45, if_else(
    wind$Wind_Dir>68 & wind$Wind_Dir<=112, 90, if_else(
      wind$Wind_Dir>112 & wind$Wind_Dir<=158, 135, if_else(
        wind$Wind_Dir>158 & wind$Wind_Dir<=202, 180, if_else(
          wind$Wind_Dir>202 & wind$Wind_Dir<=248, 225, if_else(
            wind$Wind_Dir>248 & wind$Wind_Dir<=292, 270, if_else(
              wind$Wind_Dir>292 & wind$Wind_Dir<=338, 315, if_else(
                wind$Wind_Dir>338 & wind$Wind_Dir<=360, 0, 99999)))))))))

wind$beaufort<-if_else(1>wind$Wind_spd, 0, 
                          if_else(4>wind$Wind_spd, 1,
                                  if_else(7>wind$Wind_spd, 2,
                                          if_else(12>wind$Wind_spd, 3, 
                                                  if_else(18>wind$Wind_spd, 4, 
                                                          if_else(23>wind$Wind_spd, 5, 
                                                                  if_else(30>wind$Wind_spd, 6, 
                                                                          if_else(38>wind$Wind_spd, 7, 
                                                                                  if_else(46>wind$Wind_spd, 8, 
                                                                                          if_else(55>wind$Wind_spd,9,999999))))))))))

wind$Season<-if_else(wind$month==1|wind$month==2|wind$month==12, "Winter", 
                        if_else(wind$month==3|wind$month==4|wind$month==5, "Spring",
                                if_else(wind$month==6|wind$month==7|wind$month==8,"Summer", "Autumn")))


wind_freq<-wind%>% 
  group_by(year) %>% 
  count(., grouped_wind)
wind_zero<-wind_freq %>% 
  filter(grouped_wind==0)
wind_zero$grouped_wind<-360
wind_freq<-wind_freq %>% 
  bind_rows(., wind_zero)                               

wind_freq_strength<-wind%>% 
  group_by(year, beaufort) %>% 
  count(., grouped_wind)                         

wind_freq_strength_2017$direction<-if_else(wind_freq_strength_2017$grouped_wind==0, "N", 
                                           if_else(wind_freq_strength_2017$grouped_wind==45, "NE",
                                                   if_else(wind_freq_strength_2017$grouped_wind==90, "E",
                                                           if_else(wind_freq_strength_2017$grouped_wind==135, "SE",
                                                                   if_else(wind_freq_strength_2017$grouped_wind==180, "S",
                                                                           if_else(wind_freq_strength_2017$grouped_wind==225, "SW",
                                                                                   if_else(wind_freq_strength_2017$grouped_wind==270, "W",
                                                                                           if_else(wind_freq_strength_2017$grouped_wind==315, "NW","9999999"))))))))



wind_freq_strength<-wind%>% 
  group_by(year, beaufort) %>% 
  count(., grouped_wind)                          
wind_freq_strength_2017<-wind_freq_strength %>% 
  filter(year==2017)
wind_freq_strength_2017$beaufort<-as.factor(wind_freq_strength_2017$beaufort)
wind_freq_strength_2017$direction<-if_else(wind_freq_strength_2017$grouped_wind==0, "N", 
                                           if_else(wind_freq_strength_2017$grouped_wind==45, "NE",
                                                   if_else(wind_freq_strength_2017$grouped_wind==90, "E",
                                                           if_else(wind_freq_strength_2017$grouped_wind==135, "SE",
                                                                   if_else(wind_freq_strength_2017$grouped_wind==180, "S",
                                                                           if_else(wind_freq_strength_2017$grouped_wind==225, "SW",
                                                                                   if_else(wind_freq_strength_2017$grouped_wind==270, "W",
                                                                                           if_else(wind_freq_strength_2017$grouped_wind==315, "NW","9999999"))))))))
wind_freq_strength_2017<-wind_freq_strength_2017[-54,]
wind_freq_strength_2017$direction<-factor(wind_freq_strength_2017$direction, levels=c("E", "SE", "S", "SW", "W", "NW", "N", "NE"))
wind_freq_strength_2017$beaufort<-factor(wind_freq_strength_2017$beaufort, levels = c("8","7", "6", "5", "4", "3", "2", "1", "0"))
ws_zero<-wind_freq_strength_2017 %>% 
  filter(grouped_wind==0)
ws_zero$grouped_wind<-360
ws_2017<-wind_freq_strength_2017 %>% 
  bind_rows(., ws_zero)
wind_freq<-na.omit(wind_freq)


wind_freq_seasonal<-wind%>% 
  group_by(Season,year) %>% 
  count(., grouped_wind)
wind_zero_seasonal<-wind_freq_seasonal %>% 
  filter(grouped_wind==0)
wind_zero_seasonal$grouped_wind<-360
wind_freq_seasonal<-wind_freq_seasonal %>% 
  bind_rows(., wind_zero_seasonal)
wfs2017<-wind_freq_seasonal %>% 
  filter(year==2017)


write.csv(wind_freq, "data/wind_freq.csv")
write.csv(wind_freq_seasonal, "data/wind_freq_seasonal.csv")
write.csv(wind_freq_strength_2017, "data/wind_freq_strength_2017.csv")
write.csv(wind, "data/wind.csv")

wq$DateTime<-ymd_hms(wq$DateTime)
wq$Day<-day(wq$DateTime)

salinity_hour<-wq %>% 
  group_by(Station, Year, Month, Day, Hour) %>% 
  summarise(hourly_av=mean(Salinity))
salinity_hour$date_time<- paste(salinity_hour$Year,"-", 
                                salinity_hour$Month, "-", salinity_hour$Day, " ",
                                salinity_hour$Hour, sep = "")
salinity_hour$date_time<-ymd_h(salinity_hour$date_time)
salinity_hour$fake_date<-paste(1919,"-", 
                               salinity_hour$Month, "-", salinity_hour$Day, " ",
                               salinity_hour$Hour, sep = "")
salinity_hour$fake_date<-ymd_h(salinity_hour$fake_date)

write.csv(salinity_hour, "data/salinity.csv")
