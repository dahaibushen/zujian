//
//  CollectionViewFlowLayout.h
//  Collection_HeaderVIew_Demo
//
//  Created by hu on 2020/8/3.
//  Copyright © 2020 hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) CGFloat springDamping;
@property (nonatomic, assign) CGFloat springFrequency;
@property (nonatomic, assign) CGFloat resistanceFactor;

@end

NS_ASSUME_NONNULL_END
