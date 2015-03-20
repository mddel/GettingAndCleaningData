## Getting And Cleaning Data

This repository contains the solution for the "Getting and Cleaning Data" course project.

### Files

1.  `CodeBook.md` contains a description of the data transformations
2.  `run_analysis.R` contains the `R` source code
3.  `tidySummary.txt` contains the resulting summary data in `txt` format

### Steps

1.  download zip file
2.  unzip
3.  run `run_analysis.R`
    a.  the scrip will generate two data frames, `subsetData` and `summaryData` and a file called `tidySummary.txt`
    b.  package `reshape2` is needed in order to generate `summaryData`
    
### Data transformations in `run_analysis.R`

First step is reading the data from the files: `activity_labels.txt` contains the 6 activity names and `features.txt` contains the 561 different names of the measurement types, described in detail in `features_info`. The actual measurements are organized in two folders, `test` and `train`. The structure is identical. For each of the two folders, the files of interest are `subject_*`, `X_*` and `y_*`, where * is either "test" or "train".

1. read the activity labels
2. read the features
3. read the test and training data: subject, x and y
4. bind "subject" and "y" as columns to "x", representing `subject` and `activity` respectively
5. add together the rows for the test and the training data
6. sanitize the feature names by removing "()" and replacing "-" with "."
7. update the column names of the resulting data set with the `features`
8. update the values of the `activity` column with the more verbose labels read at step 1.

<!-- -->

    allData$activity <- sapply(allData$activity, 
                               function(x) 
                                   {as.factor(tolower(activityLabels[x,2]))}
                               )

9. subset the data and only keep data referring to `mean` and `std` for each feature. Columns like `meanFreq` need to be eliminitated as well. The following regular expression was used:

<!-- -->

    "mean[.]|mean$|std[.]|std$|^activity$|^subject$"
    
The requiered `subsetData` is now available

10. Calculate the summary data by first "melting" the data set into a form suitable to be re-organized:

<!-- -->

    melt(subsetData, id = c("subject", "activity"))
    
This will create a data frame with "subject", "activity", "variable" and "value" columns, where each of the remaining columns from the original data set are set as rows in the "variable" column, and their values, for each original row, are set into new row in the "variable" column. This makes grouping much simpler.

11. "Cast" a new data set that calculates the mean per "subject" and "activity" for every "variable".

<!-- -->

    dcast(dataMelt, subject + activity ~ variable, mean)
    
12. Write the result to a file