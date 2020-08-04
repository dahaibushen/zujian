//
//  CollectionViewFlowLayout.m
//  Collection_HeaderVIew_Demo
//
//  Created by hu on 2020/8/3.
//  Copyright © 2020 hu. All rights reserved.
//

#import "CollectionViewFlowLayout.h"

@interface CollectionViewFlowLayout ()

@property (nonatomic, assign) NSInteger leastSectionNum;
@property (nonatomic, strong) UIDynamicAnimator *animator;

@end

@implementation CollectionViewFlowLayout

-(id)init {
    if ([super init]) {
        _springDamping = 0.5;
        _springFrequency = 0.8;
        _resistanceFactor = 500;
    }
    return self;
}

-(void)setSpringDamping:(CGFloat)springDamping {
    if (springDamping >= 0 && _springDamping != springDamping) {
        _springDamping = springDamping;
        for (UIAttachmentBehavior *spring in _animator.behaviors) {
            spring.damping = _springDamping;
        }
    }
}

-(void)setSpringFrequency:(CGFloat)springFrequency {
    if (springFrequency >= 0 && _springFrequency != springFrequency) {
        _springFrequency = springFrequency;
        for (UIAttachmentBehavior *spring in _animator.behaviors) {
            spring.frequency = _springFrequency;
        }
    }
}

-(void)prepareLayout {
    [super prepareLayout];
    
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
        CGSize contentSize = [self collectionViewContentSize];
        NSArray *items = [super layoutAttributesForElementsInRect:CGRectMake(0, 0, contentSize.width, contentSize.height)];
        
        for (UICollectionViewLayoutAttributes *item in items) {
            UIAttachmentBehavior *spring = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:item.center];
            
            spring.length = 0;
            spring.damping = self.springDamping;
            spring.frequency = self.springFrequency;
            
            [_animator addBehavior:spring];
        }
    }
}

//rect区域 所有的attributes
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [_animator itemsInRect:rect];
}

//返回indexPath上元素的布局
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [_animator layoutAttributesForCellAtIndexPath:indexPath];
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    UIScrollView *scrollView = self.collectionView;
    CGFloat scrollDelta = newBounds.origin.y - scrollView.bounds.origin.y;
    CGPoint touchLocation = [scrollView.panGestureRecognizer locationInView:scrollView];
    
    
    for (UIAttachmentBehavior *spring in _animator.behaviors) {
        CGPoint anchorPoint = spring.anchorPoint;
        
        CGFloat distanceFromTouch = fabsf(touchLocation.y - anchorPoint.y);
        
//        UICollectionViewLayoutAttributes *itemAttributes = [spring.items firstObject];
//        NSLog(@"sdsdsd-----touchY:%f  archpoint:%f  indexRow:%ld indexSec:%ld disFromTouch:%f",touchLocation.y,anchorPoint.y,itemAttributes.indexPath.row,itemAttributes.indexPath.section,(touchLocation.y - anchorPoint.y));
        
        CGFloat scrollResistance =  distanceFromTouch / self.resistanceFactor;
//        NSLog(@"sdsdsdsd------scRerate:%f   index:%@",scrollResistance,itemAttributes.indexPath);
        UICollectionViewLayoutAttributes *item = [spring.items firstObject];
        if (item.indexPath.section == 0 &&item.indexPath.row == 0) {
            NSLog(@"sdsdsdsdsd----:%f",distanceFromTouch);
        }
        CGPoint center = item.center;
        center.y += (scrollDelta > 0) ? MIN(scrollDelta, scrollDelta * scrollResistance)
                                      : MAX(scrollDelta, scrollDelta * scrollResistance);
        
        item.center = center;
        
        
        [_animator updateItemUsingCurrentState:item];
    }
    //test
    return YES;
    //test
    return NO;
}


@end
