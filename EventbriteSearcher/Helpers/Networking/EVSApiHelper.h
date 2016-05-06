//
//  EVSApiHelper.h
//  EventbriteSearcher
//
//  Created by Leonardo Salmaso on 5/4/16.
//  Copyright © 2016 Leonardo Salmaso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

//Blocks to response
typedef void (^CompletionBlock)(id _Nullable response, NSError* _Nullable error);

@interface EVSApiHelper : AFHTTPSessionManager

+ (nonnull instancetype)sharedInstance;

- (void)searchEventsForQuery:(nonnull NSString *)query sinceDate:(nonnull NSDate *)sinceDate nearToLatitude:(nullable NSString*)latitude nearToLongitude:(nullable NSString *)longitude pageNumber:(int)pageNumber  completionBlock:(nonnull CompletionBlock)completionBlock;

@end
