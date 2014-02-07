//
//  FavouriteViewController.m
//  Souku
//
//  Created by Daniel Qiu on 2/1/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import "FavouriteViewController.h"
#import "AMapPOI+storage.h"
#import "LocationDetailViewController.h"

@interface FavouriteViewController ()

@end

@implementation FavouriteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"收藏";
        //self.tabBarItem.image = [UIImage imageNamed:@"favouriteItem"];
        self.locationDataController = [[LocationDataController alloc]init];
        [self.locationDataController initializeDefaultDataList];
        [self initTableData];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.favouriteTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    
    self.favouriteTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.favouriteTableView.delegate = self;
    self.favouriteTableView.dataSource = self;
    [self.favouriteTableView reloadData];

    self.view = self.favouriteTableView;

}


-(void)initTableData
{
    self.favouriteItemArray = [[NSMutableArray alloc]init];
    for(AMapPOI *poi in self.locationDataController.locationList)
    {
        [self.favouriteItemArray addObject:poi];
        NSLog(@"%@",poi.name);
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%d",self.favouriteItemArray.count);
    return self.favouriteItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"favCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    AMapPOI *currentPOI = [self.favouriteItemArray objectAtIndex:indexPath.row];
    cell.textLabel.text = currentPOI.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationDetailViewController *detail = [[LocationDetailViewController alloc] initWithNibName:@"LocationDetail" bundle:nil];
    detail.poi = [self.favouriteItemArray objectAtIndex:indexPath.row];
    detail.hidesBottomBarWhenPushed = YES;
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    [self.navigationController pushViewController:detail animated:YES];

}

@end
