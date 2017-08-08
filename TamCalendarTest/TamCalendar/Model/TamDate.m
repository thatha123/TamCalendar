//
//  TamDate.m
//  TestCalendar
//
//  Created by xin chen on 17/7/11.
//  Copyright © 2017年 涂怀安. All rights reserved.
//

#import "TamDate.h"

@implementation TamDate

+ (NSCalendar *)calendar {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    calendar.timeZone = [NSTimeZone localTimeZone];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//Asia/Shanghai
//    calendar.locale = [NSLocale currentLocale];
    return calendar;
}

+ (NSDateComponents *)compts:(NSDate *)date {
    NSDateComponents *compts = [[self calendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:date];
//    compts.timeZone = [NSTimeZone localTimeZone];
    return compts;
}

+ (NSUInteger)numberOfDaysInMonth:(NSDate *)date{
    return [[self calendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
}

+ (NSDate *)firstDateOfMonth:(NSDate *)date{
    NSDateComponents *comps = [self compts:date];
    comps.day = 1;
    return [[self calendar] dateFromComponents:comps];
}

+ (NSUInteger)startDayOfWeek:(NSDate *)date
{
    NSDateComponents *comps = [self compts:[self firstDateOfMonth:date]];
    return comps.weekday;
}

+ (NSDate *)getLastMonth:(NSDate *)date{
    NSDateComponents *comps = [self compts:date];
    comps.month -= 1;
    return [[self calendar] dateFromComponents:comps];
}

+ (NSDate *)getNextMonth:(NSDate *)date{
    NSDateComponents *comps = [self compts:date];
    comps.month += 1;
    return [[self calendar] dateFromComponents:comps];
}

+ (NSDate *)dateOfDay:(NSInteger)day tempDate:(NSDate *)tempDate{
    NSDateComponents *comps = [self compts:tempDate];
    comps.day = day;
    return [[self calendar] dateFromComponents:comps];
}

+ (NSDate *)dateOfYear:(NSInteger)year tempDate:(NSDate *)tempDate{
    NSDateComponents *comps = [self compts:tempDate];
    comps.year = year;
    return [[self calendar] dateFromComponents:comps];
}

+(NSString *)getyyyyMMddWithDate:(NSDate *)date
{
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString * locationString=[dateformatter stringFromDate:date];
    return locationString;
}

+(NSString *)getyyyyMMWithDate:(NSDate *)date
{
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy年MM月"];
    NSString * locationString=[dateformatter stringFromDate:date];
    return locationString;
}

+(NSString *)getMMddWithDate:(NSDate *)date
{
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM月dd日"];
    NSString * locationString=[dateformatter stringFromDate:date];
    return locationString;
}

+(NSInteger)getyyyyWithDate:(NSDate *)date
{
    NSDateComponents *comps = [self compts:date];
    return comps.year;
}

+(NSInteger)getddWithDate:(NSDate *)date
{
    NSDateComponents *comps = [self compts:date];
    return comps.day;
}

+ (NSString *)weekStringWithDate:(NSDate *)date {
    NSDateComponents *compts = [self compts:date];
    NSArray *weeks = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
    return weeks[compts.weekday - 1];
}

+(NSDate *)getDateWithMargin:(NSInteger)margin
{
    NSDateComponents *comps = [self compts:[NSDate date]];
    comps.day -= margin;
    return [[self calendar] dateFromComponents:comps];
}

+(NSDate *)getDateWithyyyyMMdd:(NSString *)yyyyMMdd
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSString *newStr = [NSString stringWithFormat:@"%@ 08:00:00",yyyyMMdd];//给时间不然到另一天了
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date =[dateFormatter dateFromString:newStr];
    return date;
}

@end
