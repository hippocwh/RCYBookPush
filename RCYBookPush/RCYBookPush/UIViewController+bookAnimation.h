//
//  UIViewController+bookAnimation.h
//  RCYBookPush
//
//  Created by hcwh on 2019/2/18.
//  Copyright © 2019年 huchengwenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (bookAnimation)

@property (nonatomic, strong) __kindof UIView *bookCoverView;

@property (nonatomic, assign) Class targetClass;

@property (nonatomic, assign) UINavigationControllerOperation bookAnimateOperation;

@property (nonatomic, copy) void (^bookPushBlock)(void);

- (void)appendTapActionWithTargetView:(__kindof UIView *)targetView;

- (void)appendEdgePanActionWithDirection:(UIRectEdge)direction;

@end

NS_ASSUME_NONNULL_END
