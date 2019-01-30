//
//  RCYBookAnimatorObject.m
//  RCYBookPush
//
//  Created by hcwh on 2019/1/29.
//  Copyright © 2019年 huchengwenhao. All rights reserved.
//

#import "RCYBookAnimatorObject.h"

@interface RCYBookAnimatorObject () <UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) __kindof UIView *fromView;
@property (nonatomic, assign) UINavigationControllerOperation operation;

@end

@implementation RCYBookAnimatorObject

+ (id<UIViewControllerAnimatedTransitioning>)objectWithFromView:(__kindof UIView *)fromView animationControllerForOperation:(UINavigationControllerOperation)operation {
    RCYBookAnimatorObject *object = [[RCYBookAnimatorObject alloc] init];
    object.fromView = fromView;
    object.operation = operation;
    return object;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.8;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -0.002;
    [containerView.layer setSublayerTransform:transform];
    switch (self.operation) {
        case UINavigationControllerOperationPush: {
            UIView *currentToView = [transitionContext viewForKey:UITransitionContextToViewKey];
            //toView 和 fromView 都用截图
            UIView *toView = [currentToView snapshotViewAfterScreenUpdates:YES];
            UIView *fromView = [self.fromView snapshotViewAfterScreenUpdates:NO];
            
            [containerView addSubview:toView];
            [containerView addSubview:fromView];
            
            CGRect toViewFrame = toView.frame;
            CGRect fromViewFrame = self.fromView.frame;

            fromView.layer.anchorPoint = CGPointMake(0, 0.5);
            fromView.frame = fromViewFrame;
            toView.frame = fromViewFrame;
            
            NSTimeInterval duration = [self transitionDuration:transitionContext];
            [UIView animateKeyframesWithDuration:duration
                                           delay:0.0
                                         options:0
                                      animations:^{
                                          fromView.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 1, 0);
                                          toView.frame = toViewFrame;
                                          fromView.frame = toViewFrame;
                                      } completion:^(BOOL finished) {
                                          [fromView removeFromSuperview];
                                          [toView removeFromSuperview];
                                          [containerView addSubview:currentToView];
                                          [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                                      }];
            break;
        }
        case UINavigationControllerOperationPop: {
            UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            UIView *currentFromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
            //toView 和 fromView 都用截图
            UIView *toView = [self.fromView snapshotViewAfterScreenUpdates:YES];
            UIView *fromView = [currentFromView snapshotViewAfterScreenUpdates:NO];
            
            [containerView addSubview:fromView];
            [containerView addSubview:toView];
            [containerView insertSubview:toVC.view atIndex:0];
            fromVC.view.hidden = YES;

            CGRect toViewFrame = self.fromView.frame;
            CGRect fromViewFrame = fromView.frame;

            toView.layer.anchorPoint = CGPointMake(0, 0.5);
            fromView.frame = fromViewFrame;
            toView.frame = fromViewFrame;
            toView.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 1, 0);
            
            NSTimeInterval duration = [self transitionDuration:transitionContext];
            [UIView animateKeyframesWithDuration:duration
                                           delay:0.0
                                         options:0
                                      animations:^{
                                          toView.layer.transform = CATransform3DIdentity;
                                          fromView.frame = toViewFrame;
                                          toView.frame = toViewFrame;
                                      } completion:^(BOOL finished) {
                                          [fromView removeFromSuperview];
                                          [toView removeFromSuperview];
                                          [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                                      }];
            break;
        }
            
        default:
            break;
    }
}

@end
