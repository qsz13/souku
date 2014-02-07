//
//  AMapGeoPoint+storage.m
//  Souku
//
//  Created by Daniel Qiu on 2/7/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import "AMapGeoPoint+storage.h"

@implementation AMapGeoPoint (storage)

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeFloat:self.latitude forKey:@"latitude"];
    [aCoder encodeFloat:self.longitude forKey:@"longitude"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.latitude = [aDecoder decodeFloatForKey:@"latitude"];
        self.longitude = [aDecoder decodeFloatForKey:@"longitude"];
    }
    return self;
    
}




@end
