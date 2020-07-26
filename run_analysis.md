---
title: "run_analysis"
author: "Hiran Hasanka"
date: "7/26/2020"
output: pdf_document
---

> The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  
> 
> One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 
> 
> http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
> 
> Here are the data for the project: 
> 
> https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
> 
> You should create one R script called run_analysis.R that does the following. 
> 
> 1. **DONE** Merges the training and the test sets to create one data set.
> 2. **DONE** Extracts only the measurements on the mean and standard deviation for each measurement.
> 3. **DONE** Uses descriptive activity names to name the activities in the data set.
> 4. **DONE** Appropriately labels the data set with descriptive activity names.
> 5. **DONE** Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
> 
> Good luck!

## Loading Packages

```r
library(data.table)
library(dplyr)
```

## Downloading and Unzipping Data
The dataset will be downloaded to the 'data' folder.
The dataset is already downloaded and unzipped.
**Do NOT evaluate the following chunk of code.**
The data files have been placed in a folder named 'UCI HAR Dataset'.


```r
if (!file.exists('./data')) {
  dir.create('./data')
}

download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip', destfile = './data/Dataset.zip')
```


## Reading Data
**Refer 'README.txt' file in the folder 'UCI HAR Dataset' for details.**

### 1. Reading Subjects


```r
trainSubs <- fread('./data/UCI HAR Dataset/train/subject_train.txt')
testSubs <- fread('./data/UCI HAR Dataset/test/subject_test.txt')
# Concatenating them togehter
dataSubs <- rbind(trainSubs, testSubs)
names(dataSubs) <- "Subjects"
dim(dataSubs)
```

```
## [1] 10299     1
```

### 2. Reading Activities


```r
trainActs <- fread('./data/UCI HAR Dataset/train/y_train.txt')
testActs <- fread('./data/UCI HAR Dataset/test/y_test.txt')
# Concatenating them together
dataActs <- rbind(trainActs, testActs)
names(dataActs) <- "Activities"
dim(dataActs)
```

```
## [1] 10299     1
```

### 3. Reading Data for other Features


```r
trainData <- fread('./data/UCI HAR Dataset/train/X_train.txt')
testData <- fread('./data/UCI HAR Dataset/test/X_test.txt')
# Concatenating them together
dTable <- rbind(trainData, testData)
dim(dTable)
```

```
## [1] 10299   561
```

### 4. Merging Columns Together
Seeting the key of the data table for "Subjects" and "Activities".


```r
dTable <- cbind(dataSubs, dataActs, dTable)
dTable <- data.table(dTable)
setkey(dTable, Subjects, Activities)
dim(dTable)
```

```
## [1] 10299   563
```

### 5. Reading Feature Names


```r
dataFeatures <- fread('./data/UCI HAR Dataset/features.txt')
names(dataFeatures) <- c('featureNumber', 'featureName')
head(dataFeatures)
```

```
##    featureNumber       featureName
## 1:             1 tBodyAcc-mean()-X
## 2:             2 tBodyAcc-mean()-Y
## 3:             3 tBodyAcc-mean()-Z
## 4:             4  tBodyAcc-std()-X
## 5:             5  tBodyAcc-std()-Y
## 6:             6  tBodyAcc-std()-Z
```

## Subsetting and Processing

Subsetting Mean and Standard Deviation from the feature name list.


```r
dataFeatures <- dataFeatures[grep("mean\\(\\)|std\\(\\)", featureName)]
dim(dataFeatures)
```

```
## [1] 66  2
```

Creating a column for variable keys to match the variable names in dTable.


```r
dataFeatures$featureKey <- dataFeatures[, paste0("V", featureNumber)]
head(dataFeatures)
```

```
##    featureNumber       featureName featureKey
## 1:             1 tBodyAcc-mean()-X         V1
## 2:             2 tBodyAcc-mean()-Y         V2
## 3:             3 tBodyAcc-mean()-Z         V3
## 4:             4  tBodyAcc-std()-X         V4
## 5:             5  tBodyAcc-std()-Y         V5
## 6:             6  tBodyAcc-std()-Z         V6
```

Subsetting the original dataset with only these features.


```r
dTable <- dTable[, c("Subjects", "Activities", dataFeatures$featureKey), with = F]
dim(dTable)
```

```
## [1] 10299    68
```

Reading activity tables


```r
activityLabels <- fread('./data/UCI HAR Dataset/activity_labels.txt')
names(activityLabels) <- c('activityNumber', 'activityName')
head(activityLabels)
```

```
##    activityNumber       activityName
## 1:              1            WALKING
## 2:              2   WALKING_UPSTAIRS
## 3:              3 WALKING_DOWNSTAIRS
## 4:              4            SITTING
## 5:              5           STANDING
## 6:              6             LAYING
```

Merge datasets 'dTable' and 'activityTables' to get labels for activities.


```r
dTable <- merge(dTable, activityLabels, by.x = 'Activities', by.y = 'activityNumber',
                all.x = T)
dim(dTable)
```

```
## [1] 10299    69
```

Updating keys


```r
setkey(dTable, Subjects, Activities, activityName)
```

Melting the data table to reshape it to tall and narrow format.


```r
dTable <- data.table(melt(dTable, key(dTable), variable.name = 'featureKey'))
head(dTable)
```

```
##    Subjects Activities activityName featureKey     value
## 1:        1          1      WALKING         V1 0.2820216
## 2:        1          1      WALKING         V1 0.2558408
## 3:        1          1      WALKING         V1 0.2548672
## 4:        1          1      WALKING         V1 0.3433705
## 5:        1          1      WALKING         V1 0.2762397
## 6:        1          1      WALKING         V1 0.2554682
```

Merge Feature Names.


```r
dTable <- merge(dTable, dataFeatures, by = 'featureKey', all.x = T)
head(dTable)
```

```
##    featureKey Subjects Activities activityName     value featureNumber       featureName
## 1:         V1        1          1      WALKING 0.2820216             1 tBodyAcc-mean()-X
## 2:         V1        1          1      WALKING 0.2558408             1 tBodyAcc-mean()-X
## 3:         V1        1          1      WALKING 0.2548672             1 tBodyAcc-mean()-X
## 4:         V1        1          1      WALKING 0.3433705             1 tBodyAcc-mean()-X
## 5:         V1        1          1      WALKING 0.2762397             1 tBodyAcc-mean()-X
## 6:         V1        1          1      WALKING 0.2554682             1 tBodyAcc-mean()-X
```

Create two variables, 'Activity' and 'featureName' as factors.


```r
dTable$Activity <- as.factor(dTable$activityName)
dTable$featureName <- as.factor(dTable$featureName)
head(dTable)
```

```
##    featureKey Subjects Activities activityName     value featureNumber       featureName
## 1:         V1        1          1      WALKING 0.2820216             1 tBodyAcc-mean()-X
## 2:         V1        1          1      WALKING 0.2558408             1 tBodyAcc-mean()-X
## 3:         V1        1          1      WALKING 0.2548672             1 tBodyAcc-mean()-X
## 4:         V1        1          1      WALKING 0.3433705             1 tBodyAcc-mean()-X
## 5:         V1        1          1      WALKING 0.2762397             1 tBodyAcc-mean()-X
## 6:         V1        1          1      WALKING 0.2554682             1 tBodyAcc-mean()-X
##    Activity
## 1:  WALKING
## 2:  WALKING
## 3:  WALKING
## 4:  WALKING
## 5:  WALKING
## 6:  WALKING
```

## Making Data Tidy

The current data table is not exactly tidy. One record of 'featureName' contains many information in it. I've identified them as follows:
    1. Domain (Time or Frequency)
    2. Instrument (Accelerometer or Gyroscope)
    3. Acceleration (Body or Gravity)
    4. Variable (Mean or Standard Deviation)
    5. Jerk (Jerk or not)
    6. Magnitude (Magnitude or not)
    7. Axis (X, Y or Z)
    
**Please refer to the README file provided with the dataset for more details about the information given with feature names.**
I'll try to make these information types as separate features in the data table.

### 1. Domain


```r
timeRows <- grep("^t", dTable$featureName)
freqRows <- grep("^f", dTable$featureName)
dTable$Domain[timeRows] <- "Time"
dTable$Domain[freqRows] <- "Frequency"
head(dTable$Domain)
```

```
## [1] "Time" "Time" "Time" "Time" "Time" "Time"
```

### 2. Instrument


```r
accRows <- grep("Acc", dTable$featureName)
gyroRows <- grep("Gyro", dTable$featureName)
dTable$Instrument[accRows] <- "Accelerometer"
dTable$Instrument[gyroRows] <- "Gyroscope"
head(dTable$Instrument)
```

```
## [1] "Accelerometer" "Accelerometer" "Accelerometer" "Accelerometer" "Accelerometer"
## [6] "Accelerometer"
```

### 3. Acceleration


```r
bodyRows <- grep("BodyAcc", dTable$featureName)
gravRows <- grep("GravityAcc", dTable$featureName)
dTable$Acceleration[bodyRows] <- "Body"
dTable$Acceleration[gravRows] <- "Gravity"
head(dTable$Acceleration)
```

```
## [1] "Body" "Body" "Body" "Body" "Body" "Body"
```

### 4. Variable


```r
mnRows <- grep("mean", dTable$featureName)
stdRows <- grep("std", dTable$featureName)
dTable$Variable <- NA
dTable$Variable[mnRows] <- "Mean"
dTable$Variable[stdRows] <- "SD"
head(dTable$Variable)
```

```
## [1] "Mean" "Mean" "Mean" "Mean" "Mean" "Mean"
```

### 5. Jerk


```r
jerkRows <- grep("Jerk", dTable$featureName)
dTable$Jerk[jerkRows] <- "Jerk"
head(dTable$Jerk)
```

```
## [1] NA NA NA NA NA NA
```

### 6. Magnitude


```r
magnitudeRows <- grep("Mag", dTable$featureName)
dTable$Magnitude <- NA
dTable$Magnitude[magnitudeRows] <- "Magnitude"
head(dTable$Magnitude)
```

```
## [1] NA NA NA NA NA NA
```

### 7. Axis


```r
xRows <- grep("-X", dTable$featureName)
yRows <- grep("-Y", dTable$featureName)
zRows <- grep("-Z", dTable$featureName)
dTable$Axis <- NA
dTable$Axis[xRows] <- "X"
dTable$Axis[yRows] <- "Y"
dTable$Axis[zRows] <- "Z"
head(dTable$Axis)
```

```
## [1] "X" "X" "X" "X" "X" "X"
```

Creating a dataset with the mean of each variable for each activity and each subject.


```r
setkey(dTable, 'Subjects', 'Activity', 'Domain', 'Instrument', 'Acceleration', 'Variable', 'Jerk', 'Magnitude', 'Axis')
```



```r
dTable <- dTable[, list(Count = .N, Average = mean(value)), by=key(dTable)]
dTableTidy <- dTable[, c(key(dTable), 'Count', 'Average'), with = F]
head(dTableTidy)
```

```
##    Subjects Activity    Domain    Instrument Acceleration Variable Jerk Magnitude Axis
## 1:        1   LAYING Frequency Accelerometer         Body     Mean <NA>      <NA>    X
## 2:        1   LAYING Frequency Accelerometer         Body     Mean <NA>      <NA>    Y
## 3:        1   LAYING Frequency Accelerometer         Body     Mean <NA>      <NA>    Z
## 4:        1   LAYING Frequency Accelerometer         Body     Mean <NA> Magnitude <NA>
## 5:        1   LAYING Frequency Accelerometer         Body     Mean Jerk      <NA>    X
## 6:        1   LAYING Frequency Accelerometer         Body     Mean Jerk      <NA>    Y
##    Count    Average
## 1:    50 -0.9390991
## 2:    50 -0.8670652
## 3:    50 -0.8826669
## 4:    50 -0.8617676
## 5:    50 -0.9570739
## 6:    50 -0.9224626
```

