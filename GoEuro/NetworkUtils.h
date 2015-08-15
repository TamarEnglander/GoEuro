//
//  NetworkUtils.h
//  SF90
//
//  Created by alina on 8/8/15.
//  Copyright (c) 2015 kobayashi porcelain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkUtils : NSObject


//Downloading data stream and converting it to a data object
+(NSData*)dataStringFromURL: (NSString*)sURL;

//get a data dictionary object from a url
+(NSArray*)dictionaryArrayFromURL: (NSString*)sURL;

@end

