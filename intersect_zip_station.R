library("terra")
library("tidyverse")

#https://opendata.dc.gov/datasets/DCGIS::metro-stations-regional/explore?location=38.909217%2C-77.374507%2C9.70
metro<-vect("Metro_Stations_Regional/Metro_Stations_Regional.shp")
line<-vect("Metro_Lines_Regional/Metro_Lines_Regional.shp")

metrodf<-as.data.frame(metro)

st1<-c("Wiehle-Reston East", "Spring Hill", "Greensboro", "Tysons", "McLean")
st2<-c("Ashburn", "Loudoun Gateway", "Dulles International Airport", 
       "Innovation Center", "Herndon", "Reston Town Center")

#select metro that opens in 2014
silver_2014<-buffer(subset(metro, metro$NAME %in% st1), width=2414)

plot(line)
plot(silver_2014, col="blue", add=TRUE)

#find zip code that intersects with this portion of the silver line
va<-vect("VA/VA_Zip_Codes.shp")
va_project<-project(va, crs(metro))
va_2014<-terra::intersect(va_project, silver_2014)
va_2014_df<-as.data.frame(va_2014) |>
  select(ZIP_CODE) |>
  rename(ZIPCODE=ZIP_CODE) |>
  mutate(open=2014)

#check if it intersects with only 6 zip codes
plot(silver_2014, col="blue", alpha=0.5)
plot(va_project, add=TRUE)

############execute the same task for the 2022 expansion of the silver line######


#find zip code that intersects other metro stations in virginia ############



#combine everything together
zips<-rbind(va_2014_df, va_2022_df)
