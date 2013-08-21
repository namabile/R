\name{ParseDataFeedJSON}
\alias{ParseDataFeedJSON}
\title{A function to request to the Google Management API with the Query string prepared by the QueryBuilder class}
\usage{ParseDataFeedJSON}
\description{This function will parse the json response and checks whether the reponse is errror,
             if any error found it will promt user with the related error message. We also allow the user to pass in a string JSON if
required for offline inspection.}
\value{A JSON respone returned from the Google Management API }
\arguments{\item{query.uri}{The query string to fire at the Google Management API which includes the access_token.}}
