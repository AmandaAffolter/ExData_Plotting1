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
png (filename = "plot4.png", width = 480, height = 480)

par(mfcol=c(2,2))

with(data, plot(y=GlobalActivePower, x=datetime, type = "n", xlab ="", ylab = "Global Active Power"))
with(data, lines(y=GlobalActivePower, x=datetime))

with(data, plot(y=SubMetering1, x=datetime, type = "n", xlab = "", ylab = "Energy sub metering"))
with(data,lines(y=SubMetering1, x=datetime, col = "black"))
with(data,lines(y=SubMetering2, x=datetime, col = "red"))
with(data,lines(y=SubMetering3, x=datetime, col = "blue"))

legend("topright", lty = "solid", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

with(data, plot(y=Voltage, x=datetime, type = "n"))
with(data, lines(y=Voltage, x=datetime, col = "black"))

with(data,plot(y=GlobalReactivePower, x=datetime, type = "n", ylab = "Global_reactive_power"))
with(data,lines(y=GlobalReactivePower, x=datetime, col = "black"))


dev.off()
