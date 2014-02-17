//
//  POIAnnotationView.h
//  Souku
//
//  Created by Daniel Qiu on 2/17/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "MapCalloutView.h"

@interface POIAnnotationView : MAAnnotationView




@property (nonatomic, strong) MapCalloutView *calloutView;
@property (nonatomic, strong) NSString *title;
@property (nonatomic,strong) UIViewController *parentViewController;



- (void)setIconImage:(UIImage *)icon;

- (NSString*)getIDString;

- (void)setIDLabel:(NSString *)idStirng;


@end
