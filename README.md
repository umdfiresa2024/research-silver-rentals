# How did the opening of the Silver Line of the Washington Metro System
impact adjacent rental prices?


Step 1. Install necessary packages.

``` r
install.packages("tidyverse")
```

    Installing package into '/cloud/lib/x86_64-pc-linux-gnu-library/4.4'
    (as 'lib' is unspecified)

``` r
install.packages("kableExtra")
```

    Installing package into '/cloud/lib/x86_64-pc-linux-gnu-library/4.4'
    (as 'lib' is unspecified)

Step 2. Declare that you will use these packages in this session.

``` r
library("tidyverse")
```

    ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ✔ dplyr     1.1.4     ✔ readr     2.1.5
    ✔ forcats   1.0.0     ✔ stringr   1.5.1
    ✔ ggplot2   3.5.1     ✔ tibble    3.2.1
    ✔ lubridate 1.9.3     ✔ tidyr     1.3.1
    ✔ purrr     1.0.2     
    ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ✖ dplyr::filter() masks stats::filter()
    ✖ dplyr::lag()    masks stats::lag()
    ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors

``` r
library("kableExtra")
```


    Attaching package: 'kableExtra'

    The following object is masked from 'package:dplyr':

        group_rows

Step 3. Upload the dataframe that you have created in Spring 2024 into
the repository.

Step 4. Open the dataframe into the RStudio Environment.

``` r
df<-read.csv("panel.csv")

df2<-df %>%
  mutate(date = as.Date(Date, format = "%Y.%m.%d"), month = month(date), year = year(date))
```

Step 5. Use the **head** and **kable** function showcase the first 10
rows of the dataframe to the reader.

``` r
kable(head(df2))
```

| ZIPCODE | Date | ZORI | State | City | date | silver | dist | month | year |
|---:|:---|---:|:---|:---|:---|---:|---:|---:|---:|
| 20001 | 2023.07.31 | 2651.125 | DC | Washington | 2023-07-31 | 0 | 1830.833 | 7 | 2023 |
| 20001 | 2023.08.31 | 2659.947 | DC | Washington | 2023-08-31 | 0 | 1830.833 | 8 | 2023 |
| 20001 | 2023.09.30 | 2686.397 | DC | Washington | 2023-09-30 | 0 | 1830.833 | 9 | 2023 |
| 20001 | 2024.07.31 | 2733.693 | DC | Washington | 2024-07-31 | 0 | 1830.833 | 7 | 2024 |
| 20001 | 2024.08.31 | 2759.074 | DC | Washington | 2024-08-31 | 0 | 1830.833 | 8 | 2024 |
| 20001 | 2015.02.28 | 2059.505 | DC | Washington | 2015-02-28 | 0 | 1830.833 | 2 | 2015 |

## Question 1: What is the frequency of this data frame?

Answer: Monthly

## Question 2: What is the cross-sectional (geographical) unit of this data frame?

Answer: Zip code

Step 6. Use the **names** function to display all the variables (column)
in the dataframe.

``` r
names(df2)
```

     [1] "ZIPCODE" "Date"    "ZORI"    "State"   "City"    "date"    "silver" 
     [8] "dist"    "month"   "year"   

## Question 3: Which column represents the treatment variable of interest?

Answer: silver

## Question 4: Which column represents the outcome variable of interest?

Answer: ZORI

Step 7: Create a boxplot to visualize the distribution of the outcome
variable under treatment and no treatment.

``` r
ggplot(df2, aes(x=ZORI)) +
  geom_histogram() +
  facet_wrap(~silver)
```

Step 8: Fit a regression model $y=\beta_0 + \beta_1 x + \epsilon$ where
$y$ is the outcome variable and $x$ is the treatment variable. Use the
**summary** function to display the results.

``` r
model1<-lm(ZORI ~ silver, data=df2)

summary(model1)
```


    Call:
    lm(formula = ZORI ~ silver, data = df2)

    Residuals:
       Min     1Q Median     3Q    Max 
    -867.1 -266.4  -41.7  210.1 2682.6 

    Coefficients:
                Estimate Std. Error t value Pr(>|t|)    
    (Intercept) 2040.443      4.614  442.19   <2e-16 ***
    silver       191.809      9.212   20.82   <2e-16 ***
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    Residual standard error: 388.5 on 9459 degrees of freedom
    Multiple R-squared:  0.04383,   Adjusted R-squared:  0.04373 
    F-statistic: 433.6 on 1 and 9459 DF,  p-value: < 2.2e-16

## Question 5: What is the predicted value of the outcome variable when treatment=0?

Answer: 2040.129

## Question 6: What is predicted value of the outcome variable when treatment=1?

Answer: 2040.129 + 188.653 = 2228.782

## Question 7: What is the equation that describes the linear regression above? Please include an explanation of the variables and subscripts.

Answer: $$ZORI = \beta_0 + \beta_1silver + \epsilon$$

## Question 8: What fixed effects can be included in the regression? What does each fixed effects control for? Please include a new equation that incorporates the fixed effects.

Answer:
$$ZORI = \beta_0 + \beta_1 silver + \beta_2 city + \beta_3 zip\_code + \beta_4 month + \beta_5 year + \epsilon$$

## Question 9: What is the impact of the treatment effect once fixed effects are included?

``` r
model2 <- lm(ZORI ~ silver + as.factor(City) + as.factor(ZIPCODE) + as.factor(month) + as.factor(year), data=df2)
summary(model2)
```


    Call:
    lm(formula = ZORI ~ silver + as.factor(City) + as.factor(ZIPCODE) + 
        as.factor(month) + as.factor(year), data = df2)

    Residuals:
        Min      1Q  Median      3Q     Max 
    -339.22  -43.17   -1.46   41.60  269.99 

    Coefficients: (78 not defined because of singularities)
                                          Estimate Std. Error t value Pr(>|t|)    
    (Intercept)                          2065.5614    24.1687  85.464  < 2e-16 ***
    silver                                631.3412    48.0410  13.142  < 2e-16 ***
    as.factor(City)Alexandria             -14.3267    24.5153  -0.584 0.558967    
    as.factor(City)Annandale             -380.1321    24.7338 -15.369  < 2e-16 ***
    as.factor(City)Arlington             -396.4884    25.1525 -15.763  < 2e-16 ***
    as.factor(City)Ashburn               -562.6591    54.0104 -10.418  < 2e-16 ***
    as.factor(City)Beltsville           -1075.8626    26.3129 -40.887  < 2e-16 ***
    as.factor(City)Bethesda               521.0156    24.5216  21.247  < 2e-16 ***
    as.factor(City)Bowie                 -208.4872    28.1971  -7.394 1.55e-13 ***
    as.factor(City)Burke                   42.1824    27.9911   1.507 0.131847    
    as.factor(City)Burtonsville          -453.2546    30.5052 -14.858  < 2e-16 ***
    as.factor(City)Capitol Heights      -1560.5098    55.1354 -28.303  < 2e-16 ***
    as.factor(City)Centreville           -453.1307    25.3265 -17.892  < 2e-16 ***
    as.factor(City)Chantilly              302.2135    28.4244  10.632  < 2e-16 ***
    as.factor(City)Chesapeake Beach         0.2235    70.8853   0.003 0.997484    
    as.factor(City)Chevy Chase           -124.8526    24.6920  -5.056 4.35e-07 ***
    as.factor(City)Clarksburg             193.7667    36.0797   5.371 8.04e-08 ***
    as.factor(City)College Park          -585.0093    24.8706 -23.522  < 2e-16 ***
    as.factor(City)Culpeper             -1081.9626    36.0797 -29.988  < 2e-16 ***
    as.factor(City)Damascus              -179.7765    70.8853  -2.536 0.011224 *  
    as.factor(City)Derwood               -137.3328    34.5741  -3.972 7.18e-05 ***
    as.factor(City)District Heights     -1144.8740    26.4679 -43.255  < 2e-16 ***
    as.factor(City)Dumfries               249.3410    33.4004   7.465 9.07e-14 ***
    as.factor(City)East Riverdale        -773.3403    26.1115 -29.617  < 2e-16 ***
    as.factor(City)Edmonston             -422.6737    36.0797 -11.715  < 2e-16 ***
    as.factor(City)Fairfax               -465.6691    24.5153 -18.995  < 2e-16 ***
    as.factor(City)Falls Church          -491.8136    54.2727  -9.062  < 2e-16 ***
    as.factor(City)Forest Heights        -757.1266    24.9296 -30.371  < 2e-16 ***
    as.factor(City)Fort Belvoir          -553.0214    32.4618 -17.036  < 2e-16 ***
    as.factor(City)Fort Hunt             1152.2464    52.8294  21.811  < 2e-16 ***
    as.factor(City)Fort Washington      -1030.5739    26.4679 -38.937  < 2e-16 ***
    as.factor(City)Frederick             -107.1191    31.6925  -3.380 0.000728 ***
    as.factor(City)Fredericksburg        -912.7370    26.4679 -34.485  < 2e-16 ***
    as.factor(City)Front Royal          -1249.2623    33.4004 -37.403  < 2e-16 ***
    as.factor(City)Gainesville             -9.1023    26.6403  -0.342 0.732605    
    as.factor(City)Gaithersburg          -586.9246    26.3129 -22.306  < 2e-16 ***
    as.factor(City)Germantown            -464.0464    25.7918 -17.992  < 2e-16 ***
    as.factor(City)Greater Landover     -1395.7068    54.5734 -25.575  < 2e-16 ***
    as.factor(City)Greenbelt             -621.2957    25.7469 -24.131  < 2e-16 ***
    as.factor(City)Groveton              -249.2614    33.4004  -7.463 9.23e-14 ***
    as.factor(City)Haymarket              488.0850    40.9152  11.929  < 2e-16 ***
    as.factor(City)Herndon              -1037.6792    54.0104 -19.213  < 2e-16 ***
    as.factor(City)Huntington            -613.2901    24.8426 -24.687  < 2e-16 ***
    as.factor(City)Hyattsville           -760.5279    24.8706 -30.579  < 2e-16 ***
    as.factor(City)Hybla Valley          -583.5776    25.0137 -23.330  < 2e-16 ***
    as.factor(City)Kensington             185.7319    38.0877   4.876 1.10e-06 ***
    as.factor(City)La Plata              -243.1098    70.8853  -3.430 0.000607 ***
    as.factor(City)Landover Hills       -1163.1007    27.3207 -42.572  < 2e-16 ***
    as.factor(City)Langley Park          -991.1085    28.4245 -34.868  < 2e-16 ***
    as.factor(City)Lanham Seabrook       -789.6269    40.9152 -19.299  < 2e-16 ***
    as.factor(City)Laurel                -938.3803    26.2420 -35.759  < 2e-16 ***
    as.factor(City)Leesburg              -335.9147    26.4679 -12.691  < 2e-16 ***
    as.factor(City)Lincolnia             -508.1238    25.0320 -20.299  < 2e-16 ***
    as.factor(City)Lorton                -350.0835    24.6021 -14.230  < 2e-16 ***
    as.factor(City)Manassas               500.7478    45.2367  11.070  < 2e-16 ***
    as.factor(City)McLean                -778.1061    54.0104 -14.407  < 2e-16 ***
    as.factor(City)Middletown            -359.7765    70.8853  -5.075 3.94e-07 ***
    as.factor(City)Montgomery Village    -592.2226    27.0670 -21.880  < 2e-16 ***
    as.factor(City)Mount Vernon            13.5394    31.6925   0.427 0.669235    
    as.factor(City)North Bethesda        -408.2569    24.5153 -16.653  < 2e-16 ***
    as.factor(City)Oakton                 -38.6765    36.0797  -1.072 0.283760    
    as.factor(City)Potomac               1239.7990    26.3129  47.117  < 2e-16 ***
    as.factor(City)Purcellville           295.0805    45.2367   6.523 7.25e-11 ***
    as.factor(City)Reston                -292.1032    25.9398 -11.261  < 2e-16 ***
    as.factor(City)Rockville             -659.7765    70.8853  -9.308  < 2e-16 ***
    as.factor(City)Rose Hill             -241.8778    24.5219  -9.864  < 2e-16 ***
    as.factor(City)Silver Spring         -537.3668    24.7128 -21.744  < 2e-16 ***
    as.factor(City)Springfield            160.3797    25.3834   6.318 2.77e-10 ***
    as.factor(City)Stafford              -285.0462    34.5741  -8.244  < 2e-16 ***
    as.factor(City)Sterling              -844.2858    54.6153 -15.459  < 2e-16 ***
    as.factor(City)Suitland-Silver Hill  -597.2599    24.9618 -23.927  < 2e-16 ***
    as.factor(City)Takoma Park          -1066.4268    25.8388 -41.272  < 2e-16 ***
    as.factor(City)Temple Hills         -1102.6723    33.4004 -33.014  < 2e-16 ***
    as.factor(City)Upper Marlboro       -1218.0902    54.0461 -22.538  < 2e-16 ***
    as.factor(City)Vienna                -291.3991    54.1002  -5.386 7.37e-08 ***
    as.factor(City)Waldorf                733.5569    70.8853  10.349  < 2e-16 ***
    as.factor(City)Warrenton             -915.5189    34.5741 -26.480  < 2e-16 ***
    as.factor(City)Washington              10.2385    24.5215   0.418 0.676300    
    as.factor(City)Woodbridge            -739.2287    24.5221 -30.145  < 2e-16 ***
    as.factor(ZIPCODE)20002              -874.6219    48.8388 -17.908  < 2e-16 ***
    as.factor(ZIPCODE)20003              -625.4701    48.9028 -12.790  < 2e-16 ***
    as.factor(ZIPCODE)20004              -865.8485    51.2230 -16.904  < 2e-16 ***
    as.factor(ZIPCODE)20005              -674.3517    48.9386 -13.780  < 2e-16 ***
    as.factor(ZIPCODE)20006             -1079.0052    49.9511 -21.601  < 2e-16 ***
    as.factor(ZIPCODE)20007              -597.1216    48.8983 -12.211  < 2e-16 ***
    as.factor(ZIPCODE)20008              -400.5266     9.3591 -42.795  < 2e-16 ***
    as.factor(ZIPCODE)20009                 2.8890     8.7905   0.329 0.742425    
    as.factor(ZIPCODE)20010              -334.4508     9.3876 -35.627  < 2e-16 ***
    as.factor(ZIPCODE)20011              -458.3901     9.1427 -50.137  < 2e-16 ***
    as.factor(ZIPCODE)20012              -475.1172    15.6037 -30.449  < 2e-16 ***
    as.factor(ZIPCODE)20015               136.4907     9.8584  13.845  < 2e-16 ***
    as.factor(ZIPCODE)20016                -1.6007     9.0940  -0.176 0.860284    
    as.factor(ZIPCODE)20017              -490.5383    12.0863 -40.586  < 2e-16 ***
    as.factor(ZIPCODE)20018              -496.9649    11.1253 -44.670  < 2e-16 ***
    as.factor(ZIPCODE)20019             -1288.3609    49.3766 -26.093  < 2e-16 ***
    as.factor(ZIPCODE)20020              -770.9795    10.2946 -74.891  < 2e-16 ***
    as.factor(ZIPCODE)20024              -759.7505    48.7345 -15.590  < 2e-16 ***
    as.factor(ZIPCODE)20032             -1185.6691    17.8875 -66.285  < 2e-16 ***
    as.factor(ZIPCODE)20036              -373.7765     9.3591 -39.937  < 2e-16 ***
    as.factor(ZIPCODE)20037              -699.6604    48.9028 -14.307  < 2e-16 ***
    as.factor(ZIPCODE)20105                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20109             -1199.4615    39.8660 -30.087  < 2e-16 ***
    as.factor(ZIPCODE)20110             -1130.1312    39.9211 -28.309  < 2e-16 ***
    as.factor(ZIPCODE)20111             -1262.6609    39.3703 -32.071  < 2e-16 ***
    as.factor(ZIPCODE)20112                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20120                22.5959    11.1734   2.022 0.043176 *  
    as.factor(ZIPCODE)20121                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20132                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20147              -427.2084     8.7714 -48.705  < 2e-16 ***
    as.factor(ZIPCODE)20148                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20151               -60.2511    33.8066  -1.782 0.074744 .  
    as.factor(ZIPCODE)20152                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20155                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20164               469.8260    50.6369   9.278  < 2e-16 ***
    as.factor(ZIPCODE)20165               637.2271    50.5424  12.608  < 2e-16 ***
    as.factor(ZIPCODE)20166                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20169                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20170               -32.7276     9.0535  -3.615 0.000302 ***
    as.factor(ZIPCODE)20171                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20175              -156.6297    13.7501 -11.391  < 2e-16 ***
    as.factor(ZIPCODE)20176                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20186                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20190              -595.3687    49.6001 -12.003  < 2e-16 ***
    as.factor(ZIPCODE)20191              -794.9403    49.6030 -16.026  < 2e-16 ***
    as.factor(ZIPCODE)20194                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20601             -1552.6055    67.8346 -22.888  < 2e-16 ***
    as.factor(ZIPCODE)20602             -1142.2481    77.1574 -14.804  < 2e-16 ***
    as.factor(ZIPCODE)20603             -1205.3573    67.3552 -17.896  < 2e-16 ***
    as.factor(ZIPCODE)20646                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20695                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20705                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20706                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20707               219.9787    13.1571  16.719  < 2e-16 ***
    as.factor(ZIPCODE)20708                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20715                89.3875    41.5426   2.152 0.031446 *  
    as.factor(ZIPCODE)20716              -297.1608    18.2482 -16.284  < 2e-16 ***
    as.factor(ZIPCODE)20720               561.2108    68.5868   8.182 3.15e-16 ***
    as.factor(ZIPCODE)20721                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20732                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20737                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20740                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20743                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20744                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20745                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20746                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20747                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20748                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20770                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20772              1253.7190    51.0284  24.569  < 2e-16 ***
    as.factor(ZIPCODE)20774                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20781                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20782                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20783                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20784                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20785                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20814              -374.9647     8.8289 -42.470  < 2e-16 ***
    as.factor(ZIPCODE)20815                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20816              -535.4439    23.2066 -23.073  < 2e-16 ***
    as.factor(ZIPCODE)20817                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20850               375.0056    67.1580   5.584 2.42e-08 ***
    as.factor(ZIPCODE)20851               409.7354    68.9010   5.947 2.83e-09 ***
    as.factor(ZIPCODE)20852                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20853                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20854                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20855                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20866                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20871                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20872                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20874              -235.3461    11.9705 -19.661  < 2e-16 ***
    as.factor(ZIPCODE)20876                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20877              -127.7907    15.4993  -8.245  < 2e-16 ***
    as.factor(ZIPCODE)20878               139.2673    13.0769  10.650  < 2e-16 ***
    as.factor(ZIPCODE)20879                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20886                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20895                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20901               -32.0187    24.7128  -1.296 0.195134    
    as.factor(ZIPCODE)20902                25.7334     9.6537   2.666 0.007697 ** 
    as.factor(ZIPCODE)20903              -514.8335    22.3125 -23.074  < 2e-16 ***
    as.factor(ZIPCODE)20904              -202.8443    12.3700 -16.398  < 2e-16 ***
    as.factor(ZIPCODE)20906              -173.6356    10.2532 -16.935  < 2e-16 ***
    as.factor(ZIPCODE)20910                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20912                     NA         NA      NA       NA    
    as.factor(ZIPCODE)21701              -675.2975    22.1084 -30.545  < 2e-16 ***
    as.factor(ZIPCODE)21702              -738.4290    22.2267 -33.223  < 2e-16 ***
    as.factor(ZIPCODE)21703              -448.4863    23.1202 -19.398  < 2e-16 ***
    as.factor(ZIPCODE)21704                     NA         NA      NA       NA    
    as.factor(ZIPCODE)21769                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22003                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22015                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22025              -175.7842    70.8853  -2.480 0.013162 *  
    as.factor(ZIPCODE)22026                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22030                76.0359     9.7312   7.814 6.16e-15 ***
    as.factor(ZIPCODE)22031                82.0694     9.0304   9.088  < 2e-16 ***
    as.factor(ZIPCODE)22032               848.7128    28.0570  30.250  < 2e-16 ***
    as.factor(ZIPCODE)22033                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22041              -120.8848    49.3312  -2.450 0.014285 *  
    as.factor(ZIPCODE)22042               269.3709    49.2954   5.464 4.76e-08 ***
    as.factor(ZIPCODE)22043              -305.8131    10.5717 -28.928  < 2e-16 ***
    as.factor(ZIPCODE)22044              -216.3476    49.5686  -4.365 1.29e-05 ***
    as.factor(ZIPCODE)22046                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22060                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22079                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22101              2506.9302    54.7460  45.792  < 2e-16 ***
    as.factor(ZIPCODE)22102                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22124                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22150              -565.6795    14.7771 -38.281  < 2e-16 ***
    as.factor(ZIPCODE)22152               270.3361    28.8179   9.381  < 2e-16 ***
    as.factor(ZIPCODE)22153                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22180               277.5011    49.9003   5.561 2.76e-08 ***
    as.factor(ZIPCODE)22181               414.8438    49.1886   8.434  < 2e-16 ***
    as.factor(ZIPCODE)22182                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22191               141.7201     8.7904  16.122  < 2e-16 ***
    as.factor(ZIPCODE)22192               103.2345     8.7904  11.744  < 2e-16 ***
    as.factor(ZIPCODE)22193                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22201              -350.2872    47.7118  -7.342 2.29e-13 ***
    as.factor(ZIPCODE)22202               266.6122    10.6861  24.949  < 2e-16 ***
    as.factor(ZIPCODE)22203              -150.1591    47.8080  -3.141 0.001690 ** 
    as.factor(ZIPCODE)22204               -32.1423    10.4847  -3.066 0.002178 ** 
    as.factor(ZIPCODE)22205               689.8038    52.8294  13.057  < 2e-16 ***
    as.factor(ZIPCODE)22206                12.8250    10.7429   1.194 0.232582    
    as.factor(ZIPCODE)22207               794.6351    12.2716  64.754  < 2e-16 ***
    as.factor(ZIPCODE)22209              -195.3862    47.7181  -4.095 4.26e-05 ***
    as.factor(ZIPCODE)22213                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22301              -141.8530    10.1829 -13.931  < 2e-16 ***
    as.factor(ZIPCODE)22302                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22303                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22304              -684.3088     9.8047 -69.794  < 2e-16 ***
    as.factor(ZIPCODE)22305              -626.3686    10.2796 -60.933  < 2e-16 ***
    as.factor(ZIPCODE)22306                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22307                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22308                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22309                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22310                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22311              -806.7477    12.0736 -66.819  < 2e-16 ***
    as.factor(ZIPCODE)22312                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22314              -199.9171    10.1373 -19.721  < 2e-16 ***
    as.factor(ZIPCODE)22315                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22401                12.9589    13.5205   0.958 0.337853    
    as.factor(ZIPCODE)22405               288.3329    19.0599  15.128  < 2e-16 ***
    as.factor(ZIPCODE)22407               139.0356    15.7652   8.819  < 2e-16 ***
    as.factor(ZIPCODE)22408               140.1601    15.6065   8.981  < 2e-16 ***
    as.factor(ZIPCODE)22553                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22554              -110.8372    26.0922  -4.248 2.18e-05 ***
    as.factor(ZIPCODE)22556                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22630                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22701                     NA         NA      NA       NA    
    as.factor(month)2                       9.5567     3.3691   2.837 0.004570 ** 
    as.factor(month)3                      23.8074     3.3446   7.118 1.17e-12 ***
    as.factor(month)4                      40.3506     3.3356  12.097  < 2e-16 ***
    as.factor(month)5                      57.3335     3.3258  17.239  < 2e-16 ***
    as.factor(month)6                      72.5027     3.3182  21.850  < 2e-16 ***
    as.factor(month)7                      85.6360     3.3199  25.795  < 2e-16 ***
    as.factor(month)8                      93.6321     3.3150  28.245  < 2e-16 ***
    as.factor(month)9                      92.6563     3.5121  26.382  < 2e-16 ***
    as.factor(month)10                     88.5333     3.5070  25.245  < 2e-16 ***
    as.factor(month)11                     82.8844     3.4849  23.784  < 2e-16 ***
    as.factor(month)12                     81.0051     3.4816  23.267  < 2e-16 ***
    as.factor(year)2016                    31.6739     4.9253   6.431 1.33e-10 ***
    as.factor(year)2017                    81.4815     4.7308  17.223  < 2e-16 ***
    as.factor(year)2018                   123.6075     4.6098  26.814  < 2e-16 ***
    as.factor(year)2019                   182.3599     4.5393  40.173  < 2e-16 ***
    as.factor(year)2020                   194.2350     4.5029  43.135  < 2e-16 ***
    as.factor(year)2021                   260.9268     4.4448  58.704  < 2e-16 ***
    as.factor(year)2022                   439.0829     4.4051  99.677  < 2e-16 ***
    as.factor(year)2023                   532.7922     4.3914 121.326  < 2e-16 ***
    as.factor(year)2024                   650.5829     4.5891 141.769  < 2e-16 ***
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    Residual standard error: 66.8 on 9273 degrees of freedom
    Multiple R-squared:  0.9723,    Adjusted R-squared:  0.9717 
    F-statistic:  1739 on 187 and 9273 DF,  p-value: < 2.2e-16

## 

Answer: When fixed effects are included, the silver line’s effect jumps
from 188 to 630.

# Questions for Week 5

## Question 10: In a difference-in-differences (DiD) model, what is the treatment GROUP?

Answer:

## Question 11: In a DiD model, what are the control groups?

Answer:

## Question 12: What is the DiD regression equation that will answer your research question?

## Question 13: Run your DiD regressions below. What are the results of the DiD regression?

## Question 14: What are the next steps of your research?

Step 9: Change the document format to gfm

Step 10: Save this document as README.qmd

Step 11: Render the document. README.md file should be created after
this process.

Step 12: Push the document back to GitHub and observe your beautiful
document in your repository!

Step 13: If your team has a complete dataframe that includes both the
treated and outcome variable, you are done with the assignment. If not,
make a research plan in Notion to collect data on the outcome and
treatment variable and combine it into one dataframe.
