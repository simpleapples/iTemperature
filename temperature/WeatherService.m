//
//  WeatherService.m
//  temperature
//
//  Created by Zzy on 11/14/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import "WeatherService.h"
#import "AFNetworking.h"

@implementation WeatherService

+ (WeatherService *)sharedSingleton {
    static WeatherService *sharedSingleton;
    @synchronized(self) {
        if (!sharedSingleton) {
            sharedSingleton = [[WeatherService alloc] init];
        }
        return sharedSingleton;
    }
}

- (instancetype)init {
    self = [super init];
    return self;
}

- (void)getCurrentTemperatureByCityName:(NSString *)cityName block:(TemperatureBlock)block {
    
}

- (void)getCurrentTemperatureByLatitue:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude block:(TemperatureBlock)block {
    NSString *url = [[NSString alloc] initWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f", latitude, longitude];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject objectForKey:@"main"] && [[responseObject objectForKey:@"main"] objectForKey:@"temp"]) {
            if (block) {
                CGFloat temperature = [[[responseObject objectForKey:@"main"] objectForKey:@"temp"] doubleValue] - 273.15;
                block(YES, temperature);
            }
        } else if (block) {
            block(NO, 0);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(NO, 0);
        }
    }];
}

@end
