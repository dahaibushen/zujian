//
//  JDLivePlayer.h
//  JDPlayer
//
//  Created by NULL on 2016/12/19.
//  Copyright © 2016年 NULL. All rights reserved.
//

// 直播控制器

#import <UIKit/UIKit.h>
#import "JDVRProductModelProtocol.h"

static NSString *JDLivePlayerFormatOptionKey = @"format";
static NSString *JDLivePlayerCodecOptionKey = @"codec";
static NSString *JDLivePlayerSwsOptionKey = @"sws";
static NSString *JDLivePlayerPlayerOptionKey = @"player";

// 日志输出级别
typedef enum JDLogLevel {
    k_JD_LOG_UNKNOWN = 0,
    k_JD_LOG_DEFAULT = 1,
    
    k_JD_LOG_VERBOSE = 2,
    k_JD_LOG_DEBUG   = 3,
    k_JD_LOG_INFO    = 4,
    k_JD_LOG_WARN    = 5,
    k_JD_LOG_ERROR   = 6,
    k_JD_LOG_FATAL   = 7,
    k_JD_LOG_SILENT  = 8,
} JDLogLevel;

//播放状态
typedef NS_ENUM(NSInteger, JDPlayerPlayState) {
    JDPlayerPlayStatePrepareUnknow = -1,    //未知状态不会调用 状态改变回调方法
    JDPlayerPlayStatePreparing = 0,         //准备播放中
    JDPlayerPlayStatePrepareDone,           //准备结束
    JDPlaybackStatePreparedError,           //准备出错
    JDPlayerPlayStateStopped,               //播放停止
    JDPlayerPlayStatePlaying,               //播放中
    JDPlayerPlayStatePaused,                //播放暂停
    JDPlayerPlayStateInterrupted,           //播放中断
    JDPlayerPlayStateDidFinish,             //播放结束
    JDPlayerPlayStateGetVideoSize,          //视频源Size
    JDPlayerPlayStateRenderFirstPic,        //获取到第一帧
    JDPlayerPlayStateBufferStart,           //开始缓冲
    JDPlayerPlayStateBufferEnd,             //缓冲结束
    JDPlayerPlayStateSeekComplete,          //seek结束
    JDPlayerPlayStateNoStream = 100,        //无码流
    JDPlayerPlayStatePlayError,             //播放出错
    JDPlayerPlayStateSeekingForward,        //回放向前播放
    JDPlayerPlayStateSeekingBackward,       //回放向后播放
    JDPlayerPlayStateNotStarted             //直播未开始
};

// 视频缩放模式
typedef NS_ENUM(NSInteger, JDPlayerContentMode) {
    JDPlayerContentModeNone,
    JDPlayerContentModeAspectFit,
    JDPlayerContentModeAspectFill,
    JDPlayerContentModeFill
};


typedef NS_ENUM(NSInteger, JDPlayerSourceType) {
    JDPlayerSourceTypeDefaults,             // 默认模式
    JDPlayerSourceTypeVRPanoram,            // 全景模式
    JDPlayerSourceTypeVR,                   // 双目模式
};

typedef NS_ENUM(NSInteger, JDPlayerVRPlayerStructType) {
    JDPlayerVRPlayerStructType360 = 0,             // 360度VR直播
    JDPlayerVRPlayerStructType180,             // 180度VR直播
};

typedef NS_ENUM(int, JDPlayerCodecCoreType) {
    JDPlayerCodecCoreTypeUndefine = 0,
    JDPlayerCodecCoreTypeCustomPlayer = 1,
    JDPlayerCodecCoreTypeAVPlayer = 2
};

// 延时过长，主动丢弃部分包，采取的轮询模式
typedef NS_ENUM(NSInteger, JDPlayerDropFormatMode) {
    JDPlayerDropFormatModeGop,              //gop 轮询模式
    JDPlayerDropFormatModeDuration          //固定时长轮询模式
};


@class JDLivePlayer;
@protocol JDLivePlayerDelegate <NSObject>

/**
 播放状态改变

 @param player 播放控制器
 @param playState 当前播放状态
 @param error 错误信息，如果没有出错 error=nil
 */
- (void)player:(JDLivePlayer *)player playStateChanged:(JDPlayerPlayState)playState error:(id)error;

/*播放器播放时间回调*/
- (void)player:(JDLivePlayer *)player
        position:(int64_t)position
   cacheDuration:(int64_t)cacheDuration
        duration:(int64_t)duration;


/**
 播放器主动触发丢帧逻辑回调

 @param player 播放器
 @param audioCacheDuration 音频总缓存时长
 @param audioDropDuration 音频丢弃时长
 @param videoCacheDuration 视频总缓存时长
 @param videoDropDuration 视频丢弃时长
 */
- (void)player:(JDLivePlayer *)player dropFrameWithAudioCacheDuration:(int64_t )audioCacheDuration
                                                    audioDropDuration:(int64_t)audioDropDuration
                                                    videoCacheDuration:(int64_t)videoCacheDuration
                                                    videoDropDuration:(int64_t)videoDropDuration;

@end


@interface JDLivePlayer : NSObject<JDVRProductModelProtocol>

@property (nonatomic, weak) id<JDLivePlayerDelegate>        delegate;               // 代理
@property (nonatomic, weak) id<JDVRProductModelDelegate>    productModelDelegate;   // 商品模型代理
@property (nonatomic, readonly) NSString                    *urlString;             // 当前播放视频url
@property (nonatomic, weak, readonly) UIView                *view;                  // 承载视频的View
@property(nonatomic, assign) JDPlayerContentMode            contentMode;            // 播放View的显示模式
@property(nonatomic, assign) BOOL                           shouldAutoplay;         // 是否自动播放

@property (nonatomic, assign, readonly) JDPlayerPlayState   playState;              // 播放状态
@property (nonatomic, assign) JDPlayerSourceType            sourceType;             // 播放源类型
@property (nonatomic, assign) JDPlayerVRPlayerStructType    VRStructType;           // VR直播类型 默认360度，可切换180度

@property (nonatomic, assign, readonly) NSTimeInterval      currentPlaybackTime;    // 当前播放时间
@property(nonatomic, readonly) NSTimeInterval               duration;               // 总时长
@property(nonatomic, readonly) NSTimeInterval               playableDuration;       // 可以播放的时长
@property(nonatomic, readonly) NSInteger                    bufferingProgress;      // 缓存比例


@property(nonatomic, readonly) CGSize                       naturalSize;            // 视频宽高
@property (nonatomic, assign, readonly) float               playbackRate;           // 播放速率
@property (nonatomic, assign, readonly) float               playbackVolume;         // 播放音量

@property(nonatomic, readonly) CGFloat                      fpsInMeta;
@property(nonatomic, readonly) CGFloat                      fpsAtOutput;

@property (nonatomic, assign, readonly) JDPlayerCodecCoreType         codecCoreType;          //播放内核type，如果在注册前未指定(undefine)，则在注册完毕后自动选择JDPlayerCodecCoreType

@property (nonatomic, assign) NSTimeInterval maxCachedDuration;                     // 允许的最大缓冲时长,单位（s）默认3S
@property (nonatomic, assign) NSTimeInterval maxCachedDurationAfterDrop;                     // 允许丢完帧后最大的缓存时长 单位(s) 默认0
@property (nonatomic, assign) JDPlayerDropFormatMode dropFormatMode;                // 丢帧轮询模式，用于超时过长采取哪种轮询模式(默认采用GOP)
@property (nonatomic, assign) NSTimeInterval dropFormatOpenStartTime;               // 丢帧策略开始时间,单位(s),打开直播多长时间后开始丢帧策略，避免直播一开始就触发丢帧导致卡顿 默认0
@property (nonatomic, assign) NSTimeInterval dropFormatSpaceTime;                   // 丢帧策略触发最小时间间隔 单位(s)默认3s

//缓冲高低水位设置
@property (nonatomic, assign) NSTimeInterval startBufferDuration;                   // 缓冲开始的低水位 单位(s)默认0.1s
@property (nonatomic, assign) NSTimeInterval endBufferDuration;                     // 缓冲结束的高水位 单位(s)默认1s

//点播缓冲区最大水位设置,缓冲到最大水位停止缓冲
@property (nonatomic, assign) NSTimeInterval maxCacheSizeForAVPlayer;               // 点播缓冲区最大水位设置,缓冲到最大水位停止缓冲,单位（M）默认2.5M(直播的时候设置该参数无效)

@property (nonatomic, assign) BOOL           disableSensor;                         // 仅VR模式有效。是否禁用陀螺仪，默认否。禁用陀螺仪时开启手势

@property (nonatomic, assign) BOOL           tcpOpen;                               //tcp连接是否成功
/* 播放前需要先调用该方法注册播放器 */
//- (BOOL) registerWithURLString:(NSString *) urlString completion:(void (^)(BOOL result))completion;
/* 异步方法需要等待block回调后才能进行其他操作 销毁播放器前，或重新注册前需要调用该方法*/
//- (BOOL) unregister;
//切换码率接口
//- (BOOL) switchSelectStreamRateItem:(LECStreamRateItem *) selectStreamRateItem;
//- (BOOL) switchSelectStreamRateItem:(LECStreamRateItem *) selectStreamRateItem completion:(void (^)())completion;
////检测某操作是否可以进行
//- (BOOL) canDoOperation:(LECPlayerPlayOperation) playOperation;

#pragma mark - 构造方法

/* options: 外部传入的option设置  示例:
                                  @{JDLivePlayerFormatOptionKey:@{// format相关option},    
                                    JDLivePlayerCodecOptionKey:@{// code相关option},
                                    JDLivePlayerSwsOptionKey:@{// sws相关option},                                     
                                    JDLivePlayerPlayerOptionKey:@{// player相关option}}
 */

- (instancetype)initWithURL:(NSString *)urlString
                    options:(NSDictionary *)options
              codecCoreType:(JDPlayerCodecCoreType)coreType
                   delegate:(id<JDLivePlayerDelegate>)delegate
                 completion:(void (^)(BOOL))completion;

+ (instancetype)playerWithURL:(NSString *)urlString
                      options:(NSDictionary *)options
                codecCoreType:(JDPlayerCodecCoreType)coreType
                     delegate:(id<JDLivePlayerDelegate>)delegate
                   completion:(void (^)(BOOL))completion;

- (void)registerWithURLString:(NSString *)urlString
                      options:(NSDictionary *)options
                codecCoreType:(JDPlayerCodecCoreType)coreType
                     delegate:(id<JDLivePlayerDelegate>)delegate
                   completion:(void (^)(BOOL result))completion;

#pragma mark - Control method

/**
 准备播放 是个异步的过程，能提高视频初载速度
 */
- (void)prepareToPlay;
- (void)prepareWithCompletion:(void (^)(BOOL))completion;

/**
 播放
 */
- (void)play;
- (void)playWithCompletion:(void (^)())completion;

/**
 暂停
 */
- (void)pause;

/**
 停止
 */
- (void)stop;
- (void)stopWithCompletion:(void (^)())completion;

/**
 是否正在播放

 @return 是否正在播放
 */
- (BOOL)isPlaying;

/**
 seek到视频相应位置

 @param position 拖拽到的位置
 */
- (void)seekToPosition:(NSTimeInterval)position;
- (void)seekToPosition:(NSInteger) position completion:(void (^)())completion;

#pragma mark - Set Option

- (void)setFormatOptionValue:       (NSString *)value forKey:(NSString *)key;
- (void)setCodecOptionValue:        (NSString *)value forKey:(NSString *)key;
- (void)setSwsOptionValue:          (NSString *)value forKey:(NSString *)key;
- (void)setPlayerOptionValue:       (NSString *)value forKey:(NSString *)key;

/**
 恢复播放接口

 @return 是否成功恢复播放
 */
- (BOOL)resume;

/**
 完全退出
 */
- (void)shutdown;

/**
 设置退入后台时 是否暂停 默认YES

 @param pause 暂停
 */
- (void)setPauseInBackground:(BOOL)pause;

/**
 设置回到前台时 是否重新开始播放 默认YES
 
 @param autoPlayAfterInterrupt 重新开始播放
 */
- (void)setAutoPlayAfterInterrupt:(BOOL)autoPlayAfterInterrupt;


/**
 展示hudView 用于调试 在debug模式下可用 release模式下设置无效

 @param showHudView 是否展示hudView
 */
- (void)showHudView:(BOOL)showHudView;

/**
  获得当前截屏

 @return 返回截屏图片对象
 */
- (UIImage *)thumbnailImageAtCurrentTime;


#pragma mark - Log Set
// 日志打印开关
+ (void)setLogReport:(BOOL)preferLogReport;
// 设置打印等级。优先级低的日志将不会打印
+ (void)setLogLevel:(JDLogLevel)logLevel;


#pragma mark - NetWork Speed
- (int64_t)getNewtWorkSpeed;


@end
