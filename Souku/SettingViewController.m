//
//  SettingViewController.m
//  Souku
//
//  Created by Daniel Qiu on 2/1/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"设置";
        //self.tabBarItem.image = [UIImage imageNamed:@"settingItem"];
    }
    return self;
}

-(void)initPOIName
{
    UILabel *POIName = [[UILabel alloc] init];
    POIName.backgroundColor  = [UIColor clearColor];
    POIName.textColor        = [UIColor whiteColor];
    POIName.text = @"POI Name";
    //[POIName drawTextInRect:CGRectMake(30, 30, 80, 30)];
    [self.view addSubview:POIName];
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initPOIName];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
