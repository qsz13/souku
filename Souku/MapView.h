//
//  MapView.h
//  Souku
//
//  Created by Daniel Qiu on 2/9/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>


@interface MapView : NSObject<MAMapViewDelegate>


@property (nonatomic, retain) MAMapView *map;

+(MapView *)sharedManager;
-(MAMapView *)getMap;
-(MAUserLocation *)getCurrentLocation;

@end



