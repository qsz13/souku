//
//  POIAnnotationView.h
//  Souku
//
//  Created by Daniel Qiu on 2/17/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface POIAnnotationView : MAAnnotationView

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger *idNumber;

@property (nonatomic, strong) UIImage *portrait;

@property (nonatomic, strong) UIView *calloutView;


@end
