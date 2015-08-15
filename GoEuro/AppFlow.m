//
//  AppFlow.m
//  GoEuro
//
//  Created by alina on 8/9/15.
//  Copyright (c) 2015 kobayashi porcelain. All rights reserved.
//

#import "AppFlow.h"
#import "strings.h"
#import "NetworkUtils.h"
#import "LogUtils.h"
#import "CommandLineSettings.h"
#import "MacroUtils.h"

@implementation AppFlow

//get an array of data out of a keyword string
+(NSArray*)getDataByKeyword:(NSString*)sKeyword
{
    NSArray* dataDictionary = nil;
    
    //search term has been successfully extracted.
    NSString* sQueryURL = QUERY_URL;
    
    //1. build the query url by replacing the placeholder with the query string...
    sQueryURL = [sQueryURL stringByReplacingOccurrencesOfString:QUERY_STRING_PLACEHOLDER withString:sKeyword];
    
    //2. get a dictionary out of the response data...
    dataDictionary = [NetworkUtils dictionaryArrayFromURL:sQueryURL];
    return dataDictionary;
}

//build a CSV file format string out of an array of dictionaries
+(NSString*)getCSVFileContentFromData:(NSArray*)dataDictionary
{
    NSString* sCSVFileRet = @"";
    NSMutableString* sCSVFile = @"";
    //The JSON dictionary has been successfully extracted - convert to a csv file format.
    sCSVFile = [NSMutableString stringWithString:CSV_HEADERS];
    
    //traverse the dictionaries array...
    for(int i = 0; i < [dataDictionary count]; i++)
    {
        //get the current dictionary in the array
        NSDictionary* currDictionary = dataDictionary[i];
        
        //define a single row string of the CSV file
        NSString* sCurrentRow = @"";
        
        //Extract each item in the dictionary. If the extracted item string is nil set it to an empty string. Update the current row woth the value.
        NSString* sID = [currDictionary objectForKey:@"_id"];
        sID = EMPTY_STRING_IF_NIL_STRING(sID);
        
        sCurrentRow = [sCurrentRow stringByAppendingFormat:@"\"%@\",", sID];
        
        NSString* sCoreCountry = [currDictionary objectForKey:@"coreCountry"];
        sCoreCountry = EMPTY_STRING_IF_NIL_STRING(sCoreCountry);
        sCurrentRow = [sCurrentRow stringByAppendingFormat:@"\"%@\",", sCoreCountry];
        
        NSString* sCountry = [currDictionary objectForKey:@"country"];
        sCountry = EMPTY_STRING_IF_NIL_STRING(sCountry);
        sCurrentRow = [sCurrentRow stringByAppendingFormat:@"\"%@\",", sCountry];
        
        NSString* sCountryCode = [currDictionary objectForKey:@"countryCode"];
        sCountryCode = EMPTY_STRING_IF_NIL_STRING(sCountryCode);
        sCurrentRow = [sCurrentRow stringByAppendingFormat:@"\"%@\",", sCountryCode];
        
        NSString* sDistance = [currDictionary objectForKey:@"distance"];
        sDistance = EMPTY_STRING_IF_NIL_STRING(sDistance);
        sCurrentRow = [sCurrentRow stringByAppendingFormat:@"%@,", sDistance];
        
        NSString* sFullName = [currDictionary objectForKey:@"fullName"];
        sFullName = EMPTY_STRING_IF_NIL_STRING(sFullName);
        sCurrentRow = [sCurrentRow stringByAppendingFormat:@"\"%@\",", sFullName];
        
        NSString* sLatitude = @"";
        NSString* sLongitude = @"";
        NSDictionary* geo_positionDictionary = [currDictionary objectForKey:@"geo_position"];
        
        if(IS_NIL_DICTIONARY(geo_positionDictionary) == NO &&  IS_EMPTY_DICTIONARY(geo_positionDictionary) == NO)
        {
            //the geo position dictionary is valid - get the latitude and longitude values...
            sLatitude = [geo_positionDictionary objectForKey:@"latitude"];
            sLongitude = [geo_positionDictionary objectForKey:@"longitude"];
        }
        
        sLatitude = EMPTY_STRING_IF_NIL_STRING(sLatitude);
        sCurrentRow = [sCurrentRow stringByAppendingFormat:@"\"%@\",", sLatitude];
        
        sLongitude = EMPTY_STRING_IF_NIL_STRING(sLongitude);
        sCurrentRow = [sCurrentRow stringByAppendingFormat:@"\"%@\",", sLongitude];
        
        NSString* sIATA_airport_code = [currDictionary objectForKey:@"iata_airport_code"];
        sIATA_airport_code = EMPTY_STRING_IF_NIL_STRING(sIATA_airport_code);
        sCurrentRow = [sCurrentRow stringByAppendingFormat:@"\"%@\",", sIATA_airport_code];
        
        NSString* sInEurope = [currDictionary objectForKey:@"inEurope"];
        sInEurope = EMPTY_STRING_IF_NIL_STRING(sInEurope);
        sCurrentRow = [sCurrentRow stringByAppendingFormat:@"\"%@\",", sInEurope];
        
        NSString* sKey = [currDictionary objectForKey:@"key"];
        sKey = EMPTY_STRING_IF_NIL_STRING(sKey);
        sCurrentRow = [sCurrentRow stringByAppendingFormat:@"\"%@\",", sKey];
        
        NSString* sLocationId = [currDictionary objectForKey:@"locationId"];
        sLocationId = EMPTY_STRING_IF_NIL_STRING(sLocationId);
        sCurrentRow = [sCurrentRow stringByAppendingFormat:@"\"%@\",", sLocationId];
        
        NSString* sName = [currDictionary objectForKey:@"name"];
        sName = EMPTY_STRING_IF_NIL_STRING(sName);
        sCurrentRow = [sCurrentRow stringByAppendingFormat:@"\"%@\",", sName];
        
        NSString* sType = [currDictionary objectForKey:@"type"];
        sType = EMPTY_STRING_IF_NIL_STRING(sType);
        sCurrentRow = [sCurrentRow stringByAppendingFormat:@"\"%@\",", sType];
        
        [sCSVFile appendFormat:@"\n%@", sCurrentRow];
    }
    
    sCSVFileRet = sCSVFile;
    
    return sCSVFileRet;
}

//execute the application flow
+(BOOL)execute
{
    BOOL bRet = YES;
    NSString* sOutputMessage = @"";
    
    NSString *sOutputFileName = @"output.csv";
    
    NSError *error;
    
    NSArray* dataDictionary = nil;
    //1. Get the search term value from the command line arguments.
    NSString* sSearchTermValue = [GN_CMD_LINE_SETTINGS_INSTANCE getValueByKey:@"searchterm"];
    
    NSString* sCSVFile = @"";
    bRet = (sSearchTermValue != nil && [sSearchTermValue isNotEqualTo:@""] == YES) ? YES : NO;
    if(bRet == YES)
    {
        //2. Search term has been successfully extracted - get the corresponding data regarding the search term from the URL request.
        dataDictionary = [AppFlow getDataByKeyword:sSearchTermValue];
        bRet = (dataDictionary != nil && ([dataDictionary count] > 0) == YES) ? YES : NO;
        if(bRet == NO)
        {
            //no data is generated...
            sOutputMessage = [NSString stringWithFormat:NO_DATA_FOUND, sSearchTermValue];
        }
    }
    else
    {
        //no valid command line is stated - display usage
        sOutputMessage = HELP_USAGE;
    }
    if(bRet == YES)
    {
        //3. create a CSV format string out of the data structure
        sCSVFile = [self getCSVFileContentFromData:dataDictionary];
        
        bRet = (IS_EMPTY_STRING(sCSVFile) == NO) ? YES : NO;
        if(bRet == NO)
        {
            //we shouldn't be here!!!
            sOutputMessage = NO_CSV_FILE_CONTENT;
        }
    }
    if(bRet == TRUE)
    {
        //4. write the CSV string to a file: output.csv
        bRet = [sCSVFile writeToFile:sOutputFileName atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if(bRet == NO)
        {
            sOutputMessage = [NSString stringWithFormat:ERROR_WRITING_FILE, [error localizedDescription], sOutputFileName];
        }
    }
    if(bRet == TRUE)
    {
        sOutputMessage = SUCCESS_MESSAGE;
    }
    
    //Display the message...
    sOutputMessage = EMPTY_STRING_IF_NIL_STRING(sOutputMessage);
    if(IS_EMPTY_STRING(sOutputMessage) == NO)
    {
        NSPrint(sOutputMessage);
    }

    return bRet;
}

@end
