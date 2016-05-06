//
//  EVSUtils.h
//  EventbriteSearcher
//
//  Created by Leonardo Salmaso on 5/4/16.
//  Copyright © 2016 Leonardo Salmaso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVSUtils : NSObject

+(NSString *)stringFormattedDate:(NSDate *)date;
+(NSDate *)dateFromServerSrting:(NSString *)date;

@end
