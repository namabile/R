\name{GetProfilesFromJSON}

\alias{GetProfilesFromJSON}

\title{A function to convert the profile JSON into an R dataframe}

\usage{profiles <- GetProfilesFromJSON(api.response.json)}

\description{This function will do the parsing operation on the JSON reponse 
             returned from the Google Management API and return the dataframe
			 stored with the profile id and prfile name.
             We also allow the user to pass in a string JSON if required for offline inspection.}

\value{A list of the processed JSON string comprising of the profile
as a data.frame and the number of accounts the profile has access to.}

\arguments{\item{api.response.json}{The JSON string to be processed.}}
