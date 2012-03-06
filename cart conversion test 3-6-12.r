#will remove ALL objects 
rm(list=ls())

# load in library
source("x:/ad hoc/R/lib/lib.r")

#connect to GA
ga <- GA()
ga$GetProfileIDs()

start_date <- mdy("3/6/2012")
end_date <- ymd(toString(Sys.Date()))

dimensions <- c("ga:eventCategory,ga:eventLabel")
metrics <- c("ga:visits,ga:totalEvents,ga:uniqueEvents")
filters <- c("ga:eventCategory==Checkout,ga:eventCategory==Confirmation")
sort <- c("ga:eventLabel")

ga.data <- c()
query <- QueryBuilder()
query$Init(		start.date		= dtoString(start_date),
               	end.date 		= dtoString(end_date),
               	dimensions 		= dimensions,
               	metrics 		= metrics,
               	filters			= filters,
               	sort			= sort,
               	table.id 		= rg_profile
)
result <- ga$GetReportData(query)$data
ga.data <- rbind(ga.data, result)

names <- factor(ga.data$"ga:eventCategory")
new_cart <- ga.data[ga.data$"ga:eventLabel" == "New", "ga:totalEvents"]
names(new_cart) <- levels(names)
old_cart <- ga.data[ga.data$"ga:eventLabel" == "Old", "ga:totalEvents"]
names(old_cart) <- levels(names)

new_conversion <- new_cart["Confirmation"]/new_cart["Checkout"] * 100
old_conversion <- old_cart["Confirmation"]/old_cart["Checkout"] * 100

new_cart <- c(new_cart,new_conversion)
old_cart <- c(old_cart,old_conversion)

new_data <- rbind(new_cart,old_cart)
var <- (new_conversion/old_conversion - 1) * 100
colnames(new_data) <- c("Checkout","Confirmation","Conversion")
print(new_data)
print(var)