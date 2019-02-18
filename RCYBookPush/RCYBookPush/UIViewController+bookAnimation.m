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

- (Class)targetClass {
    return objc_getAssociatedObject(self, @selector(targetClass));
}

- (void)setTargetClass:(Class)targetClass {
    objc_setAssociatedObject(self, @selector(targetClass), targetClass, OBJC_ASSOCIATION_ASSIGN);
}

- (UINavigationControllerOperation)bookAnimateOperation {
    NSNumber *operation = objc_getAssociatedObject(self, @selector(bookAnimateOperation));
    return [operation integerValue];
}

- (void)setBookAnimateOperation:(UINavigationControllerOperation)bookAnimateOperation {
    objc_setAssociatedObject(self, @selector(bookAnimateOperation), @(bookAnimateOperation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (__kindof UIView *)bookCoverView {
    return objc_getAssociatedObject(self, @selector(bookCoverView));
}

- (void)setBookCoverView:(__kindof UIView *)bookCoverView {
    objc_setAssociatedObject(self, @selector(bookCoverView), bookCoverView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIPercentDrivenInteractiveTransition *)percentInteractiveTransition {
    return objc_getAssociatedObject(self, @selector(percentInteractiveTransition));
}

- (void)setPercentInteractiveTransition:(UIPercentDrivenInteractiveTransition *)percentInteractiveTransition {
    objc_setAssociatedObject(self, @selector(percentInteractiveTransition), percentInteractiveTransition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIRectEdge)direction {
    return [objc_getAssociatedObject(self, @selector(direction)) integerValue];
}

- (void)setDirection:(UIRectEdge)direction {
    objc_setAssociatedObject(self, @selector(direction), @(direction), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)appendTapActionWithTargetView:(__kindof UIView *)targetView {
    targetView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture;
    switch (self.bookAnimateOperation) {
        case UINavigationControllerOperationPush:
        {
            tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToNextViewController)];
            [targetView addGestureRecognizer:tapGesture];
            break;
        }
        case UINavigationControllerOperationPop:
        {
            tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popToFromViewController)];
            [targetView addGestureRecognizer:tapGesture];
            break;
        }
        default:
            break;
    }
    
}

- (void)appendEdgePanActionWithDirection:(UIRectEdge)direction {
    self.view.userInteractionEnabled = YES;
    self.direction = direction;
    UIScreenEdgePanGestureRecognizer *edgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanAction:)];
    edgePanGesture.edges = self.direction;
    [self.view addGestureRecognizer:edgePanGesture];
}

- (void)edgePanAction:(UIScreenEdgePanGestureRecognizer *)recognizer {
    CGFloat progress = [recognizer translationInView:self.view].x / self.view.bounds.size.width;
    if (self.direction == UIRectEdgeRight) {
        progress = -progress;
    }
    progress = MIN(1.0, MAX(0.0, progress));
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.percentInteractiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        switch (self.bookAnimateOperation) {
            case UINavigationControllerOperationPush:
            {
                [self pushToNextViewController];
                break;
            }
            case UINavigationControllerOperationPop:
            {
                [self popToFromViewController];
                break;
            }
            default:
                break;
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        [self.percentInteractiveTransition updateInteractiveTransition:progress];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        if (progress > 0.5) {
            [self.percentInteractiveTransition finishInteractiveTransition];
        }
        else {
            [self.percentInteractiveTransition cancelInteractiveTransition];
        }
        self.percentInteractiveTransition = nil;
    }
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
    if ([toVC isKindOfClass:self.targetClass]) {
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

/**
 下面两个方法由主类实现
 */
- (void)pushToNextViewController {
    
}

- (void)popToFromViewController {
    
}

@end
