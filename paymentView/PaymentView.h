//
//  PaymentView.h
//  paymentView
//
//  Created by 小王 on 2017/3/8.
//  Copyright © 2017年 小王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentTypeView.h"

@interface PaymentView : UIView

- (instancetype)initWithOrderInfo:(NSString *)orderInfo money:(NSString *)money paymentType:(PaymentType)paymentType;

- (void)showPayment;

@end
