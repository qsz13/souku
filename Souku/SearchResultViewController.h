//
//  AroundMapViewController.h
//  Souku
//
//  Created by Daniel Qiu on 2/2/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "APIKey.h"
#import "POIAnnotation.h"
#import "LocationDetailViewController.h"
#import "MBProgressHUD.h"

@interface SearchResultViewController : UIViewController<MAMapViewDelegate, AMapSearchDelegate,MBProgressHUDDelegate,UITableViewDelegate, UITableViewDataSource>


@property (strong, nonatomic) AMapSearchAPI *search;
@property (strong, nonatomic) NSString *searchKey;
@property (strong, nonatomic) MAUserLocation *currentLocation;
@property (strong, nonatomic) NSMutableArray *poiArray;

@end
