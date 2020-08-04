//
//  ViewController.m
//  Category_Animation_demo
//
//  Created by hu on 2020/8/3.
//  Copyright © 2020 hu. All rights reserved.
//

#import "ViewController.h"
#import "CollectionHeaderView.h"
#import "CollectionViewFlowLayout.h"
#import "THSpringyFlowLayout.h"
#import "CollectionViewCell.h"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) THSpringyFlowLayout *layout;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.layout = [[THSpringyFlowLayout alloc] init];
    self.layout.itemSize = CGSizeMake(self.view.frame.size.width, 120);
    self.layout.headerReferenceSize = CGSizeMake(self.view.frame.size.height, 44);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.layout];
    collectionView.backgroundColor = [UIColor clearColor];
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    [collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cellid"];
    [collectionView registerNib:[UINib nibWithNibName:@"CollectionHeaderView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    collectionView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.8];
    collectionView.dataSource = self;
    [self.view insertSubview:collectionView atIndex:0];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 100;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    cell.contentLbl.text = [NSString stringWithFormat:@"这是%ld组，第%ld个",indexPath.section+1,indexPath.row];
    if (indexPath.row%5==0) {
        cell.backgroundColor = [UIColor orangeColor];
    }else if (indexPath.row%5==1){
       cell.backgroundColor = [UIColor greenColor];
    }else if (indexPath.row%5==2){
       cell.backgroundColor = [UIColor blueColor];
    }else if (indexPath.row%5==3){
       cell.backgroundColor = [UIColor brownColor];
    }else if (indexPath.row%5==4){
       cell.backgroundColor = [UIColor purpleColor];
    }
    return cell;
}

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    CollectionHeaderView *resuleview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    resuleview.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.4];
    return resuleview;
}


@end
