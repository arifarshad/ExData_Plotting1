# Test for directory and create if need be
if(!file.exists("HPC")){
  dir.create("HPC")
}
# Download and unzip
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url = url, destfile = "../HPC", method = "curl")
unzip("exdata%2Fdata%2Fhousehold_power_consumption.zip")

# Load the data
HPC <- read.table("../HPC/household_power_consumption.txt", header = TRUE, sep = ";", dec = ".", stringsAsFactors = FALSE)

# Subset for rows for the appropriate dates
HPC_sub <- HPC[HPC$Date %in% c("1/2/2007", "2/2/2007"),]

# convert column to numeric vector, construct a histogrram from the vector, and save a copy as a png
Global_active_power <- as.numeric(HPC_sub$Global_active_power)
hist(Global_active_power, xlab = "Global Active Power (kilowatts)", ylab = "Frequency", main = "Global Active Power", col = "red")
dev.copy(device = png, "plot1.png", width = 480, height = 480)
dev.off()
