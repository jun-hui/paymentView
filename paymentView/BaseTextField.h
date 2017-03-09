//
//  BaseTextField.h
//  paymentView
//
//  Created by 小王 on 2017/3/8.
//  Copyright © 2017年 小王. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseTextField;

@protocol TextFieldDeleteDelegate <NSObject>

- (void)textFieldDeleteBackward:(BaseTextField *)textField;

@end

@interface BaseTextField : UITextField

@property (nonatomic, assign) id<TextFieldDeleteDelegate> deleteDelegate;

@end
