//
//  RCYMainViewController.m
//  RCYBookPush
//
//  Created by hcwh on 2019/1/29.
//  Copyright © 2019年 huchengwenhao. All rights reserved.
//

#import "RCYMainViewController.h"
#import "RCYNextViewController.h"
#import "RCYBookAnimatorObject.h"

@interface RCYMainViewController () <UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *bookCover;

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentInteractiveTransition;

@end

@implementation RCYMainViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我是第一个";
    self.view.backgroundColor = UIColor.brownColor;
    
    
    [self.view addSubview:self.bookCover];
    self.bookCover.frame = CGRectMake(0, 0, 200, 240);
    self.bookCover.center = self.view.center;
    
    self.view.userInteractionEnabled = YES;
    UIScreenEdgePanGestureRecognizer *edgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanAction:)];
    edgePanGesture.edges = UIRectEdgeRight;
    [self.view addGestureRecognizer:edgePanGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToNextViewController)];
    [self.bookCover addGestureRecognizer:tapGesture];
}

- (void)pushToNextViewController {
    RCYNextViewController *nextVc = [[RCYNextViewController alloc] init];
    nextVc.bookCover = self.bookCover;
    [self.navigationController pushViewController:nextVc animated:YES];
}

- (void)edgePanAction:(UIScreenEdgePanGestureRecognizer *)recognizer {
    CGFloat progress = -[recognizer translationInView:self.view].x / self.view.bounds.size.width;
    progress = MIN(1.0, MAX(0.0, progress));
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.percentInteractiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self pushToNextViewController];
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

- (UIImageView *)bookCover {
    if (!_bookCover) {
        _bookCover = [[UIImageView alloc] init];
        _bookCover.image = [UIImage imageNamed:@"main_bookcover"];
        _bookCover.layer.shadowColor = UIColor.blackColor.CGColor;
        _bookCover.layer.shadowOffset = CGSizeMake(0, 2.5);
        _bookCover.layer.shadowOpacity = 0.3;
        _bookCover.layer.shadowRadius = 10;
        _bookCover.userInteractionEnabled = YES;
    }
    return _bookCover;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
   return [RCYBookAnimatorObject objectWithBookCoverView:self.bookCover animationControllerForOperation:operation];
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

@end
