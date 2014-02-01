//
//  HomeViewController.h
//  Souku
//
//  Created by Daniel Qiu on 2/1/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIBarButtonItem *mapButton;
@property (strong, nonatomic) UIBarButtonItem *refreshButton;
@property (strong, nonatomic) UIBarButtonItem *searchButton;
@property (strong, nonatomic) UIBarItem *appLogo;
@property (strong, nonatomic) UIBarItem *appName;
@property (strong, nonatomic) UITableView *parkingLotTableView;
@property (strong, nonatomic) NSArray *parkArray;
@end
