//
//  BSTableViewModel.h
//  babylearn
//
//  Created by Bobby on 15/10/20.
//  Copyright (c) 2015年 ci123. All rights reserved.
//

#import "BSViewModel.h"

@interface BSTableViewModel : BSViewModel

// The data source of table view.
@property (copy, nonatomic) NSArray *dataSource;

@property (assign, nonatomic) NSUInteger page;
@property (assign, nonatomic) NSUInteger perPage;

// The list of section titles to display in section index view.
@property (copy, nonatomic) NSArray *sectionIndexTitles;

@property (assign, nonatomic) BOOL shouldPullToRefresh;
@property (assign, nonatomic) BOOL shouldInfiniteScrolling;
@property (assign, nonatomic) BOOL shouldDisplayEmptyDataSet;

@property (assign, nonatomic) BOOL isMore;

@property (strong, nonatomic, readonly) RACCommand *requestRemoteDataCommand;

- (id)fetchLocalData;

- (BOOL (^)(NSError *error))requestRemoteDataErrorsFilter;

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page;

- (RACSignal *)requestEnableSignal;
@end
