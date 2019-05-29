//
//  ViewController.m
//  HYYDaHuaXianTan
//
//  Created by hu on 2019/5/28.
//  Copyright © 2019 huyiyong. All rights reserved.
//

#import "ViewController.h"
#import <HYYService/HYYService.h>
#import <CommonCrypto/CommonDigest.h>
#import <HYYBse/NSString+MD5Str.h>
#import <HYYCustom/HYYCustom.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    HYYService *server = [HYYService serviceShare];
    NSString *url  = @"/jy-shop/IShopRpcService/findShops";
//    [server postRequestDataWithUrl:[self stringFromMD5WithStr:@"/jy-shop/IShopRpcService/findShops"]];
    [server postRequestDataWithUrl:[url stringFromMD5]];
}

- (NSString *)stringFromMD5WithStr:(NSString*)string
{
    if (string==nil || [string length]==0) {
        return nil;
    }
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger count=0; count<CC_MD5_DIGEST_LENGTH; count++) {
        [outputString appendFormat:@"%02x", outputBuffer[count]];
    }
    
    return outputString;
}


@end
