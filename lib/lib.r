## Library by: N. Amabile
## Updated 2/29/2012

# packages
library(RCurl) 		## to connnect to APIs and web data
library(XML)  		## to parse XML web responses
library(lubridate) 	## for easier date handling
library(RODBC) 		## to connect to SQL data sources
library(rjson) 		## need to parse json data from api responses

# set working directory
dir <- "c:/sites/R"
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
			if(is.null(username) || is.null(password)) {
				stop("Please provide your username and/or password")
			}
			ga$SetCredentials(username, password)
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

		return(list(profiles))
	}

	GetSegments <- function () {
		## args: 		none
		## returns: 	returns a list with the segment names and ids
		ga <- GAConnect()
		segments <- ga$GetProfileData()
		segments <- segments$segments
		rownames(segments) <- segments$SegmentName

		return(segments)
	}

return(list(
	GetReportData = GetReportData,
	GetProfileIDs = GetProfileIDs,
	GetSegments = GetSegments,
	GAConnect = GAConnect
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
	}

	query <- function (query) {
		## Function to query the RG production database
		## arge: 		SQL query string
		## returns:		a dataframe with the SQL query results or prints an error
		conn <- connect()

		data <- sqlQuery(conn,query)
		if (length(data) > 0) {
			if (data == -1) {
				stop(print("There was an error"))
			}
			else {
				return(data)
			}
		}
		else {
			return(invisible())
		}
	}

	query_from_file <- function(file) {
		## Creates a query string from a text file supplied
		## Then calls the query function above to run the string as a SQL with the default parameters
		## args:		path to a text file containing a SQL query
		## returns:		a datafrem with the SQL query results or prints an error

		query <- scan(file, what = character(), quiet = TRUE, sep ="\n")

		## remove use command if it's in there since I can't figure out how to make it work on ODBC
		if (tolower(substr(query[1],1,3)) == "use") {
			query<- scan(file, what = character(), quiet = TRUE, skip = 1, sep ="\n")
		}

		## remove tabs
		query <- gsub("\t","", query)

		## remove comments from beginning of lines
		for (i in 1:length(query)) {

			if (substr(query[i],1,2) == "--") {
				query[i] <- ""
			}
		}

		## remove comments from end of lines
		for(i in 1:length(query)) {
			line <- query[i]
			m <- gregexpr("--", line)
			m<- m[[1]]
			if (m[1] > 0) {
				query[i] <- substr(line,1,m[1]-1)
			}
		}

		## collapse the query into one long string
		q <- paste(query, collapse = " ")

		## check for ; to separate out commands
		m <- gregexpr(";", q)
		m <- m[[1]]
		if (m[1] > 0) {
			j <- 1
			commands <- c()
			for (i in 1:length(m)) {
				k = i + 1
				if (j == 1) {
					command <- substr(q, 1, m[1])
				}
				else {
					if (i == length(m)) {
						command <- substring(q,m[i], nchar(q))
					}
					else {
						command <- substring(q,m[i], m[k])
					}
				}
				commands <- c(commands,command)
				j <- j + 1
			}
		}

		## run commands specified in the commands object
		results <- c()
		for (i in 1:length(commands)) {
			command <- commands[i]
			result <- query(command)
			results <- c(results, result)
		}

		## return for debugging
		return(list( results = results, query = q))

		## regular return
		# return(results)
	}

return( list(
	query = query,
	query_from_file = query_from_file
	))
}