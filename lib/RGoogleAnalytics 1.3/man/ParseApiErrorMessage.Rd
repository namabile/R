\name{ParseApiErrorMessage}
\alias{ParseApiErrorMessage}
\title{To check whether the returned JSON response is error or not...}
\usage{ParseApiErrorMessage}
\description{
If it is error then it will intterupt the process and prompt with the related error code and message. 
We also allow the user to pass in a string JSON if required for offline inspection.}
\value{List which contains the response data in list and the error code value if it is null 
                     then there is no error otherwise it will return a error message and stop the programm 
					  will be stopped.}
\arguments{\item{api.response.json}{The JSON string to be processed.}}
