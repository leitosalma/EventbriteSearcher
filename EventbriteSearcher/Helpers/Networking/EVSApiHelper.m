//
//  EVSApiHelper.m
//  EventbriteSearcher
//
//  Created by Leonardo Salmaso on 5/4/16.
//  Copyright © 2016 Leonardo Salmaso. All rights reserved.
//

#import "EVSApiHelper.h"
#import "EVSUtils.h"

@implementation EVSApiHelper

static NSString * const kBaseUrl = @"https://www.eventbriteapi.com/";
static NSString * const kEventSearch = @"v3/events/search";

//session configuration constants
const int kRequestTimeOut = 90;

+ (nonnull instancetype)sharedInstance {
    static EVSApiHelper *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //Session configuration setup
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024     // 10MB. memory cache
                                                          diskCapacity:50 * 1024 * 1024     // 50MB. on disk cache
                                                              diskPath:nil];
        
        sessionConfiguration.URLCache = cache;
        sessionConfiguration.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
        sessionConfiguration.timeoutIntervalForRequest = kRequestTimeOut;
        
        _sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl] sessionConfiguration:sessionConfiguration];
        
        _sharedInstance.requestSerializer = [AFJSONRequestSerializer serializer];
        
        //Use hardcode oatuh token to test the app - NOT WORKING! :S
        
//        [_sharedInstance.requestSerializer setValue:@"Bearer TE2TQUT463S6XXJXMVLM" forHTTPHeaderField:@"Authorization"];
        
        _sharedInstance.responseSerializer = [AFJSONResponseSerializer serializer];
        
        
    });
    
    return _sharedInstance;
}

- (void)searchEventsForQuery:(nonnull NSString *)query sinceDate:(nonnull NSDate *)sinceDate nearToLatitude:(nullable NSString*)latitude nearToLongitude:(nullable NSString *)longitude pageNumber:(int)pageNumber  completionBlock:(nonnull CompletionBlock)completionBlock {
    
    NSMutableDictionary *requestParameter = [self defaultParameters];
    [requestParameter setObject:query forKey:@"q"];
    [requestParameter setObject:[NSString stringWithFormat:@"%d", pageNumber] forKey:@"page"];
    [requestParameter setObject:@"date" forKey:@"sort_by"];
    [requestParameter setObject:[EVSUtils stringFormattedDate:sinceDate] forKey:@"start_date.range_start"];
    
    
    if (latitude != nil) {
        [requestParameter setObject:latitude forKey:@"location.latitude"];
    }
    
    if (longitude != nil) {
        [requestParameter setObject:longitude forKey:@"location.longitude"];
    }
    
    [self GET:kEventSearch parameters:requestParameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionBlock(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionBlock(nil, error);
    }];
}

- (NSMutableDictionary *)defaultParameters {
    NSMutableDictionary *requestParameter = [[NSMutableDictionary alloc] initWithCapacity:1];
    [requestParameter setObject:@"TE2TQUT463S6XXJXMVLM" forKey:@"token"];
    
    return requestParameter;
}

@end
