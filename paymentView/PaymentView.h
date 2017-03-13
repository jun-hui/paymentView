//
//  PaymentView.h
//  paymentView
//
//  Created by 小王 on 2017/3/8.
//  Copyright © 2017年 小王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentTypeView.h"

@protocol PaymentViewDelegate <NSObject>

- (void)passwordInputFinished:(NSString *)passwordString;

@end

@interface PaymentView : UIView

@property (nonatomic, strong) PaymentTypeView *payDetailView;
@property (nonatomic, strong) PaymentTypeView *typeView;
@property (nonatomic, strong) PaymentTypeView *inputPasswView;
@property (nonatomic, weak) id<PaymentViewDelegate> paymentDelegate;

- (instancetype)initWithOrderInfo:(NSString *)orderInfo money:(NSString *)money paymentType:(PaymentType)paymentType;

- (void)showPayment;

-(void)hidden;

@end
