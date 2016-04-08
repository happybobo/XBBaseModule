//
//  BSViewControllerProtocol.h
//  babylearn
//
//  Created by Bobby on 15/10/20.
//  Copyright (c) 2015年 ci123. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BSViewModelProtocol;

@protocol BSViewControllerProtocol <NSObject>

@required

// Initialization method. This is the preferred way to create a new view.
//
// viewModel - corresponding view model
//
// Returns a new view.
- (instancetype)initWithViewModel:(id<BSViewModelProtocol>)viewModel;

// The `viewModel` parameter in `-initWithViewModel:` method.
@property (strong, nonatomic, readonly) id<BSViewModelProtocol> viewModel;

@optional

- (void)bindViewModel;

@end