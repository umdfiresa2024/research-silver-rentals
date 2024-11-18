library("terra")
library("tidyverse")

#https://opendata.dc.gov/datasets/DCGIS::metro-stations-regional/explore?location=38.909217%2C-77.374507%2C9.70
metro<-vect("Metro_Stations_Regional/Metro_Stations_Regional.shp")
line<-vect("Metro_Lines_Regional/Metro_Lines_Regional.shp")

metrodf<-as.data.frame(metro)

st1<-c("Wiehle-Reston East", "Spring Hill", "Greensboro", "Tysons", "McLean")
st2<-c("Ashburn", "Loudoun Gateway", "Dulles International Airport", 
       "Innovation Center", "Herndon", "Reston Town Center")
st3<-c("Vienna/Fairfax-GMU", "Dunn Loring-Merrifield", "West Falls Church",
       "East Falls Church", "Ballston MU", "Virginia Square-GMU", "Clarendon",
       "Court House", "Rosslyn", "Arlington Cemetery", "Pentagon", "Pentagon City",
       "Crystal City", "Ronald Reagan Washington National Airport", "Potomac Yard",
       "Braddock Road", "King St-Old Town", "Eisenhower Ave", "Huntington",
       "Van Dorn Street", "Franconia-Springfield")

#select metro that opens in 2014
silver_2014<-buffer(subset(metro, metro$NAME %in% st1), width=2414)

plot(line)
plot(silver_2014, col="blue", add=TRUE)

#find zip code that intersects with this portion of the silver line
va<-vect("VA/VA_Zip_Codes.shp")
va_project<-project(va, crs(metro))
va_project <- terra::makeValid(va_project)
va_2014<-terra::intersect(va_project, silver_2014)
va_2014_df<-as.data.frame(va_2014) |>
  select(ZIP_CODE) |>
  rename(ZIPCODE=ZIP_CODE) |>
  mutate(open=2014)

#check if it intersects with only 6 zip codes
plot(silver_2014, col="blue", alpha=0.5)
plot(va_project, add=TRUE)

############execute the same task for the 2022 expansion of the silver line######
silver_2022<-buffer(subset(metro, metro$NAME %in% st2), width=2414)

plot(line)
plot(silver_2022, col="red", add=TRUE)

#find zip code that intersects with this portion of the silver line
va2<-vect("VA/VA_Zip_Codes.shp")
va_project2<-project(va2, crs(metro))
va_project2 <- terra::makeValid(va_project2)
va_2022<-terra::intersect(va_project2, silver_2022)
va_2022_df<-as.data.frame(va_2022) |>
  select(ZIP_CODE) |>
#  rename(ZIPCODE=ZIP_CODE) |>
  mutate(open=2022)

va_zips <- c("20120", "20121", "20147", "20148", "20166", "20170", "20171", "20175", 
             "20190", "20191", "20194", "22003", "22030", "22031", "22033", "22041", 
             "22042", "22043", "22044", "22079", "22102", "22153", "22181", "22182", 
             "22303", "22306", "22310", "22312", "22315")

plot(silver_2022, col="red", alpha=0.5)

plot(va_project2, add=TRUE)


va_project_merged <- merge(va_project2, va_2022_df, by="ZIP_CODE")
va_fl <- subset(va_project2, va_project2$ZIP_CODE %in% va_zips)

bg_color <- "white"
fl_color <- "#00297b"
line_color <- "#C0C0C0"

plot(va_fl, col=bg_color)
plot(va_project_merged, col=fl_color, add=TRUE)
plot(line, col=line_color, lwd=3, add=TRUE)

add_legend("bottomleft", 
       legend=c("Treatment Group", "Silver Line"), pch=c(15, 20), 
       xpd=NA, bg=NA, col=c(fl_color, line_color))

#select other metro stations in Virginia
other_stations<-buffer(subset(metro, metro$NAME %in% st3), width=2414)

plot(line)
plot(other_stations, col="green", add=TRUE)

#find zip code that intersects other metro stations in virginia ############
va3<-vect("VA/VA_Zip_Codes.shp")
va_project3<-project(va3, crs(metro))
va_project3<-terra::makeValid(va_project3)
other_stations<-terra::intersect(va_project3, other_stations)
other_stations_df<-as.data.frame(other_stations) |>
  select(ZIP_CODE) |>
  rename(ZIPCODE=ZIP_CODE) |>
  mutate(open="other_stations")

plot(other_stations, col="green", alpha=0.5)
plot(va_project, add=TRUE)


#combine everything together
zips<-rbind(va_2014_df, va_2022_df, other_stations_df)
write.csv(zips, "intersect_zip_station.csv")
