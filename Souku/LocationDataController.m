//
//  LocationDataController.m
//  Souku
//
//  Created by Daniel Qiu on 2/7/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import "LocationDataController.h"
@implementation LocationDataController


-(void)addPOI:(AMapPOI *)poi
{
    
    [self.locationList addObject:poi];

    NSData *encodedFavLocationList = [NSKeyedArchiver archivedDataWithRootObject:self.locationList];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedFavLocationList forKey:@"favouriteLocationList"];
}

-(void)initializeDefaultDataList{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *savedEncodedData = [defaults objectForKey:@"favouriteLocationList"];
    if(savedEncodedData == nil)
    {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        self.locationList = list;
    }
    else{
        self.locationList = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:savedEncodedData];
    }
}


@end
