//
//  LocationDataController.h
//  Souku
//
//  Created by Daniel Qiu on 2/7/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapSearchKit/AMapCommonObj.h>

@interface LocationDataController : NSObject

@property (nonatomic)NSMutableArray *locationList;
-(void)initializeDefaultDataList;
-(void)addPOI:(AMapPOI *)poi;
-(void) removePOI:(AMapPOI *)poi;
-(bool)containsPOI:(AMapPOI *)poi;
@end
