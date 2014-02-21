//
//  MapCalloutView.m
//  Souku
//
//  Created by Daniel Qiu on 2/17/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import "MapCalloutView.h"
#import "NavigationViewController.h"
#import "LocationDetailViewController.h"
#define kArrorHeight    10

@interface MapCalloutView ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIButton *navigationButton;
@property (nonatomic, strong) NavigationViewController *navigationViewController;
@property (strong, nonatomic) LocationDetailViewController *locationDetailViewController;
@property (nonatomic, readwrite, strong) AMapPOI *poi;
@property (nonatomic,strong) UIButton *detailButton;
@end

CGRect screenRect;
CGFloat screenWidth;
CGFloat screenHeight;

@implementation MapCalloutView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        self.backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"detailBackground"]];
        screenRect = [[UIScreen mainScreen] bounds];
        screenWidth = screenRect.size.width;
        screenHeight = screenRect.size.height;
        [self.backgroundImageView setFrame:CGRectMake(0, 0, screenWidth, screenHeight/8)];
        [self addSubview:self.backgroundImageView];
        [self initNavigationButton];
        [self initDetailButton];
        
        
    }
    return self;
}

-(void)initNavigationButton
{
    self.navigationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navigationButton setImage:[UIImage imageNamed:@"navigationIcon"] forState:UIControlStateNormal];
    [self.navigationButton setFrame:CGRectMake(screenWidth-60, 5 , 50, screenHeight/10)];
    [self.navigationButton addTarget:self action:@selector(navigate) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:self.navigationButton];
    
}

- (void)initDetailButton
{
    self.detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[self.detailButton setImage:[[UIImage alloc]init] forState:UIControlStateNormal];
    [self.detailButton setFrame:CGRectMake(0, 0 , screenWidth-70, screenHeight/10)];
    [self.detailButton addTarget:self action:@selector(detail) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.detailButton];
    
}
-(void)detail
{
    self.locationDetailViewController = [[LocationDetailViewController alloc] init];
    
    self.locationDetailViewController.poi = self.poi;
    [self.parentViewController performSelectorInBackground:@selector(clearMapView) withObject:nil] ;
    [[self.parentViewController navigationController] pushViewController: self.locationDetailViewController animated:YES];
    [self removeFromSuperview];
}

-(void)navigate
{
    self.navigationViewController = [[NavigationViewController alloc] init];
    self.navigationViewController.poi = self.poi;
    [self.parentViewController performSelectorInBackground:@selector(clearMapView) withObject:nil];
    [self.parentViewController.navigationController setNavigationBarHidden:YES animated:YES];
    [self.parentViewController.navigationController pushViewController:self.navigationViewController animated:YES];
    [self.parentViewController performSelectorInBackground:@selector(clearMapView) withObject:nil]; 
    [self removeFromSuperview];
}

- (void)setTitleLabelText:(NSString *)title
{
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, screenWidth-60, screenHeight/10)];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
    [self addSubview:self.titleLabel];
}
- (void)setSubTitleLabelText:(NSString *)title
{
    self.subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 13+self.titleLabel.frame.size.height, screenWidth-60, 20)];
    [self.subTitleLabel setBackgroundColor:[UIColor clearColor]];
    self.subTitleLabel.numberOfLines = 2;
    self.subTitleLabel.text = title;
    [self.subTitleLabel setFont:[UIFont systemFontOfSize:13]];
    [self.subTitleLabel sizeToFit];
    [self addSubview:self.subTitleLabel];

}

-(void)setPOI:(AMapPOI *)poi
{
    self.poi = poi;
}


@end