library(jsonlite)
library(lubridate)
library(ggplot2)

url_sensor_types = "http://wsn-api.manchesterdda.net/v1/units/info/sensor_types"
url_all_data = "http://wsn-api.manchesterdda.net/v1/units/data/all?limit=1000"

sensor_types <- fromJSON(url_sensor_types, flatten=T)$data
sensor_types$name <- as.factor(sensor_types$name)
sensor_types$data_type <- as.factor(sensor_types$data_type)
sensor_types$label <- paste0(sensor_types$name, " (", sensor_types$data_type, ")")

sensors <- fromJSON(url_all_data, flatten=T)$data
sensors$datetime <- ymd_hms(sensors$datetime)

sensors <- merge(sensors, sensor_types, by.x="sensor_id", by.y="sensor_type_id")

device_names <- data.frame(device_id=c("WASP0011","WASP0013","WASP0014","WASP0015","WASP0016"),device_name=c("Clock Tower","Grosvenor Park","Mancunian Way","Aquatics Centre","Royal Exchange"))

sensors <- merge(sensors, device_names, by="device_id")


ggplot(sensors, aes(datetime, value)) + geom_line(aes(colour=device_name)) + facet_wrap(~ label, ncol=1, scales="free_y") + labs(y="Date", x="Sensor Reading", colour="Device")

ggplot(sensors, aes(datetime, value)) + geom_line(aes(colour=device_name)) + facet_wrap(~ label, ncol=1, scales="free_y") + labs(y="Date", x="Sensor Reading", colour="Device") + xlim(ymd("2014-12-04"), ymd("2014-12-18"))

ggplot(sensors, aes(datetime, value)) + geom_line(aes(colour=device_name)) + facet_wrap(~ label, ncol=1, scales="free_y") + labs(y="Date", x="Sensor Reading", colour="Device") + xlim(ymd("2015-02-18"), ymd("2015-03-01"))

# Temperature around the clock
ggplot(sensors[sensors$name=="Temperature",], aes(((hour(datetime)*60)+minute(datetime))/60, value)) + geom_point(alpha=0.5) + coord_polar() + facet_wrap(~ device_name) + scale_x_continuous(breaks=1:24) + labs(x="Time of day", y = "Temperature in Centigrade")
