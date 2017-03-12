dataURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if (file.exists("../rawData/household_power_consumption.zip") ||  file.exists("../rawData/household_power_consumption.txt")) {
  message("== Data file (zip or txt format) exists, skipping downloading step \r")
} else { if (! (file.exists("../rawData/"))) { 
  message("== Creating data folder, warning message might show... \r")
  dir.create("../rawData/")
}
  message("== Downloading data file...\r")
  download.file(url=dataURL, destfile = "../rawData/household_power_consumption.zip")
}
if (file.exists("../rawData/household_power_consumption.txt")) {message("== Data file (txt format) exists, skipping extraction...\r")
  unzip(zipfile = "../rawData/household_power_consumption.zip", exdir="../rawData/")
}
data <- read.table(file = "../rawData/household_power_consumption.txt", sep = ";", header = FALSE,
                   na.strings = "?", nrows = 2880, skip = 66637)
colnames(data) <- c("date","time", "GlobalActivePower", "GlobalReactivePower", "Voltage", "GlobalIntensity",
                    "SubMetering1", "SubMetering2", "SubMetering3")
data$datetime <- strptime(paste(data$date, data$time, sep = " "), format = "%d/%m/%Y %H:%M:%S")
data$date <- as.Date(data$date, format = "%d/%m/%Y")
png (filename = "plot3.png", width = 480, height = 480)


with(data, plot(y = SubMetering1, x = datetime, type = "n", ylab = "Energy sub metering", xlab = ""))
with(data, points(datetime, SubMetering1, type = "l"))
with(data, points(datetime, SubMetering2, type = "l", col = "red"))
with(data, points(datetime, SubMetering3, type = "l", col = "blue"))
legend("topright", lty = "solid", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.off()
