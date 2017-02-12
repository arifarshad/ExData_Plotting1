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

# Parsing dates and converting to abbreviated day of the week
library(lubridate)
Dates <- parse_date_time(HPC_sub$Date, "dmy")
Times <- parse_date_time(HPC_sub$Time, "HMS")
Date_Times <- paste(Dates, Times)
Date_Times <- gsub("0000-01-01", "", Date_Times)
Date_Times <- parse_date_time(Date_Times, "ymd HMS")
Date_Time_HPC <- cbind(Date_Times, HPC_sub)

# construct and arrange 4 plots, and then save as a png
par(mfrow = c(2,2))
with(Date_Time_HPC, {
  plot(Date_Time_HPC$Date_Times, Date_Time_HPC$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)")
  plot(Date_Time_HPC$Date_Times, Date_Time_HPC$Voltage, type = "l", xlab = "datetime", ylab = "Voltage")
  plot(Date_Time_HPC$Date_Times, Date_Time_HPC$Sub_metering_1, type = "l", col = "black", xlab = "", ylab = "Energy sub meeting")
      lines(Date_Time_HPC$Date_Times, Date_Time_HPC$Sub_metering_2, type = "l", col = "red")
      lines(Date_Time_HPC$Date_Times, Date_Time_HPC$Sub_metering_3, type = "l", col = "blue")
      legend(x = 'topright', lty = c(1,1,1), lwd = 2, col = c("black", "red", "blue"),
             legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), cex = .4)
  plot(Date_Time_HPC$Date_Times, Date_Time_HPC$Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power")
})
dev.copy(device = png, "plot4.png", width = 480, height = 480)
dev.off()