//
//  MapView.m
//  Souku
//
//  Created by Daniel Qiu on 2/9/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import "MapView.h"

static MAUserLocation *currentLocation = nil;


@implementation MapView

@synthesize map;


+(MapView *)sharedManager
{
    static MapView *mapView = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapView = [[MapView alloc] init];

    });
    return mapView;
}

- (id)init {
    if (self = [super init])
    {
        map = [[MAMapView alloc]init];
        map.showsUserLocation = YES;
        [map setUserTrackingMode: MAUserTrackingModeFollowWithHeading animated:YES];
        map.delegate = self;
    }
    return self;
}



-(void)mapView:(MAMapView*)mapView didUpdateUserLocation:(MAUserLocation*)userLocation updatingLocation:(BOOL)updatingLocation
{
    //NSLog(@"asdf");
    currentLocation = userLocation;
}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"get location failed, should warn user");
}

-(MAMapView *)getMap
{
    return map;
}

-(MAUserLocation *)getCurrentLocation
{
    return currentLocation;
}

-(void)setCurrentLocation:(MAUserLocation *)location
{
    currentLocation = location;
}

@end
