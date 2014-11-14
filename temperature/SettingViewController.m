//
//  SettingViewController.m
//  temperature
//
//  Created by Zzy on 11/14/14.
//  Copyright (c) 2014 zangzhiya. All rights reserved.
//

#import "SettingViewController.h"
#import "LocationService.h"
#import "GlobalHolder.h"

@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *versionStr = [NSString stringWithFormat:@"%@ Build %@", [info objectForKey:@"CFBundleShortVersionString"], [info objectForKey:@"CFBundleVersion"]];
    self.versionLabel.text = versionStr;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    if (![GlobalHolder sharedSingleton].city) {
        [self updateLocation];
    } else {
        self.locationLabel.text = [GlobalHolder sharedSingleton].city;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updateLocation
{
    self.locationResultLabel.text = @"正在定位...";
    [[LocationService sharedSingleton] getCurrentLocationWithBlock:^(CLLocation *location) {
        CLGeocoder *clGeoCoder=[[CLGeocoder alloc] init];
        [clGeoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            if (!error && placemarks) {
                CLPlacemark *placeMark = [placemarks objectAtIndex:0];
                NSDictionary *addressDic = placeMark.addressDictionary;
                NSString *city = [addressDic objectForKey:@"City"];
                [GlobalHolder sharedSingleton].city = city;
                self.locationLabel.text = city;
                self.locationResultLabel.text = @"定位完成";
            } else {
                self.locationResultLabel.text = @"定位失败";
            }
        }];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self updateLocation];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        NSString *urlStr = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=941511360";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }
}

@end
