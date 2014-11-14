//
//  WeatherService.h
//  temperature
//
//  Created by Zzy on 11/14/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^TemperatureBlock)(BOOL success, CGFloat temperature);

@interface WeatherService : NSObject

+ (WeatherService *)sharedSingleton;

- (void)getCurrentTemperatureByLatitue:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude block:(TemperatureBlock)block;
- (void)getCurrentTemperatureByCityName:(NSString *)cityName block:(TemperatureBlock)block;

@end
