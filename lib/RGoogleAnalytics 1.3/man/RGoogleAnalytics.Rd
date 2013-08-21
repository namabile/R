\name{RGoogleAnalytics}

\alias{RGoogleAnalytics}

\title{Creates a skeleton shell for accessing the Google Analytics API.}

\description{Creates a skeleton shell for accessing the Google Analytics API.}

\value{Returns a list of methods, for accessing the Google Analytics API
GetProfileData() - This function will retrive the available profiles from 
                   your Google anlaytics account by the Google Management API with 
		   the help of the access token. And the output will be in dataframe format.  

GetReportData() - This function will request with prepared query string 
                  to retrive the GA data feed in data.frame format. 
   
GetAcctDataFeedJSON() - This function will request to Google Management API with 
                        the query prepared by the QueryBuilder class for retriving 
		        the GA Account data. 

GetProfilesFromJSON() - This function will do the parsing operation on the JSON reponse 
                        returned from the Google Management API and return the dataframe
 			stored with the profile id and prfile name.

ParseApiErrorMessage() - To check whether the response is error or not. 
                         If it is error then it will intterupt the process 
			 and prompt with the related error messages  

ParseDataFeedJSON() - This function will parse the data feed json response and checks whether the reponse is errror,
                      if any error found it will promt user with the related error message	

}
\examples{

# Authorize your account and paste the accesstoken 
# query <- QueryBuilder()
# access_token <- query$authorize()

# Create a new Google Analytics API object
# ga <- RGoogleAnalytics()
# ga.profiles <- ga$GetProfileData(access_token)

# List the GA profiles 
# ga.profiles

# Build the query string 
# query$Init(start.date = "2012-06-18",
#           end.date = "2012-12-18",
#           dimensions = "ga:date,ga:pagePath",
#           metrics = "ga:visits,ga:pageviews,ga:timeOnPage",
#           sort = "ga:visits",
#           max.results = 99,
#           table.id = paste("ga:",ga.profiles$id[1],sep="",collapse=","),
#           access_token=access_token)

# Make a request to get the data from the API
# ga.data <- ga$GetReportData(query)

# Look at the returned data
# head(ga.data)
}