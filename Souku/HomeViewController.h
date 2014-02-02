//
//  HomeViewController.h
//  Souku
//
//  Created by Daniel Qiu on 2/1/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

@interface HomeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MAMapViewDelegate>

@property (strong, nonatomic) UIBarButtonItem *mapButton;

@property (strong, nonatomic) UIBarButtonItem *refreshButton;
@property (strong, nonatomic) UIBarButtonItem *searchButton;
@property (strong, nonatomic) UIBarButtonItem *listButton;
@property (strong, nonatomic) UIBarButtonItem *appLogo;
@property (strong, nonatomic) UIBarButtonItem *appName;

@property (strong, nonatomic) UITableView *parkingLotTableView;
@property (strong, nonatomic) NSArray *parkArray;

@property (nonatomic, strong) MAMapView *mapView;

@end
