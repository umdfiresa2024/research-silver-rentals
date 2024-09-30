library("terra")
library("tidyverse")

metro<-vect("Metro_Lines_Regional/Metro_Lines_Regional.shp")
silver<-subset(metro, metro$NAME=="silver")
silver_df<-as.data.frame(silver)

dc<-vect("DC_zips/Zip_codes.shp")
dc_project<-project(dc, crs(silver))
dc_silver<-terra::intersect(dc_project, silver)
dc_silver_df<-as.data.frame(dc_silver) |>
  select(ZIPCODE) |>
  mutate(silver=1) 

md<-vect("MD/Maryland_Political_Boundaries_-_ZIP_Codes_-_5_Digit.shp")
md_project<-project(md, crs(silver))
md_silver<-terra::intersect(md_project, silver)
md_silver_df<-as.data.frame(md_silver) |>
  select(ZIPCODE1) |>
  rename(ZIPCODE=ZIPCODE1) |>
  mutate(silver=1)

va<-vect("VA/VA_Zip_Codes.shp")
va_project<-project(va, crs(silver))
va_silver<-terra::intersect(va_project, silver)
va_silver_df<-as.data.frame(va_silver) |>
    select(ZIP_CODE) |>
    rename(ZIPCODE=ZIP_CODE) |>
  mutate(silver=1)

zip_silver<-rbind(dc_silver_df, md_silver_df, va_silver_df)

write.csv(zip_silver, "zip_silver.csv", row.names = F)

zori<-read.csv("zori.csv") |>
  mutate(date=as.Date(Date, format="%Y.%m.%d")) %>%
  rename(ZIPCODE=ZipCode)

table(zori$ZIPCODE)

fdf<-merge(zori, zip_silver, by="ZIPCODE", all.x=TRUE) |>
  mutate(silver=ifelse(is.na(silver), 0, silver))

write.csv(fdf, "panel.csv", row.names=F)
