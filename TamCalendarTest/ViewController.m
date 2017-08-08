//
//  ViewController.m
//  TamCalendarTest
//
//  Created by xin chen on 2017/8/7.
//  Copyright © 2017年 涂怀安. All rights reserved.
//

#import "ViewController.h"
#import "TamCalendar.h"

@interface ViewController ()

@property(nonatomic,strong)NSDate *currentDate;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.currentDate = [NSDate date];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [TamCalendar showCalendarDefDate:self.currentDate passDateBlock:^(NSDate *date) {
        self.currentDate = date;
        NSString *dateStr = [TamDate getyyyyMMddWithDate:date];
        NSLog(@"%@",dateStr);
    }];

}

@end
