//
//  LineDashPolyline.m
//  Souku
//
//  Created by Daniel Qiu on 2/5/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import "LineDashPolyline.h"

@implementation LineDashPolyline

@synthesize coordinate;

@synthesize boundingMapRect ;

@synthesize polyline = _polyline;

- (id)initWithPolyline:(MAPolyline *)polyline
{
    self = [super init];
    if (self)
    {
        self.polyline = polyline;
    }
    return self;
}

- (CLLocationCoordinate2D) coordinate
{
    return [_polyline coordinate];
}

- (MAMapRect) boundingMapRect
{
    return [_polyline boundingMapRect];
}


@end
