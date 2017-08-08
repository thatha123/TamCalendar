//
//  TamLeftAndRightView.m
//  TestCalendar
//
//  Created by xin chen on 17/7/10.
//  Copyright © 2017年 涂怀安. All rights reserved.
//

#import "TamLeftAndRightView.h"

@interface TamLeftAndRightView()

@property(nonatomic,strong)UIButton *leftBtn;
@property(nonatomic,strong)UIButton *rightBtn;

@end

@implementation TamLeftAndRightView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.leftBtn.frame = CGRectMake(0, 0, 80, self.frame.size.height);
    self.rightBtn.frame = CGRectMake(self.frame.size.width-80, 0, 80, self.frame.size.height);
    self.label.frame = CGRectMake(self.leftBtn.frame.size.width+10, 0, self.frame.size.width-self.leftBtn.frame.size.width*2-10*2 , self.frame.size.height);
}

/**
 *  初始化UI
 */
-(void)setupUI
{
    UILabel *label = [[UILabel alloc]init];
    self.label = label;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:17];
    [self addSubview:label];
    
    UIButton *leftBtn = [[UIButton alloc]init];
    self.leftBtn = leftBtn;
    leftBtn.tag = 0;
    [leftBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [self addSubview:leftBtn];
    
    UIButton *rightBtn = [[UIButton alloc]init];
    self.rightBtn = rightBtn;
    rightBtn.tag = 1;
    [rightBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    [self addSubview:rightBtn];
}

-(void)clickBtn:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(clickLeftAndRightBtn:)]) {
        [self.delegate clickLeftAndRightBtn:sender];
    }
}

@end
