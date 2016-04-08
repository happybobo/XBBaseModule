//
//  XBNetworkEngine.h
//  ci123web
//
//  Created by Bobby on 15/11/25.
//  Copyright © 2015年 ci123. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    FetchErrorCodeCheckNet = -1000 ,
    FetchErrorCodeDataFormat ,
    FetchErrorCodeRetFormat ,
    FetchErrorCodeReadImage
}FetchErrorCode;


@class RACSignal;
@interface XBNetworkEngine : NSObject

+ (RACSignal *)rac_post:(NSString *)path
                pararms:(NSDictionary *)pararms;

+ (RACSignal *)rac_post:(NSString *)path
                  image:(UIImage *)image
                pararms:(NSDictionary *)pararms;

+ (void)appGet:(NSURL *)URL;


@end
