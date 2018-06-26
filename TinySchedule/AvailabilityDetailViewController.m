//
//  AvailabilityDetailViewController.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/10/21.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "AvailabilityDetailViewController.h"

#define weekLabelWidth      80
#define weekLabelHeight     40
#define weekButtonWidth     50
#define availaButtonHeight    134
#define AddButtonWidth      30
#define availableBtnWidth  60

#define pickerViewHeight 200
#define bgViewHeight 260

@interface AvailabilityDetailViewController ()
{
    NSArray *arr_weekTitle;
    NSMutableArray *arr_SUN;
    NSMutableArray *arr_MON;
    NSMutableArray *arr_TUE;
    NSMutableArray *arr_WED;
    NSMutableArray *arr_THU;
    NSMutableArray *arr_FRI;
    NSMutableArray *arr_SAT;
    
    NSMutableArray *firstTimePickerArray;
    NSMutableArray *secondTimePickerArray;
    NSInteger firstTimeIndex;
    NSInteger secondTimeIndex;
    
    NSMutableDictionary *dict_configuration;
    
    NSMutableString *modifySubAvailabilities;
    NSMutableDictionary *currentOprationDict;

    UIButton *lastBtn;
    NSInteger editButtonTag;
    
    NSString *newParentUuid;
}
@end

@implementation AvailabilityDetailViewController
@synthesize uuid;
@synthesize employeeuuid;


-(void) getConfigurationSetting:(NSDictionary *)dict
{
    if (![[dict objectForKey:Availability_Configuration_YearMonthDay1] isEqualToString:[dict_configuration objectForKey:Availability_Configuration_YearMonthDay1]] || ![[dict objectForKey:Availability_Configuration_YearMonthDay2] isEqualToString:[dict_configuration objectForKey:Availability_Configuration_YearMonthDay2]]) {
        
        dict_configuration = nil;
        dict_configuration = [NSMutableDictionary dictionaryWithDictionary:dict];
        
        NSArray *arr = [modifySubAvailabilities componentsSeparatedByString:Availability_JsonStringseparator];
        NSMutableArray *arr_dict = [NSMutableArray array];
        for (NSString *jsonstring in arr) {
            NSDictionary *dict = [StringManager getDictionaryByJsonString:jsonstring];
            if (dict != nil) {
                [arr_dict addObject:dict];
            }
        }
        NSMutableArray *arr_dict2 = [NSMutableArray arrayWithArray:arr_dict];
        for (NSMutableDictionary *dict in arr_dict) {
            
            NSInteger index = [arr_dict indexOfObject:dict];
            
            NSString *time1 = @"";
            if ([[dict objectForKey:Availability_FromTime] containsString:@"a"]) {
                time1 = [[dict objectForKey:Availability_FromTime] stringByReplacingOccurrencesOfString:@" a.m." withString:@""];
            }
            else if ([[dict objectForKey:Availability_FromTime] containsString:@"p"])
            {
                time1 = [[dict objectForKey:Availability_FromTime] stringByReplacingOccurrencesOfString:@" p.m." withString:@""];
            }
            NSString *time2 = @"";
            if ([[dict objectForKey:Availability_ToTime] containsString:@"a"]) {
                time2 = [Availability_ToTime stringByReplacingOccurrencesOfString:@" a.m." withString:@""];
            }
            else if ([Availability_ToTime containsString:@"p"])
            {
                time2 = [Availability_ToTime stringByReplacingOccurrencesOfString:@" p.m." withString:@""];
            }
            
            NSString *year1 = [NSString stringWithFormat:@"%@ %@",[dict_configuration objectForKey:Availability_Configuration_YearMonthDay1],time1];
            NSString *year2 = [NSString stringWithFormat:@"%@ %@",[dict_configuration objectForKey:Availability_Configuration_YearMonthDay2],time2];
            
            [dict setObject:[StringManager stringDateTimeTransferTimeStamp:year1] forKey:Availability_StampEffectiveStart];
            if ([[dict_configuration objectForKey:Availability_Configuration_YearMonthDay2] isEqualToString:@"0"]) {
                [dict setObject:@"0" forKey:Availability_StampEffectiveEnd];
            }
            else
            {
                [dict setObject:[StringManager stringDateTimeTransferTimeStamp:year2] forKey:Availability_StampEffectiveEnd];
            }
            
            [arr_dict2 replaceObjectAtIndex:index withObject:dict];
        }
        NSMutableArray *arr_resultjsonstring = [NSMutableArray array];
        for (NSDictionary *dict in arr_dict2) {
            NSString *string = [StringManager getJsonStringByDictionary:(NSMutableDictionary *)dict];
            if (string != nil) {
                [arr_resultjsonstring addObject:string];
            }
        }
        modifySubAvailabilities = [NSMutableString stringWithString:[arr_resultjsonstring componentsJoinedByString:Availability_JsonStringseparator]];
    }
    [dict_configuration setObject:[dict objectForKey:Availability_Configuration_Title] forKey:Availability_Configuration_Title];
    [dict_configuration setObject:[dict objectForKey:Availability_Configuration_Rotation] forKey:Availability_Configuration_Rotation];
    [dict_configuration setObject:[dict objectForKey:Availability_Configuration_YearMonthDay1] forKey:Availability_Configuration_YearMonthDay1];
    [dict_configuration setObject:[dict objectForKey:Availability_Configuration_YearMonthDay2] forKey:Availability_Configuration_YearMonthDay2];
    [dict_configuration setObject:[dict objectForKey:Availability_Configuration_StringEffectiveDate1] forKey:Availability_Configuration_StringEffectiveDate1];
    [dict_configuration setObject:[dict objectForKey:Availability_Configuration_StringEffectiveDate2] forKey:Availability_Configuration_StringEffectiveDate2];
    [dict_configuration setObject:[dict objectForKey:Availability_Configuration_Rotation] forKey:Availability_Configuration_Rotation];
    if ([dict objectForKey:Availability_Configuration_Notes] != nil) {
        [dict_configuration setObject:[dict objectForKey:Availability_Configuration_Notes] forKey:Availability_Configuration_Notes];
    }
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        arr_SUN = [NSMutableArray array];
        arr_MON = [NSMutableArray array];
        arr_TUE = [NSMutableArray array];
        arr_WED = [NSMutableArray array];
        arr_THU = [NSMutableArray array];
        arr_FRI = [NSMutableArray array];
        arr_SAT = [NSMutableArray array];
        
        dict_configuration = [NSMutableDictionary dictionary];
        
        currentOprationDict = [NSMutableDictionary dictionary];
        
        firstTimeIndex = 20;        //time 初始的默认显示行数  －－ 0 component
        secondTimeIndex = 21;
        
        editButtonTag = -1;
        
        lastBtn = nil;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.navigationController.navigationBar.hidden = YES;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    arr_weekTitle = [NSArray arrayWithObjects:InternationalL(@"Sun"),InternationalL(@"Mon"),InternationalL(@"Tue"),InternationalL(@"Wed"),InternationalL(@"Thu"),InternationalL(@"Fri"),InternationalL(@"Sat"), nil];
    
    NSString *timePlistPath = [[NSBundle mainBundle] pathForResource:@"TimePlist" ofType:@"plist"];
    firstTimePickerArray = [NSMutableArray arrayWithContentsOfFile:timePlistPath];
    secondTimePickerArray = [NSMutableArray arrayWithContentsOfFile:timePlistPath];
    firstTimePickerArray = (NSMutableArray *)[firstTimePickerArray subarrayWithRange:NSMakeRange(0, 96)];
    
    Availability *availability = [DatabaseManager getAvailabilitybyUuid:uuid];
    NSArray *arr = nil;
    if (availability == nil) {
        
        newParentUuid = [StringManager getItemID];
        
        modifySubAvailabilities = nil;
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
        
        comps = [calendar components:unitFlags fromDate:[NSDate date]];
        
        //long week = [comps weekday];
        long year=[comps year];
        long month = [comps month];
        long day = [comps day];
        
        NSString *string_yearMonthDay1 = [NSString stringWithFormat:@"%lu-%lu-%lu",year,month,day];//2016-10-26
        NSString *string_yearMonthDay2 = @"0";//ongoing
        NSString *effective1 = [NSString stringWithFormat:@"%@, %@ %lu %lu",[StringManager featureWeekdayWithDate:year andMonth:month andDay:day],[StringManager getEnglishMonth:month],day,year];//Sat,Oct 26
        NSString *effective2 = @"0";//ongoing
        NSString *rotation = @"0";//every week
        
        [dict_configuration setObject:@"Default Availability" forKey:Availability_Configuration_Title];
        [dict_configuration setObject:effective1 forKey:Availability_Configuration_StringEffectiveDate1];
        [dict_configuration setObject:effective2 forKey:Availability_Configuration_StringEffectiveDate2];
        [dict_configuration setObject:string_yearMonthDay1 forKey:Availability_Configuration_YearMonthDay1];
        [dict_configuration setObject:string_yearMonthDay2 forKey:Availability_Configuration_YearMonthDay2];
        [dict_configuration setObject:rotation forKey:Availability_Configuration_Rotation];
        [dict_configuration setObject:employeeuuid forKey:Availability_Configuration_EmployeeUuid];
    }
    else
    {
        modifySubAvailabilities = [NSMutableString stringWithFormat:@"%@",availability.subAvailabilities];
        arr = [modifySubAvailabilities componentsSeparatedByString:Availability_JsonStringseparator];
        [dict_configuration setObject:availability.title forKey:Availability_Configuration_Title];
        [dict_configuration setObject:availability.string_effectiveDate1 forKey:Availability_Configuration_StringEffectiveDate1];
        [dict_configuration setObject:availability.string_effectiveDate2 forKey:Availability_Configuration_StringEffectiveDate2];
        [dict_configuration setObject:availability.string_yearMonthDay1 forKey:Availability_Configuration_YearMonthDay1];
        [dict_configuration setObject:availability.string_yearMonthDay2 forKey:Availability_Configuration_YearMonthDay2];
        [dict_configuration setObject:availability.rotation forKey:Availability_Configuration_Rotation];
        [dict_configuration setObject:employeeuuid forKey:Availability_Configuration_EmployeeUuid];
        if (availability.notes != nil) {
            [dict_configuration setObject:availability.notes forKey:Availability_Configuration_Notes];
        }
        arr = [availability.subAvailabilities componentsSeparatedByString:Availability_JsonStringseparator];
    }
    
    for (NSString *jsonstring in arr) {
        NSDictionary *dict = [StringManager getDictionaryByJsonString:jsonstring];
        if ([[dict objectForKey:Availability_Week] isEqualToString:@"0"]) {
            [arr_SUN addObject:dict];
        }
        else if ([[dict objectForKey:Availability_Week] isEqualToString:@"1"]) {
            [arr_MON addObject:dict];
        }
        else if ([[dict objectForKey:Availability_Week] isEqualToString:@"2"]) {
            [arr_TUE addObject:dict];
        }
        else if ([[dict objectForKey:Availability_Week] isEqualToString:@"3"]) {
            [arr_WED addObject:dict];
        }
        else if ([[dict objectForKey:Availability_Week] isEqualToString:@"4"]) {
            [arr_THU addObject:dict];
        }
        else if ([[dict objectForKey:Availability_Week] isEqualToString:@"5"]) {
            [arr_FRI addObject:dict];
        }
        else if ([[dict objectForKey:Availability_Week] isEqualToString:@"6"]) {
            [arr_SAT addObject:dict];
        }
    }
    
    [self initView];
    [_tableView reloadData];
    // Do any additional setup after loading the view from its nib.
}

-(void) initView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NavibarHeight, ScreenWidth, ScreenHeight - NavibarHeight - 50)];
        _scrollView.contentSize = CGSizeMake(weekLabelWidth * 7, ScreenHeight - NavibarHeight - 50);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.directionalLockEnabled=YES;//定向锁定
        [self.view addSubview:_scrollView];
        
        
        for (int i = 0; i < arr_weekTitle.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = CGRectMake(i * weekLabelWidth, 0, weekLabelWidth, weekLabelHeight);
            [btn setTitle:[arr_weekTitle objectAtIndex:i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
            [_scrollView addSubview:btn];
            btn.tag = i;
            [btn addTarget:self action:@selector(addAvailability:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, weekLabelHeight+10, weekLabelWidth * 7, 1)];
        line.backgroundColor = SetColor(240, 240, 240, 1.0);
        [_scrollView addSubview:line];
        
        for (int i = 0; i < arr_weekTitle.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i * weekLabelWidth, 30, weekLabelWidth, weekLabelHeight);
            [btn setImage:[UIImage imageNamed:@"addAvailable"] forState:UIControlStateNormal];
            [_scrollView addSubview:btn];
            btn.tag = i;
            [btn addTarget:self action:@selector(addAvailability:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, weekLabelWidth * 7, _scrollView.frame.size.height - 70)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_scrollView addSubview:_tableView];
    }
    
    if (_bgBlackView == nil) {
        
        _bgBlackView = [[UIView alloc]initWithFrame:CGRectMake(0, NavibarHeight, ScreenWidth, ScreenHeight)];
        _bgBlackView.backgroundColor = [UIColor blackColor];
        _bgBlackView.alpha = 0.2;
        [self.view addSubview:_bgBlackView];
        _bgBlackView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidebgBlackView:)];
        [_bgBlackView addGestureRecognizer:tap];
    }
    if (_bgWhiteView == nil) {
        _bgWhiteView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, bgViewHeight)];
        _bgWhiteView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_bgWhiteView];
        
        if (_preferrImageView == nil) {
            _preferrImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-208/2, 20, 208, 24)];
            _preferrImageView.image = [UIImage imageNamed:@"avai_preferred"];
            _preferrImageView.highlightedImage = [UIImage imageNamed:@"avai_unavailable"];
            _preferrImageView.userInteractionEnabled = YES;
            [_bgWhiteView addSubview:_preferrImageView];
            if (ScreenWidth == 320) {
                _preferrImageView.frame = CGRectMake(ScreenWidth/2-(208-20)/2, 20, 208-20, 24);
            }
        }
        if (_preferBtn == nil) {
            _preferBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            _preferBtn.frame = CGRectMake(0, 0, _preferrImageView.frame.size.width/2, _preferrImageView.frame.size.height);
            [_preferBtn setTitle:@"Preferred" forState:UIControlStateNormal];
            [_preferBtn setTitleColor:SetColor(0, 0, 0, 0.2) forState:UIControlStateNormal];
            _preferBtn.tag = 0;
            [_preferBtn.titleLabel setFont:[UIFont fontWithName:SemiboldFontName size:14.0]];
            [_preferrImageView addSubview:_preferBtn];
            [_preferBtn addTarget:self action:@selector(preferredAvailability:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        if (_unavailabilityBtn == nil) {
            _unavailabilityBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            _unavailabilityBtn.frame = CGRectMake(_preferrImageView.frame.size.width/2, 0, _preferrImageView.frame.size.width/2, _preferrImageView.frame.size.height);
            [_unavailabilityBtn setTitle:@"Unavailable" forState:UIControlStateNormal];
            [_unavailabilityBtn setTitleColor:SetColor(0, 0, 0, 0.2) forState:UIControlStateNormal];
            _unavailabilityBtn.tag = 1;
            [_unavailabilityBtn.titleLabel setFont:[UIFont fontWithName:SemiboldFontName size:14.0]];
            [_preferrImageView addSubview:_unavailabilityBtn];
            [_unavailabilityBtn addTarget:self action:@selector(preferredAvailability:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if (_pickerViewTime == nil) {
            _pickerViewTime = [[UIPickerView alloc]initWithFrame:CGRectMake(0 , 60, ScreenWidth , pickerViewHeight)];
            _pickerViewTime.delegate = self;
            _pickerViewTime.dataSource = self;
            [_pickerViewTime selectRow:firstTimeIndex inComponent:0 animated:YES];
            [_pickerViewTime selectRow:secondTimeIndex inComponent:1 animated:YES];
            [_bgWhiteView addSubview:_pickerViewTime];
            //[self changeTime:[firstTimePickerArray objectAtIndex:firstTimeIndex] and:[secondTimePickerArray objectAtIndex:secondTimeIndex]];
        }
        if (_allDayButton == nil) {
            _allDayButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            _allDayButton.frame = CGRectMake(ScreenWidth - 80, 20, 80, 24);
            [_allDayButton setTitle:@"All Day" forState:UIControlStateNormal];
            [_allDayButton setTitleColor:TextColorAlpha_54 forState:UIControlStateNormal];
            [_allDayButton.titleLabel setFont:[UIFont fontWithName:SemiboldFontName size:14.0]];
            [_bgWhiteView addSubview:_allDayButton];
            [_allDayButton addTarget: self action:@selector(setAllDay) forControlEvents:UIControlEventTouchUpInside];
            
            if (ScreenWidth == 320) {
                _allDayButton.frame = CGRectMake(ScreenWidth - 70, 20, 70, 24);
            }
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //第一列的button：tag ＝ 1000+indexpath.row     SUN
    //第二列的button：tag ＝ 2000+indexpath.row     MON
    //第三列的button：tag ＝ 3000+indexpath.row     TUE
    //第四列的button：tag ＝ 4000+indexpath.row     WED
    //第五列的button：tag ＝ 5000+indexpath.row     THU
    //第六列的button：tag ＝ 6000+indexpath.row     FRI
    //第七列的button：tag ＝ 7000+indexpath.row     SAT
    
    if (indexPath.row == 0) {
        
        for (int i = 0; i < 7; i++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i * weekLabelWidth, 0, weekLabelWidth, availaButtonHeight);
            [btn setImage:[UIImage imageNamed:@"a_allDay"] forState:UIControlStateNormal];
            [cell.contentView addSubview:btn];
            
            btn.tag = (i + 1) * 1000;//1000,2000,3000,4000,5000,6000,7000
            
            [btn addTarget:self action:@selector(editAvailable:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, btn.frame.size.width, btn.frame.size.height)];
            lab.text = @"All Day";
            lab.numberOfLines = 3;
            lab.lineBreakMode = NSLineBreakByWordWrapping;
            lab.textColor = SetColor(0, 0, 0, 0.3);
            lab.font = [UIFont fontWithName:SemiboldFontName size:14.0];
            lab.textAlignment = NSTextAlignmentCenter;
            [btn addSubview:lab];
            
            NSDictionary *dict = nil;
            if (i == 0) {
                if (arr_SUN.count != 0 && arr_SUN.count-1 >= indexPath.row) {
                    dict = [arr_SUN objectAtIndex:0];
                }
            }
            else if (i == 1)
            {
                if (arr_MON.count != 0 && arr_MON.count-1 >= indexPath.row) {
                    dict = [arr_MON objectAtIndex:0];
                }
            }
            else if (i == 2)
            {
                if (arr_TUE.count != 0 && arr_TUE.count-1 >= indexPath.row) {
                    dict = [arr_TUE objectAtIndex:0];
                }
            }
            else if (i == 3)
            {
                if (arr_WED.count != 0 && arr_WED.count-1 >= indexPath.row) {
                    dict = [arr_WED objectAtIndex:0];
                }
            }
            else if (i == 4)
            {
                if (arr_THU.count != 0 && arr_THU.count-1 >= indexPath.row) {
                    dict = [arr_THU objectAtIndex:0];
                }
            }
            else if (i == 5)
            {
                if (arr_FRI.count != 0 && arr_FRI.count-1 >= indexPath.row) {
                    dict = [arr_FRI objectAtIndex:0];
                }
            }
            else if (i == 6)
            {
                if (arr_SAT.count != 0 && arr_SAT.count-1 >= indexPath.row) {
                    dict = [arr_SAT objectAtIndex:0];
                }
            }
            if (dict != nil) {
                if ([[dict objectForKey:Availability_State] isEqualToString:@"0"]) {
                    [btn setImage:[UIImage imageNamed:@"a_preferred"] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"a_preferred_delete"] forState:UIControlStateSelected];
                }
                else
                {
                    [btn setImage:[UIImage imageNamed:@"a_unavailable"] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"a_unavailable_delete"] forState:UIControlStateSelected];
                }
                if ([dict isEqualToDictionary:currentOprationDict]) {
                    btn.selected = YES;
                }
                if ([[dict objectForKey:Availability_IsAllDay] isEqualToString:@"1"]) {
                    lab.text = @"All Day";
                }
                else
                {
                    lab.text = [NSString stringWithFormat:@"%@\n%@\n%@",[[dict objectForKey:Availability_FromTime] stringByReplacingOccurrencesOfString:@".m." withString:@""],@"I",[[dict objectForKey:Availability_ToTime] stringByReplacingOccurrencesOfString:@".m." withString:@""]];
                }
                lab.textColor = [UIColor whiteColor];
            }
        }
    }
    else
    {
        if (arr_SUN.count >= 2 || arr_MON.count >= 2 || arr_TUE.count >= 2 || arr_WED.count >= 2 || arr_THU.count >=2 || arr_FRI.count >= 2 || arr_SAT.count >= 2) {
            
            for (int i = 0; i < 7; i++) {
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(i * weekLabelWidth, 0, weekLabelWidth, availaButtonHeight);
                [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                
                btn.tag = (i + 1) * 1000 + indexPath.row;//1001,2001,3001,4001,5001,6001,7001
                
                [btn addTarget:self action:@selector(editAvailable:) forControlEvents:UIControlEventTouchUpInside];
                
                UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, weekLabelWidth, availaButtonHeight)];
                lab.numberOfLines = 3;
                lab.lineBreakMode = NSLineBreakByWordWrapping;
                lab.textColor = [UIColor lightGrayColor];
                lab.font = [UIFont boldSystemFontOfSize:15.0];
                lab.textAlignment = NSTextAlignmentCenter;
                
                NSDictionary *dict = nil;
                if (i == 0) {
                    if (arr_SUN.count != 0 && arr_SUN.count-1 >= indexPath.row) {
                        dict = [arr_SUN objectAtIndex:indexPath.row];
                        [cell.contentView addSubview:btn];
                        [btn addSubview:lab];
                    }
                }
                else if (i == 1)
                {
                    if (arr_MON.count != 0 && arr_MON.count-1 >= indexPath.row) {
                        dict = [arr_MON objectAtIndex:indexPath.row];
                        [cell.contentView addSubview:btn];
                        [btn addSubview:lab];
                    }
                }
                else if (i == 2)
                {
                    if (arr_TUE.count != 0 && arr_TUE.count-1 >= indexPath.row) {
                        dict = [arr_TUE objectAtIndex:indexPath.row];
                        [cell.contentView addSubview:btn];
                        [btn addSubview:lab];
                    }
                }
                else if (i == 3)
                {
                    if (arr_WED.count != 0 && arr_WED.count-1 >= indexPath.row) {
                        dict = [arr_WED objectAtIndex:indexPath.row];
                        [cell.contentView addSubview:btn];
                        [btn addSubview:lab];
                    }
                }
                else if (i == 4)
                {
                    if (arr_THU.count != 0 && arr_THU.count-1 >= indexPath.row) {
                        dict = [arr_THU objectAtIndex:indexPath.row];
                        [cell.contentView addSubview:btn];
                        [btn addSubview:lab];
                    }
                }
                else if (i == 5)
                {
                    if (arr_FRI.count != 0 && arr_FRI.count-1 >= indexPath.row) {
                        dict = [arr_FRI objectAtIndex:indexPath.row];
                        [cell.contentView addSubview:btn];
                        [btn addSubview:lab];
                    }
                }
                else if (i == 6)
                {
                    if (arr_SAT.count != 0 && arr_SAT.count-1 >= indexPath.row) {
                        dict = [arr_SAT objectAtIndex:indexPath.row];
                        [cell.contentView addSubview:btn];
                        [btn addSubview:lab];
                    }
                }
                if (dict != nil) {
                    if ([[dict objectForKey:Availability_State] isEqualToString:@"0"]) {
                        [btn setImage:[UIImage imageNamed:@"a_preferred"] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:@"a_preferred_delete"] forState:UIControlStateSelected];
                    }
                    else
                    {
                        [btn setImage:[UIImage imageNamed:@"a_unavailable"] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:@"a_unavailable_delete"] forState:UIControlStateSelected];
                    }
                    if ([dict isEqualToDictionary:currentOprationDict]) {
                        btn.selected = YES;
                    }
                    
                    if ([[dict objectForKey:Availability_IsAllDay] isEqualToString:@"1"]) {
                        lab.text = @"All Day";
                    }
                    else
                    {
                        lab.text = [NSString stringWithFormat:@"%@\n%@\n%@",[[dict objectForKey:Availability_FromTime] stringByReplacingOccurrencesOfString:@".m." withString:@""],@"I",[[dict objectForKey:Availability_ToTime] stringByReplacingOccurrencesOfString:@".m." withString:@""]];
                    }
                    lab.textColor = [UIColor whiteColor];
                }
            }
        }
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UIView animateWithDuration:AnimatedDuration animations:^{
        _bgWhiteView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, bgViewHeight);
        _tableView.frame = CGRectMake(0, 70, weekLabelWidth * 7, _scrollView.frame.size.height - 70);
        currentOprationDict = nil;
        [self refreshData:currentOprationDict];
    } completion:^(BOOL finished){
        _bgBlackView.hidden = YES;
    }];
}

-(void)hidebgBlackView:(UITapGestureRecognizer *)tap
{
    
    [UIView animateWithDuration:AnimatedDuration animations:^{
        _bgWhiteView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, bgViewHeight);
        _tableView.frame = CGRectMake(0, 70, weekLabelWidth * 7, _scrollView.frame.size.height - 70);
        currentOprationDict = nil;
        [self refreshData:currentOprationDict];
    } completion:^(BOOL finished){
        _bgBlackView.hidden = YES;
    }];
}

-(void) preferredAvailability:(UIButton *)sender
{
    if (sender.tag == 0) {
        _preferrImageView.highlighted = NO;
        [_preferBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_unavailabilityBtn setTitleColor:SetColor(0, 0, 0, 0.2) forState:UIControlStateNormal];
    }
    else
    {
        _preferrImageView.highlighted = YES;
        [_unavailabilityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_preferBtn setTitleColor:SetColor(0, 0, 0, 0.2) forState:UIControlStateNormal];
    }
    if ([[currentOprationDict objectForKey:Availability_State] intValue] != sender.tag) {
        
        NSString *mystate = [NSString stringWithFormat:@"%lu",(unsigned long)sender.tag];
        
        NSArray *arr = [modifySubAvailabilities componentsSeparatedByString:Availability_JsonStringseparator];
        NSMutableArray *arr_dict = [NSMutableArray array];
        for (NSString *jsonstring in arr) {
            NSDictionary *dict = [StringManager getDictionaryByJsonString:jsonstring];
            if (dict != nil) {
                [arr_dict addObject:dict];
            }
        }
        
        BOOL isreload = NO;
        for (NSDictionary *dict in arr_dict) {
            if (editButtonTag >= 1000 && editButtonTag < 2000 && [arr_SUN containsObject:dict]) {
                
                NSMutableDictionary *dict_temp = [NSMutableDictionary dictionaryWithDictionary:[arr_SUN objectAtIndex:editButtonTag-1000]];
                if ([[dict_temp objectForKey:Availability_Uuid] isEqualToString:[dict objectForKey:Availability_Uuid]]) {
                    [dict_temp setObject:mystate forKey:Availability_State];
                    NSInteger index = [arr_dict indexOfObject:dict];
                    [arr_dict replaceObjectAtIndex:index withObject:dict_temp];
                    NSInteger index2 = [arr_SUN indexOfObject:dict];
                    [arr_SUN replaceObjectAtIndex:index2 withObject:dict_temp];
                    currentOprationDict = dict_temp;
                    isreload = YES;
                    break;
                }
            }
            else if (editButtonTag >= 2000 && editButtonTag < 3000 && [arr_MON containsObject:dict]) {
                NSMutableDictionary *dict_temp = [NSMutableDictionary dictionaryWithDictionary:[arr_MON objectAtIndex:editButtonTag-2000]];
                if ([[dict_temp objectForKey:Availability_Uuid] isEqualToString:[dict objectForKey:Availability_Uuid]]) {
                    [dict_temp setObject:mystate forKey:Availability_State];
                    NSInteger index = [arr_dict indexOfObject:dict];
                    [arr_dict replaceObjectAtIndex:index withObject:dict_temp];
                    NSInteger index2 = [arr_MON indexOfObject:dict];
                    [arr_MON replaceObjectAtIndex:index2 withObject:dict_temp];
                    currentOprationDict = dict_temp;
                    isreload = YES;
                    break;
                }
            }
            else if (editButtonTag >= 3000 && editButtonTag < 4000 && [arr_TUE containsObject: dict]) {
                NSMutableDictionary *dict_temp = [NSMutableDictionary dictionaryWithDictionary:[arr_TUE objectAtIndex:editButtonTag-3000]];
                if ([[dict_temp objectForKey:Availability_Uuid] isEqualToString:[dict objectForKey:Availability_Uuid]]) {
                    [dict_temp setObject:mystate forKey:Availability_State];
                    NSInteger index = [arr_dict indexOfObject:dict];
                    [arr_dict replaceObjectAtIndex:index withObject:dict_temp];
                    NSInteger index2 = [arr_TUE indexOfObject:dict];
                    [arr_TUE replaceObjectAtIndex:index2 withObject:dict_temp];
                    currentOprationDict = dict_temp;
                    isreload = YES;
                    break;
                }
            }
            else if (editButtonTag >= 4000 && editButtonTag < 5000 && [arr_WED containsObject:dict]) {
                NSMutableDictionary *dict_temp = [NSMutableDictionary dictionaryWithDictionary:[arr_WED objectAtIndex:editButtonTag-4000]];
                if ([[dict_temp objectForKey:Availability_Uuid] isEqualToString:[dict objectForKey:Availability_Uuid]]) {
                    [dict_temp setObject:mystate forKey:Availability_State];
                    NSInteger index = [arr_dict indexOfObject:dict];
                    [arr_dict replaceObjectAtIndex:index withObject:dict_temp];
                    NSInteger index2 = [arr_WED indexOfObject:dict];
                    [arr_WED replaceObjectAtIndex:index2 withObject:dict_temp];
                    currentOprationDict = dict_temp;
                    isreload = YES;
                    break;
                }
            }
            else if (editButtonTag >= 5000 && editButtonTag < 6000 && [arr_THU containsObject: dict]) {
                NSMutableDictionary *dict_temp = [NSMutableDictionary dictionaryWithDictionary:[arr_THU objectAtIndex:editButtonTag-5000]];
                if ([[dict_temp objectForKey:Availability_Uuid] isEqualToString:[dict objectForKey:Availability_Uuid]]) {
                    [dict_temp setObject:mystate forKey:Availability_State];
                    NSInteger index = [arr_dict indexOfObject:dict];
                    [arr_dict replaceObjectAtIndex:index withObject:dict_temp];
                    NSInteger index2 = [arr_THU indexOfObject:dict];
                    [arr_THU replaceObjectAtIndex:index2 withObject:dict_temp];
                    currentOprationDict = dict_temp;
                    isreload = YES;
                    break;
                }
            }
            else if (editButtonTag >= 6000 && editButtonTag < 7000 && [arr_FRI containsObject: dict]) {
                NSMutableDictionary *dict_temp = [NSMutableDictionary dictionaryWithDictionary:[arr_FRI objectAtIndex:editButtonTag-6000]];
                if ([[dict_temp objectForKey:Availability_Uuid] isEqualToString:[dict objectForKey:Availability_Uuid]]) {
                    [dict_temp setObject:mystate forKey:Availability_State];
                    NSInteger index = [arr_dict indexOfObject:dict];
                    [arr_dict replaceObjectAtIndex:index withObject:dict_temp];
                    NSInteger index2 = [arr_FRI indexOfObject:dict];
                    [arr_FRI replaceObjectAtIndex:index2 withObject:dict_temp];
                    currentOprationDict = dict_temp;
                    isreload = YES;
                    break;
                }
            }
            else if (editButtonTag >= 7000 && [arr_SAT containsObject:dict]) {
                NSMutableDictionary *dict_temp = [NSMutableDictionary dictionaryWithDictionary:[arr_SAT objectAtIndex:editButtonTag-7000]];
                if ([[dict_temp objectForKey:Availability_Uuid] isEqualToString:[dict objectForKey:Availability_Uuid]]) {
                    [dict_temp setObject:mystate forKey:Availability_State];
                    NSInteger index = [arr_dict indexOfObject:dict];
                    [arr_dict replaceObjectAtIndex:index withObject:dict_temp];
                    NSInteger index2 = [arr_SAT indexOfObject:dict];
                    [arr_SAT replaceObjectAtIndex:index2 withObject:dict_temp];
                    currentOprationDict = dict_temp;
                    isreload = YES;
                    break;
                }
            }
        }
        if (isreload == YES) {
            //[currentOprationDict setObject:mystate forKey:Availability_State];
            NSMutableArray *arr_resultjsonstring = [NSMutableArray array];
            for (NSDictionary *dict in arr_dict) {
                NSString *string = [StringManager getJsonStringByDictionary:(NSMutableDictionary *)dict];
                [arr_resultjsonstring addObject:string];
            }
            modifySubAvailabilities = [NSMutableString stringWithString:[arr_resultjsonstring componentsJoinedByString:Availability_JsonStringseparator]];
            [_tableView reloadData];
        }
    }
}


-(void)addAvailability:(UIButton *)sender
{
    currentOprationDict = nil;

    NSInteger index = 0;

    if (sender.tag == 0) {
        editButtonTag = (sender.tag+1) * 1000+arr_SUN.count;
    }
    else if (sender.tag == 1)
    {
        editButtonTag = (sender.tag+1) * 1000+arr_MON.count;
    }
    else if (sender.tag == 2)
    {
        editButtonTag = (sender.tag+1) * 1000+arr_TUE.count;
    }
    else if (sender.tag == 3)
    {
        editButtonTag = (sender.tag+1) * 1000+arr_WED.count;
    }
    else if (sender.tag == 4)
    {
        editButtonTag = (sender.tag+1) * 1000+arr_THU.count;
    }
    else if (sender.tag == 5)
    {
        editButtonTag = (sender.tag+1) * 1000+arr_FRI.count;
    }
    else if (sender.tag == 6)
    {
        editButtonTag = (sender.tag+1) * 1000+arr_SAT.count;
    }
    
    int passvalue = 0;
    if (editButtonTag >= 1000 && editButtonTag < 2000)
    {
        passvalue = 0;
    }
    else if (editButtonTag >= 2000 && editButtonTag < 3000)
    {
        passvalue = 1;
    }
    else if (editButtonTag >= 3000 && editButtonTag < 4000)
    {
        passvalue = 2;
    }
    else if (editButtonTag >= 4000 && editButtonTag < 5000)
    {
        passvalue = 3;
    }
    else if (editButtonTag >= 5000 && editButtonTag < 6000)
    {
        passvalue = 4;
    }
    else if (editButtonTag >= 6000 && editButtonTag < 7000)
    {
        passvalue = 5;
    }
    else if (editButtonTag >= 7000)
    {
        passvalue = 6;
    }
    [self isShowAllDayButton:passvalue];
    
    if (sender.tag == 0) {
        
        BOOL isMobile = NO;
        if (arr_SUN.count < 3) {
            if (arr_SUN.count == 1) {
                NSDictionary *dict = [arr_SUN objectAtIndex:0];
                if ([[dict objectForKey:Availability_IsAllDay] isEqualToString:@"0"]) {
                    isMobile = YES;
                    [self beganToAddAvailability:sender.tag];
                }
            }
            else
            {
                isMobile = YES;
                [self beganToAddAvailability:sender.tag];
            }
        }
        if (isMobile == YES) {
            index = editButtonTag - 1000;
        }
    }
    else if (sender.tag == 1) {
        BOOL isMobile = NO;
        if (arr_MON.count < 3) {
            if (arr_MON.count == 1) {
                NSDictionary *dict = [arr_MON objectAtIndex:0];
                if ([[dict objectForKey:Availability_IsAllDay] isEqualToString:@"0"]) {
                    isMobile = YES;
                    [self beganToAddAvailability:sender.tag];
                }
            }
            else
            {
                isMobile = YES;
                [self beganToAddAvailability:sender.tag];
            }
        }
        if (isMobile == YES) {
            index = editButtonTag - 2000;
        }
    }
    else if (sender.tag == 2) {
        BOOL isMobile = NO;
        if (arr_TUE.count < 3) {
            if (arr_TUE.count == 1) {
                NSDictionary *dict = [arr_TUE objectAtIndex:0];
                if ([[dict objectForKey:Availability_IsAllDay] isEqualToString:@"0"]) {
                    isMobile = YES;
                    [self beganToAddAvailability:sender.tag];
                }
            }
            else
            {
                isMobile = YES;
                [self beganToAddAvailability:sender.tag];
            }
        }
        if (isMobile == YES) {
            index = editButtonTag - 3000;
        }
    }
    else if (sender.tag == 3) {
        BOOL isMobile = NO;
        if (arr_WED.count < 3) {
            if (arr_WED.count == 1) {
                NSDictionary *dict = [arr_WED objectAtIndex:0];
                if ([[dict objectForKey:Availability_IsAllDay] isEqualToString:@"0"]) {
                    isMobile = YES;
                    [self beganToAddAvailability:sender.tag];
                }
            }
            else
            {
                isMobile = YES;
                [self beganToAddAvailability:sender.tag];
            }
        }
        if (isMobile == YES) {
            index = editButtonTag - 4000;
        }
    }
    else if (sender.tag == 4) {
        BOOL isMobile = NO;
        if (arr_THU.count < 3) {
            if (arr_THU.count == 1) {
                NSDictionary *dict = [arr_THU objectAtIndex:0];
                if ([[dict objectForKey:Availability_IsAllDay] isEqualToString:@"0"]) {
                    isMobile = YES;
                    [self beganToAddAvailability:sender.tag];
                }
            }
            else
            {
                isMobile = YES;
                [self beganToAddAvailability:sender.tag];
            }
        }
        if (isMobile == YES) {
            index = editButtonTag - 5000;
        }
    }
    else if (sender.tag == 5) {
        BOOL isMobile = NO;
        if (arr_FRI.count < 3) {
            if (arr_FRI.count == 1) {
                NSDictionary *dict = [arr_FRI objectAtIndex:0];
                if ([[dict objectForKey:Availability_IsAllDay] isEqualToString:@"0"]) {
                    isMobile = YES;
                    [self beganToAddAvailability:sender.tag];
                }
            }
            else
            {
                isMobile = YES;
                [self beganToAddAvailability:sender.tag];
            }
        }
        if (isMobile == YES) {
            index = editButtonTag - 6000;
        }
    }
    else if (sender.tag == 6) {
        BOOL isMobile = NO;
        if (arr_SAT.count < 3) {
            if (arr_SAT.count == 1) {
                NSDictionary *dict = [arr_SAT objectAtIndex:0];
                if ([[dict objectForKey:Availability_IsAllDay] isEqualToString:@"0"]) {
                    isMobile = YES;
                    [self beganToAddAvailability:sender.tag];
                }
            }
            else
            {
                isMobile = YES;
                [self beganToAddAvailability:sender.tag];
            }
        }
        if (isMobile == YES) {
            index = editButtonTag - 7000;
        }
    }
    [self mobileTableview:index];
}

-(void) mobileTableview:(NSInteger) index
{
    if (ScreenWidth == 414) {
        if (index == 2)
        {
            [UIView animateWithDuration:AnimatedDuration animations:^{
                _tableView.frame = CGRectMake(0, -60, weekLabelWidth * 7, _scrollView.frame.size.height - 70);
            }];
        }
    }
    else if (ScreenWidth == 375)
    {
        if (index == 1) {
            [UIView animateWithDuration:AnimatedDuration animations:^{
                _tableView.frame = CGRectMake(0, 60, weekLabelWidth * 7, _scrollView.frame.size.height);
            }];
        }
        else if (index == 2)
        {
            [UIView animateWithDuration:AnimatedDuration animations:^{
                _tableView.frame = CGRectMake(0, -80, weekLabelWidth * 7, _scrollView.frame.size.height);
            }];
        }
    }
    else if (ScreenWidth < 375)
    {
        if (index == 1) {
            [UIView animateWithDuration:AnimatedDuration animations:^{
                _tableView.frame = CGRectMake(0, -40, weekLabelWidth * 7, _scrollView.frame.size.height - 70);
            }];
        }
        else if (index == 2)
        {
            [UIView animateWithDuration:AnimatedDuration animations:^{
                _tableView.frame = CGRectMake(0, -180, weekLabelWidth * 7, _scrollView.frame.size.height);
            }];
        }
    }
}

-(void) mobileTableview2:(NSInteger) index
{
    if (ScreenWidth == 414) {
        if (index == 2)
        {
            _tableView.frame = CGRectMake(0, -60, weekLabelWidth * 7, _scrollView.frame.size.height - 70);
        }
    }
    else if (ScreenWidth == 375)
    {
        if (index == 1) {
            _tableView.frame = CGRectMake(0, 60, weekLabelWidth * 7, _scrollView.frame.size.height);
        }
        else if (index == 2)
        {
            _tableView.frame = CGRectMake(0, -80, weekLabelWidth * 7, _scrollView.frame.size.height);
        }
    }
    else if (ScreenWidth < 375)
    {
        if (index == 1) {
            _tableView.frame = CGRectMake(0, -40, weekLabelWidth * 7, _scrollView.frame.size.height - 70);
        }
        else if (index == 2)
        {
            _tableView.frame = CGRectMake(0, -180, weekLabelWidth * 7, _scrollView.frame.size.height);
        }
    }
}

-(void) beganToAddAvailability:(NSInteger) tag
{
    _bgWhiteView.backgroundColor = [UIColor whiteColor];
    _preferrImageView.highlighted = NO;
    [_preferBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_unavailabilityBtn setTitleColor:SetColor(178, 178, 178, 1.0) forState:UIControlStateNormal];
    _bgBlackView.hidden = NO;
    [UIView animateWithDuration:AnimatedDuration animations:^{
        
        _bgWhiteView.frame = CGRectMake(0, ScreenHeight - bgViewHeight, ScreenWidth, bgViewHeight);
        
        currentOprationDict = [NSMutableDictionary dictionary];
        [currentOprationDict setObject:[StringManager getItemID] forKey:Availability_Uuid];
        if(uuid != nil)
        {
            [currentOprationDict setObject:uuid forKey:Availability_ParentUuid];
        }
        else
        {
            [currentOprationDict setObject:newParentUuid forKey:Availability_ParentUuid];
        }
        [currentOprationDict setObject:[NSString stringWithFormat:@"%lu",(unsigned long)tag] forKey:Availability_Week];
        [currentOprationDict setObject:@"0" forKey:Availability_State];
        [currentOprationDict setObject:@"0" forKey:Availability_IsAllDay];
        NSString *time1 = [firstTimePickerArray objectAtIndex:firstTimeIndex];
        NSString *time2 = [secondTimePickerArray objectAtIndex:secondTimeIndex];
        [currentOprationDict setObject:time1 forKey:Availability_FromTime];
        [currentOprationDict setObject:time2 forKey:Availability_ToTime];
        NSString *str1 = @"";
        if ([time1 containsString:@"a"]) {
            str1 = [time1 stringByReplacingOccurrencesOfString:@" a.m." withString:@""];
        }
        else if ([time1 containsString:@"p"]) {
            str1 = [time1 stringByReplacingOccurrencesOfString:@" p.m." withString:@""];
        }
        NSString *str2 = @"";
        if ([time2 containsString:@"a"]) {
            str2 = [time2 stringByReplacingOccurrencesOfString:@" a.m." withString:@""];
        }
        else if ([time2 containsString:@"p"]) {
            str2 = [time2 stringByReplacingOccurrencesOfString:@" p.m." withString:@""];
        }
        NSString *year1 = [NSString stringWithFormat:@"%@ %@",[dict_configuration objectForKey:Availability_Configuration_YearMonthDay1],str1];
        NSString *year2 = [NSString stringWithFormat:@"%@ %@",[dict_configuration objectForKey:Availability_Configuration_YearMonthDay2],str2];
        [currentOprationDict setObject:[StringManager stringDateTimeTransferTimeStamp:year1] forKey:Availability_StampEffectiveStart];
        [currentOprationDict setObject:[StringManager stringDateTimeTransferTimeStamp:year2] forKey:Availability_StampEffectiveEnd];
        [self refreshData:currentOprationDict];
    } completion:^(BOOL finished){
    }];
}

-(void) refreshData:(NSMutableDictionary *) dict
{
    NSArray *arr = [modifySubAvailabilities componentsSeparatedByString:Availability_JsonStringseparator];
    if (arr.count == 0) {
        NSString *addJsonString = [StringManager getJsonStringByDictionary:dict];
        if (modifySubAvailabilities == nil) {
            modifySubAvailabilities = [NSMutableString stringWithFormat:@"%@",addJsonString];
        }
        else
        {
            modifySubAvailabilities = [NSMutableString stringWithFormat:@"%@%@%@",modifySubAvailabilities,Availability_JsonStringseparator,addJsonString];
        }
        if ([[dict objectForKey:Availability_Week] isEqualToString:@"0"]) {
            [arr_SUN addObject:dict];
        }
        else if ([[dict objectForKey:Availability_Week] isEqualToString:@"1"]) {
            [arr_MON addObject:dict];
        }
        else if ([[dict objectForKey:Availability_Week] isEqualToString:@"2"]) {
            [arr_TUE addObject:dict];
        }
        else if ([[dict objectForKey:Availability_Week] isEqualToString:@"3"]) {
            [arr_WED addObject:dict];
        }
        else if ([[dict objectForKey:Availability_Week] isEqualToString:@"4"]) {
            [arr_THU addObject:dict];
        }
        else if ([[dict objectForKey:Availability_Week] isEqualToString:@"5"]) {
            [arr_FRI addObject:dict];
        }
        else if ([[dict objectForKey:Availability_Week] isEqualToString:@"6"]) {
            [arr_SAT addObject:dict];
        }
    }
    else
    {
        for (NSString *jsonstring in arr)
        {
            NSMutableDictionary *dict_temp = [NSMutableDictionary dictionaryWithDictionary:[StringManager getDictionaryByJsonString:jsonstring]];
            if ([[dict objectForKey:Availability_Uuid] isEqualToString:[dict_temp objectForKey:Availability_Uuid]]) {
                //modify
                NSArray *arr2 = [modifySubAvailabilities componentsSeparatedByString:Availability_JsonStringseparator];
                NSMutableArray *arr_dcit = [NSMutableArray array];
                for (NSString *jsonstring in arr2) {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[StringManager getDictionaryByJsonString:jsonstring]];
                    [arr_dcit addObject:dict];
                }
                for (NSDictionary *dict2 in arr_dcit) {
                    if ([[dict2 objectForKey:Availability_Uuid] isEqualToString:[dict objectForKey:Availability_Uuid]]) {
                        [arr_dcit removeObject: dict2];
                        [arr_dcit addObject:dict];
                        break;
                    }
                }
                NSMutableArray *arr_string = [NSMutableArray array];
                for (NSDictionary *dict3 in arr_dcit) {
                    NSString *string = [StringManager getJsonStringByDictionary:(NSMutableDictionary *)dict3];
                    [arr_string addObject:string];
                }
                modifySubAvailabilities = [NSMutableString stringWithString:[arr_string componentsJoinedByString:Availability_JsonStringseparator]];
                break;
            }
            else
            {
                if ([[dict objectForKey:Availability_Week] isEqualToString:@"0"] && ![arr_SUN containsObject:dict]) {
                    [arr_SUN addObject:dict];
                    //add
                    NSString *addJsonString = [StringManager getJsonStringByDictionary:dict];
                    if (modifySubAvailabilities == nil) {
                        modifySubAvailabilities = [NSMutableString stringWithFormat:@"%@",addJsonString];
                    }
                    else
                    {
                        modifySubAvailabilities = [NSMutableString stringWithFormat:@"%@%@%@",modifySubAvailabilities,Availability_JsonStringseparator,addJsonString];
                    }
                    break;
                }
                else if ([[dict objectForKey:Availability_Week] isEqualToString:@"1"] && ![arr_MON containsObject:dict]) {
                    [arr_MON addObject:dict];
                    //add
                    NSString *addJsonString = [StringManager getJsonStringByDictionary:dict];
                    if (modifySubAvailabilities == nil) {
                        modifySubAvailabilities = [NSMutableString stringWithFormat:@"%@",addJsonString];
                    }
                    else
                    {
                        modifySubAvailabilities = [NSMutableString stringWithFormat:@"%@%@%@",modifySubAvailabilities,Availability_JsonStringseparator,addJsonString];
                    }
                    break;
                }
                else if ([[dict objectForKey:Availability_Week] isEqualToString:@"2"] && ![arr_TUE containsObject:dict]) {
                    [arr_TUE addObject:dict];
                    //add
                    NSString *addJsonString = [StringManager getJsonStringByDictionary:dict];
                    if (modifySubAvailabilities == nil) {
                        modifySubAvailabilities = [NSMutableString stringWithFormat:@"%@",addJsonString];
                    }
                    else
                    {
                        modifySubAvailabilities = [NSMutableString stringWithFormat:@"%@%@%@",modifySubAvailabilities,Availability_JsonStringseparator,addJsonString];
                    }
                    break;
                }
                else if ([[dict objectForKey:Availability_Week] isEqualToString:@"3"] && ![arr_WED containsObject:dict]) {
                    [arr_WED addObject:dict];
                    //add
                    NSString *addJsonString = [StringManager getJsonStringByDictionary:dict];
                    if (modifySubAvailabilities == nil) {
                        modifySubAvailabilities = [NSMutableString stringWithFormat:@"%@",addJsonString];
                    }
                    else
                    {
                        modifySubAvailabilities = [NSMutableString stringWithFormat:@"%@%@%@",modifySubAvailabilities,Availability_JsonStringseparator,addJsonString];
                    }
                    break;
                }
                else if ([[dict objectForKey:Availability_Week] isEqualToString:@"4"] && ![arr_THU containsObject:dict]) {
                    [arr_THU addObject:dict];
                    //add
                    NSString *addJsonString = [StringManager getJsonStringByDictionary:dict];
                    if (modifySubAvailabilities == nil) {
                        modifySubAvailabilities = [NSMutableString stringWithFormat:@"%@",addJsonString];
                    }
                    else
                    {
                        modifySubAvailabilities = [NSMutableString stringWithFormat:@"%@%@%@",modifySubAvailabilities,Availability_JsonStringseparator,addJsonString];
                    }
                    break;
                }
                else if ([[dict objectForKey:Availability_Week] isEqualToString:@"5"] && ![arr_FRI containsObject:dict]) {
                    [arr_FRI addObject:dict];
                    //add
                    NSString *addJsonString = [StringManager getJsonStringByDictionary:dict];
                    if (modifySubAvailabilities == nil) {
                        modifySubAvailabilities = [NSMutableString stringWithFormat:@"%@",addJsonString];
                    }
                    else
                    {
                        modifySubAvailabilities = [NSMutableString stringWithFormat:@"%@%@%@",modifySubAvailabilities,Availability_JsonStringseparator,addJsonString];
                    }
                    break;
                }
                else if ([[dict objectForKey:Availability_Week] isEqualToString:@"6"] && ![arr_SAT containsObject:dict]) {
                    [arr_SAT addObject:dict];
                    //add
                    NSString *addJsonString = [StringManager getJsonStringByDictionary:dict];
                    if (modifySubAvailabilities == nil) {
                        modifySubAvailabilities = [NSMutableString stringWithFormat:@"%@",addJsonString];
                    }
                    else
                    {
                        modifySubAvailabilities = [NSMutableString stringWithFormat:@"%@%@%@",modifySubAvailabilities,Availability_JsonStringseparator,addJsonString];
                    }
                    break;
                }
            }
        }
    }
    [_tableView reloadData];
}

-(void)editAvailable:(UIButton *)sender
{
    
    int passvalue = 0;
    if (editButtonTag >= 1000 && editButtonTag < 2000)
    {
        passvalue = 0;
    }
    else if (editButtonTag >= 2000 && editButtonTag < 3000)
    {
        passvalue = 1;
    }
    else if (editButtonTag >= 3000 && editButtonTag < 4000)
    {
        passvalue = 2;
    }
    else if (editButtonTag >= 4000 && editButtonTag < 5000)
    {
        passvalue = 3;
    }
    else if (editButtonTag >= 5000 && editButtonTag < 6000)
    {
        passvalue = 4;
    }
    else if (editButtonTag >= 6000 && editButtonTag < 7000)
    {
        passvalue = 5;
    }
    else if (editButtonTag >= 7000)
    {
        passvalue = 6;
    }
    [self isShowAllDayButton:passvalue];
    
    if (sender.selected == YES) {
        BOOL isPop = NO;
        if (editButtonTag >= 1000 && editButtonTag < 2000) {
            if (arr_SUN.count > editButtonTag - 1000) {
                isPop = YES;
            }
        }
        else if (editButtonTag >= 2000 && editButtonTag < 3000) {
            if (arr_MON.count > editButtonTag - 2000) {
                isPop = YES;
            }
        }
        else if (editButtonTag >= 3000 && editButtonTag < 4000) {
            if (arr_TUE.count > editButtonTag - 3000) {
                isPop = YES;
            }
        }
        else if (editButtonTag >= 4000 && editButtonTag < 5000) {
            if (arr_WED.count > editButtonTag - 4000) {
                isPop = YES;
            }
        }
        else if (editButtonTag >= 5000 && editButtonTag < 6000) {
            if (arr_THU.count > editButtonTag - 5000) {
                isPop = YES;
            }
        }
        else if (editButtonTag >= 6000 && editButtonTag < 7000) {
            if (arr_FRI.count > editButtonTag - 6000) {
                isPop = YES;
            }
        }
        else if (editButtonTag >= 7000) {
            if (arr_SAT.count > editButtonTag - 7000) {
                isPop = YES;
            }
        }
        
        if (isPop == YES) {
            editButtonTag = -1;
            [self deleteAvailability:sender.tag];
            [UIView animateWithDuration:AnimatedDuration animations:^{
                
                _tableView.frame = CGRectMake(0, 70, weekLabelWidth * 7, _scrollView.frame.size.height - 70);
                _bgWhiteView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, bgViewHeight);
            }];
        }
    }
    else
    {
        sender.selected = YES;
        
        editButtonTag = sender.tag;
        
        NSDictionary *dict = [NSDictionary dictionary];
        
        NSInteger index = 0;
        
        BOOL isPop = NO;
        
        if (editButtonTag >= 1000 && editButtonTag < 2000) {
            if (arr_SUN.count > editButtonTag - 1000) {
                dict = [arr_SUN objectAtIndex:editButtonTag - 1000];
                index = editButtonTag - 1000;
                isPop = YES;
            }
        }
        else if (editButtonTag >= 2000 && editButtonTag < 3000) {
            if (arr_MON.count > editButtonTag - 2000) {
                dict = [arr_MON objectAtIndex:editButtonTag - 2000];
                index = editButtonTag - 2000;
                isPop = YES;
            }
        }
        else if (editButtonTag >= 3000 && editButtonTag < 4000) {
            if (arr_TUE.count > editButtonTag - 3000) {
                dict = [arr_TUE objectAtIndex:editButtonTag - 3000];
                index = editButtonTag - 3000;
                isPop = YES;
            }
        }
        else if (editButtonTag >= 4000 && editButtonTag < 5000) {
            if (arr_WED.count > editButtonTag - 4000) {
                dict = [arr_WED objectAtIndex:editButtonTag - 4000];
                index = editButtonTag - 4000;
                isPop = YES;
            }
        }
        else if (editButtonTag >= 5000 && editButtonTag < 6000) {
            if (arr_THU.count > editButtonTag - 5000) {
                dict = [arr_THU objectAtIndex:editButtonTag - 5000];
                index = editButtonTag - 5000;
                isPop = YES;
            }
        }
        else if (editButtonTag >= 6000 && editButtonTag < 7000) {
            if (arr_FRI.count > editButtonTag - 6000) {
                dict = [arr_FRI objectAtIndex:editButtonTag - 6000];
                index = editButtonTag - 6000;
                isPop = YES;
            }
        }
        else if (editButtonTag >= 7000) {
            if (arr_SAT.count > editButtonTag - 7000) {
                dict = [arr_SAT objectAtIndex:editButtonTag - 7000];
                index = editButtonTag - 7000;
                isPop = YES;
            }
        }
        
        if (isPop == YES) {
            _bgWhiteView.backgroundColor = SetColor(250, 250, 250, 1.0);
            
            if ([[dict objectForKey:Availability_State] isEqualToString:@"0"]) {
                _preferrImageView.highlighted = NO;
                [_preferBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_unavailabilityBtn setTitleColor:SetColor(178, 178, 178, 1.0) forState:UIControlStateNormal];
            }
            else
            {
                _preferrImageView.highlighted = YES;
                [_preferBtn setTitleColor:SetColor(178, 178, 178, 1.0) forState:UIControlStateNormal];
                [_unavailabilityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            
            //_bgBlackView.hidden = NO;
            [UIView animateWithDuration:AnimatedDuration animations:^{
                
                [self mobileTableview2:index];
                _bgWhiteView.frame = CGRectMake(0, ScreenHeight - bgViewHeight, ScreenWidth, bgViewHeight);
            }];
        }
    }
}

-(void) deleteAvailability:(NSInteger) tag
{
    NSArray *arr = [modifySubAvailabilities componentsSeparatedByString:Availability_JsonStringseparator];
    NSMutableArray *arr_dict = [NSMutableArray array];
    for (NSString *jsonstring in arr) {
        NSDictionary *dict = [StringManager getDictionaryByJsonString:jsonstring];
        if (dict != nil) {
            [arr_dict addObject:dict];
        }
    }
    
    NSMutableArray *arr_temp = [NSMutableArray arrayWithArray:arr_dict];
    
    for (NSDictionary *dict in arr_temp) {
        if (tag >= 1000 && tag < 2000 && [arr_SUN containsObject:dict] && [[arr_SUN objectAtIndex:tag-1000] isEqualToDictionary:dict]) {
            [arr_SUN removeObject: dict];
            [arr_dict removeObject:dict];
            break;
        }
        else if (tag >= 2000 && tag < 3000 && [arr_MON containsObject:dict] && [[arr_MON objectAtIndex:tag-2000] isEqualToDictionary:dict]) {
            [arr_MON removeObject: dict];
            [arr_dict removeObject:dict];
            break;
        }
        else if (tag >= 3000 && tag < 4000 && [arr_TUE containsObject: dict] && [[arr_TUE objectAtIndex:tag-3000] isEqualToDictionary:dict]) {
            [arr_TUE removeObject:dict];
            [arr_dict removeObject:dict];
            break;
        }
        else if (tag >= 4000 && tag < 5000 && [arr_WED containsObject:dict] && [[arr_WED objectAtIndex:tag-4000] isEqualToDictionary:dict]) {
            [arr_WED removeObject:dict];
            [arr_dict removeObject:dict];
            break;
        }
        else if (tag >= 5000 && tag < 6000 && [arr_THU containsObject: dict] && [[arr_THU objectAtIndex:tag-5000] isEqualToDictionary:dict]) {
            [arr_THU removeObject:dict];
            [arr_dict removeObject:dict];
            break;
        }
        else if (tag >= 6000 && tag < 7000 && [arr_FRI containsObject: dict] && [[arr_FRI objectAtIndex:tag-6000] isEqualToDictionary:dict]) {
            [arr_FRI removeObject:dict];
            [arr_dict removeObject:dict];
            break;
        }
        else if (tag >= 7000 && [arr_SAT containsObject:dict] && [[arr_SAT objectAtIndex:tag-7000] isEqualToDictionary:dict]) {
            [arr_SAT removeObject:dict];
            [arr_dict removeObject:dict];
            break;
        }
    }
    NSMutableArray *arr_resultjsonstring = [NSMutableArray array];
    for (NSDictionary *dict in arr_dict) {
        NSString *string = [StringManager getJsonStringByDictionary:(NSMutableDictionary *)dict];
        [arr_resultjsonstring addObject:string];
    }
    modifySubAvailabilities = [NSMutableString stringWithString:[arr_resultjsonstring componentsJoinedByString:Availability_JsonStringseparator]];
    [_tableView reloadData];
}

-(void)setAllDay
{
    NSArray *arr = [modifySubAvailabilities componentsSeparatedByString:Availability_JsonStringseparator];
    NSMutableArray *arr_dict = [NSMutableArray array];
    for (NSString *jsonstring in arr) {
        NSDictionary *dict = [StringManager getDictionaryByJsonString:jsonstring];
        if (dict != nil) {
            [arr_dict addObject:dict];
        }
    }
    
    BOOL isreload = NO;
    NSDictionary *mydict = [NSDictionary dictionary];
    for (NSDictionary *dict in arr_dict) {
        if (editButtonTag >= 1000 && editButtonTag < 2000 && [arr_SUN containsObject:dict] && arr_SUN.count == 1) {
            NSMutableDictionary *dict_temp = [NSMutableDictionary dictionaryWithDictionary:[arr_SUN objectAtIndex:editButtonTag-1000]];
            if ([[dict_temp objectForKey:Availability_Uuid] isEqualToString:[dict objectForKey:Availability_Uuid]]) {
                if ([[dict objectForKey:Availability_IsAllDay] isEqualToString:@"1"]) {
                    [dict_temp setObject:@"0" forKey:Availability_IsAllDay];
                }
                else
                {
                    [dict_temp setObject:@"1" forKey:Availability_IsAllDay];
                    [dict_temp setObject:@"0" forKey:Availability_StampEffectiveStart];
                    [dict_temp setObject:@"0" forKey:Availability_StampEffectiveEnd];
                }
                NSInteger index = [arr_dict indexOfObject:dict];
                [arr_dict replaceObjectAtIndex:index withObject:dict_temp];
                NSInteger index2 = [arr_SUN indexOfObject:dict];
                [arr_SUN replaceObjectAtIndex:index2 withObject:dict_temp];
                mydict = dict_temp;
                isreload = YES;
                break;
            }
        }
        else if (editButtonTag >= 2000 && editButtonTag < 3000 && [arr_MON containsObject:dict] && arr_MON.count == 1) {
            NSMutableDictionary *dict_temp = [NSMutableDictionary dictionaryWithDictionary:[arr_MON objectAtIndex:editButtonTag-2000]];
            if ([[dict_temp objectForKey:Availability_Uuid] isEqualToString:[dict objectForKey:Availability_Uuid]]) {
                if ([[dict objectForKey:Availability_IsAllDay] isEqualToString:@"1"]) {
                    [dict_temp setObject:@"0" forKey:Availability_IsAllDay];
                }
                else
                {
                    [dict_temp setObject:@"1" forKey:Availability_IsAllDay];
                    [dict_temp setObject:@"0" forKey:Availability_StampEffectiveStart];
                    [dict_temp setObject:@"0" forKey:Availability_StampEffectiveEnd];
                }
                NSInteger index = [arr_dict indexOfObject:dict];
                [arr_dict replaceObjectAtIndex:index withObject:dict_temp];
                NSInteger index2 = [arr_MON indexOfObject:dict];
                [arr_MON replaceObjectAtIndex:index2 withObject:dict_temp];
                mydict = dict_temp;
                isreload = YES;
                break;
            }
        }
        else if (editButtonTag >= 3000 && editButtonTag < 4000 && [arr_TUE containsObject: dict] && arr_TUE.count == 1) {
            NSMutableDictionary *dict_temp = [NSMutableDictionary dictionaryWithDictionary:[arr_TUE objectAtIndex:editButtonTag-3000]];
            if ([[dict_temp objectForKey:Availability_Uuid] isEqualToString:[dict objectForKey:Availability_Uuid]]) {
                if ([[dict objectForKey:Availability_IsAllDay] isEqualToString:@"1"]) {
                    [dict_temp setObject:@"0" forKey:Availability_IsAllDay];
                }
                else
                {
                    [dict_temp setObject:@"1" forKey:Availability_IsAllDay];
                    [dict_temp setObject:@"0" forKey:Availability_StampEffectiveStart];
                    [dict_temp setObject:@"0" forKey:Availability_StampEffectiveEnd];
                }
                NSInteger index = [arr_dict indexOfObject:dict];
                [arr_dict replaceObjectAtIndex:index withObject:dict_temp];
                NSInteger index2 = [arr_TUE indexOfObject:dict];
                [arr_TUE replaceObjectAtIndex:index2 withObject:dict_temp];
                mydict = dict_temp;
                isreload = YES;
                break;
            }
        }
        else if (editButtonTag >= 4000 && editButtonTag < 5000 && [arr_WED containsObject:dict] && arr_WED.count == 1) {
            NSMutableDictionary *dict_temp = [NSMutableDictionary dictionaryWithDictionary:[arr_WED objectAtIndex:editButtonTag-4000]];
            if ([[dict_temp objectForKey:Availability_Uuid] isEqualToString:[dict objectForKey:Availability_Uuid]]) {
                if ([[dict objectForKey:Availability_IsAllDay] isEqualToString:@"1"]) {
                    [dict_temp setObject:@"0" forKey:Availability_IsAllDay];
                }
                else
                {
                    [dict_temp setObject:@"1" forKey:Availability_IsAllDay];
                    [dict_temp setObject:@"0" forKey:Availability_StampEffectiveStart];
                    [dict_temp setObject:@"0" forKey:Availability_StampEffectiveEnd];
                }
                NSInteger index = [arr_dict indexOfObject:dict];
                [arr_dict replaceObjectAtIndex:index withObject:dict_temp];
                NSInteger index2 = [arr_WED indexOfObject:dict];
                [arr_WED replaceObjectAtIndex:index2 withObject:dict_temp];
                mydict = dict_temp;
                isreload = YES;
                break;
            }
        }
        else if (editButtonTag >= 5000 && editButtonTag < 6000 && [arr_THU containsObject: dict] && arr_THU.count == 1) {
            NSMutableDictionary *dict_temp = [NSMutableDictionary dictionaryWithDictionary:[arr_THU objectAtIndex:editButtonTag-5000]];
            if ([[dict_temp objectForKey:Availability_Uuid] isEqualToString:[dict objectForKey:Availability_Uuid]]) {
                if ([[dict objectForKey:Availability_IsAllDay] isEqualToString:@"1"]) {
                    [dict_temp setObject:@"0" forKey:Availability_IsAllDay];
                }
                else
                {
                    [dict_temp setObject:@"1" forKey:Availability_IsAllDay];
                    [dict_temp setObject:@"0" forKey:Availability_StampEffectiveStart];
                    [dict_temp setObject:@"0" forKey:Availability_StampEffectiveEnd];
                }
                NSInteger index = [arr_dict indexOfObject:dict];
                [arr_dict replaceObjectAtIndex:index withObject:dict_temp];
                NSInteger index2 = [arr_THU indexOfObject:dict];
                [arr_THU replaceObjectAtIndex:index2 withObject:dict_temp];
                mydict = dict_temp;
                isreload = YES;
                break;
            }
        }
        else if (editButtonTag >= 6000 && editButtonTag < 7000 && [arr_FRI containsObject: dict] && arr_FRI.count == 1) {
            NSMutableDictionary *dict_temp = [NSMutableDictionary dictionaryWithDictionary:[arr_FRI objectAtIndex:editButtonTag-6000]];
            if ([[dict_temp objectForKey:Availability_Uuid] isEqualToString:[dict objectForKey:Availability_Uuid]]) {
                if ([[dict objectForKey:Availability_IsAllDay] isEqualToString:@"1"]) {
                    [dict_temp setObject:@"0" forKey:Availability_IsAllDay];
                }
                else
                {
                    [dict_temp setObject:@"1" forKey:Availability_IsAllDay];
                    [dict_temp setObject:@"0" forKey:Availability_StampEffectiveStart];
                    [dict_temp setObject:@"0" forKey:Availability_StampEffectiveEnd];
                }
                NSInteger index = [arr_dict indexOfObject:dict];
                [arr_dict replaceObjectAtIndex:index withObject:dict_temp];
                NSInteger index2 = [arr_FRI indexOfObject:dict];
                [arr_FRI replaceObjectAtIndex:index2 withObject:dict_temp];
                mydict = dict_temp;
                isreload = YES;
                break;
            }
        }
        else if (editButtonTag >= 7000 && [arr_SAT containsObject:dict] && arr_SAT.count == 1) {
            NSMutableDictionary *dict_temp = [NSMutableDictionary dictionaryWithDictionary:[arr_SAT objectAtIndex:editButtonTag-7000]];
            if ([[dict_temp objectForKey:Availability_Uuid] isEqualToString:[dict objectForKey:Availability_Uuid]]) {
                if ([[dict objectForKey:Availability_IsAllDay] isEqualToString:@"1"]) {
                    [dict_temp setObject:@"0" forKey:Availability_IsAllDay];
                }
                else
                {
                    [dict_temp setObject:@"1" forKey:Availability_IsAllDay];
                    [dict_temp setObject:@"0" forKey:Availability_StampEffectiveStart];
                    [dict_temp setObject:@"0" forKey:Availability_StampEffectiveEnd];
                }
                NSInteger index = [arr_dict indexOfObject:dict];
                [arr_dict replaceObjectAtIndex:index withObject:dict_temp];
                NSInteger index2 = [arr_SAT indexOfObject:dict];
                [arr_SAT replaceObjectAtIndex:index2 withObject:dict_temp];
                mydict = dict_temp;
                isreload = YES;
                break;
            }
        }
    }
    if (isreload == YES) {
        NSMutableArray *arr_resultjsonstring = [NSMutableArray array];
        for (NSDictionary *dict in arr_dict) {
            NSString *string = [StringManager getJsonStringByDictionary:(NSMutableDictionary *)dict];
            [arr_resultjsonstring addObject:string];
        }
        modifySubAvailabilities = [NSMutableString stringWithString:[arr_resultjsonstring componentsJoinedByString:Availability_JsonStringseparator]];
        currentOprationDict = [NSMutableDictionary dictionaryWithDictionary:mydict];
        [_tableView reloadData];
        [UIView animateWithDuration:AnimatedDuration animations:^{
            _bgWhiteView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, bgViewHeight);
            _tableView.frame = CGRectMake(0, 70, weekLabelWidth * 7, _scrollView.frame.size.height - 70);
            currentOprationDict = nil;
            [self refreshData:currentOprationDict];
        } completion:^(BOOL finished){
            _bgBlackView.hidden = YES;
        }];
    }
}


-(void) setAvailabilityStamp:(NSString *)str1 and:(NSString *)str2
{
    NSArray *arr = [modifySubAvailabilities componentsSeparatedByString:Availability_JsonStringseparator];
    NSMutableArray *arr_dict = [NSMutableArray array];
    for (NSString *jsonstring in arr) {
        NSDictionary *dict = [StringManager getDictionaryByJsonString:jsonstring];
        if(dict != nil)
        {
            [arr_dict addObject:dict];
        }
    }
    
    BOOL isreload = NO;
    
    NSString *time1 = @"";
    if ([str1 containsString:@"a"]) {
        time1 = [str1 stringByReplacingOccurrencesOfString:@" a.m." withString:@""];
    }
    else if ([str1 containsString:@"p"])
    {
        time1 = [str1 stringByReplacingOccurrencesOfString:@" p.m." withString:@""];
    }
    NSString *time2 = @"";
    if ([str2 containsString:@"a"]) {
        time2 = [str1 stringByReplacingOccurrencesOfString:@" a.m." withString:@""];
    }
    else if ([str2 containsString:@"p"])
    {
        time2 = [str2 stringByReplacingOccurrencesOfString:@" p.m." withString:@""];
    }
    NSString *year1 = [NSString stringWithFormat:@"%@ %@",[dict_configuration objectForKey:Availability_Configuration_YearMonthDay1],time1];
    NSString *year2 = [NSString stringWithFormat:@"%@ %@",[dict_configuration objectForKey:Availability_Configuration_YearMonthDay2],time2];
    
    for (NSDictionary *dict in arr_dict) {
        if (editButtonTag >= 1000 && editButtonTag < 2000 && [arr_SUN containsObject:dict]) {
            NSMutableDictionary *dict_temp = [NSMutableDictionary dictionaryWithDictionary:[arr_SUN objectAtIndex:editButtonTag-1000]];
            if ([[dict_temp objectForKey:Availability_Uuid] isEqualToString:[dict objectForKey:Availability_Uuid]]) {
                if (![[dict_temp objectForKey:Availability_FromTime] isEqualToString:str1] || ![[dict_temp objectForKey:Availability_ToTime] isEqualToString:str2]) {
                    
                    [dict_temp setObject:@"0" forKey:Availability_IsAllDay];
                    [dict_temp setObject:str1 forKey:Availability_FromTime];
                    [dict_temp setObject:str2 forKey:Availability_ToTime];
                    [dict_temp setObject:[StringManager stringDateTimeTransferTimeStamp:year1] forKey:Availability_StampEffectiveStart];
                    if ([[dict_configuration objectForKey:Availability_Configuration_YearMonthDay2] isEqualToString:@"0"]) {
                        
                        [dict_temp setObject:@"0" forKey:Availability_StampEffectiveEnd];
                    }
                    else
                    {
                        [dict_temp setObject:[StringManager stringDateTimeTransferTimeStamp:year2] forKey:Availability_StampEffectiveEnd];
                    }
                    NSInteger index = [arr_dict indexOfObject:dict];
                    [arr_dict replaceObjectAtIndex:index withObject:dict_temp];
                    NSInteger index2 = [arr_SUN indexOfObject:dict];
                    [arr_SUN replaceObjectAtIndex:index2 withObject:dict_temp];
                    isreload = YES;
                    break;
                }
            }
        }
        else if (editButtonTag >= 2000 && editButtonTag < 3000 && [arr_MON containsObject:dict]) {
            NSMutableDictionary *dict_temp = [NSMutableDictionary dictionaryWithDictionary:[arr_MON objectAtIndex:editButtonTag-2000]];
            if ([[dict_temp objectForKey:Availability_Uuid] isEqualToString:[dict objectForKey:Availability_Uuid]]) {
                if (![[dict_temp objectForKey:Availability_FromTime] isEqualToString:str1] || ![[dict_temp objectForKey:Availability_ToTime] isEqualToString:str2]) {
                    
                    [dict_temp setObject:@"0" forKey:Availability_IsAllDay];
                    [dict_temp setObject:str1 forKey:Availability_FromTime];
                    [dict_temp setObject:str2 forKey:Availability_ToTime];
                    [dict_temp setObject:[StringManager stringDateTimeTransferTimeStamp:year1] forKey:Availability_StampEffectiveStart];
                    if ([[dict_configuration objectForKey:Availability_Configuration_YearMonthDay2] isEqualToString:@"0"]) {
                        
                        [dict_temp setObject:@"0" forKey:Availability_StampEffectiveEnd];
                    }
                    else
                    {
                        [dict_temp setObject:[StringManager stringDateTimeTransferTimeStamp:year2] forKey:Availability_StampEffectiveEnd];
                    }
                    NSInteger index = [arr_dict indexOfObject:dict];
                    [arr_dict replaceObjectAtIndex:index withObject:dict_temp];
                    NSInteger index2 = [arr_MON indexOfObject:dict];
                    [arr_MON replaceObjectAtIndex:index2 withObject:dict_temp];
                    isreload = YES;
                    break;
                }
            }
        }
        else if (editButtonTag >= 3000 && editButtonTag < 4000 && [arr_TUE containsObject: dict]) {
            NSMutableDictionary *dict_temp = [NSMutableDictionary dictionaryWithDictionary:[arr_TUE objectAtIndex:editButtonTag-3000]];
            if ([[dict_temp objectForKey:Availability_Uuid] isEqualToString:[dict objectForKey:Availability_Uuid]]) {
                if (![[dict_temp objectForKey:Availability_FromTime] isEqualToString:str1] || ![[dict_temp objectForKey:Availability_ToTime] isEqualToString:str2]) {
                    
                    [dict_temp setObject:@"0" forKey:Availability_IsAllDay];
                    [dict_temp setObject:str1 forKey:Availability_FromTime];
                    [dict_temp setObject:str2 forKey:Availability_ToTime];
                    [dict_temp setObject:[StringManager stringDateTimeTransferTimeStamp:year1] forKey:Availability_StampEffectiveStart];
                    if ([[dict_configuration objectForKey:Availability_Configuration_YearMonthDay2] isEqualToString:@"0"]) {
                        
                        [dict_temp setObject:@"0" forKey:Availability_StampEffectiveEnd];
                    }
                    else
                    {
                        [dict_temp setObject:[StringManager stringDateTimeTransferTimeStamp:year2] forKey:Availability_StampEffectiveEnd];
                    }
                    NSInteger index = [arr_dict indexOfObject:dict];
                    [arr_dict replaceObjectAtIndex:index withObject:dict_temp];
                    NSInteger index2 = [arr_TUE indexOfObject:dict];
                    [arr_TUE replaceObjectAtIndex:index2 withObject:dict_temp];
                    isreload = YES;
                    break;
                }
            }
        }
        else if (editButtonTag >= 4000 && editButtonTag < 5000 && [arr_WED containsObject:dict]) {
            NSMutableDictionary *dict_temp = [NSMutableDictionary dictionaryWithDictionary:[arr_WED objectAtIndex:editButtonTag-4000]];
            if ([[dict_temp objectForKey:Availability_Uuid] isEqualToString:[dict objectForKey:Availability_Uuid]]) {
                if (![[dict_temp objectForKey:Availability_FromTime] isEqualToString:str1] || ![[dict_temp objectForKey:Availability_ToTime] isEqualToString:str2]) {
                    
                    [dict_temp setObject:@"0" forKey:Availability_IsAllDay];
                    [dict_temp setObject:str1 forKey:Availability_FromTime];
                    [dict_temp setObject:str2 forKey:Availability_ToTime];
                    [dict_temp setObject:[StringManager stringDateTimeTransferTimeStamp:year1] forKey:Availability_StampEffectiveStart];
                    if ([[dict_configuration objectForKey:Availability_Configuration_YearMonthDay2] isEqualToString:@"0"]) {
                        
                        [dict_temp setObject:@"0" forKey:Availability_StampEffectiveEnd];
                    }
                    else
                    {
                        [dict_temp setObject:[StringManager stringDateTimeTransferTimeStamp:year2] forKey:Availability_StampEffectiveEnd];
                    }
                    NSInteger index = [arr_dict indexOfObject:dict];
                    [arr_dict replaceObjectAtIndex:index withObject:dict_temp];
                    NSInteger index2 = [arr_WED indexOfObject:dict];
                    [arr_WED replaceObjectAtIndex:index2 withObject:dict_temp];
                    isreload = YES;
                    break;
                }
            }
        }
        else if (editButtonTag >= 5000 && editButtonTag < 6000 && [arr_THU containsObject: dict]) {
            NSMutableDictionary *dict_temp = [NSMutableDictionary dictionaryWithDictionary:[arr_THU objectAtIndex:editButtonTag-5000]];
            if ([[dict_temp objectForKey:Availability_Uuid] isEqualToString:[dict objectForKey:Availability_Uuid]]) {
                if (![[dict_temp objectForKey:Availability_FromTime] isEqualToString:str1] || ![[dict_temp objectForKey:Availability_ToTime] isEqualToString:str2]) {
                    
                    [dict_temp setObject:@"0" forKey:Availability_IsAllDay];
                    [dict_temp setObject:str1 forKey:Availability_FromTime];
                    [dict_temp setObject:str2 forKey:Availability_ToTime];
                    [dict_temp setObject:[StringManager stringDateTimeTransferTimeStamp:year1] forKey:Availability_StampEffectiveStart];
                    if ([[dict_configuration objectForKey:Availability_Configuration_YearMonthDay2] isEqualToString:@"0"]) {
                        
                        [dict_temp setObject:@"0" forKey:Availability_StampEffectiveEnd];
                    }
                    else
                    {
                        [dict_temp setObject:[StringManager stringDateTimeTransferTimeStamp:year2] forKey:Availability_StampEffectiveEnd];
                    }
                    NSInteger index = [arr_dict indexOfObject:dict];
                    [arr_dict replaceObjectAtIndex:index withObject:dict_temp];
                    NSInteger index2 = [arr_THU indexOfObject:dict];
                    [arr_THU replaceObjectAtIndex:index2 withObject:dict_temp];
                    isreload = YES;
                    break;
                }
            }
        }
        else if (editButtonTag >= 6000 && editButtonTag < 7000 && [arr_FRI containsObject: dict]) {
            NSMutableDictionary *dict_temp = [NSMutableDictionary dictionaryWithDictionary:[arr_FRI objectAtIndex:editButtonTag-6000]];
            if ([[dict_temp objectForKey:Availability_Uuid] isEqualToString:[dict objectForKey:Availability_Uuid]]) {
                if (![[dict_temp objectForKey:Availability_FromTime] isEqualToString:str1] || ![[dict_temp objectForKey:Availability_ToTime] isEqualToString:str2]) {
                    
                    [dict_temp setObject:@"0" forKey:Availability_IsAllDay];
                    [dict_temp setObject:str1 forKey:Availability_FromTime];
                    [dict_temp setObject:str2 forKey:Availability_ToTime];
                    [dict_temp setObject:[StringManager stringDateTimeTransferTimeStamp:year1] forKey:Availability_StampEffectiveStart];
                    if ([[dict_configuration objectForKey:Availability_Configuration_YearMonthDay2] isEqualToString:@"0"]) {
                        
                        [dict_temp setObject:@"0" forKey:Availability_StampEffectiveEnd];
                    }
                    else
                    {
                        [dict_temp setObject:[StringManager stringDateTimeTransferTimeStamp:year2] forKey:Availability_StampEffectiveEnd];
                    }
                    NSInteger index = [arr_dict indexOfObject:dict];
                    [arr_dict replaceObjectAtIndex:index withObject:dict_temp];
                    NSInteger index2 = [arr_FRI indexOfObject:dict];
                    [arr_FRI replaceObjectAtIndex:index2 withObject:dict_temp];
                    isreload = YES;
                    break;
                }
            }
        }
        else if (editButtonTag >= 7000 && [arr_SAT containsObject:dict]) {
            NSMutableDictionary *dict_temp = [NSMutableDictionary dictionaryWithDictionary:[arr_SAT objectAtIndex:editButtonTag-7000]];
            if ([[dict_temp objectForKey:Availability_Uuid] isEqualToString:[dict objectForKey:Availability_Uuid]]) {
                if (![[dict_temp objectForKey:Availability_FromTime] isEqualToString:str1] || ![[dict_temp objectForKey:Availability_ToTime] isEqualToString:str2]) {
                    
                    [dict_temp setObject:@"0" forKey:Availability_IsAllDay];
                    [dict_temp setObject:str1 forKey:Availability_FromTime];
                    [dict_temp setObject:str2 forKey:Availability_ToTime];
                    [dict_temp setObject:[StringManager stringDateTimeTransferTimeStamp:year1] forKey:Availability_StampEffectiveStart];
                    if ([[dict_configuration objectForKey:Availability_Configuration_YearMonthDay2] isEqualToString:@"0"]) {
                        
                        [dict_temp setObject:@"0" forKey:Availability_StampEffectiveEnd];
                    }
                    else
                    {
                        [dict_temp setObject:[StringManager stringDateTimeTransferTimeStamp:year2] forKey:Availability_StampEffectiveEnd];
                    }
                    NSInteger index = [arr_dict indexOfObject:dict];
                    [arr_dict replaceObjectAtIndex:index withObject:dict_temp];
                    NSInteger index2 = [arr_SAT indexOfObject:dict];
                    [arr_SAT replaceObjectAtIndex:index2 withObject:dict_temp];
                    isreload = YES;
                    break;
                }
            }
        }
    }
    if (isreload == YES) {
        NSMutableArray *arr_resultjsonstring = [NSMutableArray array];
        for (NSDictionary *dict in arr_dict) {
            NSString *string = [StringManager getJsonStringByDictionary:(NSMutableDictionary *)dict];
            [arr_resultjsonstring addObject:string];
        }
        modifySubAvailabilities = [NSMutableString stringWithString:[arr_resultjsonstring componentsJoinedByString:Availability_JsonStringseparator]];
        [_tableView reloadData];
    }
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return firstTimePickerArray.count;
    }
    else
        return secondTimePickerArray.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [firstTimePickerArray objectAtIndex:row];
    }
    else {
        return [secondTimePickerArray objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        
        firstTimeIndex = row;
        
        if (row == firstTimePickerArray.count-1) {
            secondTimeIndex = 0;
        }
        else
        {
            if (row == 0) {
                secondTimeIndex = 1;
            }
            else
            {
                if (secondTimeIndex <= row) {
                    secondTimeIndex = row + 1;
                }
            }
        }
        
        [_pickerViewTime selectRow:secondTimeIndex inComponent:1 animated:YES];
        
        [self setAvailabilityStamp:[firstTimePickerArray objectAtIndex:firstTimeIndex] and:[secondTimePickerArray objectAtIndex:secondTimeIndex]];
    }
    else {
        
        secondTimeIndex = row;
        
        //当前选择的时间是否大于开始的时间，若小于，则更新conpoment 0
        NSString *time_1 = [firstTimePickerArray objectAtIndex:firstTimeIndex];
        NSString *time_2 = [secondTimePickerArray objectAtIndex:secondTimeIndex];
        float timeInterval = [StringManager getIntervalHoursFromTowTime:time_1 andTime2:time_2];
        if (timeInterval < 0) {
            
            if (row == 0) {
                firstTimeIndex = firstTimePickerArray.count - 1;
            }
            else
            {
                firstTimeIndex = row - 1;
            }
            
            [_pickerViewTime selectRow:firstTimeIndex inComponent:0 animated:YES];
        }
        [self setAvailabilityStamp:[firstTimePickerArray objectAtIndex:firstTimeIndex] and:[secondTimePickerArray objectAtIndex:secondTimeIndex]];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save:(UIButton *)sender {
    
    if (modifySubAvailabilities == nil || [modifySubAvailabilities isEqualToString:@""]) {
        
    }
    else
    {
        //某一天是否有冲突的时间段
        
        NSMutableArray *arr_temp = [NSMutableArray array];
        if (arr_SUN.count >= 2) {
            [arr_temp addObject:arr_SUN];
        }
        if (arr_MON.count >= 2) {
            [arr_temp addObject:arr_MON];
        }
        if (arr_TUE.count >= 2) {
            [arr_temp addObject:arr_TUE];
        }
        if (arr_WED.count >= 2) {
            [arr_temp addObject:arr_WED];
        }
        if (arr_THU.count >= 2) {
            [arr_temp addObject:arr_THU];
        }
        if (arr_FRI.count >= 2) {
            [arr_temp addObject:arr_FRI];
        }
        if (arr_SAT.count >= 2) {
            [arr_temp addObject:arr_SAT];
        }
        
        NSMutableString *resultString = nil;
        if (arr_temp.count != 0) {
            resultString = [DatabaseManager getConflictAvailabilityInDay:arr_temp];
            if (resultString == nil) {
                [self beginSyncData];
            }
            else
            {
                NSString *title = [NSString stringWithFormat:@"Double Check\n%@",resultString];
                NSString *message = [NSString stringWithFormat:@"Preffered and Unavailabe time should not share a coincident period of time."];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
        else
        {
            [self beginSyncData];
        }
    }
}

-(void) beginSyncData
{
    if ([self isChangeAvailability] == YES) {
        
        [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
        
        AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appdelegate managedObjectContext];
        
        DDBDataModel *model = [DynamoDBManager getAvailableDataModel:uuid andConfiguration:dict_configuration andSubAvailabilities:modifySubAvailabilities andNewParentUuid:newParentUuid];
        
        AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
        [[dynamoDBObjectMapper save:model]
         continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task) {
             if (task.error) {
                 [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                 NSString *error = [DatabaseManager AWSDynamoDBErrorMessage:task.error.code];
                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:error preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                 [alertController addAction:okAction];
                 [self presentViewController:alertController animated:YES completion:nil];
             }
             else {
                 if ([model isKindOfClass:[DDBDataModel class]]) {
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         if (uuid == nil) {
                             Availability *avai = [NSEntityDescription insertNewObjectForEntityForName:@"Availability" inManagedObjectContext:context];
                             avai.createDate = model.createDate;
                             avai.modifyDate = model.modifyDate;
                             avai.uuid = model.uuid;
                             avai.managerUuid = model.managerUuid;
                             avai.parentUuid = model.parentUuid;
                             avai.isDelete = [model.isDelete shortValue];
                             avai.title = model.avail_title;
                             avai.rotation = model.avail_rotation;
                             avai.string_yearMonthDay1 = model.avail_string_yearMonthDay1;
                             avai.string_yearMonthDay2 = model.avail_string_yearMonthDay2;
                             avai.string_effectiveDate1 = model.avail_string_effectiveDate1;
                             avai.string_effectiveDate2 = model.avail_string_effectiveDate2;
                             avai.notes = model.avail_notes;
                             avai.subAvailabilities = model.avail_subAvailabilities;
                             avai.employeeUuid = model.avail_employeeUuid;
                             
                             [context save:nil];
                         }
                         else
                         {
                             Availability *avai = [DatabaseManager getAvailabilitybyUuid:uuid];
                             avai.modifyDate = model.modifyDate;
                             avai.title = model.avail_title;
                             avai.rotation = model.avail_rotation;
                             avai.string_yearMonthDay1 = model.avail_string_yearMonthDay1;
                             avai.string_yearMonthDay2 = model.avail_string_yearMonthDay2;
                             avai.string_effectiveDate1 = model.avail_string_effectiveDate1;
                             avai.string_effectiveDate2 = model.avail_string_effectiveDate2;
                             avai.notes = model.avail_notes;
                             avai.subAvailabilities = model.avail_subAvailabilities;
                             avai.employeeUuid = model.avail_employeeUuid;
                             [context save:nil];
                         }
                         
                         [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                         [self.navigationController popViewControllerAnimated:YES];
                     });
                 }
             }
             return nil;
         }];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(BOOL) isChangeAvailability
{
    BOOL isChange = NO;
    
    if (uuid == nil) {
        isChange = YES;
    }
    else
    {
        Availability *avai = [DatabaseManager getAvailabilitybyUuid:uuid];
        if (![avai.title isEqualToString:[dict_configuration objectForKey:Availability_Configuration_Title]]) {
            isChange = YES;
        }
        else if (![avai.rotation isEqualToString:[dict_configuration objectForKey:Availability_Configuration_Rotation]])
        {
            isChange = YES;
        }
        else if (![avai.string_yearMonthDay1 isEqualToString:[dict_configuration objectForKey:Availability_Configuration_YearMonthDay1]])
        {
            isChange = YES;
        }
        else if (![avai.string_yearMonthDay2 isEqualToString:[dict_configuration objectForKey:Availability_Configuration_YearMonthDay2]])
        {
            isChange = YES;
        }
        else if (![avai.string_effectiveDate1 isEqualToString:[dict_configuration objectForKey:Availability_Configuration_StringEffectiveDate1]])
        {
            isChange = YES;
        }
        else if (![avai.string_effectiveDate2 isEqualToString:[dict_configuration objectForKey:Availability_Configuration_StringEffectiveDate2]])
        {
            isChange = YES;
        }
        else if (![avai.subAvailabilities isEqualToString:modifySubAvailabilities])
        {
            isChange = YES;
        }
        else
        {
            if (avai.notes == nil && [dict_configuration objectForKey:Availability_Configuration_Notes] == nil) {
                isChange = NO;
            }
            else
            {
                if (![avai.notes isEqualToString:[dict_configuration objectForKey:Availability_Configuration_Notes]]) {
                    isChange = YES;
                }
            }
        }

    }
    
    return isChange;
}


-(NSMutableDictionary *) getContent:(NSArray *) arr
{
    NSMutableDictionary *mydict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"content1",@"",@"content2",@"",@"content3", nil];
    
    NSString *effectivedate = @"";
    if ([[dict_configuration objectForKey:Availability_Configuration_StringEffectiveDate2] isEqualToString:@"0"]) {
        effectivedate = [NSString stringWithFormat:@"(%@ - ongoing)",[dict_configuration objectForKey:Availability_Configuration_StringEffectiveDate1]];
    }
    else
    {
        effectivedate = [NSString stringWithFormat:@"(%@ - %@)",[dict_configuration objectForKey:Availability_Configuration_StringEffectiveDate1],[dict_configuration objectForKey:Availability_Configuration_StringEffectiveDate2]];
    }
    
    for (int i = 0; i < arr.count; i++) {
        NSDictionary *dict = [arr objectAtIndex:i];
        
        NSString *state = @"";
        if ([[dict objectForKey:Availability_State] isEqualToString:@"0"]) {
            state = @"Preferred";
        }
        else
        {
            state = @"Unavailable";
        }
        NSString *timeinterval = @"";
        if ([[dict objectForKey:Availability_IsAllDay] isEqualToString:@"0"]) {
            timeinterval = [NSString stringWithFormat:@"%@ - %@",[dict objectForKey:Availability_FromTime],[dict objectForKey:Availability_ToTime]];
        }
        else
        {
            timeinterval = @"All Day";
        }
        
        NSString *showString = [NSString stringWithFormat:@"%@ %@ %@",state,timeinterval,effectivedate];
        
        if (i == 0) {
            [mydict setObject:showString forKey:@"content1"];
        }
        else if (i == 1)
        {
            [mydict setObject:showString forKey:@"content2"];
        }
        else if (i == 2)
        {
            [mydict setObject:showString forKey:@"content3"];
        }
    }
    return mydict;
}

-(void) isShowAllDayButton:(int) week
{
    if(week == 0)
    {
        if (arr_SUN.count >= 1) {
            _allDayButton.hidden = YES;
        }
        else
        {
            _allDayButton.hidden = NO;
        }
    }
    else if (week == 1)
    {
        if (arr_MON.count >= 1) {
            _allDayButton.hidden = YES;
        }
        else
        {
            _allDayButton.hidden = NO;
        }
    }
    else if (week == 2)
    {
        if (arr_TUE.count >= 1) {
            _allDayButton.hidden = YES;
        }
        else
        {
            _allDayButton.hidden = NO;
        }
    }
    else if (week == 3)
    {
        if (arr_WED.count >= 1) {
            _allDayButton.hidden = YES;
        }
        else
        {
            _allDayButton.hidden = NO;
        }
    }
    else if (week == 4)
    {
        if (arr_THU.count >= 1) {
            _allDayButton.hidden = YES;
        }
        else
        {
            _allDayButton.hidden = NO;
        }
    }
    else if (week == 5)
    {
        if (arr_FRI.count >= 1) {
            _allDayButton.hidden = YES;
        }
        else
        {
            _allDayButton.hidden = NO;
        }
    }
    else if (week == 6)
    {
        if (arr_SAT.count >= 1) {
            _allDayButton.hidden = YES;
        }
        else
        {
            _allDayButton.hidden = NO;
        }
    }
}

- (IBAction)toConfiguration:(UIButton *)sender {
    ConfigurationViewController_iphone *configuration = [ConfigurationViewController_iphone new];
    NSMutableDictionary *dict_temp = [NSMutableDictionary dictionary];
    [dict_temp setObject:[dict_configuration objectForKey:Availability_Configuration_StringEffectiveDate1] forKey:Availability_Configuration_StringEffectiveDate1];
    [dict_temp setObject:[dict_configuration objectForKey:Availability_Configuration_StringEffectiveDate2] forKey:Availability_Configuration_StringEffectiveDate2];
    [dict_temp setObject:[dict_configuration objectForKey:Availability_Configuration_EmployeeUuid] forKey:Availability_Configuration_EmployeeUuid];
    [dict_temp setObject:[dict_configuration objectForKey:Availability_Configuration_YearMonthDay1] forKey:Availability_Configuration_YearMonthDay1];
    [dict_temp setObject:[dict_configuration objectForKey:Availability_Configuration_YearMonthDay2] forKey:Availability_Configuration_YearMonthDay2];
    [dict_temp setObject:[dict_configuration objectForKey:Availability_Configuration_Rotation] forKey:Availability_Configuration_Rotation];
    [dict_temp setObject:[dict_configuration objectForKey:Availability_Configuration_Title] forKey:Availability_Configuration_Title];
    if ([dict_configuration objectForKey:Availability_Configuration_Notes] != nil) {
        [dict_temp setObject:[dict_configuration objectForKey:Availability_Configuration_Notes] forKey:Availability_Configuration_Notes];
    }
    
    configuration.dict = dict_temp;
    configuration.delegate = self;
    [self presentViewController:configuration animated:YES completion:nil];
}
/*点击添加按钮，如果是week的第一个，picker view就给一个默认的值，如果是该week的第二个或者第三个，默认值的开始值为上一个的结束值
 修改一条数据时，picker view的默认值为该数据的原始值
 */


@end
