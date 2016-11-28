//
//  MXDateColumnView.m
//  MXCustomView
//
//  Created by IOS_HMX on 15/7/7.
//  Copyright (c) 2015年 IOS_HMX. All rights reserved.
//

#import "MXDateColumnView.h"
#import "UIColor+Additions.h"
#import "NSDate+Additions.h"
static const CGFloat kLayerHeight = 3.;
//static const CGFloat kLayerRadius = 2.;
//static NSString *const kLayerName1  = @"Commission";
//static NSString *const kLayerName2  = @"Economic";
//static NSString *const kLayerName3  = @"Business";


@interface MXDateColumnView ()
@property(nonatomic,strong)UIButton *numberButton;
@property(nonatomic,strong)CALayer *backLayer;
@end
@implementation MXDateColumnView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self configView];
        //self.columnType = MXDateColumnViewTypeNone;
    }
    return self;
}
-(void)configView
{
    [self addSubview:self.numberButton];
    [self.layer addSublayer:self.backLayer];
}
-(void)layoutSubviews
{
    CGFloat posX = _edgeInsets.left;
    CGFloat posY = _edgeInsets.top;
    self.numberButton.frame = CGRectMake(posX, posY, CGRectGetWidth(self.frame)-_edgeInsets.left - _edgeInsets.right, CGRectGetWidth(self.frame)-_edgeInsets.left - _edgeInsets.right);

    posY = CGRectGetHeight(self.frame)- kLayerHeight - _edgeInsets.bottom;
    CGFloat width = CGRectGetWidth(self.frame) - _edgeInsets.left - _edgeInsets.right;
    _backLayer.frame = CGRectMake(posX, posY, width, kLayerHeight);
    
    [self layoutLayers];
}
#pragma mark - private
-(UIColor *)getButtonTitleColor
{
    if (self.selected) {
        return COLOR(@"#2e73ce");
    }
    if (_colorStyle == MXDateColumnViewColorStyleWhite) {
        return [UIColor whiteColor];
    }else if(_colorStyle == MXDateColumnViewColorStyleGray)
    {
        return [UIColor colorWithWhite:1 alpha:0.5];
    }else
    {
        return COLOR_ALPHA(@"#133158", 0.3);
    }
}
-(void)layoutLayers
{
    NSArray *array = self.backLayer.sublayers;
    if (array == nil || array.count == 0) {
        return;
    }
    CGFloat posX = 0.0;
    CGFloat posY = 0.0;
    CGFloat width = 0.0;

    if (array.count == 1) {
        CALayer *layer = [array objectAtIndex:0];
        width = CGRectGetWidth(self.backLayer.frame) ;
        layer.frame = CGRectMake(posX, posY, width, kLayerHeight);
    }else if (array.count == 2)
    {
        CALayer *layer1 = [array objectAtIndex:0];
        CALayer *layer2 = [array objectAtIndex:1];
        width = CGRectGetWidth(self.backLayer.frame)/2;
        layer1.frame = CGRectMake(posX, posY, width, kLayerHeight);
        layer2.frame = CGRectMake(CGRectGetMaxX(layer1.frame), posY, width, kLayerHeight);
    }else if (array.count == 3)
    {
        CALayer *layer1 = [array objectAtIndex:0];
        CALayer *layer2 = [array objectAtIndex:1];
        CALayer *layer3 = [array objectAtIndex:2];
        width = CGRectGetWidth(self.backLayer.frame)/3;
        layer1.frame = CGRectMake(posX, posY, width, kLayerHeight);
        layer2.frame = CGRectMake(CGRectGetMaxX(layer1.frame), posY, width, kLayerHeight);
        layer3.frame = CGRectMake(CGRectGetMaxX(layer2.frame), posY, width, kLayerHeight);
    }
    
}
-(void)clickAction:(UIButton *)button
{
    if (self.selected) {
        return;
    }else
    {
        self.selected = YES;
        if (self.delegate&&[self.delegate respondsToSelector:@selector(didSelectedDateColumnView:)]) {
            [self.delegate didSelectedDateColumnView:self];
        }
    }
}
#pragma mark - get and set
-(void)setSelected:(BOOL)selected
{
    _selected  = selected;
    if (selected) {
        self.numberButton.layer.cornerRadius = (CGRectGetWidth(self.frame)-_edgeInsets.left - _edgeInsets.right)/2;
        self.numberButton.layer.masksToBounds = YES;
        self.numberButton.backgroundColor = [UIColor whiteColor];
        [_numberButton setTitleColor:COLOR(@"#2e73ce") forState:UIControlStateNormal];
    }else
    {
        self.numberButton.layer.cornerRadius = 0;
        self.numberButton.layer.masksToBounds = NO;
        self.numberButton.backgroundColor = [UIColor clearColor];
        [_numberButton setTitleColor:[self getButtonTitleColor] forState:UIControlStateNormal];
    }
    
}
-(void)setColorStyle:(MXDateColumnViewColorStyle)colorStyle
{
    _colorStyle = colorStyle;
    [self.numberButton setTitleColor:[self getButtonTitleColor] forState:UIControlStateNormal];
}
-(void)setDay:(NSInteger)day
{
    _day = day;
    [self.numberButton setTitle:[NSString stringWithFormat:@"%ld",day] forState:UIControlStateNormal];
}
-(void)setDate:(NSDate *)date
{
    _date = date;
    //self.day = [_date getDayOfTheDate];
    self.day = [[date.description substringWithRange:NSMakeRange(8, 2)]intValue];
    
}
-(void)setColumnType:(MXDateColumnViewType)columnType
{
    NSArray * array = [NSArray arrayWithArray: self.backLayer.sublayers];
    for (CALayer *layer in array) {
        [layer removeFromSuperlayer];
    }
    if ((columnType) == MXDateColumnViewTypeNone) {
        return ;
    }
    if ((columnType & MXDateColumnViewTypeCommission) == MXDateColumnViewTypeCommission) {
        CALayer *layer = [CALayer layer];
        layer.backgroundColor =RGB_COLOR(246, 90, 86).CGColor;
        [self.backLayer addSublayer:layer];
    }
    if ((columnType & MXDateColumnViewTypeEconomic) == MXDateColumnViewTypeEconomic) {
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = RGB_COLOR(251, 188, 25).CGColor;
        [self.backLayer addSublayer:layer];
    }
    if ((columnType & MXDateColumnViewTypeBusiness) == MXDateColumnViewTypeBusiness) {
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = RGB_COLOR(79, 218, 155).CGColor;
        [self.backLayer addSublayer:layer];
    }
    [self layoutLayers];
}
-(UIButton *)numberButton
{
    if (!_numberButton) {
        _numberButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _numberButton.backgroundColor = [UIColor clearColor];
        [_numberButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _numberButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_numberButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _numberButton;
}
-(CALayer *)backLayer
{
    if (!_backLayer) {
        _backLayer = [CALayer layer];
        _backLayer.backgroundColor = [UIColor clearColor].CGColor;
        _backLayer.cornerRadius = kLayerHeight/2;
        _backLayer.masksToBounds = YES;
    }
    return _backLayer;
}
@end
