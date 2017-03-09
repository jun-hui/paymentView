//
//  BaseTextField.m
//  paymentView
//
//  Created by 小王 on 2017/3/8.
//  Copyright © 2017年 小王. All rights reserved.
//

#import "BaseTextField.h"

@implementation BaseTextField

-(void)deleteBackward
{
    [super deleteBackward];
    if ([self.deleteDelegate respondsToSelector:@selector(textFieldDeleteBackward:)]) {
        [self.deleteDelegate textFieldDeleteBackward:self];
    }
}

@end
