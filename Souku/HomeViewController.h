//
//  HomeViewController.h
//  Souku
//
//  Created by Daniel Qiu on 2/1/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

@interface HomeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MAMapViewDelegate, UISearchBarDelegate>

@property (strong, nonatomic) UIBarButtonItem *mapButton;

@property (strong, nonatomic) UIBarButtonItem *refreshButton;
@property (strong, nonatomic) UIBarButtonItem *searchButton;
@property (strong, nonatomic) UIBarButtonItem *listButton;
@property (strong, nonatomic) UIBarButtonItem *appLogo;
@property (strong, nonatomic) UIBarButtonItem *appName;

@property (strong, nonatomic) UISearchBar *searchBar;

@property (strong, nonatomic) UITableView *parkingLotTableView;
@property (strong, nonatomic) NSArray *parkArray;

@property (strong, nonatomic) MAMapView *mapView;
@property (strong, nonatomic) CLLocation *currentLocation;
@end
