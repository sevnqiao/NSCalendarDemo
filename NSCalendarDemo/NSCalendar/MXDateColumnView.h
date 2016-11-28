//
//  MXDateColumnView.h
//  MXCustomView
//
//  Created by IOS_HMX on 15/7/7.
//  Copyright (c) 2015年 IOS_HMX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MXDateColumnView;
/**
 *  日历类型
 */
typedef NS_OPTIONS(NSUInteger, MXDateColumnViewType){
    /**
     *  无
     */
    MXDateColumnViewTypeNone         =0,
    /**
     *  代办事项
     */
    MXDateColumnViewTypeCommission   =1 << 0,
    /**
     *  经济日历
     */
    MXDateColumnViewTypeEconomic     =1 << 1,
    /**
     *  业务节点
     */
    MXDateColumnViewTypeBusiness     =1 << 2,
    
};
typedef NS_ENUM(NSUInteger, MXDateColumnViewColorStyle){
    /**
     *  正常白色
     */
    MXDateColumnViewColorStyleWhite   ,
    /**
     *  双休灰色
     */
    MXDateColumnViewColorStyleGray    ,
    /**
     *  暗黑
     */
    MXDateColumnViewColorStyleDark
    
};
/**
 *  日期view 代理
 */
@protocol MXDateColumnViewDelegate <NSObject>

@optional
/**
 *  点击选择日期事件代理
 */
-(void)didSelectedDateColumnView:(MXDateColumnView *)dateColumnView;

@end
/**
 *  日期view
 */
@interface MXDateColumnView : UIView
/**
 *  绘制边界
 */
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
/**
 *  日期里包含的 日历事件类型
 */
@property (nonatomic, assign) MXDateColumnViewType columnType;
/**
 *  日期数值颜色 （双休日 工作日 颜色不同）
 */
@property (nonatomic, assign) MXDateColumnViewColorStyle colorStyle;
/**
 *  是否是选中状态
 */
@property (nonatomic, assign) BOOL selected;
/**
 *  view所对应的时间
 */
@property (nonatomic, strong) NSDate *date;
/**
 *  date 所对应的 day
 */
@property (nonatomic, assign) NSInteger day;
/**
 *  代理
 */
@property (nonatomic, assign) id<MXDateColumnViewDelegate>delegate;
@end
