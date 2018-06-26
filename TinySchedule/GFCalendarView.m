//
//  GFCalendarView.m
//
//  Created by Mercy on 2016/11/9.
//  Copyright © 2016年 Mercy. All rights reserved.
//

#import "GFCalendarView.h"
#import "GFCalendarScrollView.h"
#import "NSDate+GFCalendar.h"

#define bgImageViewWidth 120
#define bgImageViewHeight 24
#define dayString @"Day"
#define weekString @"Week"
#define moveLabelAlpha 0.3
#define duration 0.2

@interface GFCalendarView()
@property (nonatomic, strong) UILabel *calendarHeaderLabel;

@property (nonatomic, strong) UIButton *todayButton;
@property (nonatomic, strong) UIView *weekHeaderView;
@property (nonatomic, strong) GFCalendarScrollView *calendarScrollView;

@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, strong) UIImageView *bgimageview;
@property (nonatomic, strong) UILabel *daylabel;
@property (nonatomic, strong) UILabel *weeklabel;
@property (nonatomic, strong) UILabel *movelabel;

@end

@implementation GFCalendarView


#pragma mark - Initialization

- (instancetype)initWithFrameOrigin:(CGPoint)origin width:(CGFloat)width {
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    // 根据宽度计算 calender 主体部分的高度
    CGFloat weekLineHight = 0.85 * (width / 7.0);
    CGFloat monthHeight = 6 * weekLineHight;
    
    // 星期头部栏高度
    CGFloat weekHeaderHeight = 0.6 * weekLineHight;
    
    // calendar 头部栏高度
    CGFloat calendarHeaderHeight = 0.8 * weekLineHight;
    
    // 最后得到整个 calender 控件的高度
    _calendarHeight = calendarHeaderHeight + weekHeaderHeight + monthHeight;
    
    if (self = [super initWithFrame:CGRectMake(origin.x, origin.y, width, _calendarHeight)]) {
        
        _calendarHeaderLabel = [self setupCalendarHeaderLabelWithFrame:CGRectMake(6, 0, ScreenWidth-6, 45)];
        
        //_imagview = [self setupCalendarHeaderSegmentBgImageviewWithFrame:CGRectMake(ScreenWidth/2-120/2, 10, 120, 24)];
        _bgimageview = [self setupCalendarHeaderSegmentBgImageviewWithFrame:CGRectMake(ScreenWidth/2-120/2, 10, bgImageViewWidth, bgImageViewHeight)];
        
        _todayButton = [self setupCalendarHeaderTodayButtonWithFrame:CGRectMake(ScreenWidth-90, 0, 90, 45)];
        
        if (ScreenWidth == 320) {
            _weekHeaderView = [self setupWeekHeadViewWithFrame:CGRectMake(0.0, calendarHeaderHeight+5, width, weekHeaderHeight)];
            _calendarScrollView = [self setupCalendarScrollViewWithFrame:CGRectMake(0.0, calendarHeaderHeight + weekHeaderHeight+5, width, monthHeight)];
        }
        else
        {
            _weekHeaderView = [self setupWeekHeadViewWithFrame:CGRectMake(0.0, calendarHeaderHeight, width, weekHeaderHeight)];
            _calendarScrollView = [self setupCalendarScrollViewWithFrame:CGRectMake(0.0, calendarHeaderHeight + weekHeaderHeight, width, monthHeight)];
        }
        
        
        [self addSubview:_calendarHeaderLabel];
        //[self addSubview:_imagview];
        [self addSubview:_bgimageview];
        [self addSubview:_todayButton];
        [self addSubview:_weekHeaderView];
        [self addSubview:_calendarScrollView];
        
        // 注册 Notification 监听
        [self addNotificationObserver];
        
    }
    
    return self;
    
}

- (void)dealloc {
    // 移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UILabel *)setupCalendarHeaderLabelWithFrame:(CGRect)frame {
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont fontWithName:SemiboldFontName size:14.0];
    label.textColor = TextColorAlpha_54;
    label.userInteractionEnabled = YES;
    label.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshToCurrentMonthAction)];
    [label addGestureRecognizer:tap];
    return label;
}

-(UIImageView *) setupCalendarHeaderSegmentBgImageviewWithFrame:(CGRect)frame
{
    UIImageView *imagview = [[UIImageView alloc] initWithFrame:frame];
    imagview.image = [UIImage imageNamed:@"calendarSliderBgview"];
    imagview.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgimageview:)];
    [imagview addGestureRecognizer:tap];
    
    float framewidth = frame.size.width;
    float frameheight = frame.size.height;
    
    _daylabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, framewidth/2, frameheight)];
    _daylabel.text = dayString;
    _daylabel.font = [UIFont fontWithName:SemiboldFontName size:14.0];
    _daylabel.textColor = SetColor(0, 0, 0, 0.3);
    _daylabel.textAlignment = NSTextAlignmentCenter;
    [imagview addSubview:_daylabel];
    
    _weeklabel = [[UILabel alloc] initWithFrame:CGRectMake(framewidth/2, 0, framewidth/2, frameheight)];
    _weeklabel.text = weekString;
    _weeklabel.font = [UIFont fontWithName:SemiboldFontName size:14.0];
    _weeklabel.textColor = SetColor(0, 0, 0, 0.3);
    _weeklabel.textAlignment = NSTextAlignmentCenter;
    [imagview addSubview:_weeklabel];
    
    _movelabel = [[UILabel alloc] initWithFrame:CGRectMake(framewidth/2, 0, framewidth/2, frameheight)];
    _movelabel.text = weekString;
    _movelabel.textColor = [UIColor whiteColor];
    _movelabel.backgroundColor = AppMainColor;
    _movelabel.font = [UIFont fontWithName:SemiboldFontName size:14.0];
    _movelabel.layer.masksToBounds = YES;
    _movelabel.layer.cornerRadius = 5.0;
    _movelabel.textAlignment = NSTextAlignmentCenter;
    _movelabel.userInteractionEnabled = YES;
    NSDictionary *dict = [UserEntity getCalendarDate];
    if ([[dict objectForKey:@"state"] isEqualToString:@"1"]) {
        _movelabel.frame = CGRectMake(0, 0, framewidth/2, frameheight);
        _movelabel.text = dayString;
    }
    [imagview addSubview:_movelabel];
//    _pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
//    [_movelabel addGestureRecognizer:_pan];
    
    return imagview;
}
-(void) tapBgimageview:(UITapGestureRecognizer *) tap
{
    NSDictionary *dict = [UserEntity getCalendarDate];
    float x = _movelabel.frame.origin.x;
    if (x > 0) {
        
        [UIView animateWithDuration:duration animations:^{
            
            _movelabel.frame = CGRectMake(0, 0, bgImageViewWidth/2, bgImageViewHeight);
            _movelabel.text = @"";
            _movelabel.alpha = moveLabelAlpha;
            
            [StringManager setCalendarDayDictionary:[dict objectForKey:@"date"]];
            [_calendarScrollView refreshView];
            
        } completion:^(BOOL finish){
            if (finish == YES) {
                _movelabel.alpha = 1.0;
                _movelabel.text = dayString;
            }
        }];
    }
    else
    {
        [UIView animateWithDuration:duration animations:^{
            
            _movelabel.frame = CGRectMake(bgImageViewWidth/2, 0, bgImageViewWidth/2, bgImageViewHeight);
            _movelabel.text = @"";
            _movelabel.alpha = moveLabelAlpha;
            
            [StringManager setCalendarWeekDictionary:[dict objectForKey:@"date"]];
            [_calendarScrollView refreshView];
            
        } completion:^(BOOL finish){
            if (finish == YES) {
                _movelabel.alpha = 1.0;
                _movelabel.text = weekString;
            }
        }];
    }
}

//滑动手势
- (void) handlePan: (UIPanGestureRecognizer *)gesture{
    
    _movelabel.alpha = moveLabelAlpha;
    _movelabel.text = @"";
    
    float label_ori_x = 0;
    UILabel *label = (UILabel *)gesture.view;
    label_ori_x = label.frame.origin.x;
    
    CGPoint translation = [gesture translationInView:label];

    // move label
    if (label_ori_x == 0 && translation.x < 0) {
        
    }
    else if (label_ori_x == 60 && translation.x > 0)
    {
    }
    else
    {
        if (_movelabel.frame.origin.x < 0) {
            _movelabel.frame = CGRectMake(0, 0, _movelabel.frame.size.width, _movelabel.frame.size.height);
            _movelabel.alpha = 1.0;
            _movelabel.text = dayString;
        }
        else if (_movelabel.frame.origin.x > bgImageViewWidth/2)
        {
            _movelabel.frame = CGRectMake(bgImageViewWidth/2, 0, _movelabel.frame.size.width, _movelabel.frame.size.height);
            _movelabel.alpha = 1.0;
            _movelabel.text = weekString;
        }
        else
        {
            _movelabel.frame = CGRectMake(label_ori_x+translation.x, 0, _movelabel.frame.size.width, _movelabel.frame.size.height);
        }
    }
    
        //手势结束后修正位置,超过约一半时向多出的一半偏移
        if (gesture.state == UIGestureRecognizerStateEnded) {
    
            if(translation.x < 0)
            {
                
            }
            else
            {

            }
        }
}

-(void) moveToWeek
{
    NSDictionary *dict = [UserEntity getCalendarDate];
    [StringManager setCalendarWeekDictionary:[dict objectForKey:@"date"]];
    
    [UIView animateWithDuration:duration animations:^{
    
        _movelabel.frame = CGRectMake(bgImageViewWidth/2, 0, bgImageViewWidth/2, bgImageViewHeight);
        _movelabel.alpha = moveLabelAlpha;
        _movelabel.text = @"";
        
    } completion:^(BOOL finish){
        if (finish == YES) {
            
            _movelabel.alpha = 1.0;
            _movelabel.text = weekString;
            [_calendarScrollView refreshView];
        }
    }];
}
-(void) moveToDay
{
    NSDictionary *dict = [UserEntity getCalendarDate];
    [StringManager setCalendarDayDictionary:[dict objectForKey:@"date"]];
    
    [UIView animateWithDuration:duration animations:^{
        
        _movelabel.frame = CGRectMake(0, 0, bgImageViewWidth/2, bgImageViewHeight);
        _movelabel.text = @"";
        _movelabel.alpha = moveLabelAlpha;
        
    } completion:^(BOOL finish){
        if (finish == YES) {
            _movelabel.alpha = 1.0;
            _movelabel.text = dayString;
            [_calendarScrollView refreshView];
        }
    }];
}

-(UIButton *) setupCalendarHeaderTodayButtonWithFrame:(CGRect)frame
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = frame;
    [btn setTitle:@"Today" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont fontWithName:SemiboldFontName size:14.0]];
    [btn setTitleColor:AppMainColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickTodayButton) forControlEvents:UIControlEventTouchUpInside];

    return btn;
}

- (UIView *)setupWeekHeadViewWithFrame:(CGRect)frame {
    
    CGFloat height = frame.size.height;
    CGFloat width = frame.size.width / 7.0;
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    NSArray *weekArray = @[@"SUN", @"MON", @"TUE", @"WED", @"THR", @"FRI", @"SAT"];
    for (int i = 0; i < 7; ++i) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * width, 5.0, width, height)];
        label.text = weekArray[i];
        label.textColor = SetColor(91, 168, 101, 0.54);
        label.font = [UIFont systemFontOfSize:12.0];
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        
    }
    
    return view;
    
}

-(void) clickTodayButton
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDate *currentDate = [calendar dateFromComponents:components];
    
    NSInteger year = [currentDate dateYear];
    NSInteger month = [currentDate dateMonth];
    NSInteger day = [currentDate dateDay];
    
    NSDate *mydate = [StringManager stringTransferDate:[NSString stringWithFormat:@"%lu-%lu-%lu",(long)year,(long)month,day]];

    [StringManager setCalendarDayDictionary:mydate];
    _movelabel.frame = CGRectMake(0, 0, bgImageViewWidth/2, bgImageViewHeight);
    _movelabel.alpha = 1.0;
    _movelabel.text = dayString;
    [_calendarScrollView refreshView];
    self.didSelectDayHandler(year, month, day); // 执行回调
}

- (GFCalendarScrollView *)setupCalendarScrollViewWithFrame:(CGRect)frame {
    GFCalendarScrollView *scrollView = [[GFCalendarScrollView alloc] initWithFrame:frame];
    return scrollView;
}

- (void)setDidSelectDayHandler:(DidSelectDayHandler)didSelectDayHandler {
    _didSelectDayHandler = didSelectDayHandler;
    if (_calendarScrollView != nil) {
        _calendarScrollView.didSelectDayHandler = _didSelectDayHandler; // 传递 block
    }
}

- (void)addNotificationObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCalendarHeaderAction:) name:@"ChangeCalendarHeaderNotification" object:nil];
}


#pragma mark - Actions

- (void)refreshToCurrentMonthAction{
    
    NSInteger year = [[NSDate date] dateYear];
    NSInteger month = [[NSDate date] dateMonth];
    
    NSString *title = [NSString stringWithFormat:@"%@ %lu",[StringManager getEnglishMonth:month],(long)year];
    
    _calendarHeaderLabel.text = title;;
    
    [_calendarScrollView refreshToCurrentMonth];
    
}

- (void)changeCalendarHeaderAction:(NSNotification *)sender {
    
    NSDictionary *dic = sender.userInfo;
    
    NSNumber *year = dic[@"year"];
    NSNumber *month = dic[@"month"];
    
    NSString *title = [NSString stringWithFormat:@"%@ %@",[StringManager getEnglishMonth:[month longValue]], year];
    
    _calendarHeaderLabel.text = title;
}

@end
