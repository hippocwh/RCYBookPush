//
//  UIViewController+transition.m
//  RCYBookPush
//
//  Created by hcwh on 2019/2/19.
//  Copyright © 2019年 huchengwenhao. All rights reserved.
//

#import "UIViewController+transition.h"

#import <objc/runtime.h>

@interface UIViewController () <UINavigationControllerDelegate>

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentInteractiveTransition;
@property (nonatomic, assign) UIRectEdge direction;

@end

@implementation UIViewController (transition)

- (UITapGestureRecognizer *)appendTapActionWithTargetView:(__kindof UIView *)targetView {
    targetView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture;
    switch (self.transitionOperation) {
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
    return tapGesture;
}

- (UIScreenEdgePanGestureRecognizer *)appendEdgePanActionWithDirection:(UIRectEdge)direction {
    self.view.userInteractionEnabled = YES;
    self.direction = direction;
    UIScreenEdgePanGestureRecognizer *edgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanAction:)];
    edgePanGesture.edges = self.direction;
    [self.view addGestureRecognizer:edgePanGesture];
    return edgePanGesture;
}

- (void)edgePanAction:(UIScreenEdgePanGestureRecognizer *)recognizer {
    CGFloat progress = [recognizer translationInView:self.view].x / self.view.bounds.size.width;
    if (self.direction == UIRectEdgeRight) {
        progress = -progress;
    }
    progress = MIN(1.0, MAX(0.0, progress));
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.percentInteractiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        switch (self.transitionOperation) {
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

- (void)pushToNextViewController {
    if (self.transitionGestureDelegate && [self.transitionGestureDelegate respondsToSelector:@selector(transitionGesturePush)]) {
        [self.transitionGestureDelegate transitionGesturePush];
    }
    else if (self.targetClass && [self.targetClass isKindOfClass:[UIViewController class]]) {
        UIViewController *vc = [[self.targetClass alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)popToFromViewController {
    if (self.transitionGestureDelegate && [self.transitionGestureDelegate respondsToSelector:@selector(transitionGesturePop)]) {
        [self.transitionGestureDelegate transitionGesturePop];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - setter & getter
- (Class)targetClass {
    return objc_getAssociatedObject(self, @selector(targetClass));
}

- (void)setTargetClass:(Class)targetClass {
    objc_setAssociatedObject(self, @selector(targetClass), targetClass, OBJC_ASSOCIATION_ASSIGN);
}

- (UINavigationControllerOperation)transitionOperation {
    return [objc_getAssociatedObject(self, @selector(transitionOperation)) integerValue];
}

- (void)setTransitionOperation:(UINavigationControllerOperation)transitionOperation {
    objc_setAssociatedObject(self, @selector(transitionOperation), @(transitionOperation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id <transitionGestureDelegate>)transitionGestureDelegate {
    return objc_getAssociatedObject(self, @selector(transitionGestureDelegate));
}

- (void)setTransitionGestureDelegate:(id<transitionGestureDelegate>)transitionGestureDelegate {
    objc_setAssociatedObject(self, @selector(transitionGestureDelegate), transitionGestureDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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

@end
