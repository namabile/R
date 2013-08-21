# Copyright 2010 Google Inc. All Rights Reserved.
# Author: mpearmain@google.com (Mike Pearmain)

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Run unit tests in R, for RGoogleAnalytics.R
# The driver file to execute is ./Runit_driver.R


# Unit tests for the RGoogleAnalytics() class.
# The SetCredentials() function is trivial and only returns an Auth.Token as a
# string.  This is non-trivial to mock so no unit test is applied.

source("D:/Office/vignesh/RGoogleAnalytics/R/RGoogleAnalytics.r")

# Test the parsing of XML feed after it has been returned for profile
# information.

  # To check the profile data returned as JSON response. 
TestParseAccountFeedJSON <- function() {
    
  ga <- RGoogleAnalytics()
  # Create a data.frame with the same properties as the mock JSON.
  
 
  ProfileName <- c("tatvic.com")
  TableId <- c("10696290")
  test.profile <- data.frame(ProfileName=ProfileName,TableId=TableId)
   

  data <- ga$GetProfilesFromJSON(AccountFeedJSONString())
  
  profile.data <- data.frame(ProfileName=data$profiles$name,TableId=data$profiles$id)
  
  checkEquals(test.profile,profile.data)

  
  checkEqualsNumeric(1, as.numeric(data$totalResults))
  
}


AccountFeedJSONString <- function() {
  return('{\"kind\":\"analytics#profiles\",\"username\":\"vignesh@tatvic.com\",\"totalResults\":1,\"startIndex\":1,\"itemsPerPage\":1000,\"items\":[{\"id\":\"10696290\",\"kind\":\"analytics#profile\",\"selfLink\":\"https://www.googleapis.com/analytics/v3/management/accounts/5306665/webproperties/UA-5306665-1/profiles/10696290\",\"accountId\":\"5306665\",\"webPropertyId\":\"UA-5306665-1\",\"internalWebPropertyId\":\"10240597\",\"name\":\"tatvic.com\",\"currency\":\"USD\",\"timezone\":\"Asia/Calcutta\",\"websiteUrl\":\"http://www.tatvic.com/\",\"excludeQueryParameters\":\"fb_xd_fragment,tim,m,token,n\",\"siteSearchQueryParameters\":\"s\",\"type\":\"WEB\",\"created\":\"2008-08-15T14:45:21.000Z\",\"updated\":\"2012-12-10T13:47:52.046Z\",\"eCommerceTracking\":false,\"parentLink\":{\"type\":\"analytics#webproperty\",\"href\":\"https://www.googleapis.com/analytics/v3/management/accounts/5306665/webproperties/UA-5306665-1\"},\"childLink\":{\"type\":\"analytics#goals\",\"href\":\"https://www.googleapis.com/analytics/v3/management/accounts/5306665/webproperties/UA-5306665-1/profiles/10696290/goals\"}}]}')
}

# To test the error message existense in JSON response.
TestParseApiErrorMessage <- function() {
  ga <- RGoogleAnalytics()
  error.message <- ga$ParseApiErrorMessage(SampleErrorJSONString())
 
  checkEquals(400, error.message$code)
  checkEquals('Sort key ga:foo is not a dimension or metric in this query.',
              error.message$message)
}

SampleErrorJSONString <- function() {
return('{\"error\":{\"errors\":[{\"domain\":\"global\",\"reason\":\"badRequest\",\"message\":\"Sort key ga:foo is not a dimension or metric in this query.\"}],\"code\":400,\"message\":\"Sort key ga:foo is not a dimension or metric in this query.\"}}')
}

# To test the GA data feed returned as JSON response.

TestParseDataFeedJSON <- function(){
ga <- RGoogleAnalytics()

# Testing the $data structure is the same.
DataFeed.json <- ga$ParseDataFeedJSON(DataFeedJSONString())
DataFeed.json.totalResults <- DataFeed.json$totalResults
DataFeed.json.totalsForAllResults.visits <- DataFeed.json$totalsForAllResults$`ga:visits`
DataFeed.json.totalsForAllResults.bounces <- DataFeed.json$totalsForAllResults$`ga:bounces`


ga.source  <- c("(direct)",
                "Tatvic Newsletter",
                "analytics.blogspot.com",
                "analytics.blogspot.in")
				  
ga.medium  <- c("(none)","email","referral","referral")

ga.visits  <- c(27,1,2,1)

ga.bounces <- c(17,1,0,0)
test.data  <- data.frame(ga.source, ga.medium, ga.visits, ga.bounces,
                           stringsAsFactors = FALSE)
						   
names(test.data) <- c("source", "medium", "visits", "bounces")




# Testing the $total.results is as expected.
  
  test.total.results <- 28
  checkEquals(test.total.results, as.numeric(DataFeed.json.totalResults))

# Testing aggr.totals match
  
  ga.visits <- 148
  ga.bounces <- 94
  
  test.aggr.totals <- as.data.frame(rbind(ga.visits, ga.bounces))
  names(test.aggr.totals) <- "aggregate.totals"
  rownames(test.aggr.totals) <- c("ga:visits", "ga:bounces")

  
 
  
  json.aggr.totals <- as.data.frame(rbind(as.numeric(DataFeed.json.totalsForAllResults.visits), as.numeric(DataFeed.json.totalsForAllResults.bounces)))
  names(json.aggr.totals) <- "aggregate.totals"
  rownames(json.aggr.totals) <- c("ga:visits", "ga:bounces")

  
  
  checkEquals(test.aggr.totals, json.aggr.totals)

}


DataFeedJSONString <- function(){
return('{\"kind\":\"analytics#gaData\",\"id\":\"https://www.googleapis.com/analytics/v3/data/ga?ids=ga:10696290&dimensions=ga:source,ga:medium&metrics=ga:visits,ga:bounces&start-date=2013-01-03&end-date=2013-01-03&start-index=1&max-results=4\",\"query\":{\"start-date\":\"2013-01-03\",\"end-date\":\"2013-01-03\",\"ids\":\"ga:10696290\",\"dimensions\":\"ga:source,ga:medium\",\"metrics\":[\"ga:visits\",\"ga:bounces\"],\"start-index\":1,\"max-results\":4},\"itemsPerPage\":4,\"totalResults\":28,\"selfLink\":\"https://www.googleapis.com/analytics/v3/data/ga?ids=ga:10696290&dimensions=ga:source,ga:medium&metrics=ga:visits,ga:bounces&start-date=2013-01-03&end-date=2013-01-03&start-index=1&max-results=4\",\"nextLink\":\"https://www.googleapis.com/analytics/v3/data/ga?ids=ga:10696290&dimensions=ga:source,ga:medium&metrics=ga:visits,ga:bounces&start-date=2013-01-03&end-date=2013-01-03&start-index=5&max-results=4\",\"profileInfo\":{\"profileId\":\"10696290\",\"accountId\":\"5306665\",\"webPropertyId\":\"UA-5306665-1\",\"internalWebPropertyId\":\"10240597\",\"profileName\":\"tatvic.com\",\"tableId\":\"ga:10696290\"},\"containsSampledData\":false,\"columnHeaders\":[{\"name\":\"ga:source\",\"columnType\":\"DIMENSION\",\"dataType\":\"STRING\"},{\"name\":\"ga:medium\",\"columnType\":\"DIMENSION\",\"dataType\":\"STRING\"},{\"name\":\"ga:visits\",\"columnType\":\"METRIC\",\"dataType\":\"INTEGER\"},{\"name\":\"ga:bounces\",\"columnType\":\"METRIC\",\"dataType\":\"INTEGER\"}],\"totalsForAllResults\":{\"ga:visits\":\"148\",\"ga:bounces\":\"94\"},\"rows\":[[\"(direct)\",\"(none)\",\"27\",\"17\"],[\"Tatvic Newsletter\",\"email\",\"1\",\"1\"],[\"analytics.blogspot.com\",\"referral\",\"2\",\"0\"],[\"analytics.blogspot.in\",\"referral\",\"1\",\"0\"]]}')
}
