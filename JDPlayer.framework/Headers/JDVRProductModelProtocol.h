//
//  JDVRProductModelProtocol.h
//  JDPlayer
//
//  Created by cjw-macPro on 2017/3/20.
//  Copyright © 2017年 NULL. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,JDVRProductModelMessageType){
    JDVRProductModelMessageTypeUnKnown = -1,
    JDVRProductModelMessageTypeAddCartSuccess = 1,//加购物车成功
    JDVRProductModelMessageTypeAddCartFail = 0,//加购物车失败
    JDVRProductModelMessageTypeAddCartFull = 2//加购物车已满
};

@protocol JDVRProductModelProtocol <NSObject>

/**
 关闭商品模型
 
 @param skuId 商品id
 */
- (void)closeProductModel:(NSString *)skuId;


/**
 加载商品模型

 @param skuId 商品id
 @param path 模型zip包路径
 @param skuName 商品名称
 @param price 商品价格
 */
- (void)loadProductModel:(NSString *)skuId path:(NSString *)path skuName:(NSString *)skuName price:(NSString *)price;

/**
 商品模型消息推送（业务方-->sdk）

 @param messageType 消息类型
 @param skuId 商品id
 */
- (void)pushProdutcMessage:(JDVRProductModelMessageType)messageType skuId:(NSString *)skuId;

@end

@protocol JDVRProductModelDelegate <NSObject>

/**
 加入购物车(业务方传入加入购物车方法供sdk调用)

 @param skuId 商品id
 */
- (void)addToCart:(NSString *)skuId;

/**
 模型关闭(商品模型关闭以后回调用的业务方法)

 @param skuId 商品id
 */
- (void)productModelClosed:(NSString *)skuId;

/**
 返回(未知)
 */
- (void)onBack;

@end








