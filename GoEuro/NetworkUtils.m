//
//  NetworkUtils.m
//  SF90
//
//  Created by alina on 8/8/15.
//  Copyright (c) 2015 kobayashi porcelain. All rights reserved.
//

#import "NetworkUtils.h"
#import "LogUtils.h"

@implementation NetworkUtils

//Downloading data stream and converting it to a data object
+(NSData*)dataStringFromURL: (NSString*)sURL
{
    NSData* dataFromFileAtURL = nil;
    
    if ( (sURL!=nil) && ([sURL length] > 0))
    {
        //this is basically done in order to url encode spaces stated in the search term...
        NSString *escapedSURL = [sURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        NSURL* url = [NSURL URLWithString:escapedSURL];
        NSDataReadingOptions readOp = 0;
        NSError* err = nil;
        NSData* urlData = [NSData dataWithContentsOfURL:url options:readOp error:&err];
        if (err == nil)
        {
            dataFromFileAtURL = urlData;
        }
    }
    
    return dataFromFileAtURL;
}



//get a data dictionary object from a url
+(NSString*)stringFromURL: (NSString*)sURL
{
    NSString* sDataOut = nil;
    BOOL bRet = YES;
    
    NSString* sData = nil;
    NSData* dataFromFileAtURL = [NetworkUtils dataStringFromURL:sURL];
    bRet = (dataFromFileAtURL != nil) ? YES : NO;
    if(bRet == YES)
    {
        sData = [[NSString alloc] initWithData:dataFromFileAtURL encoding:NSUTF8StringEncoding];
        bRet = (sData != nil) ? YES : NO;
    }
    if(bRet == YES)
    {
        sDataOut = sData;
    }
    return sDataOut;
}


//get a data dictionary object from a url
+(NSArray*)dictionaryArrayFromURL: (NSString*)sURL
{
    NSArray* dataDictionaryOut = nil;
    BOOL bRet = YES;
    
    NSArray* dataDictionary = nil;
    NSData* dataFromFileAtURL = [NetworkUtils dataStringFromURL:sURL];
    bRet = (dataFromFileAtURL != nil) ? YES : NO;
    if(bRet == YES)
    {
        @try
        {
            NSError *jsonError;
            dataDictionary = [NSJSONSerialization JSONObjectWithData:dataFromFileAtURL
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
        }
        @catch(NSException* exc)
        {
            logNSException(exc);
        }

        bRet = (dataDictionary != nil) ? YES : NO;
    }
    if(bRet == YES)
    {
        dataDictionaryOut = dataDictionary;
    }
    
    return dataDictionaryOut;
}

@end
