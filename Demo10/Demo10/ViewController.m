//
//  ViewController.m
//  Demo10
//
//  Created by hu on 2019/4/22.
//  Copyright © 2019 huyiyong. All rights reserved.
//

#import "ViewController.h"
#import <HYYBase/HYYTableViewCell.h>
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "MapViewController.h"

@interface ViewController ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *sdCycleView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sdCycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 120, self.view.frame.size.width, 300) delegate:self placeholderImage:nil];
//    self.sdCycleView.autoScroll = NO;
    [self.view addSubview:self.sdCycleView];
    UIButton *button = [UIButton new];
    button.frame = CGRectMake(30, 30, 30, 30);
    button.backgroundColor = [UIColor orangeColor];
    [button addTarget:self action:@selector(buttClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
-(void)buttClick:(UIButton*)btn{
//    self.sdCycleView.imageURLStringsGroup = @[@"http://d.hiphotos.baidu.com/lvpics/w=1000/sign=e2347e78217f9e2f703519082f00eb24/730e0cf3d7ca7bcb49f90bb1b8096b63f724a8aa.jpg",@"http://pic32.nipic.com/20130823/13339320_183302468194_2.jpg",@"http://pic40.nipic.com/20140412/18428321_144447597175_2.jpg",@"http://pic37.nipic.com/20140110/17563091_221827492154_2.jpg",@"http://pic25.nipic.com/20121112/9252150_150552938000_2.jpg"];
    MapViewController *mapVC = [[MapViewController alloc] init];
    [self presentViewController:mapVC animated:YES completion:nil];
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
}


@end
