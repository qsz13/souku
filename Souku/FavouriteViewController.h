//
//  FavouriteViewController.h
//  Souku
//
//  Created by Daniel Qiu on 2/1/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavouriteViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *favouriteTableView;
@property (nonatomic, strong) NSArray *favouriteItemArray;

@end
