//
//  EVSManager.m
//  EventbriteSearcher
//
//  Created by Leonardo Salmaso on 5/4/16.
//  Copyright © 2016 Leonardo Salmaso. All rights reserved.
//

#import "EVSManager.h"
#import "EVSApiHelper.h"
#import "EVSLocationManager.h"
#import "EVSSearchResultDTO.h"
#import "EVSUtils.h"

@implementation EVSManager

+ (nonnull instancetype)sharedInstance {
    static EVSManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[EVSManager alloc] init];

    });
    
    return _sharedInstance;
}

- (void)searchEventsForQuery:(nonnull NSString *)query sinceDate:(nonnull NSDate *)sinceDate pageNumber:(int)pageNumber completionBlock:(nonnull void (^)(id _Nullable response, NSError* _Nullable error))completionBlock {
    
    NSString *latitude;
    NSString *longitude;
    
    if ([[EVSLocationManager sharedInstance] validatePermission]) {
        CLLocationCoordinate2D currentLocation = [EVSLocationManager sharedInstance].lastCoordinate;
        latitude = [NSString stringWithFormat:@"%f", currentLocation.latitude];
        longitude = [NSString stringWithFormat:@"%f", currentLocation.longitude];
    }
    
    [[EVSApiHelper sharedInstance] searchEventsForQuery:query sinceDate:sinceDate nearToLatitude:latitude nearToLongitude:longitude pageNumber:pageNumber completionBlock:^(NSDictionary *  _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            
            if (response[@"events"] != nil) {
            
            NSMutableArray *nearEvents = [[NSMutableArray alloc] initWithCapacity:0];
            
            for (NSDictionary *event in response[@"events"]) {
                EVSSearchResultDTO *dto = [[EVSSearchResultDTO alloc] init];
                
                if(![event[@"name"] isEqual:[NSNull null]] && ![event[@"name"][@"text"] isEqual:[NSNull null]]) {
                    dto.title = event[@"name"][@"text"];
                }
                
                if(![event[@"description"][@"html"] isEqual:[NSNull null]]) {
                    dto.detail = event[@"description"][@"html"];
                }
                
                //I could not find the name of the event place.
                dto.place = @"";
                
                if(![event[@"logo"] isEqual:[NSNull null]] && ![event[@"logo"][@"url"] isEqual:[NSNull null]]) {
                    
                    //To improve this I need to consider the aspect ratio
                    dto.imageUrl = event[@"logo"][@"url"];
                }
                
                if(![event[@"start"] isEqual:[NSNull null]] && ![event[@"start"][@"local"] isEqual:[NSNull null]]) {
                    
                    //Show date only in the local time
                    dto.date = [EVSUtils dateFromServerSrting:event[@"start"][@"local"]];
                }
                
                [nearEvents addObject:dto];
            }
            
            completionBlock(nearEvents, nil);
                
            } else if(response[@"error_description"] != nil) {
                NSDictionary *userInfo = [[NSMutableDictionary alloc] init];
                [userInfo setValue:response[@"error_description"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [[NSError alloc] initWithDomain:@"eventbriteSearcherSwift" code:900 userInfo:userInfo];
                completionBlock(nil, error);
            }
        } else {
            completionBlock(nil, error);
        }
        
    }];
}

@end
