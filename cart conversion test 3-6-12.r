#will remove ALL objects 
rm(list=ls())

# load in library
source("x:/ad hoc/R/lib/lib.r")

#connect to GA
ga <- GA()
ga$GetProfileIDs()

#start_date <- mdy("3/6/2012")
start_date <- mdy("3/8/2012")
end_date <- ymd(toString(Sys.Date()))

## get orders placed using the new and old carts
dimensions <- c("ga:eventCategory,ga:eventLabel")
metrics <- c("ga:totalEvents")
filters <- c("ga:eventCategory==Confirmation")
sort <- c("ga:eventLabel")

query <- QueryBuilder()
query$Init(		start.date		= dtoString(start_date),
               	end.date 		= dtoString(end_date),
               	dimensions 		= dimensions,
               	metrics 		= metrics,
               	filters			= filters,
               	sort			= sort,
               	table.id 		= rg_profile
)
ga.data <- ga$GetReportData(query)$data

new_cart_orders <- ga.data[ga.data$"ga:eventLabel" == "New", "ga:totalEvents"]
old_cart_orders <- ga.data[ga.data$"ga:eventLabel" == "Old", "ga:totalEvents"]

## get visits for web01, web02, and web03 sgements
metrics <- c("ga:visits")
dimensions <- c("ga:CustomVarValue2")

query <- QueryBuilder()
query$Init(		start.date		= dtoString(start_date),
               	end.date 		= dtoString(end_date),
               	metrics 		= metrics,
               	dimensions		= dimensions,
               	table.id 		= rg_profile
)
ga.data <- ga$GetReportData(query)$data

new_cart_visits <- ga.data[1, "ga:visits"]
old_cart_visits <- ga.data[2, "ga:visits"] + ga.data[3, "ga:visits"]

new_conversion <- new_cart_orders / new_cart_visits * 100
old_conversion <- old_cart_orders / old_cart_visits * 100

var <- (new_conversion/old_conversion - 1) * 100

results <- list(new_conversion = new_conversion, old_conversion = old_conversion, var = var)
print(results)