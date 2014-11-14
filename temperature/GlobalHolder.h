//
//  GlobalHolder.h
//  temperature
//
//  Created by Zzy on 11/14/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalHolder : NSObject

@property (copy, nonatomic) NSString *city;

@property (strong, nonatomic, readonly) UIColor *ballColdColor;
@property (strong, nonatomic, readonly) UIColor *ballWarmColor;
@property (strong, nonatomic, readonly) UIColor *backgroundColdColor;
@property (strong, nonatomic, readonly) UIColor *backgroundWarmColor;

+ (GlobalHolder *)sharedSingleton;

@end
