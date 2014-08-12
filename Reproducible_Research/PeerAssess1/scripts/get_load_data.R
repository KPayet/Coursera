# get_load_data.R: Kevin Payet
# checks if the dataset can be found in the current directory
# if not, downloads it
# when then read the .csv file and clean the column's format

if(!file.exists("./activity.zip")){
    data_url = "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"
    download.file(data_url,destfile = "./activity.zip")
}

data <- read.csv(unz("activity.zip", filename = "activity.csv"))

data[,2] <- as.Date(data[, 2], "%Y-%m-%d") # replace the character dates by real dates
