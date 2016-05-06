//
//  EVSSearchResultDTO.h
//  EventbriteSearcher
//
//  Created by Leonardo Salmaso on 5/4/16.
//  Copyright © 2016 Leonardo Salmaso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVSSearchResultDTO : NSObject

@property (nullable, strong, nonatomic) NSString *title;
@property (nullable, strong, nonatomic) NSString *place;
@property (nullable, strong, nonatomic) NSString *detail;
@property (nullable, strong, nonatomic) NSString *imageUrl;
@property (nullable, strong, nonatomic) NSDate *date;
@property (nullable, strong, nonatomic) NSMutableArray *tags;

@end
