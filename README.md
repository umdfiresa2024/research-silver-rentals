# How did the opening of the Silver Line of the Washington Metro System impact adjacent rental prices?


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
```

Step 5. Use the **head** and **kable** function showcase the first 10
rows of the dataframe to the reader.

``` r
kable(head(df))
```

| ZIPCODE | Date       |     ZORI | State | City       | date       | silver |
|--------:|:-----------|---------:|:------|:-----------|:-----------|-------:|
|   20001 | 2023.05.31 | 2621.437 | DC    | Washington | 2023-05-31 |      0 |
|   20001 | 2023.06.30 | 2633.269 | DC    | Washington | 2023-06-30 |      0 |
|   20001 | 2023.07.31 | 2651.125 | DC    | Washington | 2023-07-31 |      0 |
|   20001 | 2023.08.31 | 2659.947 | DC    | Washington | 2023-08-31 |      0 |
|   20001 | 2023.09.30 | 2686.397 | DC    | Washington | 2023-09-30 |      0 |
|   20001 | 2023.10.31 | 2676.108 | DC    | Washington | 2023-10-31 |      0 |

## Question 1: What is the frequency of this data frame?

Answer: Monthly

## Question 2: What is the cross-sectional (geographical) unit of this data frame?

Answer: Zip code

Step 6. Use the **names** function to display all the variables (column)
in the dataframe.

``` r
names(df)
```

    [1] "ZIPCODE" "Date"    "ZORI"    "State"   "City"    "date"    "silver" 

## Question 3: Which column represents the treatment variable of interest?

Answer: silver

## Question 4: Which column represents the outcome variable of interest?

Answer: ZORI

Step 7: Create a boxplot to visualize the distribution of the outcome
variable under treatment and no treatment.

``` r
ggplot(df, aes(x=ZORI)) +
  geom_histogram() +
  facet_wrap(~silver)
```

Step 8: Fit a regression model $y=\beta_0 + \beta_1 x + \epsilon$ where
$y$ is the outcome variable and $x$ is the treatment variable. Use the
**summary** function to display the results.

``` r
model1<-lm(ZORI ~ silver, data=df)

summary(model1)
```


    Call:
    lm(formula = ZORI ~ silver, data = df)

    Residuals:
        Min      1Q  Median      3Q     Max 
    -866.76 -268.03  -43.53  211.48 2682.88 

    Coefficients:
                Estimate Std. Error t value Pr(>|t|)    
    (Intercept) 2040.129      4.626  441.06   <2e-16 ***
    silver       188.653      9.359   20.16   <2e-16 ***
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    Residual standard error: 389.7 on 9390 degrees of freedom
    Multiple R-squared:  0.04147,   Adjusted R-squared:  0.04137 
    F-statistic: 406.3 on 1 and 9390 DF,  p-value: < 2.2e-16

## Question 5: What is the predicted value of the outcome variable when treatment=0?

Answer: 2040.129

## Question 6: What is predicted value of the outcome variable when treatment=1?

Answer: 2040.129 + 188.653 = 2228.782

## Question 7: What is the equation that describes the linear regression above? Please include an explanation of the variables and subscripts.

Answer: $$ZORI = \beta_0 + \beta_1silver + \epsilon$$

## Question 8: What fixed effects can be included in the regression? What does each fixed effects control for? Please include a new equation that incorporates the fixed effects.

Answer:
$$ZORI = \beta_0 + \beta_1 silver + \beta_2 city + \beta_3 zip\_code + \epsilon$$

## Question 9: What is the impact of the treatment effect once fixed effects are included?

``` r
model2 <- lm(ZORI ~ silver + as.factor(City) + as.factor(ZIPCODE), data=df)
summary(model2)
```


    Call:
    lm(formula = ZORI ~ silver + as.factor(City) + as.factor(ZIPCODE), 
        data = df)

    Residuals:
       Min     1Q Median     3Q    Max 
    -469.7 -143.9  -39.3  128.7  714.3 

    Coefficients: (80 not defined because of singularities)
                                          Estimate Std. Error t value Pr(>|t|)    
    (Intercept)                          2763.9967    67.4028  41.007  < 2e-16 ***
    silver                                928.5330   136.9287   6.781 1.27e-11 ***
    as.factor(City)Alexandria            -417.1371    69.6883  -5.986 2.23e-09 ***
    as.factor(City)Annandale             -719.8554    70.3347 -10.235  < 2e-16 ***
    as.factor(City)Arlington             -658.4651    71.5545  -9.202  < 2e-16 ***
    as.factor(City)Ashburn              -1262.6612   153.6422  -8.218 2.34e-16 ***
    as.factor(City)Beltsville           -1203.9590    74.9140 -16.071  < 2e-16 ***
    as.factor(City)Bethesda               120.0060    69.7078   1.722 0.085183 .  
    as.factor(City)Bowie                 -266.5784    80.3495  -3.318 0.000911 ***
    as.factor(City)Burke                  -20.8085    79.7521  -0.261 0.794164    
    as.factor(City)Burtonsville          -479.7123    87.0166  -5.513 3.63e-08 ***
    as.factor(City)Capitol Heights      -1949.4954   156.9672 -12.420  < 2e-16 ***
    as.factor(City)Centreville           -694.0031    72.0566  -9.631  < 2e-16 ***
    as.factor(City)Chantilly              250.0974    81.0081   3.087 0.002026 ** 
    as.factor(City)Charles Town          -930.0254    92.6363 -10.040  < 2e-16 ***
    as.factor(City)Chesapeake Beach        46.0033   202.2084   0.228 0.820037    
    as.factor(City)Chevy Chase           -475.5875    70.2124  -6.774 1.33e-11 ***
    as.factor(City)Clarksburg             208.1247   102.9595   2.021 0.043265 *  
    as.factor(City)College Park          -895.7570    70.7333 -12.664  < 2e-16 ***
    as.factor(City)Culpeper             -1069.9798   102.9595 -10.392  < 2e-16 ***
    as.factor(City)Damascus              -133.9967   202.2084  -0.663 0.507561    
    as.factor(City)Derwood               -130.4967    98.6676  -1.323 0.186005    
    as.factor(City)District Heights     -1258.7536    75.3586 -16.704  < 2e-16 ***
    as.factor(City)Dumfries               249.3410    95.3220   2.616 0.008917 ** 
    as.factor(City)East Riverdale        -919.0965    74.3333 -12.365  < 2e-16 ***
    as.factor(City)Edmonston             -408.3157   102.9595  -3.966 7.37e-05 ***
    as.factor(City)Fairfax               -868.4795    69.6883 -12.462  < 2e-16 ***
    as.factor(City)Falls Church         -1060.6912   154.4127  -6.869 6.87e-12 ***
    as.factor(City)Forest Heights       -1055.5373    70.9065 -14.886  < 2e-16 ***
    as.factor(City)Fort Belvoir          -562.4256    92.6363  -6.071 1.32e-09 ***
    as.factor(City)Fort Hunt             1194.0281   150.7172   7.922 2.60e-15 ***
    as.factor(City)Fort Washington      -1144.4535    75.3586 -15.187  < 2e-16 ***
    as.factor(City)Frederick             -123.8588    90.4303  -1.370 0.170826    
    as.factor(City)Fredericksburg       -1026.6166    75.3586 -13.623  < 2e-16 ***
    as.factor(City)Front Royal          -1249.2623    95.3220 -13.106  < 2e-16 ***
    as.factor(City)Gainesville           -113.6023    75.8593  -1.498 0.134287    
    as.factor(City)Gaithersburg          -715.0209    74.9140  -9.545  < 2e-16 ***
    as.factor(City)Germantown            -643.7870    73.4055  -8.770  < 2e-16 ***
    as.factor(City)Greater Landover     -1878.4975   155.3017 -12.096  < 2e-16 ***
    as.factor(City)Greenbelt             -806.8946    73.2746 -11.012  < 2e-16 ***
    as.factor(City)Groveton              -249.2614    95.3220  -2.615 0.008939 ** 
    as.factor(City)Haymarket              517.5087   116.7451   4.433 9.41e-06 ***
    as.factor(City)Herndon              -1737.6814   153.6422 -11.310  < 2e-16 ***
    as.factor(City)Huntington            -930.7191    70.6530 -13.173  < 2e-16 ***
    as.factor(City)Hyattsville          -1071.2756    70.7333 -15.145  < 2e-16 ***
    as.factor(City)Hybla Valley          -868.4294    71.1502 -12.206  < 2e-16 ***
    as.factor(City)Kensington             207.7705   108.6837   1.912 0.055946 .  
    as.factor(City)La Plata              -197.3301   202.2084  -0.976 0.329152    
    as.factor(City)Landover Hills       -1248.3041    77.8300 -16.039  < 2e-16 ***
    as.factor(City)Langley Park         -1047.1939    81.0081 -12.927  < 2e-16 ***
    as.factor(City)Lanham Seabrook       -760.2032   116.7451  -6.512 7.82e-11 ***
    as.factor(City)Laurel               -1072.7875    74.7099 -14.359  < 2e-16 ***
    as.factor(City)Leesburg              -449.7943    75.3586  -5.969 2.48e-09 ***
    as.factor(City)Lincolnia             -789.9744    71.2031 -11.095  < 2e-16 ***
    as.factor(City)Lorton                -725.7823    69.9472 -10.376  < 2e-16 ***
    as.factor(City)Manassas               536.8190   129.0665   4.159 3.22e-05 ***
    as.factor(City)McLean               -1478.1083   153.6422  -9.620  < 2e-16 ***
    as.factor(City)Middletown            -313.9967   202.2084  -1.553 0.120496    
    as.factor(City)Montgomery Village    -687.2585    77.0781  -8.916  < 2e-16 ***
    as.factor(City)Mount Vernon            -3.2003    90.4303  -0.035 0.971770    
    as.factor(City)North Bethesda        -811.0673    69.6883 -11.639  < 2e-16 ***
    as.factor(City)Oakton                 -24.3185   102.9595  -0.236 0.813286    
    as.factor(City)Potomac               1111.7027    74.9140  14.840  < 2e-16 ***
    as.factor(City)Purcellville           331.1517   129.0665   2.566 0.010311 *  
    as.factor(City)Ranson                -909.2120   150.7172  -6.033 1.68e-09 ***
    as.factor(City)Reston                -454.7786    73.8361  -6.159 7.61e-10 ***
    as.factor(City)Rockville             -613.9967   202.2084  -3.036 0.002400 ** 
    as.factor(City)Rose Hill             -643.1924    69.7078  -9.227  < 2e-16 ***
    as.factor(City)Silver Spring         -883.0130    70.2723 -12.566  < 2e-16 ***
    as.factor(City)Springfield            -70.9168    72.2232  -0.982 0.326169    
    as.factor(City)Stafford              -278.2102    98.6676  -2.820 0.004818 ** 
    as.factor(City)Sterling             -1315.3083   155.4283  -8.462  < 2e-16 ***
    as.factor(City)Suitland-Silver Hill  -890.2639    71.0001 -12.539  < 2e-16 ***
    as.factor(City)Takoma Park          -1240.2576    73.5425 -16.865  < 2e-16 ***
    as.factor(City)Temple Hills         -1102.6723    95.3220 -11.568  < 2e-16 ***
    as.factor(City)Upper Marlboro       -1893.2830   153.7489 -12.314  < 2e-16 ***
    as.factor(City)Vienna                -934.2370   153.9079  -6.070 1.33e-09 ***
    as.factor(City)Waldorf                779.3366   202.2084   3.854 0.000117 ***
    as.factor(City)Warrenton             -908.6829    98.6676  -9.210  < 2e-16 ***
    as.factor(City)Washington            -390.0013    69.7078  -5.595 2.27e-08 ***
    as.factor(City)Woodbridge           -1142.4821    69.7078 -16.390  < 2e-16 ***
    as.factor(ZIPCODE)20002             -1174.3843   139.2078  -8.436  < 2e-16 ***
    as.factor(ZIPCODE)20003              -887.2156   139.3878  -6.365 2.04e-10 ***
    as.factor(ZIPCODE)20004              -807.2765   146.0721  -5.527 3.35e-08 ***
    as.factor(ZIPCODE)20005              -919.5316   139.4859  -6.592 4.57e-11 ***
    as.factor(ZIPCODE)20006             -1080.4572   142.3973  -7.588 3.57e-14 ***
    as.factor(ZIPCODE)20007              -861.4573   139.3749  -6.181 6.65e-10 ***
    as.factor(ZIPCODE)20008              -345.9330    26.6665 -12.973  < 2e-16 ***
    as.factor(ZIPCODE)20009                 0.3184    25.0871   0.013 0.989875    
    as.factor(ZIPCODE)20010              -276.9808    26.7477 -10.355  < 2e-16 ***
    as.factor(ZIPCODE)20011              -422.9438    26.0671 -16.225  < 2e-16 ***
    as.factor(ZIPCODE)20012              -148.2699    44.3632  -3.342 0.000835 ***
    as.factor(ZIPCODE)20015               232.4087    28.0724   8.279  < 2e-16 ***
    as.factor(ZIPCODE)20016                26.9518    25.9301   1.039 0.298644    
    as.factor(ZIPCODE)20017              -264.1293    34.3716  -7.685 1.69e-14 ***
    as.factor(ZIPCODE)20018              -323.3217    31.6512 -10.215  < 2e-16 ***
    as.factor(ZIPCODE)20019             -1394.4688   140.7382  -9.908  < 2e-16 ***
    as.factor(ZIPCODE)20020              -647.2459    29.3003 -22.090  < 2e-16 ***
    as.factor(ZIPCODE)20024              -970.7512   139.7133  -6.948 3.95e-12 ***
    as.factor(ZIPCODE)20032              -827.3644    50.8686 -16.265  < 2e-16 ***
    as.factor(ZIPCODE)20036              -319.1829    26.6665 -11.969  < 2e-16 ***
    as.factor(ZIPCODE)20037              -961.4059   139.3878  -6.897 5.65e-12 ***
    as.factor(ZIPCODE)20105                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20109             -1431.4210   113.6008 -12.600  < 2e-16 ***
    as.factor(ZIPCODE)20110             -1351.8013   113.7588 -11.883  < 2e-16 ***
    as.factor(ZIPCODE)20111             -1606.2167   112.1650 -14.320  < 2e-16 ***
    as.factor(ZIPCODE)20112                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20120              -102.3051    31.8193  -3.215 0.001308 ** 
    as.factor(ZIPCODE)20121                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20132                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20147              -427.2084    25.0328 -17.066  < 2e-16 ***
    as.factor(ZIPCODE)20148                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20151                 1.5379    96.3753   0.016 0.987269    
    as.factor(ZIPCODE)20152                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20155                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20164               836.3485   144.3133   5.795 7.04e-09 ***
    as.factor(ZIPCODE)20165               994.3699   144.0507   6.903 5.43e-12 ***
    as.factor(ZIPCODE)20166                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20169                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20170                -2.7902    25.8106  -0.108 0.913915    
    as.factor(ZIPCODE)20171                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20175              -388.3962    39.1259  -9.927  < 2e-16 ***
    as.factor(ZIPCODE)20176                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20186                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20190             -1132.6955   141.3202  -8.015 1.23e-15 ***
    as.factor(ZIPCODE)20191             -1329.6964   141.3299  -9.408  < 2e-16 ***
    as.factor(ZIPCODE)20194                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20601             -1726.4815   193.4272  -8.926  < 2e-16 ***
    as.factor(ZIPCODE)20602             -1151.9567   220.1366  -5.233 1.71e-07 ***
    as.factor(ZIPCODE)20603             -1529.8703   192.0406  -7.966 1.83e-15 ***
    as.factor(ZIPCODE)20646                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20695                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20705                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20706                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20707               -10.4076    37.4417  -0.278 0.781043    
    as.factor(ZIPCODE)20708                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20715               183.5499   118.4396   1.550 0.121240    
    as.factor(ZIPCODE)20716              -434.9580    51.9905  -8.366  < 2e-16 ***
    as.factor(ZIPCODE)20720               665.0817   195.5965   3.400 0.000676 ***
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
    as.factor(ZIPCODE)20772              1876.7958   145.3092  12.916  < 2e-16 ***
    as.factor(ZIPCODE)20774                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20781                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20782                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20783                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20784                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20785                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20814              -371.6629    25.1964 -14.751  < 2e-16 ***
    as.factor(ZIPCODE)20815                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20816              -143.8385    65.9878  -2.180 0.029299 *  
    as.factor(ZIPCODE)20817                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20850               -73.5846   191.4639  -0.384 0.700746    
    as.factor(ZIPCODE)20851               322.0206   196.5112   1.639 0.101312    
    as.factor(ZIPCODE)20852                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20853                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20854                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20855                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20866                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20871                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20872                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20874              -458.4160    34.0375 -13.468  < 2e-16 ***
    as.factor(ZIPCODE)20876                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20877              -167.6746    44.2203  -3.792 0.000151 ***
    as.factor(ZIPCODE)20878              -135.4468    37.1792  -3.643 0.000271 ***
    as.factor(ZIPCODE)20879                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20886                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20895                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20901               313.6275    70.2723   4.463 8.18e-06 ***
    as.factor(ZIPCODE)20902                 6.5860    27.5410   0.239 0.811007    
    as.factor(ZIPCODE)20903              -185.9270    63.4789  -2.929 0.003409 ** 
    as.factor(ZIPCODE)20904               -36.9387    35.2178  -1.049 0.294267    
    as.factor(ZIPCODE)20906              -138.7372    29.2424  -4.744 2.12e-06 ***
    as.factor(ZIPCODE)20910                     NA         NA      NA       NA    
    as.factor(ZIPCODE)20912                     NA         NA      NA       NA    
    as.factor(ZIPCODE)21701             -1058.4920    62.8755 -16.835  < 2e-16 ***
    as.factor(ZIPCODE)21702             -1086.4829    63.2294 -17.183  < 2e-16 ***
    as.factor(ZIPCODE)21703              -657.6886    65.8290  -9.991  < 2e-16 ***
    as.factor(ZIPCODE)21704                     NA         NA      NA       NA    
    as.factor(ZIPCODE)21769                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22003                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22015                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22025              -130.0044   202.2084  -0.643 0.520290    
    as.factor(ZIPCODE)22026                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22030               164.7976    27.7062   5.948 2.81e-09 ***
    as.factor(ZIPCODE)22031               109.1809    25.7447   4.241 2.25e-05 ***
    as.factor(ZIPCODE)22032              1265.8812    79.8175  15.860  < 2e-16 ***
    as.factor(ZIPCODE)22033                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22041               143.6710   140.6135   1.022 0.306929    
    as.factor(ZIPCODE)22042               518.3886   140.5111   3.689 0.000226 ***
    as.factor(ZIPCODE)22043              -405.8329    30.1166 -13.475  < 2e-16 ***
    as.factor(ZIPCODE)22044               116.4454   141.2833   0.824 0.409848    
    as.factor(ZIPCODE)22046                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22060                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22079                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22101              3213.7684   155.7400  20.635  < 2e-16 ***
    as.factor(ZIPCODE)22102                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22124                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22150              -455.6148    42.1239 -10.816  < 2e-16 ***
    as.factor(ZIPCODE)22152               513.6155    82.0401   6.261 4.01e-10 ***
    as.factor(ZIPCODE)22153                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22180               792.2427   142.1741   5.572 2.58e-08 ***
    as.factor(ZIPCODE)22181               769.9926   140.2013   5.492 4.08e-08 ***
    as.factor(ZIPCODE)22182                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22191               142.1630    25.0871   5.667 1.50e-08 ***
    as.factor(ZIPCODE)22192               103.6774    25.0871   4.133 3.62e-05 ***
    as.factor(ZIPCODE)22193                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22201              -788.3126   135.9628  -5.798 6.93e-09 ***
    as.factor(ZIPCODE)22202               152.8900    30.4365   5.023 5.18e-07 ***
    as.factor(ZIPCODE)22203              -533.6021   136.2474  -3.916 9.05e-05 ***
    as.factor(ZIPCODE)22204              -172.9760    29.8367  -5.797 6.96e-09 ***
    as.factor(ZIPCODE)22205               654.5888   150.7172   4.343 1.42e-05 ***
    as.factor(ZIPCODE)22206               -92.5821    30.6065  -3.025 0.002494 ** 
    as.factor(ZIPCODE)22207               815.7394    35.0132  23.298  < 2e-16 ***
    as.factor(ZIPCODE)22209              -628.3091   135.9830  -4.620 3.88e-06 ***
    as.factor(ZIPCODE)22213                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22301               -20.6818    28.9838  -0.714 0.475514    
    as.factor(ZIPCODE)22302                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22303                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22304              -588.9829    27.9156 -21.099  < 2e-16 ***
    as.factor(ZIPCODE)22305              -498.7490    29.2538 -17.049  < 2e-16 ***
    as.factor(ZIPCODE)22306                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22307                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22308                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22309                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22310                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22311              -577.7681    34.3319 -16.829  < 2e-16 ***
    as.factor(ZIPCODE)22312                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22314               -81.9585    28.8537  -2.840 0.004514 ** 
    as.factor(ZIPCODE)22315                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22401              -253.4036    38.4534  -6.590 4.64e-11 ***
    as.factor(ZIPCODE)22405               339.2216    54.3419   6.242 4.50e-10 ***
    as.factor(ZIPCODE)22407                83.2557    44.9694   1.851 0.064146 .  
    as.factor(ZIPCODE)22408                74.2992    44.5086   1.669 0.095088 .  
    as.factor(ZIPCODE)22553                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22554              -520.4836    74.1989  -7.015 2.47e-12 ***
    as.factor(ZIPCODE)22556                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22630                     NA         NA      NA       NA    
    as.factor(ZIPCODE)22701                     NA         NA      NA       NA    
    as.factor(ZIPCODE)25414                     NA         NA      NA       NA    
    as.factor(ZIPCODE)25438                     NA         NA      NA       NA    
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    Residual standard error: 190.6 on 9222 degrees of freedom
    Multiple R-squared:  0.7747,    Adjusted R-squared:  0.7706 
    F-statistic: 187.6 on 169 and 9222 DF,  p-value: < 2.2e-16

## 

Answer: When fixed effects are included, the silver line’s effect jumps
from 188 to 928.

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
