//
//  LocationService.m
//  ardenne
//
//  Created by Zzy on 8/13/14.
//  Copyright (c) 2014 Duobei Brothers. All rights reserved.
//

#import "LocationService.h"

@interface LocationService ()<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *manager;
@property (strong, nonatomic) LocationBlock block;
@end

@implementation LocationService

+ (LocationService *)sharedSingleton {
    static LocationService *sharedSingleton;
    @synchronized(self) {
        if (!sharedSingleton) {
            sharedSingleton = [[LocationService alloc] init];
        }
        return sharedSingleton;
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.manager = [[CLLocationManager alloc] init];
        self.manager.delegate = self;
    }
    return self;
}

- (void)getCurrentLocationWithBlock:(LocationBlock)block {
    [self.manager stopUpdatingLocation];
    self.block = block;
    if (IS_OS_8_OR_LATER) {
        [self.manager requestWhenInUseAuthorization];
    }
    self.manager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.manager startUpdatingLocation];
}

- (void)getCurrentLocationWithDistance:(CLLocationDistance)distance Block:(LocationBlock)block {
    [self.manager stopUpdatingLocation];
    self.block = block;
    if (IS_OS_8_OR_LATER) {
        [self.manager requestWhenInUseAuthorization];
    }
    self.manager.desiredAccuracy = kCLLocationAccuracyBest;
    self.manager.distanceFilter = distance;
    [self.manager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self.manager stopUpdatingLocation];
    if (self.block) {
        self.block([locations lastObject]);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.manager stopUpdatingLocation];
    if (self.block) {
        self.block(nil);
    }
}

@end
