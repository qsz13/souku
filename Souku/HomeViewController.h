//
//  HomeViewController.h
//  Souku
//
//  Created by Daniel Qiu on 2/1/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

@interface HomeViewController:UIViewController<UITableViewDelegate, UITableViewDataSource, MAMapViewDelegate, UISearchBarDelegate>


@property (strong, nonatomic) NSArray *parkArray;

@end
