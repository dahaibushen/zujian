//
//  HYYService.m
//  HYYService
//
//  Created by hu on 2019/5/28.
//  Copyright © 2019 huyiyong. All rights reserved.
//

#import "HYYService.h"
#import <AFNetworking.h>

@interface HYYService ()


@end

@implementation HYYService

+(instancetype)serviceShare{
    static dispatch_once_t onceToken;
    static HYYService *service = nil;
    dispatch_once(&onceToken, ^{
        if (service == nil) {
            service = [[HYYService alloc] init];
        }
    });
    return service;
}

-(void)postRequestDataWithUrl:(NSString*)url{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *sheme = @"https://api-dev.myt11.com";
    NSString *urlString = url;// @"/jy-shop/IShopRpcService/findShops";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@",sheme,urlString];
    
    [manager POST:requestUrl parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"====succed===:%@",responseObject);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"====failed===:%@",error);
    }];
    
}


@end
