//
//  BSTableViewController.m
//  babylearn
//
//  Created by Bobby on 15/10/20.
//  Copyright (c) 2015年 ci123. All rights reserved.
//

#import "BSTableViewController.h"
#import "BSTableViewModel.h"
#import "MJRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import <Masonry/Masonry.h>

#define WS(weakSelf)                __weak __typeof(&*self)weakSelf = self;

@interface BSTableViewController ()

@property (nonatomic, strong, readwrite) UITableView *tableView;
@property (strong, nonatomic) BSTableViewModel *viewModel;

@end

@implementation BSTableViewController

@dynamic viewModel;

- (void)setView:(UIView *)view {
    [super setView:view];
    if ([view isKindOfClass:UITableView.class])
        self.tableView = (UITableView *)view;
}

- (instancetype)initWithViewModel:(id<BSViewModelProtocol>)viewModel {
    self = [super initWithViewModel:viewModel];
    if (self) {
        
        if ([viewModel shouldRequestRemoteDataOnViewDidLoad]) {
            @weakify(self)
            [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
                @strongify(self)
                [self.viewModel.requestRemoteDataCommand execute:@1];
            }];
        }
    }
    return self;
}

- (UIEdgeInsets)contentInset {
    return UIEdgeInsetsZero;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    //self.tableView.separatorColor = HexRGB(0xdddddd);
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:self.tableView];
    
    WS(ws);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view);
    }];
    
    @weakify(self)
    if (self.viewModel.shouldPullToRefresh) {
    
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTriggered:)];
       
        self.tableView.mj_header = header;
    }
    
    if (self.viewModel.shouldInfiniteScrolling) {
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            @strongify(self)
            [[[self.viewModel.requestRemoteDataCommand execute:@(self.viewModel.page + 1)]
              deliverOn:[RACScheduler mainThreadScheduler]]
            	subscribeNext:^(NSArray *results) {
                    @strongify(self)
                    [self.tableView.infiniteScrollingView stopAnimating];
                    self.viewModel.page += 1;
                } error:^(NSError *error) {
                    @strongify(self)
                    [self.tableView.infiniteScrollingView stopAnimating];
                } completed:^{
                    @strongify(self)
                    [self.tableView.infiniteScrollingView stopAnimating];
                }];
        }];
        
        RAC(self.tableView, showsInfiniteScrolling) = [[RACObserve(self.viewModel, isMore) deliverOn:[RACScheduler mainThreadScheduler]] map:^id(NSNumber *more) {
            return more;
        }];
        
        [[RACObserve(self.tableView, showsInfiniteScrolling) deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSNumber *isShow) {
            @strongify(self);
            if (!isShow.boolValue) {
                self.tableView.contentInset = self.contentInset;
            }
        }];
    }
}

- (void)refreshTriggered:(id)sender {
    @weakify(self)
    [[[self.viewModel.requestRemoteDataCommand
       execute:@1]
     	deliverOnMainThread]
    	subscribeNext:^(id x) {
            @strongify(self)
            self.viewModel.page = 1;
            [self.tableView.mj_header endRefreshing];
        } error:^(NSError *error) {
            @strongify(self)
            [self.tableView.mj_header endRefreshing];
        } completed:^{
            @strongify(self)
            [self.tableView.mj_header endRefreshing];
        }];
}

- (void)dealloc {
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
}

- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self)
    [RACObserve(self.viewModel, dataSource).distinctUntilChanged.deliverOnMainThread subscribeNext:^(id x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
    
    [RACObserve(self.viewModel, shouldDisplayEmptyDataSet).deliverOnMainThread subscribeNext:^(id x) {
        @strongify(self)
        [self.tableView reloadEmptyDataSet];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"暂无数据"];
}

#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return self.viewModel.shouldDisplayEmptyDataSet;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (CGPoint)offsetForEmptyDataSet:(UIScrollView *)scrollView {
    return CGPointMake(0, -(self.tableView.contentInset.top - self.tableView.contentInset.bottom) / 2);
}
@end
