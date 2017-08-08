//
//  TamDate.h
//  TestCalendar
//
//  Created by xin chen on 17/7/11.
//  Copyright © 2017年 涂怀安. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TamDate : NSObject

//获取date中某个月有多少天
+ (NSUInteger)numberOfDaysInMonth:(NSDate *)date;
//获取date第一天的所有信息
+ (NSDate *)firstDateOfMonth:(NSDate *)date;
//获取date第一天为周几
+ (NSUInteger)startDayOfWeek:(NSDate *)date;
//获取date上一个月的信息
+ (NSDate *)getLastMonth:(NSDate *)date;
//获取date下一个月的信息
+ (NSDate *)getNextMonth:(NSDate *)date;
//获取tempDate中某一天的信息
+ (NSDate *)dateOfDay:(NSInteger)day tempDate:(NSDate *)tempDate;
//获取tempDate中月日对应的year的月日
+ (NSDate *)dateOfYear:(NSInteger)year tempDate:(NSDate *)tempDate;
//获取date年月日格式
+(NSString *)getyyyyMMddWithDate:(NSDate *)date;
//获取date年月格式
+(NSString *)getyyyyMMWithDate:(NSDate *)date;
//获取date月日格式
+(NSString *)getMMddWithDate:(NSDate *)date;
//获取date年份
+(NSInteger)getyyyyWithDate:(NSDate *)date;
//获取date日
+(NSInteger)getddWithDate:(NSDate *)date;
//获取date周几
+ (NSString *)weekStringWithDate:(NSDate *)date;
//获取距离今天之前的date [margin 相隔多少天]
+(NSDate *)getDateWithMargin:(NSInteger)margin;
//通过年月日获取日期
+(NSDate *)getDateWithyyyyMMdd:(NSString *)yyyyMMdd;

@end
