//
//  AroundViewController.m
//  Souku
//
//  Created by Daniel Qiu on 2/1/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import "AroundViewController.h"

@interface AroundViewController ()

@end

@implementation AroundViewController

@synthesize aroundItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"around";
        //self.tabBarItem.image = [UIImage imageNamed:@"aroundItem"];
        self.aroundItem = @[@"酒店住宿",@"餐饮服务",@"购物服务",@"生活服务",@"体育休闲",@"医疗保健",@"风景名胜"];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.aroundTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.aroundTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.aroundTableView.delegate = self;
    self.aroundTableView.dataSource = self;
    [self.aroundTableView reloadData];
    
    self.view = self.aroundTableView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return aroundItem.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"aroundCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
    
    cell.textLabel.text = [self.aroundItem objectAtIndex:indexPath.row];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AroundMapViewController *aroundMapViewController = [[AroundMapViewController alloc] init];
    aroundMapViewController.searchKey = [self.aroundItem objectAtIndex:indexPath.row];
    aroundMapViewController.hidesBottomBarWhenPushed = YES;
    [[self navigationController] pushViewController:aroundMapViewController animated:YES];

}



@end