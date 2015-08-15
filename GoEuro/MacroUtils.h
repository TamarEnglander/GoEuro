//
//  MacroUtils.h
//  GoEuro
//
//  Created by alina on 8/9/15.
//  Copyright (c) 2015 kobayashi porcelain. All rights reserved.
//

#ifndef GoEuro_MacroUtils_h
#define GoEuro_MacroUtils_h


#endif

#define EMPTY_STRING_IF_NIL_STRING(stringObj)    (stringObj ?: @"")                                      //if string is nil return an empty string
#define EMPTY_NSDATA_IF_NIL(object)              (object ?: [NSData data])                               //if object is nil return NSNull
#define EMPTY_STRING_IF_NIL_OBJECT(object)       (object ?: @"")                                         //if string is nil return an empty string

// checking if exists and has non-null length
#define IS_EMPTY_STRING(stringObj)           (([stringObj length] == 0) ? YES : NO)      // NSString
#define IS_EMPTY_DATA(dataObj)               (([dataObj length] == 0) ? YES : NO)        // NSData
#define IS_EMPTY_ARRAY(arrayObj)             (([arrayObj count] == 0) ? YES : NO)        // NSArray
#define IS_EMPTY_DICTIONARY(dictionaryObj)   (([dictionaryObj count] == 0) ? YES : NO)   // NSDictionary
#define IS_NIL_DICTIONARY(dictionaryObj)     (dictionaryObj == nil ? YES : NO)           // NSDictionary