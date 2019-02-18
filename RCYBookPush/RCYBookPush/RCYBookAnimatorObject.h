//
//  RCYBookAnimatorObject.h
//  RCYBookPush
//
//  Created by hcwh on 2019/1/29.
//  Copyright © 2019年 huchengwenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCYBookAnimatorObject : NSObject

+ (id<UIViewControllerAnimatedTransitioning>)objectWithBookCoverView:(__kindof UIView *)bookCoverView animationControllerForOperation:(UINavigationControllerOperation)operation;

@end

NS_ASSUME_NONNULL_END
