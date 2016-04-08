//
//  BSViewModelProtocol.h
//  babylearn
//
//  Created by Bobby on 15/10/20.
//  Copyright (c) 2015年 ci123. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@protocol BSViewModelProtocol <NSObject>

@required

- (instancetype)initWithParams:(id)params;

// The `params` parameter in `-initWithParams:` method.
@property (strong, nonatomic, readonly) id params;


@optional

// A RACSubject object, which representing all errors occurred in view model.
@property (strong, nonatomic, readonly) RACSubject *errors;

@property (assign, nonatomic) BOOL shouldFetchLocalDataOnViewModelInitialize;
@property (assign, nonatomic) BOOL shouldRequestRemoteDataOnViewDidLoad;

// An additional method, in which you can initialize data, RACCommand etc.
//
// This method will be execute after the execution of `-initWithParams:` method. But
// the premise is that you need to inherit `BSViewModel`.
- (void)initialize;
@end