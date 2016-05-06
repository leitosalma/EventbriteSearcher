//
//  EVSLocationManager.m
//  EventbriteSearcher
//
//  Created by Leonardo Salmaso on 5/5/16.
//  Copyright © 2016 Leonardo Salmaso. All rights reserved.
//

#import "EVSLocationManager.h"

@interface EVSLocationManager()

@property (nullable, strong, nonatomic) CLLocationManager *manager;
@property (nullable, strong, nonatomic) NSDate *lastUpdate;
@property (nonatomic) BOOL tracking;


@end

@implementation EVSLocationManager

+ (nonnull instancetype)sharedInstance {
    static EVSLocationManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[EVSLocationManager alloc] init];
        _sharedInstance.manager = [[CLLocationManager alloc] init];
        _sharedInstance.manager.delegate = _sharedInstance;
        
        _sharedInstance.manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _sharedInstance.manager.distanceFilter = 25;
    });
    
    return _sharedInstance;
}

- (BOOL)validatePermission {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        return NO;
    } else if (status == kCLAuthorizationStatusNotDetermined) {
        [self.manager requestWhenInUseAuthorization];
        return NO;
    } else {
        return YES;
    }
}

#pragma mark CLLocationManagerDelegate

- (void)startStandardTracking {
    if ([self validatePermission]) {
        [self.manager startUpdatingLocation];
        [self.manager stopMonitoringSignificantLocationChanges];
    }
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    self.tracking = status != kCLAuthorizationStatusDenied && status != kCLAuthorizationStatusRestricted;
}

- (void)stopTracking {
    [self.manager stopUpdatingLocation];
    [self.manager stopMonitoringSignificantLocationChanges];
    self.tracking = false;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error.localizedDescription);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self updateLocationInBackground:locations.lastObject.coordinate];
}

- (void)updateLocationInBackground:(CLLocationCoordinate2D)coordinate {
    if (self.lastUpdate && self.lastUpdate.timeIntervalSinceNow > -10) {
        return;
    }
    
    self.lastUpdate = [NSDate date];
    
    NSLog(@"%f %f", coordinate.latitude, coordinate.longitude);
    self.lastCoordinate = coordinate;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status != kCLAuthorizationStatusDenied && status != kCLAuthorizationStatusRestricted) {
        if (self.tracking) {
            [self startStandardTracking];
        }
    }
}


@end
