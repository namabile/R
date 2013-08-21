source("./QueryBuilder.r")
source("./RGoogleAnalytics.r")

# 1. Authorize your account and paste the accesstoken 
query <- QueryBuilder()
access_token <- query$authorize()

# 2.  Create a new Google Analytics API object
ga <- RGoogleAnalytics()
ga.profiles <- ga$GetProfileData(access_token)

# List the GA profiles 
ga.profiles

# 3. Build the query string 
query$Init(start.date = "2012-06-18",
           end.date = "2012-12-18",
           dimensions = "ga:date,ga:pagePath",
           metrics = "ga:visits,ga:pageviews,ga:timeOnPage",
           sort = "ga:visits",
           max.results = 99,
           table.id = paste("ga:",ga.profiles$id[1],sep="",collapse=","),
           access_token=access_token)

# 4. Make a request to get the data from the API
ga.data <- ga$GetReportData(query)

# 5. Look at the returned data
head(ga.data)