\name{GetProfileData}
\alias{GetProfileData}
\title{A function to convert the profile JSON into an R data...}
\usage{GetProfileData(profile=GetProfileData(access_token))}
\description{A function to convert the profile JSON into an R data.frame.
We have the raw JSON for a user profile from the GetProfilesFromJSON() function,
we clean this information and place into a human readable table in R
for consumption. We also allow the user to pass in a string JSON if
required for offline inspection.}
\value{A list of the processed JSON string comprising of the profile
as a data.frame and the number of accounts the profile has access to.}
\arguments{\item{profile}{The JSON string to be processed.}}
