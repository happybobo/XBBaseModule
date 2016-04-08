//
//  BSTableViewController.h
//  babylearn
//
//  Created by Bobby on 15/10/20.
//  Copyright (c) 2015年 ci123. All rights reserved.
//

#import "BSViewController.h"
#import "UIScrollView+EmptyDataSet.h"

@interface BSTableViewController : BSViewController
<
    UITableViewDelegate ,
    UITableViewDataSource,
    DZNEmptyDataSetSource ,
    DZNEmptyDataSetDelegate
>

@property (strong, nonatomic, readonly) UITableView *tableView;

@property (assign, nonatomic, readonly) UIEdgeInsets contentInset;
@end
