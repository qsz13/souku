//
//  LocationDetailViewController.h
//  Souku
//
//  Created by Daniel Qiu on 2/3/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POIAnnotation.h"

@interface LocationDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) AMapPOI *poi;

@end
