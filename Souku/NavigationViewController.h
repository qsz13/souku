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

@property (nonatomic, strong) AMapPOI *poi;


@end
