//
//  NavigationViewController.m
//  Souku
//
//  Created by Daniel Qiu on 2/4/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

@synthesize bottomToolbar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigationBar];
    
    [self initMap];
    
    [self initTitleBar];
//    [self initToolBar];
//    
//    [self addDefaultAnnotations];
//    
//    [self updateCourseUI];
//    
//    [self updateDetailUI];
}

-(void)initMap
{
    self.mapView=[[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
}

-(void)initTitleBar
{
    UIToolbar *topToolbar = [[UIToolbar alloc] init];
    topToolbar.frame = CGRectMake(0, 0, self.view.frame.size.width, 60);
//    NSMutableArray *items = [[NSMutableArray alloc] init];
//
//    [items addObject:];
//    [toolbar setItems:items animated:NO];

    [self.view addSubview:topToolbar];
    
    
    
    
    
    bottomToolbar = [[UIToolbar alloc] init];
   // bottomToolbar.delegate = self;
    bottomToolbar.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 60, [[UIScreen mainScreen] bounds].size.width, 60);
   // bottomToolbar.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 60);
   // [bottomToolbar positionForBar:UIToolbarPositionBottom];
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(back)];
    [items addObject:back];
    bottomToolbar.items = items;
//    UIToolbarPositionBottom
    
    [self.view addSubview:bottomToolbar];
    


}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
}



@end
