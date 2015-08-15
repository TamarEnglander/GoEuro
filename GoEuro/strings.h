//
//  strings.h
//  SF90
//
//  Created by alina on 8/8/15.
//  Copyright (c) 2015 kobayashi porcelain. All rights reserved.
//

#ifndef SF90_strings_h
#define SF90_strings_h

#define QUERY_STRING_ARGUMENT       @"search_term"
#define QUERY_STRING_PLACEHOLDER    @"{search_term}"
#define QUERY_URL                   @"http://api.goeuro.com/api/v2/position/suggest/en/{search_term}"
#define HELP_USAGE                  @"usage: GoEuro -searchterm=<search expression>"
#define NO_DATA_FOUND               @"No data was found for: %@"
#define ERROR_WRITING_FILE          @"Error %@ while writing to file %@"
#define NO_CSV_FILE_CONTENT         @"CSV file content could not be generated"
#define SUCCESS_MESSAGE             @"SUCCESS!!!"

#define CSV_HEADERS                 @"ID, Core Country, Country, Country Code, Distance, Full Name, Latitude, Longitude, IATA Airport Code, In Europe, Key, Location ID, Name, Type"

//The location properties strings array - NOTE: the properties must correspond to the CSV_HEADERS string in both size and order.
#define LOCATION_PROPERTIES         @[@"_id", @"coreCountry", @"country", @"countryCode", @"distance", @"fullName", @"latitude", @"longitude", @"\"iata_airport_code\"", @"inEurope", @"key", @"locationId", @"name", @"type" ];

#endif
