#will remove ALL objects 
rm(list=ls())

# load in library
source("x:/ad hoc/R/lib/lib.r")

#connect to GA
ga <- GA()
ga$GetProfileIDs()

#start_date <- mdy("3/6/2012")
start_date <- mdy("3/7/2012")
end_date <- ymd(toString(Sys.Date()))

dimensions <- c("ga:eventCategory,ga:eventLabel")
metrics <- c("ga:visits,ga:totalEvents,ga:uniqueEvents,ga:transactions")
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
new_cart <- ga.data[ga.data$"ga:eventLabel" == "New",]
old_cart <- ga.data[ga.data$"ga:eventLabel" == "Old",]

new_conversion <- new_cart[ga.data$"ga:eventCategory" == "Confirmation","ga:transactions"]/new_cart[ga.data$"ga:eventCategory" == "Checkout", "ga:visits"] * 100
old_conversion <- old_cart[ga.data$"ga:eventCategory" == "Confirmation","ga:transactions"]/old_cart[ga.data$"ga:eventCategory" == "Checkout", "ga:visits"] * 100

#new_data <- rbind(new_cart,old_cart)
var <- (new_conversion/old_conversion - 1) * 100
#colnames(new_data) <- c("Checkout","Confirmation","Conversion")
print(var)