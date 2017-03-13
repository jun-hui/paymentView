//
//  ProgressView.h
//  ProgressView
//
//  Created by 小王 on 2017/3/10.
//  Copyright © 2017年 小王. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProgressView;
@protocol ProgressViewDelegate <NSObject>

- (void)animationFinished:(ProgressView *)view;

@end

@interface ProgressView : UIView

@property (nonatomic, weak) id<ProgressViewDelegate> progressDelegate;

- (instancetype)initWithFrame:(CGRect)frame andLineWidth:(CGFloat)lineWidth andLineColor:(NSArray *)lineColor;

@end
