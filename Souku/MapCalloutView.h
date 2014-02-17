//
//  MapCalloutView.h
//  Souku
//
//  Created by Daniel Qiu on 2/17/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapCommonObj.h>

@interface MapCalloutView : UIView

@property (nonatomic,strong) UIViewController *parentViewController;

- (void)setPOI:(AMapPOI *)poi;
- (void)setTitleLabelText:(NSString *)title;
- (void)setSubTitleLabelText:(NSString *)title;

@end
