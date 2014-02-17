//
//  POIAnnotationView.m
//  Souku
//
//  Created by Daniel Qiu on 2/17/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import "POIAnnotationView.h"
#import "MapCalloutView.h"
#import "POIAnnotation.h"
#import <AMapSearchKit/AMapCommonObj.h>

#define kWidth  30.f
#define kHeight 30.f

#define kHoriMargin 5.f
#define kVertMargin 5.f

#define kPortraitWidth  50.f
#define kPortraitHeight 50.f

#define kCalloutWidth   200.0
#define kCalloutHeight  70.0

@interface POIAnnotationView ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, copy) NSString *idString;
@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, readwrite, strong) AMapPOI *poi;


@end


@implementation POIAnnotationView



- (void)setIDLabel:(NSString *)idString
{
    self.idString = idString;
    self.idLabel.text = idString;
}

- (NSString*)getIDString
{
    return self.idString;
}

- (UIImage *)icon
{
    return self.iconImageView.image;
}

- (void)setIconImage:(UIImage *)icon
{
    self.iconImageView.image = icon;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.calloutView == nil)
        {
            
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            CGFloat screenWidth = screenRect.size.width;
            CGFloat screenHeight = screenRect.size.height;
            CGFloat y = screenHeight-screenHeight/8;
            /* Construct custom callout. */
            self.calloutView = [[MapCalloutView alloc] initWithFrame:CGRectMake(0, y, screenWidth, screenHeight/8)];
            [self.calloutView setTitleLabelText:[NSString stringWithFormat:@"%@.%@",self.idString,self.poi.name]];
            [self.calloutView setSubTitleLabelText:self.poi.address];
            [self.calloutView setPOI:self.poi];
            self.calloutView.parentViewController = self.parentViewController;
            
        }
        
        [self.superview.superview.superview.superview.superview.superview addSubview:self.calloutView];

    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, kWidth, kHeight);
        
        self.backgroundColor = [UIColor clearColor];
        
        /* Create portrait image view and add to view hierarchy. */
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        [self addSubview:self.iconImageView];
        
        /* Create name label. */
        self.idLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -5, kWidth, kHeight)];
        self.idLabel.backgroundColor  = [UIColor clearColor];
        self.idLabel.textAlignment    = NSTextAlignmentCenter;
        self.idLabel.textColor        = [UIColor whiteColor];
        self.idLabel.font             = [UIFont boldSystemFontOfSize:14];
        [self addSubview:self.idLabel];
        POIAnnotation *anotationTemp = (POIAnnotation *)annotation;
        self.poi = anotationTemp.poi;
        
    
    }
    
    return self;
}



@end
