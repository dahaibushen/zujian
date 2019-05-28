//
//  ViewController.m
//  HYYDaHuaXianTan
//
//  Created by hu on 2019/5/28.
//  Copyright © 2019 huyiyong. All rights reserved.
//

#import "ViewController.h"
#import <HYYService/HYYService.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    HYYService *server = [HYYService serviceShare];
    [server postRequestData];
}


@end
