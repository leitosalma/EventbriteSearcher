//
//  EVSUtils.m
//  EventbriteSearcher
//
//  Created by Leonardo Salmaso on 5/4/16.
//  Copyright © 2016 Leonardo Salmaso. All rights reserved.
//

#import "EVSUtils.h"

@implementation EVSUtils

static NSString *defaultServerDateFormat = @"yyyy-MM-dd'T'hh:mm:ss";

+(NSString *)stringFormattedDate:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:defaultServerDateFormat];
    NSString *iso8601String = [dateFormatter stringFromDate:date];
    
    return iso8601String;
}

+(NSDate *)dateFromServerSrting:(NSString *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setDateFormat:defaultServerDateFormat];
    [dateFormatter setTimeZone:gmt];
    
    NSDate *newDate = [dateFormatter dateFromString:date];
    
    return newDate;
}

@end
