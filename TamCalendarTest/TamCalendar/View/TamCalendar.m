//
//  TamCalendar.m
//  TestCalendar
//
//  Created by xin chen on 17/7/10.
//  Copyright © 2017年 涂怀安. All rights reserved.
//

#import "TamCalendar.h"
#import "TamLeftAndRightView.h"
#import "TamMonthModel.h"

#import "TamBgkView.h"

#define key_window [UIApplication sharedApplication].keyWindow

#define TamMainThemeColor [UIColor colorWithRed:57/255.0 green:138/255.0 blue:207/255.0 alpha:1.0]//主题色

#define TamScreenW [UIScreen mainScreen].bounds.size.width//屏幕宽
#define TamScreenH [UIScreen mainScreen].bounds.size.height//屏幕高

static const int contentLefMagin = 20;//内容里的左右间距

static const int TopMargin = 40;//距离屏幕上下的距离
static const int LeftMargin = 20;//距离屏幕左右的距离

static const int row = 13;//3+2+7+1

#define UserOneRowH ((TamScreenW-LeftMargin*2-contentLefMagin*2)/7)//屏幕宽计算cell宽高

#define UserTopMargin MAX(TopMargin,(TamScreenH-row*UserOneRowH)/2)//上下屏幕间距

@interface TamCalendar()<UICollectionViewDelegate,UICollectionViewDataSource,TamCalendarCollectionViewCellDelegate,TamLeftAndRightViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
//,UITableViewDelegate,UITableViewDataSource

@property(nonatomic,strong)UICollectionView *collectionView;
//@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIPickerView *pickerView;

@property(nonatomic,strong)UIButton *yearBtn;
@property(nonatomic,strong)UIButton *monthBtn;
@property(nonatomic,strong)TamLeftAndRightView *leftAndRightView;

@property (strong, nonatomic) NSMutableArray *dayModelArray;
@property (strong, nonatomic) NSDate *tempDate;//当前页面的日期
@property(nonatomic,strong)NSDate *selDate;//当前选择的日期

@property(nonatomic,copy)PassDateBlock passDateBlock;

@end

@implementation TamCalendar

static NSString *cellID = @"TamCalendarCell";

static TamCalendar *_tamCalendar;

+(TamCalendar *)shareInstance
{
    if (_tamCalendar == nil) {
        _tamCalendar = [[TamCalendar alloc]init];
    }
    return _tamCalendar;
}

+(void)showCalendarDefDate:(NSDate *)DefDate passDateBlock:(PassDateBlock)passDateBlock
{
    [TamBgkView showBgkViewInView:key_window isEnable:YES isTouchHidden:NO touchBgkViewBlock:^{
        
    }];
    [TamCalendar shareInstance].frame = CGRectMake(LeftMargin, UserTopMargin, TamScreenW-LeftMargin*2, TamScreenH-UserTopMargin*2);
    [_tamCalendar setupUI];
    [key_window addSubview:_tamCalendar];
    _tamCalendar.passDateBlock = passDateBlock;
    _tamCalendar.tempDate = DefDate;//默认等于现在时间
    _tamCalendar.selDate = DefDate;//默认选择时间
    [_tamCalendar getDataDayModel];
    
    
}

+(void)dismissCalendar
{
    [TamBgkView hiddenBgkViewInView:key_window];
    
    [_tamCalendar removeFromSuperview];
    _tamCalendar = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)getDataDayModel{
    NSUInteger days = [TamDate numberOfDaysInMonth:self.tempDate];
    NSInteger week = [TamDate startDayOfWeek:self.tempDate];
    self.dayModelArray = [[NSMutableArray alloc] initWithCapacity:42];
    int day = 1;
    for (int i= 1; i<days+week; i++) {
        if (i<week) {
            [self.dayModelArray addObject:@""];
        }else{
            TamMonthModel *mon = [[TamMonthModel alloc]init];
            NSDate *dayDate = [TamDate dateOfDay:day tempDate:self.tempDate];
            mon.dateValue = dayDate;
            mon.dayValue = day;
            if ([[TamDate getyyyyMMddWithDate:dayDate] isEqualToString:[TamDate getyyyyMMddWithDate:self.selDate]]) {
                mon.isSelectedDay = YES;
            }
            [self.dayModelArray addObject:mon];
            day++;
        }
    }
    [self.yearBtn setTitle:[NSString stringWithFormat:@"%ld",[TamDate getyyyyWithDate:self.selDate]] forState:UIControlStateNormal];
    self.leftAndRightView.label.text = [TamDate getyyyyMMWithDate:self.tempDate];
    [self.monthBtn setTitle:[NSString stringWithFormat:@"%@ %@",[TamDate getMMddWithDate:self.selDate],[TamDate weekStringWithDate:self.selDate]] forState:UIControlStateNormal];
    [self.collectionView reloadData];
}

/**
 *  初始化UI
 */
-(void)setupUI
{
    /**
     *  第一部分
     */
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = TamMainThemeColor;
    headView.frame = CGRectMake(0, 0, self.frame.size.width, UserOneRowH*3);
    [self addSubview:headView];
    
    UIButton *yearBtn = [[UIButton alloc]init];
    yearBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.yearBtn = yearBtn;
    [yearBtn addTarget:self action:@selector(clickYearBtn:) forControlEvents:UIControlEventTouchUpInside];
    yearBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [yearBtn setTitle:@"" forState:UIControlStateNormal];
    [yearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    yearBtn.frame = CGRectMake(contentLefMagin, UserOneRowH/2, headView.frame.size.width-contentLefMagin*2, UserOneRowH/2);
    [headView addSubview:yearBtn];
    
    UIButton *monthBtn = [[UIButton alloc]init];
    [monthBtn addTarget:self action:@selector(clickMonthBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.monthBtn = monthBtn;
    monthBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    monthBtn.titleLabel.font = [UIFont systemFontOfSize:40];
    [monthBtn setTitle:@"" forState:UIControlStateNormal];
    [monthBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    monthBtn.frame = CGRectMake(contentLefMagin, CGRectGetMaxY(yearBtn.frame), headView.frame.size.width-contentLefMagin*2, headView.frame.size.height-CGRectGetMaxY(yearBtn.frame)-UserOneRowH/2);
    [headView addSubview:monthBtn];
    
    /**
     *  第二部分
     */
    TamLeftAndRightView *leftAndRightView = [[TamLeftAndRightView alloc]init];
    self.leftAndRightView = leftAndRightView;
    leftAndRightView.delegate = self;
    leftAndRightView.frame = CGRectMake(contentLefMagin, CGRectGetMaxY(headView.frame)+UserOneRowH/2, headView.frame.size.width-contentLefMagin*2, UserOneRowH/2);
    [self addSubview:leftAndRightView];
    
    /**
     *  第三部分
     */
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(UserOneRowH-0.1, UserOneRowH-0.1);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(contentLefMagin, CGRectGetMaxY(leftAndRightView.frame)+UserOneRowH/2, TamScreenW-2*LeftMargin-2*contentLefMagin, 7*UserOneRowH) collectionViewLayout:layout];
    self.collectionView = collectionView;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.clipsToBounds = YES;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[TamCalendarCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    [self addSubview:collectionView];
    
//    UITableView *tableView = [[UITableView alloc]init];
//    self.tableView = tableView;
//    tableView.hidden = YES;
//    tableView.delegate = self;
//    tableView.dataSource = self;
//    [UITableView setTableViewComm:tableView];
//    tableView.showsVerticalScrollIndicator = NO;
//    [self addSubview:tableView];
//    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.equalTo(leftAndRightView);
//        make.top.equalTo(leftAndRightView.mas_top).offset(-UserOneRowH/2);
//        make.height.mas_offset(9*UserOneRowH);
//    }];
//    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    UIPickerView *pickerView = [[UIPickerView alloc]init];
    self.pickerView = pickerView;
    pickerView.hidden = YES;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.frame = CGRectMake(0, leftAndRightView.frame.origin.y-UserOneRowH/2, leftAndRightView.frame.size.width, 9*UserOneRowH);
    [self addSubview:pickerView];
    
    /**
     *  第四部分
     */
    UIButton *submitBtn = [[UIButton alloc]init];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [submitBtn setTitleColor:TamMainThemeColor forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.frame = CGRectMake(self.frame.size.width-2*UserOneRowH, self.frame.size.height-UserOneRowH, 2*UserOneRowH, UserOneRowH);
    [self addSubview:submitBtn];
    
    UIButton *cancelBtn = [[UIButton alloc]init];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:TamMainThemeColor forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(CGRectGetMinX(submitBtn.frame)-2*UserOneRowH, submitBtn.frame.origin.y, 2*UserOneRowH, UserOneRowH);
    [self addSubview:cancelBtn];
}

-(void)clickYearBtn:(UIButton *)sender
{
//    self.tableView.hidden = NO;
    self.pickerView.hidden = NO;
    self.collectionView.hidden = YES;
    self.leftAndRightView.hidden = YES;
    NSInteger yyMargin = 99+([TamDate getyyyyWithDate:self.tempDate]-[TamDate getyyyyWithDate:[NSDate date]]);
    [self.pickerView selectRow:yyMargin inComponent:0 animated:YES];
    [self.pickerView reloadAllComponents];
}

-(void)clickMonthBtn:(UIButton *)sender
{
//    self.tableView.hidden = YES;
    self.pickerView.hidden = YES;
    self.collectionView.hidden = NO;
    self.leftAndRightView.hidden = NO;
}

-(void)submitAction:(UIButton *)sender
{
    if (self.passDateBlock) {
        self.passDateBlock(self.selDate);
    }
    [TamCalendar dismissCalendar];
}

-(void)cancelAction:(UIButton *)sender
{
    [TamCalendar dismissCalendar];
}

#pragma mark - TamLeftAndRightViewDelegate
-(void)clickLeftAndRightBtn:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
        {
            self.tempDate = [TamDate getLastMonth:self.tempDate];
            [self getDataDayModel];
        }
            break;
        case 1:
        {
            self.tempDate = [TamDate getNextMonth:self.tempDate];
            [self getDataDayModel];
        }
            break;
        default:
            break;
    }
}
#pragma mark - UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 100;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSMutableAttributedString *mutAttStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld",[TamDate getyyyyWithDate:[NSDate date]]+row-99]];
    NSInteger selRow = [pickerView selectedRowInComponent:0];
    if (selRow == row) {
        [mutAttStr addAttribute:NSForegroundColorAttributeName value:TamMainThemeColor range:NSMakeRange(0, mutAttStr.length)];
        [mutAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(0, mutAttStr.length)];
    }else{
        [mutAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, mutAttStr.length)];
        [mutAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(0, mutAttStr.length)];
    }

    return mutAttStr;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [pickerView reloadAllComponents];
    self.tempDate = [TamDate dateOfYear:[TamDate getyyyyWithDate:[NSDate date]]+row-99 tempDate:self.tempDate];
    [self getDataDayModel];

    [self clickMonthBtn:nil];
}

//#pragma mark - UITableViewDataSource
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 100;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    TamCalendarTableViewCell *cell = [TamCalendarTableViewCell calendarTableViewCellWithTableView:tableView];
//    cell.label.text = [NSString stringWithFormat:@"%ld",[TamDate getyyyyWithDate:[NSDate date]]+indexPath.row];
//    return cell;
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//    self.tempDate = [TamDate dateOfYear:[TamDate getyyyyWithDate:[NSDate date]]+indexPath.row tempDate:self.tempDate];
//    [self getDataDayModel];
//    
//    [self clickMonthBtn:nil];
//}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 7+self.dayModelArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TamCalendarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.delegate = self;
    if (indexPath.item < 7) {
        cell.button.enabled = NO;
        [cell.button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [cell.button setTitle:@[@"日",@"一",@"二",@"三",@"四",@"五",@"六"][indexPath.item] forState:UIControlStateNormal];
        [cell.button setBackgroundColor:[UIColor clearColor]];
    }else{
        cell.button.tag = indexPath.item;
        id mon = self.dayModelArray[indexPath.item-7];
        if ([mon isKindOfClass:[TamMonthModel class]]) {
            cell.button.enabled = YES;
            cell.monthModel = mon;
        }else{
            cell.button.enabled = NO;
            [cell.button setTitle:@"" forState:UIControlStateNormal];
            [cell.button setBackgroundColor:[UIColor clearColor]];
        }

        ;
    }
    return cell;
}

#pragma mark - TamCalendarCollectionViewCellDelegate
-(void)clickBtnAction:(UIButton *)sender
{
    [self.dayModelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[TamMonthModel class]]) {
            TamMonthModel *monthModel = obj;
            monthModel.isSelectedDay = NO;
        }
    }];
    id mon = self.dayModelArray[sender.tag-7];
    if ([mon isKindOfClass:[TamMonthModel class]]) {
        TamMonthModel *monthModel = (TamMonthModel *)mon;
        monthModel.isSelectedDay = YES;
        self.selDate = [TamDate dateOfDay:monthModel.dayValue tempDate:self.tempDate];
//        [self getDataDayModel];
        [self.yearBtn setTitle:[NSString stringWithFormat:@"%ld",[TamDate getyyyyWithDate:self.selDate]] forState:UIControlStateNormal];
        [self.monthBtn setTitle:[NSString stringWithFormat:@"%@ %@",[TamDate getMMddWithDate:self.selDate],[TamDate weekStringWithDate:self.selDate]] forState:UIControlStateNormal];
        [self.collectionView reloadData];
    }
}

@end

@implementation TamCalendarCollectionViewCell

-(TamCalendarButton *)button
{
    if (!_button) {
        _button = [[TamCalendarButton alloc]init];
        _button.selected = NO;
        _button.layer.masksToBounds = YES;
        _button.layer.cornerRadius = UserOneRowH/2;
        [_button setBackgroundColor:[UIColor clearColor]];
        _button.titleLabel.font = [UIFont systemFontOfSize:17];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_button];
    }
    return _button;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _button.frame = self.contentView.bounds;
}

-(void)btnAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(clickBtnAction:)]) {
        [self.delegate clickBtnAction:sender];
    }
}

-(void)setMonthModel:(TamMonthModel *)monthModel
{
    _monthModel = monthModel;
    [self.button setTitle:[NSString stringWithFormat:@"%02ld",_monthModel.dayValue] forState:UIControlStateNormal];
    if (_monthModel.isSelectedDay) {
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.button setBackgroundColor:TamMainThemeColor];
    }else{
        if ([[TamDate getyyyyMMddWithDate:_monthModel.dateValue] isEqualToString:[TamDate getyyyyMMddWithDate:[NSDate date]]]){
            [self.button setTitleColor:TamMainThemeColor forState:UIControlStateNormal];
        }else{
            [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [self.button setBackgroundColor:[UIColor clearColor]];
    }
}

@end

@implementation TamCalendarButton

-(void)setHighlighted:(BOOL)highlighted
{}

@end

@implementation TamCalendarTableViewCell

+(instancetype)calendarTableViewCellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"calendarCell";
    TamCalendarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[TamCalendarTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

-(UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.textColor = [UIColor blackColor];
        _label.font = [UIFont systemFontOfSize:25];
        _label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_label];
    }
    return _label;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _label.frame = self.contentView.bounds;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.label.textColor = TamMainThemeColor;
        self.label.font = [UIFont systemFontOfSize:30];
    }else{
        self.label.textColor = [UIColor blackColor];
        self.label.font = [UIFont systemFontOfSize:25];
    }
}

@end
