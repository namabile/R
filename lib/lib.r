## Library by: N. Amabile
## Updated 2/29/2012

# packages
library(RCurl) 		## to connnect to APIs and web data
library(XML)  		## to parse XML web responses
library(lubridate) 	## for easier date handling
library(RODBC) 		## to connect to SQL data sources

# set working directory
dir <- "x:/ad hoc/r/"
libpath <- paste(dir,"/lib/",sep="")

## Load Google Analytics libraries

source(paste(dir,"/lib/RGoogleAnalytics/R/QueryBuilder.r", sep=""))
source(paste(dir,"/lib/RGoogleAnalytics/R/RGoogleAnalytics.r", sep=""))

## custom functions


dtoString <- function (dates) {
	## args: 		takes a vector of dates
	## returns: 	a string vector of newdates as strings in the format YYYY-DD-MM
    newdates <- as.character(c())
    for (i in 1:length(dates)) {
        newdates[i] <- toString(dates[i], format = '%Y-%m-%d')
    }
    return(newdates)
}

getMargin <- function(markup) {
	## quick math function to calculate the margin yielded by a certain ticket markup %
	## args: 		takes a markup percentage in decimal form
	## returns: 	returns the gross margin percentage in decimal form
	margin <- markup/(1 + markup)
	return(margin)
}


## begin google analytics helper functions
GA <- function() {
	GAConnect <- function(username= NULL, password = NULL) {
		## Private helper function to authenticate the script for Google API access
		## This function checks to see if we have a valid Google auth token already stored on the network
		## If we do, it uses that to sign future requests
		## If not, it connects to Google login service and writes the auth token to a file on the network
		## args: 		none
		## returns: 	RGoogleAnalytics object that provides access to Google Analytics functions provided by the RGoogleAnalytics Library
		ga <- RGoogleAnalytics()
		ga$CheckAuthToken()
		if(is.null(auth.token)) {
			if (username == NULL || pasword == NULL) {
				stop("Please provide your username and/or password")
			}
			ga$setCredentials(username, password)
		}
		return(ga)
	}

	GetReportData <- function (query) {
		## creates accesor function for RGoogleAnalytics$GetReportDAta(query)
		ga <- GAConnect()
		result <- ga$GetReportData(query)
		return(result)
	}

	GetProfileIDs <- function() {
		## args: 		none
		## returns: 	returns a list with the parsed rg_profile and tickco_profile ids
		ga <- GAConnect()
		profiles <- ga$GetProfileData()
		profiles <- profiles$profile
		rownames(profiles) <- profiles$ProfileName

		rg_profile <<- as.character(profiles["Razorgator", "TableId"])
		tickco_profile <<- as.character(profiles["Tickco", "TableId"])

		return(list(rg_profile = rg_profile, tickco_profile = tickco_profile))
	}
return(list(
	GetReportData = GetReportData,
	GetProfileIDs = GetProfileIDs
	))
}

## begin SQL helper functions
SQL <- function() {
	
	connect <- function() {
		##	Private helper function to establish a connection to the RG production database
		## 	Log in credentials are passed via Windows authentication and are thus blank in the connection object
		##	args:		none
		## returns:		SQL connection object to the RG production database
		conn <- odbcConnect("sql03mia", uid = "", pwd = "")
		return(conn)
		rm(conn)
	}

	query <- function (query) {
		## Function to query the RG production database
		## arge: 		SQL query string
		## returns:		a dataframe with the SQL query results or prints an error
		conn <- connect()
		data <- sqlQuery(conn,query,errors= TRUE)
		if (class(data) == "data.frame") {
			return(data)	
		}
		else {
			stop(print(data))
		}		
	}

return( list(
	query = query
	))
}