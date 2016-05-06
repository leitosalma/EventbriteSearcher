//
//  EVSManager.h
//  EventbriteSearcher
//
//  Created by Leonardo Salmaso on 5/4/16.
//  Copyright © 2016 Leonardo Salmaso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVSManager : NSObject
+ (nonnull instancetype)sharedInstance;

//Use inline block definition to show other way than I used in EVSApiHelper

- (void)searchEventsForQuery:(nonnull NSString *)query sinceDate:(nonnull NSDate *)sinceDate pageNumber:(int)pageNumber completionBlock:(nonnull void (^)(id _Nullable response, NSError* _Nullable error))completionBlock;

@end
