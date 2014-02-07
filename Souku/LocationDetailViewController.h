//
//  LocationDetailViewController.h
//  Souku
//
//  Created by Daniel Qiu on 2/3/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POIAnnotation.h"
#import "NavigationViewController.h"
#import "LocationDataController.h"
#import "AMapPOI+storage.h"

@interface LocationDetailViewController : UIViewController//<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) AMapPOI *poi;
@property (strong, nonatomic) CLLocation *currentLocation;


@property (weak, nonatomic) IBOutlet UILabel *poiNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;

@property (weak, nonatomic) IBOutlet UIButton *navigationButton;
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;


@end
