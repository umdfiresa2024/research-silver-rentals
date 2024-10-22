# How did the expansion of the Silver Line of the Washington Metro
System impact adjacent rental prices?


Step 1. Install necessary packages.

``` r
#install.packages("tidyverse")
#install.packages("kableExtra")
```

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

| ZIPCODE | Date | ZORI | State | CountyName | City | date | silver | post | month | year | exptime | open2014 | open2022 | openother | dist |
|---:|:---|---:|:---|:---|:---|:---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 20120 | 2019.04.30 | 1836.296 | VA | Fairfax County | Centreville | 2019-04-30 | 0 | 0 | 4 | 2019 | 0 | 0 | 0 | 1 | 14756.27 |
| 20120 | 2019.05.31 | 1848.128 | VA | Fairfax County | Centreville | 2019-05-31 | 0 | 0 | 5 | 2019 | 0 | 0 | 0 | 1 | 14756.27 |
| 20120 | 2019.06.30 | 1844.276 | VA | Fairfax County | Centreville | 2019-06-30 | 0 | 0 | 6 | 2019 | 0 | 0 | 0 | 1 | 14756.27 |
| 20120 | 2019.07.31 | 1835.209 | VA | Fairfax County | Centreville | 2019-07-31 | 0 | 0 | 7 | 2019 | 0 | 0 | 0 | 1 | 14756.27 |
| 20120 | 2019.08.31 | 1836.571 | VA | Fairfax County | Centreville | 2019-08-31 | 0 | 0 | 8 | 2019 | 0 | 0 | 0 | 1 | 14756.27 |
| 20120 | 2019.09.30 | 1830.839 | VA | Fairfax County | Centreville | 2019-09-30 | 0 | 0 | 9 | 2019 | 0 | 0 | 0 | 1 | 14756.27 |

## Question 1: What is the frequency of this data frame?

Answer: Monthly

## Question 2: What is the cross-sectional (geographical) unit of this data frame?

Answer: Zip code

Step 6. Use the **names** function to display all the variables (column)
in the dataframe.

``` r
names(df2)
```

     [1] "ZIPCODE"    "Date"       "ZORI"       "State"      "CountyName"
     [6] "City"       "date"       "silver"     "post"       "month"     
    [11] "year"       "exptime"    "open2014"   "open2022"   "openother" 
    [16] "dist"      

## Question 3: Which column represents the treatment variable of interest?

Answer: open2022

## Question 4: Which column represents the outcome variable of interest?

Answer: ZORI

Step 7: Create a boxplot to visualize the distribution of the outcome
variable under treatment and no treatment.

``` r
df3 <- filter(df2, year=="2022")
ggplot(df3, aes(x=ZORI)) +
  geom_histogram() +
  facet_wrap(~open2022)
```

Step 8: Fit a regression model $y=\beta_0 + \beta_1 x + \epsilon$ where
$y$ is the outcome variable and $x$ is the treatment variable. Use the
**summary** function to display the results.

``` r
model1<-lm(ZORI ~ open2022*post, data=df2)

summary(model1)
```


    Call:
    lm(formula = ZORI ~ open2022 * post, data = df2)

    Residuals:
        Min      1Q  Median      3Q     Max 
    -646.86 -193.66  -42.22  144.39  972.11 

    Coefficients:
                  Estimate Std. Error t value Pr(>|t|)    
    (Intercept)   2075.458      5.027 412.878   <2e-16 ***
    open2022       -94.639      9.382 -10.087   <2e-16 ***
    post           426.789     10.430  40.918   <2e-16 ***
    open2022:post   26.430     19.566   1.351    0.177    
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    Residual standard error: 281.1 on 5702 degrees of freedom
    Multiple R-squared:  0.3084,    Adjusted R-squared:  0.3081 
    F-statistic: 847.7 on 3 and 5702 DF,  p-value: < 2.2e-16

## Question 5: What is the predicted value of the outcome variable when treatment=0?

Answer: 2075.458

## Question 6: What is predicted value of the outcome variable when treatment=1?

Answer: 2075.458 + 426.789 = undefined

## Question 7: What is the equation that describes the linear regression above? Please include an explanation of the variables and subscripts.

Answer: $$ZORI = \beta_0 + \beta_1open2022:post + \epsilon$$

## Question 8: What fixed effects can be included in the regression? What does each fixed effects control for? Please include a new equation that incorporates the fixed effects.

Answer:
$$ZORI_{zm} = \beta_1 open2022\times post + \beta_2 month + \beta_3 year + \beta_4 open2014 + \beta_5 openother + \beta_6 county + \beta_7 city + \epsilon_{zm}$$

Where $z$ represents the zip code and $m$ represents the current month

Answer:
$$ZORI = \beta_0 + \beta_1 open2022:post+ \beta_2 city + \beta_3 zip\_code + \beta_4 month + \beta_5 year + \epsilon$$

## Question 9: What is the impact of the treatment effect once fixed effects are included?

``` r
model2 <- lm(ZORI ~ open2022 + post + open2022:post + open2014 + openother + as.factor(month) + as.factor(year) + as.factor(City) + as.factor(CountyName), data=df)
model3 <- lm(ZORI ~ post*open2022*dist + open2014 + openother + as.factor(month) + as.factor(year) + as.factor(City) + as.factor(CountyName), data=df)
# summary(model2)
summary(model3)
```


    Call:
    lm(formula = ZORI ~ post * open2022 * dist + open2014 + openother + 
        as.factor(month) + as.factor(year) + as.factor(City) + as.factor(CountyName), 
        data = df)

    Residuals:
        Min      1Q  Median      3Q     Max 
    -539.70  -56.91    0.71   63.72  433.71 

    Coefficients: (2 not defined because of singularities)
                                          Estimate Std. Error t value Pr(>|t|)    
    (Intercept)                          2.532e+03  2.744e+01  92.280  < 2e-16 ***
    post                                 2.960e+01  1.241e+01   2.385 0.017131 *  
    open2022                             3.736e+02  1.816e+01  20.572  < 2e-16 ***
    dist                                -2.763e-02  1.399e-03 -19.746  < 2e-16 ***
    open2014                             6.539e+01  6.440e+00  10.153  < 2e-16 ***
    openother                                   NA         NA      NA       NA    
    as.factor(month)2                    9.382e+00  6.790e+00   1.382 0.167137    
    as.factor(month)3                    2.231e+01  6.774e+00   3.294 0.000993 ***
    as.factor(month)4                    3.973e+01  6.764e+00   5.874 4.49e-09 ***
    as.factor(month)5                    5.713e+01  6.768e+00   8.442  < 2e-16 ***
    as.factor(month)6                    7.454e+01  6.764e+00  11.020  < 2e-16 ***
    as.factor(month)7                    8.655e+01  6.764e+00  12.796  < 2e-16 ***
    as.factor(month)8                    9.139e+01  6.764e+00  13.510  < 2e-16 ***
    as.factor(month)9                    8.594e+01  7.033e+00  12.218  < 2e-16 ***
    as.factor(month)10                   8.348e+01  7.008e+00  11.911  < 2e-16 ***
    as.factor(month)11                   7.485e+01  7.181e+00  10.424  < 2e-16 ***
    as.factor(month)12                   7.899e+01  7.158e+00  11.036  < 2e-16 ***
    as.factor(year)2016                  2.545e+01  8.422e+00   3.022 0.002521 ** 
    as.factor(year)2017                  5.757e+01  8.130e+00   7.082 1.60e-12 ***
    as.factor(year)2018                  1.078e+02  7.989e+00  13.488  < 2e-16 ***
    as.factor(year)2019                  1.692e+02  7.916e+00  21.374  < 2e-16 ***
    as.factor(year)2020                  1.791e+02  7.875e+00  22.741  < 2e-16 ***
    as.factor(year)2021                  2.570e+02  7.821e+00  32.863  < 2e-16 ***
    as.factor(year)2022                  4.623e+02  8.039e+00  57.516  < 2e-16 ***
    as.factor(year)2023                  5.426e+02  1.377e+01  39.400  < 2e-16 ***
    as.factor(year)2024                  6.905e+02  1.430e+01  48.303  < 2e-16 ***
    as.factor(City)Annandale            -5.760e+02  1.820e+01 -31.654  < 2e-16 ***
    as.factor(City)Ashburn              -2.537e+02  2.829e+01  -8.967  < 2e-16 ***
    as.factor(City)Centreville          -4.588e+02  1.304e+01 -35.188  < 2e-16 ***
    as.factor(City)Fairfax              -5.809e+02  1.454e+01 -39.943  < 2e-16 ***
    as.factor(City)Falls Church         -6.796e+02  2.308e+01 -29.439  < 2e-16 ***
    as.factor(City)Herndon              -5.902e+02  2.718e+01 -21.711  < 2e-16 ***
    as.factor(City)Huntington           -7.303e+02  1.314e+01 -55.599  < 2e-16 ***
    as.factor(City)Hybla Valley         -5.680e+02  1.602e+01 -35.457  < 2e-16 ***
    as.factor(City)Leesburg             -5.888e+02  1.574e+01 -37.403  < 2e-16 ***
    as.factor(City)Lincolnia            -7.390e+02  2.004e+01 -36.876  < 2e-16 ***
    as.factor(City)Lorton                9.721e+00  2.256e+01   0.431 0.666548    
    as.factor(City)McLean               -5.916e+02  2.140e+01 -27.646  < 2e-16 ***
    as.factor(City)Reston               -8.350e+02  2.337e+01 -35.730  < 2e-16 ***
    as.factor(City)Rose Hill            -3.371e+02  1.226e+01 -27.492  < 2e-16 ***
    as.factor(City)Springfield           2.725e+02  1.844e+01  14.781  < 2e-16 ***
    as.factor(City)Sterling             -8.034e+02  2.630e+01 -30.547  < 2e-16 ***
    as.factor(City)Vienna               -1.729e+02  2.406e+01  -7.188 7.43e-13 ***
    as.factor(CountyName)Loudoun County         NA         NA      NA       NA    
    post:open2022                       -7.854e+01  1.982e+01  -3.962 7.51e-05 ***
    post:dist                            5.772e-04  5.578e-04   1.035 0.300790    
    open2022:dist                       -1.392e-01  6.572e-03 -21.177  < 2e-16 ***
    post:open2022:dist                   2.804e-02  5.337e-03   5.254 1.54e-07 ***
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    Residual standard error: 105.3 on 5660 degrees of freedom
    Multiple R-squared:  0.9036,    Adjusted R-squared:  0.9029 
    F-statistic:  1179 on 45 and 5660 DF,  p-value: < 2.2e-16

model2 \<- lm(ZORI ~ silver + as.factor(City) + as.factor(ZIPCODE) +
as.factor(month) + as.factor(year), data=df2) summary(model2) \`\`\`

## 

Answer: When fixed effects are included, the silver line’s effect jumps
from 188 to 630.

# Questions for Week 5

## Question 10: In a difference-in-differences (DiD) model, what is the treatment GROUP?

Answer: The zip codes containing the new section of the silver line

## Question 11: In a DiD model, what are the untreated groups?

Answer: The zip codes in Virginia not containing the new silver line
expansion

## Question 12: What is the DiD regression equation that will answer your research question?

Answer:
$$ZORI = \beta_1 dist + \beta_2 silver + \beta_3 post + \beta_4 (silver \times post) + \gamma_{city} + \theta_{zip\_code} + \zeta_{month} + \iota_{year} + \lambda_{City} + \epsilon$$

## Question 13: What are the results of the DiD regression?

Answer: The opening of the expansion of the silver line increased house
rental prices by an amount that isn’t statistically significant(\$2.06).

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

## Future Plans:

The house rental prices may not have adjusted immediately as the
expansion of the silver line opened. As such, including the time since
the expansion opened may help us better understand the silver line’s
effects on rental prices.
