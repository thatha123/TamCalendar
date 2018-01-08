//
//  TamLeftAndRightView.h
//  TestCalendar
//
//  Created by xin chen on 17/7/10.
//  Copyright © 2017年 涂怀安. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TamLeftAndRightViewDelegate <NSObject>

@optional
-(void)clickLeftAndRightBtn:(UIButton *)sender;

@end

@interface TamLeftAndRightView : UIView

@property(nonatomic,weak)id<TamLeftAndRightViewDelegate> delegate;
@property(nonatomic,weak)UILabel *label;

@end
