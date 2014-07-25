---
title: "README.md"
author: "Kevin Payet"
date: "Thursday, July 24, 2014"
output: html_document
---

You will find 3 files:

    - This README file
    - CookBook.md, which gives some details on the original and tidy data sets, and the steps used to produce the latter.
    - The script used to extract the tidy data set, named run_analysis.R. To use the script as is:
        - Place it in the same directory as the 'UCI HAR Dataset' directory. If you don't, you will have to open the script and give the correct paths for the different files used
        - set your working directory to the parent directory of 'UCI HAR Dataset'
		- type `source("run_analysis.R")`, and wait a little
        - tidy_data.txt has been created in your working directory (`getwd()`)
