//
//  BSViewController.h
//  babylearn
//
//  Created by Bobby on 15/10/20.
//  Copyright (c) 2015年 ci123. All rights reserved.
//

#import "BSViewControllerProtocol.h"
#import "UIViewController+MBProgressHUD.h"
#import "BSViewModel.h"

@interface BSViewController : UIViewController<BSViewControllerProtocol>

@property (nonatomic, assign) BOOL canBack;
@end
