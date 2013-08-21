This document describes how you can get started using the Google Analytics for R library.

How to install this R package in R:

This package depends on 2 libraries.
	
	a. RCurl - provides https support from within R. You can install the package from within R using:
		install.packages("RCurl") or http://cran.r-project.org/web/packages/RCurl/index.html
     
	b. rjson - provides support to parse the JSON response from the API. You can install the package from within R using:
		install.packages("rjson") or http://cran.r-project.org/web/packages/rjson/index.html

	If errors occur when downloading/installing Rcurl or rjson packages, ensure the libcurl library is up to date.
	On a Linux machine, you can run:
		$ sudo apt-get install libcurl4-gnutls-dev

Install the R package: 

	From Local repository:- 
	For installing from the local directory, you need to doenlad this R package as per your Operating system.                      
                          	
		Windows user:
	              Download this R package in Zip format
	 
		In R studio:
		Packages > Install packages >> 
										Select the following 
										1. Inastall from :: Package Archieve File (ZIP)
										2. Package Archieve :: Browser by the location of the zip file of the R package 
								   
										>> Install  

		Linux user:
	              Download this R package in tar.gz format
				  
		Packages > Install packages >> 
										Select the following 
										1. Inastall from :: Package Archieve File (tar.gz)
										2. Package Archieve :: Browser by the location of the zip file of the R package 
								   
										>> Install  
								 
								 
Getting Started:

Once everything is configured it's a snap to get Google Analytics Data! Here's an Example:

# Loading the RGoogleAnalytics library
require("RGoogleAnalytics")

# 1. Authorize your account and paste the accesstoken 
query <- QueryBuilder()
access_token <- query$authorize()								 

# 2.  Create a new Google Analytics API object
ga <- RGoogleAnalytics()
ga.profiles <- ga$GetProfileData(access_token)

# List the GA profiles 
ga.profiles

# 3. Build the query string, use the profile by setting its index value 
query$Init(start.date = "2012-06-18",
           end.date = "2012-12-18",
           dimensions = "ga:date,ga:pagePath",
           metrics = "ga:visits,ga:pageviews,ga:timeOnPage",
           sort = "ga:visits",
           #filters="",
           #segment="",
           max.results = 99,
           table.id = paste("ga:",ga.profiles$id[1],sep="",collapse=","),
           access_token=access_token)

# 4. Make a request to get the data from the API
ga.data <- ga$GetReportData(query)

# 5. Look at the returned data
head(ga.data)


--------------------------------------------------------------------------------------------------------------------------------------
#To Run unit test, follow the steps 
# 1. Update the path of two files QueryBuilder.R, RGoogleAnalytics.R in both of the unit test files - QueryBuilder_unittest.R and RGoogleAnalytics_unittest.R
# 2. Update the value od the dirs variable as the path to RGoogleAnalytics/test folder in RUnit_driver.R file.
# 3. Run the RUnit_driver.R file to execute all test cases exists in R files.

#Additional Reference Information:
# https://developers.google.com/analytics/devguides/config/mgmt/v3/
# https://developers.google.com/analytics/devguides/reporting/core/v3/reference
# http://code.google.com/p/r-google-analytics/wiki/GettingStarted
