//
//  BSViewModel.m
//  babylearn
//
//  Created by Bobby on 15/10/20.
//  Copyright (c) 2015年 ci123. All rights reserved.
//

#import "BSViewModel.h"

@interface BSViewModel ()

@property (strong, nonatomic, readwrite) id params;

@end

@implementation BSViewModel

@synthesize params   = _params;
@synthesize errors   = _errors;
@synthesize shouldFetchLocalDataOnViewModelInitialize = _shouldFetchLocalDataOnViewModelInitialize;
@synthesize shouldRequestRemoteDataOnViewDidLoad = _shouldRequestRemoteDataOnViewDidLoad;


+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    BSViewModel *viewModel = [super allocWithZone:zone];
    
    @weakify(viewModel);
    [[viewModel
        rac_signalForSelector:@selector(initWithParams:)]
        subscribeNext:^(id x) {
            @strongify(viewModel)
            [viewModel initialize];
    }];
     return viewModel;
}

- (instancetype)initWithParams:(id)params
{
    self = [super init];
    if (self) {
        self.params = params;
        self.shouldFetchLocalDataOnViewModelInitialize = YES;
        self.shouldRequestRemoteDataOnViewDidLoad = YES;
    }
    return self;
}


- (RACSubject *)errors {
    if (!_errors) _errors = [RACSubject subject];
    return _errors;
}

- (void)initialize {
}
@end
