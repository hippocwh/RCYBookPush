//
//  UIViewController+transition.h
//  RCYBookPush
//
//  Created by hcwh on 2019/2/19.
//  Copyright © 2019年 huchengwenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 只需要import这个category，就可以通过实现UINavigationControllerDelegate这个代理来新建动画
 */
@protocol transitionGestureDelegate <NSObject>
@optional
- (void)transitionGesturePush;

- (void)transitionGesturePop;

@end

@interface UIViewController (transition)

@property (nonatomic, assign) Class targetClass;

@property (nonatomic, assign) UINavigationControllerOperation transitionOperation;

/**
 当需要添加下面的两个手势时，需要实现这个delegate（若只是简单的push,pop的话可以不实现）
 */
@property (nonatomic, weak) id<transitionGestureDelegate> transitionGestureDelegate;

- (UITapGestureRecognizer *)appendTapActionWithTargetView:(__kindof UIView *)targetView;

- (UIScreenEdgePanGestureRecognizer *)appendEdgePanActionWithDirection:(UIRectEdge)direction;

@end

NS_ASSUME_NONNULL_END
