//
//  EVSLocationManager.h
//  EventbriteSearcher
//
//  Created by Leonardo Salmaso on 5/5/16.
//  Copyright © 2016 Leonardo Salmaso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface EVSLocationManager : NSObject <CLLocationManagerDelegate>

@property CLLocationCoordinate2D lastCoordinate;

+ (nonnull instancetype)sharedInstance;
- (BOOL)validatePermission;
- (void)startStandardTracking;
- (void)stopTracking;

@end
