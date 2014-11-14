//
//  GlobalHolder.m
//  temperature
//
//  Created by Zzy on 11/14/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import "GlobalHolder.h"

@interface GlobalHolder ()

@property (strong, nonatomic) UIColor *ballColdColor;
@property (strong, nonatomic) UIColor *ballWarmColor;
@property (strong, nonatomic) UIColor *backgroundColdColor;
@property (strong, nonatomic) UIColor *backgroundWarmColor;

@end

@implementation GlobalHolder

+ (GlobalHolder *)sharedSingleton {
    static GlobalHolder *sharedSingleton;
    @synchronized(self) {
        if (!sharedSingleton) {
            sharedSingleton = [[GlobalHolder alloc] init];
        }
        return sharedSingleton;
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.ballColdColor = [UIColor colorWithRed:88 / 255.0 green:164 / 255.0 blue:200 / 255.0 alpha:1];
        self.ballWarmColor = [UIColor colorWithRed:240 / 255.0 green:83 / 255.0 blue:68 / 255.0 alpha:1];
        self.backgroundColdColor = [UIColor colorWithRed:139 / 255.0 green:194 / 255.0 blue:215 / 255.0 alpha:1];
        self.backgroundWarmColor = [UIColor colorWithRed:244 / 255.0 green:113 / 255.0 blue:103 / 255.0 alpha:1];
    }
    return self;
}

@end
