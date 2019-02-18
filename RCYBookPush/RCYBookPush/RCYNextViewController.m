//
//  RCYNextViewController.m
//  RCYBookPush
//
//  Created by hcwh on 2019/1/29.
//  Copyright © 2019年 huchengwenhao. All rights reserved.
//

#import "RCYNextViewController.h"
#import "RCYBookAnimatorObject.h"

@interface RCYNextViewController () <UINavigationControllerDelegate>

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentInteractiveTransition;

@end

@implementation RCYNextViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我是第二个";
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.9 blue:0.77 alpha:1];
    self.navigationController.delegate = self;
    
    [self.view addSubview:self.contentLabel];
    self.contentLabel.frame = CGRectMake(15, 15, [UIScreen mainScreen].bounds.size.width - 30, [UIScreen mainScreen].bounds.size.height - 30);
    
    self.view.userInteractionEnabled = YES;
    UIScreenEdgePanGestureRecognizer *edgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanAction:)];
    edgePanGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgePanGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popback)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)popback {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)edgePanAction:(UIScreenEdgePanGestureRecognizer *)recognizer {
    CGFloat progress = [recognizer translationInView:self.view].x / self.view.bounds.size.width;
    progress = MIN(1.0, MAX(0.0, progress));
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.percentInteractiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
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

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:16];
        _contentLabel.numberOfLines = 0;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"虎扑1月30日讯 北京时间1月30日凌晨04:00，2018-2019赛季英超联赛第24轮比赛继续进行，曼城客场挑战纽卡斯尔。上半场，阿圭罗开场24秒闪电破门；下半场，龙东扫射扳平比分，费尔南迪尼奥送点，里奇点射破门。最终，曼城客场1-2遭纽卡斯尔逆转。此役过后，曼城18胜2平4负积56分排名次席，落后少赛一场的利物浦4分，纽卡斯尔6胜6平12负积24分排名第15位，暂时脱离降级区。"];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 15;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributedString.length)];
        _contentLabel.attributedText = attributedString;
    }
    return _contentLabel;
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
