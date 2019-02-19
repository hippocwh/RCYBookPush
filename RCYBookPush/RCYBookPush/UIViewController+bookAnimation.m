//
//  UIViewController+bookAnimation.m
//  RCYBookPush
//
//  Created by hcwh on 2019/2/18.
//  Copyright © 2019年 huchengwenhao. All rights reserved.
//

#import "UIViewController+bookAnimation.h"
#import "RCYBookAnimatorObject.h"
#import <objc/runtime.h>

@interface UIViewController () <UINavigationControllerDelegate>

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentInteractiveTransition;
@property (nonatomic, assign) UIRectEdge direction;

@end

@implementation UIViewController (bookAnimation)

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
    if ([toVC isKindOfClass:self.targetClass] && self.transitionOperation == operation) {
        if (operation == UINavigationControllerOperationPush) {
            toVC.bookCoverView = self.bookCoverView;
        }
        return [RCYBookAnimatorObject objectWithBookCoverView:self.bookCoverView animationControllerForOperation:operation];
    }
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    if ([animationController isKindOfClass:[RCYBookAnimatorObject class]]) {
        return self.percentInteractiveTransition;
    }
    else {
        return nil;
    }
}

#pragma mark - setter & getter
- (__kindof UIView *)bookCoverView {
    return objc_getAssociatedObject(self, @selector(bookCoverView));
}

- (void)setBookCoverView:(__kindof UIView *)bookCoverView {
    objc_setAssociatedObject(self, @selector(bookCoverView), bookCoverView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
