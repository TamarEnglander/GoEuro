//
//  LogUtils.m
//  SF90
//
//  Created by alina on 8/8/15.
//  Copyright (c) 2015 kobayashi porcelain. All rights reserved.
//

#import "LogUtils.h"

void NSPrint(NSString *format, ...)
{
    va_list args;
    va_start(args, format);
    
    NSString *string = [[NSString alloc] initWithFormat:format arguments:args];
    
    va_end(args);
    
    fprintf(stdout, "%s\n", [string UTF8String]);
}


void logNSException(NSException* exc)
{
    if(exc != nil)
    {
        NSString* sErrReport = [NSString stringWithFormat:@"name: %@ reason: %@ user info: %@", [exc name], [exc reason], [exc userInfo]];
        NSPrint(sErrReport);
    }
}