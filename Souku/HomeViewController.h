//
//  HomeViewController.h
//  Souku
//
//  Created by Daniel Qiu on 2/1/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <MBProgressHUD/MBProgressHUD.h>

typedef NS_ENUM(NSInteger, ParkingMapState) {
    ParkShowed  = 0,
    ParkDisabled  = 1,
    ParkLeft = 2,

};


@interface HomeViewController:UIViewController<UITableViewDelegate, UITableViewDataSource, MAMapViewDelegate,AMapSearchDelegate,UISearchBarDelegate,MBProgressHUDDelegate>



@end
