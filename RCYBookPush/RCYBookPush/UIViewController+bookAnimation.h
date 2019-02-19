//
//  UIViewController+bookAnimation.h
//  RCYBookPush
//
//  Created by hcwh on 2019/2/18.
//  Copyright © 2019年 huchengwenhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+transition.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (bookAnimation)

@property (nonatomic, strong) __kindof UIView *bookCoverView;

@end

NS_ASSUME_NONNULL_END
