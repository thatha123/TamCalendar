//
//  TamCalendar.h
//  TestCalendar
//
//  Created by xin chen on 17/7/10.
//  Copyright © 2017年 涂怀安. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TamDate.h"

typedef void(^PassDateBlock)(NSDate *date);

@interface TamCalendar : UIView

+(TamCalendar *)shareInstance;
//DefDate 默认选择时间
+(void)showCalendarDefDate:(NSDate *)DefDate passDateBlock:(PassDateBlock)passDateBlock;
+(void)dismissCalendar;

@end

/**
 *  UICollectionViewCell
 */
@protocol TamCalendarCollectionViewCellDelegate <NSObject>

@optional
-(void)clickBtnAction:(UIButton *)sender;

@end

@class TamCalendarButton,TamMonthModel;
//cell视图
@interface TamCalendarCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)TamCalendarButton *button;
@property(nonatomic,strong)id<TamCalendarCollectionViewCellDelegate> delegate;
@property(nonatomic,strong)TamMonthModel *monthModel;

@end

//cell中按钮视图
@interface TamCalendarButton : UIButton

@end

/**
 *  UITableViewCell
 */
@interface TamCalendarTableViewCell : UITableViewCell

+(instancetype)calendarTableViewCellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong)UILabel *label;

@end
