//
//  MainViewController.m
//  temperature
//
//  Created by Zzy on 11/14/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import "MainViewController.h"
#import "WeatherService.h"
#import "LocationService.h"
#import "GlobalHolder.h"
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *ballImageView;
@property (weak, nonatomic) IBOutlet UIView *cylinderView;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cylinderViewHeight;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startCaptureVideo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.activityIndicator.hidden = NO;
    [[LocationService sharedSingleton] getCurrentLocationWithBlock:^(CLLocation *location) {
        CLGeocoder *clGeoCoder=[[CLGeocoder alloc] init];
        [clGeoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            if (!error && placemarks) {
                CLPlacemark *placeMark = [placemarks objectAtIndex:0];
                NSDictionary *addressDic = placeMark.addressDictionary;
                NSString *city = [addressDic objectForKey:@"City"];
                [GlobalHolder sharedSingleton].city = city;
                [[GlobalHolder sharedSingleton] backupToLocal];
            }
        }];
        [[WeatherService sharedSingleton] getCurrentTemperatureByLatitue:location.coordinate.latitude longitude:location.coordinate.longitude block:^(BOOL success, CGFloat temperature) {
            if (success) {
                self.temperatureLabel.text = [NSString stringWithFormat:@"%ld°", (long)temperature];
                if (temperature < -30) {
                    temperature = -30;
                } else if (temperature > 50) {
                    temperature = 50;
                }
                CGFloat height = 3.3 * (temperature + 30) + 22;
                [UIView animateWithDuration:0.6 animations:^{
                    self.cylinderView.frame = CGRectMake(self.cylinderView.frame.origin.x, self.ballImageView.frame.origin.y - height + 22, self.cylinderView.frame.size.width, height);
                    self.cylinderViewHeight.constant = height;
                }];
                UIColor *backgroundColor = [GlobalHolder sharedSingleton].backgroundColdColor;
                UIColor *cylinderColor = [GlobalHolder sharedSingleton].ballColdColor;
                if (temperature > 15) {
                    backgroundColor = [GlobalHolder sharedSingleton].backgroundWarmColor;
                    cylinderColor = [GlobalHolder sharedSingleton].ballWarmColor;
                    [self.ballImageView setImage:[UIImage imageNamed:@"BackgroundBallWarm"]];
                } else {
                    [self.ballImageView setImage:[UIImage imageNamed:@"BackgroundBallCold"]];
                }
                self.backgroundView.backgroundColor = backgroundColor;
                self.cylinderView.backgroundColor = cylinderColor;
                self.activityIndicator.hidden = YES;
            }
        }];
    }];
}

- (void)startCaptureVideo {
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
    AVCaptureDevice* camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    captureVideoPreviewLayer.frame = CGRectMake((self.cameraView.frame.size.height - self.cameraView.frame.size.width) / -2, 0, self.cameraView.frame.size.height, self.cameraView.frame.size.height);
    [self.cameraView.layer addSublayer:captureVideoPreviewLayer];
    
    NSError *error = nil;
    AVCaptureInput* cameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:camera error:&error];
    if (cameraInput == nil) {
        NSLog(@"Error to create camera capture:%@",error);
    }
    
    [session setSessionPreset:AVCaptureSessionPresetLow];
    [session addInput:cameraInput];
    [session startRunning];
}

- (IBAction)onWindToMain:(UIStoryboardSegue *)segue
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
