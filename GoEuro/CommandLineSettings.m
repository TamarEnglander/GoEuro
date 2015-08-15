//
//  PNCommandLineSettings.m
//  CommandLineSettings
//
//  Created by IdanM on 4/13/14.
//  Copyright (c) 2014 IdanM. All rights reserved.
//

#import "CommandLineSettings.h"
#import "LogUtils.h"

//This class search the program arguments for parameters of the format:
//-[key name]=[value]
//These parameters are strored in a dictionary and can be extracted by their key.
//The class is a singleton 
@implementation GNCommandLineSettings
{
    NSMutableDictionary* m_argsDict;
    NSString* m_originalCmdLine;
}

#pragma mark Singleton implementation

static GNCommandLineSettings* g_instance = nil;
static dispatch_once_t g_onceInstance = 0;
static dispatch_once_t g_cmdonceInit = 0;

+ (GNCommandLineSettings*)instance
{
    dispatch_once(&g_onceInstance, ^{
        g_instance = [[GNCommandLineSettings alloc] init];
    });
    return g_instance;
}

+ (void)terminate
{
    if (g_onceInstance)
    {
#if !__has_feature(objc_arc)
        [g_instance release];
#endif
        g_instance = nil;
        g_onceInstance = 0;
    }
}

#pragma mark -

+ (NSString*)trimArgIfNeeded:(NSString*)origString
{
    // Characters to be trimmed: single-quotation('); double-quotation("); backslash(\); newlines/spaces.
    static NSMutableCharacterSet* s_charsToTrim = nil;
    if (s_charsToTrim == nil)
    {
        s_charsToTrim = [[NSCharacterSet characterSetWithCharactersInString:@"\'\"\\"] mutableCopy]; // NOTE: intentionally not released
        [s_charsToTrim formUnionWithCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    NSString* trimmedString = [origString stringByTrimmingCharactersInSet:s_charsToTrim];
    return trimmedString;
}

-(id)init
{
    if(self = [super init])
    {
        @try
        {
            dispatch_once(&g_cmdonceInit, ^{
                NSArray *arguments = [[NSProcessInfo processInfo] arguments];
                
                //if(arguments.count < 2)
                //        return nil;
                
                m_argsDict = [[NSMutableDictionary alloc] init];
                
                NSMutableArray *args = [arguments mutableCopy];
                [args removeObjectAtIndex:0]; // remove exe path
                m_originalCmdLine = ([args count] ? [args componentsJoinedByString:@" "] : @"");
                
                NSInteger skip = 0;
                for(NSString *arg in args)
                {
                    if(skip > 0 && ((NSInteger)[arguments indexOfObject:arg]) == skip)
                    {
                        continue;
                    }
                    else
                    {
                        if([arg rangeOfString:@"-"].location == 0)
                        {
                            NSString *tmpArg = [arg substringFromIndex:(1)];
                            NSRange tmpEqRange = [tmpArg rangeOfString:@"="];
                            if(tmpEqRange.location != NSNotFound)
                            {
                                //switch contains value..
                                NSString* key = [tmpArg substringToIndex:tmpEqRange.location];
                                NSString* value = [tmpArg substringFromIndex:(tmpEqRange.location + 1)];
                                value = [[self class] trimArgIfNeeded:value];
                                key = [key lowercaseString];
                                [m_argsDict setObject:value forKey:key];
                            }
                            else
                            {
                                //switch is boolean
                                tmpArg = [tmpArg lowercaseString];
                            }
                        }
                    }
                }
                
                NSLog(@"ARGS Dictionary: %@", m_argsDict);
            });
        }
        @catch (NSException* e)
        {
            logNSException(e);
        }
        @catch(...)
        {
            NSLog(@"caught exception (...)");
        }
    }
    return self;
}

//get a command line value by the key of the format -[key name]=
-(NSString*)getValueByKey:(NSString*) sKey
{
    NSString* sValue;
    @try
    {
        sKey = [sKey lowercaseString];
        sValue = (NSString*)[m_argsDict objectForKey:sKey];
    }
    @catch (NSException *exception)
    {
        logNSException(exception);
    }
    @catch(...)
    {
        NSLog(@"caught exception (...)");
    }
    
    return sValue;
}


@end
