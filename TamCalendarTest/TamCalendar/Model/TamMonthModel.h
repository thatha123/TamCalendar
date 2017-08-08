//
//  TamMonthModel.h
//  TestCalendar
//
//  Created by xin chen on 17/7/11.
//  Copyright © 2017年 涂怀安. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TamMonthModel : NSObject

@property (assign, nonatomic) NSInteger dayValue;
@property (strong, nonatomic) NSDate *dateValue;
@property (assign, nonatomic) BOOL isSelectedDay;

@end
