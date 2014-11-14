//
//  LocationService.h
//  ardenne
//
//  Created by Zzy on 8/13/14.
//  Copyright (c) 2014 Duobei Brothers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef void (^LocationBlock)(CLLocation *location);

@interface LocationService : NSObject

+ (LocationService *)sharedSingleton;

- (void)getCurrentLocationWithBlock:(LocationBlock)block;
- (void)getCurrentLocationWithDistance:(CLLocationDistance)distance Block:(LocationBlock)block;

@end
