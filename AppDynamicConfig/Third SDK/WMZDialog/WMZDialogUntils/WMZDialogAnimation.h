//
//  WMZDialogAnimation.h
//  WMZDialog
//
//  Created by wmz on 2019/9/11.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "WMZDialogMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface WMZDialogAnimation : NSObject

@property (nonatomic, copy) AnimalBlock block;
/// 淡入
- (void)curverOnAnimationWithView:(UIView*)view duration:(NSTimeInterval)duration;
/// 淡出
- (void)curverOffAnimationWithView:(UIView*)view duration:(NSTimeInterval)duration;
/// 由小变大
- (void)zoomInAnimationWithView:(UIView*)view duration:(NSTimeInterval)duration;
/// 由大变小
- (void)zoomOutAnimationWithView:(UIView*)view duration:(NSTimeInterval)duration;
/// 逆时针
- (void)rotationClockwiseAnimationWithView:(UIView*)view duration:(NSTimeInterval)duration;
/// 顺时针
- (void)rotationCounterclockwiseAnimationWithView:(UIView*)view duration:(NSTimeInterval)duration;
/// 出现组合动画 样式1
- (void)combineShowOneAnimationWithView:(UIView*)view duration:(NSTimeInterval)duration;
/// 出现组合动画 样式2
- (void)combineShowTwoAnimationWithView:(UIView*)view duration:(NSTimeInterval)duration;
/// 消失组合动画 样式1
- (void)combineHideOneAnimationWithView:(UIView*)view duration:(NSTimeInterval)duration;
/// 先放大后恢复
- (void)scaleShowAninationWithView:(UIView*)view duration:(NSTimeInterval)duration;
/// 放大
- (void)scaleHideAninationWithView:(UIView*)view duration:(NSTimeInterval)duration;
/// 垂直移动出现
- (void)verticalMoveShowAnimationWithView:(UIView*)view duration:(NSTimeInterval)duration top:(BOOL)top;
/// 垂直移移动消失
- (void)verticalMoveHideAnimationWithView:(UIView*)view duration:(NSTimeInterval)duration top:(BOOL)top;
/// 横向移动
- (void)landscapeMoveShowAnimationWithView:(UIView*)view duration:(NSTimeInterval)duration right:(BOOL)right;
/// 横向移动消失
- (void)landscapeMoveHideAnimationWithView:(UIView*)view duration:(NSTimeInterval)duration  right:(BOOL)right;
/// 大到小-小到大
- (void)zoomInBigToNormalAnimationWithView:(UIView*)view duration:(NSTimeInterval)duration;
/// 逆时针消失
- (void)rotationDisappealClockwiseAnimationWithView:(UIView*)view duration:(NSTimeInterval)duration;
/*
 *阻尼动画 出现的弹簧运动
 @prarm subView 带有子视图的数组
 @prarm kColumnCount 列
 @prarm kSectionCount 行
 @prarm vMarginY 上下间距
 @prarm vSpacingY item之间的Y轴间距
 @prarm vMarginX 左右间距
 @prarm vSpacingX item之间的X轴间距
 @prarm hideFirstPageView 是否做弹簧动画
 @prarm block 动画完成回调
 */
void springShowAnimation(UIScrollView *scrollView,NSTimeInterval duration,NSArray *subView,NSInteger kColumnCount,NSInteger kSectionCount,CGFloat vMarginY,CGFloat vSpacingY,CGFloat vMarginX,CGFloat vSpacingX,bool hideFirstPageView,AnimalBlock block);
/// 阻尼动画 消失的弹簧运动
void springHideAnimation(UIScrollView *scrollView,NSTimeInterval duration,NSArray *subView,AnimalBlock block);
/// 加载
void loadingAnimation(UIView* view,NSTimeInterval duration,UIColor *color,CGFloat width);
/// loading动画
void newLoadingAnimation(UIView* view,CAShapeLayer *lineLayer,NSTimeInterval duration);

@end

NS_ASSUME_NONNULL_END
