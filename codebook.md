---
title: "codebook"
author: "Hiran Hasanka"
date: "7/27/2020"
output: html_document
---
# Codebook

## Variable list

Variable name| Description
-------------|------------
Subjects     | subject who performed the activity for each sample. Its range is from 1 to 30.
Activity     | Activity name
Domain       | Time domain signal or frequency domain signal (Time or Freq)
Instrument   | Measuring instrument (Accelerometer or Gyroscope)
Acceleration | Acceleration signal (Body or Gravity)
Variable     | Variable (Mean or SD)
Jerk         | Jerk signal
Magnitude    | Magnitude of the signals calculated using the Euclidean norm
Axis         | Axial signals in the X, Y and Z directions (X, Y, or Z)
Count        | Count of data points used to compute `Average`
Average      | Average of each variable for each activity and each subject

## Dimensions of the Data Table


```r
dim(dTableTidy)
```

```
## [1] 11880    11
```


## Structure of the Data Table


```r
str(dTableTidy)
```

```
## Classes 'data.table' and 'data.frame':	11880 obs. of  11 variables:
##  $ Subjects    : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Activity    : Factor w/ 6 levels "LAYING","SITTING",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ Domain      : chr  "Frequency" "Frequency" "Frequency" "Frequency" ...
##  $ Instrument  : chr  "Accelerometer" "Accelerometer" "Accelerometer" "Accelerometer" ...
##  $ Acceleration: chr  "Body" "Body" "Body" "Body" ...
##  $ Variable    : chr  "Mean" "Mean" "Mean" "Mean" ...
##  $ Jerk        : chr  NA NA NA NA ...
##  $ Magnitude   : chr  NA NA NA "Magnitude" ...
##  $ Axis        : chr  "X" "Y" "Z" NA ...
##  $ Count       : int  50 50 50 50 50 50 50 50 50 50 ...
##  $ Average     : num  -0.939 -0.867 -0.883 -0.862 -0.957 ...
##  - attr(*, "sorted")= chr [1:9] "Subjects" "Activity" "Domain" "Instrument" ...
##  - attr(*, ".internal.selfref")=<externalptr>
```

## Variables of the Data Table


```r
names(dTableTidy)
```

```
##  [1] "Subjects"     "Activity"     "Domain"       "Instrument"   "Acceleration"
##  [6] "Variable"     "Jerk"         "Magnitude"    "Axis"         "Count"       
## [11] "Average"
```

## Summary of Data Table


```r
summary(dTableTidy)
```

```
##     Subjects                  Activity       Domain           Instrument       
##  Min.   : 1.0   LAYING            :1980   Length:11880       Length:11880      
##  1st Qu.: 8.0   SITTING           :1980   Class :character   Class :character  
##  Median :15.5   STANDING          :1980   Mode  :character   Mode  :character  
##  Mean   :15.5   WALKING           :1980                                        
##  3rd Qu.:23.0   WALKING_DOWNSTAIRS:1980                                        
##  Max.   :30.0   WALKING_UPSTAIRS  :1980                                        
##  Acceleration         Variable             Jerk            Magnitude        
##  Length:11880       Length:11880       Length:11880       Length:11880      
##  Class :character   Class :character   Class :character   Class :character  
##  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
##                                                                             
##                                                                             
##                                                                             
##      Axis               Count          Average        
##  Length:11880       Min.   :36.00   Min.   :-0.99767  
##  Class :character   1st Qu.:49.00   1st Qu.:-0.96205  
##  Mode  :character   Median :54.50   Median :-0.46989  
##                     Mean   :57.22   Mean   :-0.48436  
##                     3rd Qu.:63.25   3rd Qu.:-0.07836  
##                     Max.   :95.00   Max.   : 0.97451
```

