//
//  NavigationViewController.h
//  Souku
//
//  Created by Daniel Qiu on 2/4/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "APIKey.h"
#import "CommonUtility.h"
#import "LineDashPolyline.h"

@interface NavigationViewController : UIViewController<AMapSearchDelegate,MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, strong) UIToolbar *bottomToolbar;

@property (nonatomic, strong) AMapPOI *poi;
@property (strong, nonatomic) CLLocation *currentLocation;

/* 起始点经纬度. */
@property (nonatomic) CLLocationCoordinate2D startCoordinate;
/* 终点经纬度. */
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;


@property(strong,nonatomic) NSMutableArray *annotations;

@end
