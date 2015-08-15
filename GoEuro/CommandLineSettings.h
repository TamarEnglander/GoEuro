//
//  PNCommandLineSettings.h
//  CommandLineSettings
//
//  Created by IdanM on 4/13/14.
//  Copyright (c) 2014 IdanM. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GN_CMD_LINE_SETTINGS_INSTANCE   [GNCommandLineSettings instance]
#define GN_CMD_LINE_SETTINGS_TERMINATE   [GNCommandLineSettings terminate]

@interface GNCommandLineSettings : NSObject

+ (GNCommandLineSettings*)instance;
+ (void)terminate;

//get a command line value by the key of the format -[key name]=
-(NSString*)getValueByKey:(NSString*) sKey;

//return the original command line switches (as received from argv)
-(NSString*)toStringBySwitchOrderOriginal;

@end
