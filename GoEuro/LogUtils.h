//
//  LogUtils.h
//  SF90
//
//  Created by alina on 8/8/15.
//  Copyright (c) 2015 kobayashi porcelain. All rights reserved.
//

#import <Foundation/Foundation.h>

//This file contains log methods

//print a formatted string to the standard output
void NSPrint(NSString *format, ...);

//Print an NSException object to the standard output
void logNSException(NSException* exc);