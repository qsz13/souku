//
//  AMapPOI+storage.m
//  Souku
//
//  Created by Daniel Qiu on 2/7/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import "AMapPOI+storage.h"


@implementation AMapPOI (storage)


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.tel forKey:@"tel"];
    [aCoder encodeInteger:self.distance forKey:@"distance"];
    [aCoder encodeObject:self.postcode forKey:@"postcode"];
    [aCoder encodeObject:self.website forKey:@"website"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.province forKey:@"province"];
    [aCoder encodeObject:self.pcode forKey:@"pcode"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.citycode forKey:@"citycode"];
    [aCoder encodeObject:self.district forKey:@"district"];
    [aCoder encodeObject:self.adcode forKey:@"adcode"];
    [aCoder encodeObject:self.gridcode forKey:@"gridcode"];
    [aCoder encodeObject:self.navipoiid forKey:@"navipoiid"];
    [aCoder encodeObject:self.enterLocation forKey:@"enterLocation"];
    [aCoder encodeObject:self.exitLocation forKey:@"exitLocation"];
    [aCoder encodeFloat:self.weight forKey:@"weight"];
    [aCoder encodeFloat:self.match forKey:@"match"];
    [aCoder encodeInteger:self.recommend forKey:@"recommend"];
    [aCoder encodeObject:self.direction forKey:@"direction"];
    

    
    
    
    
    
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.location = [aDecoder decodeObjectForKey:@"location"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.tel = [aDecoder decodeObjectForKey:@"tel"];
        self.distance = [aDecoder decodeIntegerForKey:@"distance"];
        self.postcode = [aDecoder decodeObjectForKey:@"postcode"];
        self.website = [aDecoder decodeObjectForKey:@"website"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.province = [aDecoder decodeObjectForKey:@"province"];
        self.pcode = [aDecoder decodeObjectForKey:@"pcode"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.citycode = [aDecoder decodeObjectForKey:@"citycode"];
        self.district = [aDecoder decodeObjectForKey:@"district"];
        self.adcode = [aDecoder decodeObjectForKey:@"adcode"];
        self.gridcode = [aDecoder decodeObjectForKey:@"gridcode"];
        self.navipoiid = [aDecoder decodeObjectForKey:@"navipoiid"];
        self.enterLocation = [aDecoder decodeObjectForKey:@"enterLocation"];
        self.exitLocation = [aDecoder decodeObjectForKey:@"exitLocation"];
        self.weight = [aDecoder decodeFloatForKey:@"weight"];
        self.match = [aDecoder decodeFloatForKey:@"match"];
        self.recommend = [aDecoder decodeIntegerForKey:@"recommend"];
        self.direction = [aDecoder decodeObjectForKey:@"direction"];
        
    }
    return self;
    
}



@end
