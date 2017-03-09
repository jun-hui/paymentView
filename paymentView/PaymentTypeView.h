//
//  PaymentTypeView.h
//  paymentView
//
//  Created by 小王 on 2017/3/8.
//  Copyright © 2017年 小王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PasswordInputBoxView.h"

static NSString *paymentTypeViewID = @"PaymentTypeView";
#define payTypeNameArray @[@"支付宝支付",@"微信支付",@"银联支付",@"苹果支付"]

typedef enum : NSUInteger {
    
    PaymentTypeAlipay = 0,//支付宝支付
    PaymentTypeWeChat,//微信支付
    PaymentTypeUnionPay,//银联支付
    PaymentTypeApplePay//苹果支付
    
} PaymentType;


@protocol PaymentTypeViewDelegate <NSObject>

- (void)cancelPay;
- (void)goPayTypeViewWithPayType:(PaymentType)payType;
- (void)finishChoosePayType:(PaymentType)payType;
- (void)goInputPasswordViewWithPayType:(PaymentType)payType;

@end

@interface PaymentTypeView : UIView

@property (weak, nonatomic) IBOutlet UIButton *payTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *goInputButton;
@property (weak, nonatomic) IBOutlet UITableView *payTypeTable;
@property (weak, nonatomic) IBOutlet PasswordInputBoxView *passwordBoxView;
@property (weak, nonatomic) id<PaymentTypeViewDelegate> paymentTypeDelegate;

-(void)setPaymentTypes;

@end
