//
//  XBNetworkEngine.m
//  ci123web
//
//  Created by Bobby on 15/11/25.
//  Copyright © 2015年 ci123. All rights reserved.
//

#import "XBNetworkEngine.h"
#import "AFHTTPRequestOperationManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation XBNetworkEngine

+ (RACSignal *)rac_post:(NSString *)path
                pararms:(NSDictionary *)pararms
{
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager.requestSerializer setValue:[XBNetworkEngine appUserAgent] forHTTPHeaderField:@"User-Agent"];
        
        AFHTTPRequestOperation *operation = [manager POST:path parameters:pararms success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if (![responseObject isKindOfClass:[NSDictionary class]]) {
                [subscriber sendError:[NSError errorWithDomain:@"数据格式返回错误" code:FetchErrorCodeDataFormat userInfo:nil]];
                return;
            }
            
            if (!responseObject[@"ret"] || [responseObject[@"ret"] integerValue] != 1) {
                NSString *error = ([responseObject[@"err_msg"] isEqualToString:@""])?@"数据返回错误":responseObject[@"err_msg"];
                error = (!error)?@"":error;
                [subscriber sendError:[NSError errorWithDomain:error code: FetchErrorCodeRetFormat userInfo:nil]];
                return;
            }
            
            //NSLog(@"data %@",responseObject[@"data"]);
            [subscriber sendNext:responseObject[@"data"]];
            [subscriber sendCompleted];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [subscriber sendError:[NSError errorWithDomain:@"请检查网络" code:FetchErrorCodeCheckNet userInfo:nil]];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }]
    replayLazily]
    setNameWithFormat:@"rac_getPath: %@, parameters: %@", path, pararms];
}

+ (RACSignal *)rac_post:(NSString *)path image:(UIImage *)image pararms:(NSDictionary *)pararms
{
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        if (!image) {
            [subscriber sendError:[NSError errorWithDomain:@"图片读取失败" code:FetchErrorCodeReadImage userInfo:nil]];
            return nil;
        }
        
        
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        if ((float)data.length/1024 > 1000) {
            data = UIImageJPEGRepresentation(image, 1024*1000.0/(float)data.length);
        }
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:[XBNetworkEngine appUserAgent] forHTTPHeaderField:@"User-Agent"];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        AFHTTPRequestOperation *operation = [manager POST:path parameters:pararms constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:data name:@"Img" fileName:@"Img" mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if (![responseObject isKindOfClass:[NSDictionary class]]) {
                [subscriber sendError:[NSError errorWithDomain:@"数据格式返回错误" code:FetchErrorCodeDataFormat userInfo:nil]];
                return;
            }
            
            if (!responseObject[@"ret"] || [responseObject[@"ret"] integerValue] != 1) {
                NSString *error = ([responseObject[@"err_msg"] isEqualToString:@""])?@"数据返回错误":responseObject[@"err_msg"];
                error = (!error)?@"":error;
                [subscriber sendError:[NSError errorWithDomain:error code: FetchErrorCodeRetFormat userInfo:nil]];
                return;
            }
            
            [subscriber sendNext:responseObject[@"data"]];
            [subscriber sendCompleted];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [subscriber sendError:[NSError errorWithDomain:@"请检查网络" code:FetchErrorCodeCheckNet userInfo:nil]];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }]
    replayLazily]
    setNameWithFormat:@"rac_imagePath: %@, parameters: %@", path, pararms];
}

+ (void)appGet:(NSURL *)URL
{
     AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setValue:[XBNetworkEngine appUserAgent] forHTTPHeaderField:@"User-Agent"];
     [manager GET:URL.absoluteString parameters:nil success:nil failure:nil];
    
}

+ (NSString *)appUserAgent
{
    NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    NSString *customUserAgent = [@"" stringByAppendingFormat:@" Ci123_jxt/1.0(IOS;Build 1;Version %@;)",version];
    
    NSString *deviceName = @"other";
    customUserAgent = [NSString stringWithFormat:@"%@ %@ systemVersion %@",customUserAgent, deviceName,[UIDevice currentDevice].systemVersion];
    
    return customUserAgent;
}

@end
