# Test for directory and create if need be
if(!file.exists("HPC")){
  dir.create("HPC")
}
# Download and unzip
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url = url, destfile = "../HPC", method = "curl")
unzip("exdata%2Fdata%2Fhousehold_power_consumption.zip")

# Load the data
HPC <- read.table("../HPC/household_power_consumption.txt", header = TRUE,
                  sep = ";", dec = ".", stringsAsFactors = FALSE)

# Subset for rows for the appropriate dates
HPC_sub <- HPC[HPC$Date %in% c("1/2/2007", "2/2/2007"),]

# Parsing dates and times into a single date-time column
library(lubridate)
Dates <- parse_date_time(HPC_sub$Date, "dmy")
Times <- parse_date_time(HPC_sub$Time, "HMS")
Date_Times <- paste(Dates, Times)
Date_Times <- gsub("0000-01-01", "", Date_Times)
Date_Times <- parse_date_time(Date_Times, "ymd HMS")
Date_Time_HPC <- cbind(Date_Times, HPC_sub)

# Lined Scatterplot, saved as a png
with(Date_Time_HPC, plot(Date_Time_HPC$Date_Times, Date_Time_HPC$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)"))
dev.copy(device = png, "plot2.png", width = 480, height = 480)
dev.off()