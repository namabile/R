#will remove ALL objects
rm(list=ls())

setwd("c:/sites/R")
# load in library
source("lib/lib.r")
source("lib/RGoogleAnalytics 1.3/R/QueryBuilder.R")
source("lib/RGoogleAnalytics 1.3/R/RGoogleAnalytics.R")

#connect to GA
query <- QueryBuilder()
access_token <- query$authorize()
ga <- RGoogleAnalytics()
ga.profiles <- ga$GetProfileData(access_token)

stop()
change_date <- mdy('11/8/2011')
yesterday <- mdy('2/27/2012')
change_date2 <- change_date + ddays(1)

beforegm <- getMargin(.15)
aftergm <- getMargin(.16)

#create array of durations in number of days based on number of weeks before and after the markup change date
total_days <- as.integer(difftime(yesterday, change_date, unit="days") - ddays(1))
weeks <- c(1,2,4,8,12)
days <- c(weeks * 7)

start_dates1 <- change_date - ddays(days) + ddays(1)
end_dates1 <- start_dates1 + ddays(days) - ddays(1)
start_dates2 <- end_dates1 + ddays(1)
end_dates2 <- start_dates2 + ddays(days) - ddays(1)

periods <- c(dtoString(start_dates1), dtoString(start_dates2), dtoString(end_dates1), dtoString(end_dates2))

#create matrix of start and end dates to loop through for data queries
colnames <- c("start_date","end_date")
cols <- length(colnames)
rows <- length(periods) / 2
rownames <- c(1:rows)

dates <- matrix(periods, nrow = rows, ncol = cols, dimnames = list(rownames, colnames), byrow = FALSE)

metrics <- c("ga:visits,ga:transactions,ga:transactionRevenue")

ga.data <- c()
for (i in 1:rows) {
	query <- QueryBuilder()
	query$Init(		start.date		= dtoString(dates[i,"start_date"]),
                   	end.date 		= dtoString(dates[i, "end_date"]),
                   	metrics 		= metrics,
                   	table.id 		= tickco_profile
	)
	result <- ga$GetReportData(query)$data ##problem here
	ga.data <- rbind(ga.data, result)
}
ga.data <- cbind(dates, ga.data)
ga.data <- cbind(days, ga.data)
ga.data <- ga.data[order(ga.data$days), ]
visits <- ga.data[, "ga:visits"]
revenue <- ga.data[, "ga:transactionRevenue"]
dollarspervisit <- revenue/visits
ga.data <- cbind(ga.data, dollarspervisit)


factors <- levels(factor(ga.data$days))
results <- c()
for (i in factors) {
	data <- ga.data[ga.data$days == i, "dollarspervisit"]
	before <- data[1]
	after <- data[2]
	pctchange <- ((after/before) - 1) * 100
	results <- c(results,pctchange)

	before <- before * beforegm
	after <- after * aftergm

	pctchange <- ((after/before) - 1) * 100
	results <- c(results, pctchange)
}
results <- matrix(results,nrow = length(factors), ncol = 2, dimnames = list(c(1:length(factors)), c("dollars per visit var", "gross profit var")), byrow = TRUE)
results <- cbind(weeks, results)
print(results)