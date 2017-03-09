//
//  PasswordInputBoxView.h
//  paymentView
//
//  Created by 小王 on 2017/3/8.
//  Copyright © 2017年 小王. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PasswordInputBoxCellTogether,//单元格之间无间隙
    PasswordInputBoxCellSeparate,//单元格之间有间隙
} PasswordInputBoxType;

@protocol PasswordInputBoxViewDelegate <NSObject>

- (void)passwordInputFinished:(NSString *)passwordString;

@end

typedef void(^inputPasswordBlock)(NSString *passwordString);

@interface PasswordInputBoxView : UIView

@property (nonatomic, assign) PasswordInputBoxType boxType;
@property (nonatomic, assign) NSInteger cellNum;//密码位数
@property (nonatomic, assign) BOOL isSecure;//是否密文显示
@property (nonatomic, assign) CGFloat Spacing;//每个格子间距
@property (nonatomic, strong) UIColor *cellLayerColor;
@property (nonatomic, strong) UIColor *cellBorderColor;
@property (nonatomic, assign) CGFloat cellBorderWidth;
@property (nonatomic, assign) CGFloat cellCornerRadius;
@property (nonatomic, strong, readonly) NSString *vertificationCode;//验证码内容
@property (nonatomic, copy) inputPasswordBlock passwordBlock;
@property (nonatomic, weak) id<PasswordInputBoxViewDelegate> passwordInputDelegate;

-(instancetype)initWithFrame:(CGRect)frame boxType:(PasswordInputBoxType)boxType;

@end
