//
//  ConfigurationViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/10/21.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "ConfigurationViewController_iphone.h"
#define PickerViewHeight 200
#define placeHolder @"You can leave a message here."

@interface ConfigurationViewController_iphone ()
{
    NSMutableArray *arr_effective1;
    NSMutableArray *arr_effective2;
    NSMutableArray *arr_rotaion;
    
    NSDictionary *ori_dict;
}
@end

@implementation ConfigurationViewController_iphone
@synthesize dict;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    ori_dict = nil;
    ori_dict = [NSDictionary dictionaryWithDictionary:dict];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arr_effective1 = [NSMutableArray arrayWithArray:[StringManager getAllDaysInOneYear]];
    arr_effective2 = [NSMutableArray arrayWithArray:[StringManager getAllDaysInOneYear2]];
    arr_rotaion = [NSMutableArray arrayWithObjects:@"every week",@"every other week",@"every 3 week",@"every 4 week", nil];

    [self initPopView];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)initPopView
{
    if (_bgBlackView == nil) {
        _bgBlackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _bgBlackView.backgroundColor = [UIColor blackColor];
        _bgBlackView.alpha = 0.1;
        _bgBlackView.hidden = YES;
        [self.view addSubview:_bgBlackView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidenBgView:)];
        [_bgBlackView addGestureRecognizer:tap];
    }
    if (_bgWhiteView == nil) {
        _bgWhiteView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, PickerViewHeight)];
        _bgWhiteView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_bgWhiteView];
    }
    if (_effectivePickerView == nil) {
        _effectivePickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0 , 0, _bgWhiteView.frame.size.width , _bgWhiteView.frame.size.height)];
        _effectivePickerView.delegate = self;
        _effectivePickerView.dataSource = self;
        [_bgWhiteView addSubview:_effectivePickerView];
    }
    if (_effectivePickerView2 == nil) {
        _effectivePickerView2 = [[UIPickerView alloc]initWithFrame:CGRectMake(0 , 0, _bgWhiteView.frame.size.width , _bgWhiteView.frame.size.height)];
        _effectivePickerView2.delegate = self;
        _effectivePickerView2.dataSource = self;
        [_bgWhiteView addSubview:_effectivePickerView2];
    }
    if (_rotationPickerView == nil) {
        _rotationPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0 , 0,  _bgWhiteView.frame.size.width , _bgWhiteView.frame.size.height)];
        _rotationPickerView.delegate = self;
        _rotationPickerView.dataSource = self;
        if (dict != nil) {
            NSString *rotation = [dict objectForKey:Availability_Configuration_Rotation];
            [_rotationPickerView selectRow:[rotation intValue] inComponent:0 animated:YES];
        }
        
        [_bgWhiteView addSubview:_rotationPickerView];
    }
    
    if (dict != nil) {
        NSString *string1 = [dict objectForKey:Availability_Configuration_StringEffectiveDate1];
        NSString *string2 = [dict objectForKey:Availability_Configuration_StringEffectiveDate2];
        for (NSDictionary *mydict in arr_effective1) {
            if ([[mydict objectForKey:@"show"] isEqualToString:string1]) {
                NSInteger index = [arr_effective1 indexOfObject:mydict];
                [_effectivePickerView selectRow:index inComponent:0 animated:YES];
                break;
            }
        }
        for (NSDictionary *mydict in arr_effective2) {
            if ([[mydict objectForKey:@"show"] isEqualToString:string2]) {
                NSInteger index = [arr_effective2 indexOfObject:mydict];
                [_effectivePickerView2 selectRow:index inComponent:0 animated:YES];
                break;
            }
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return 60;
    }
    else if (indexPath.row == 3) {
        return 100;
    }
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idenity = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenity];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    if (indexPath.row == 1 || indexPath.row == 2) {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    else
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(16, 13, 24, 24)];
    [cell.contentView addSubview:imageview];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 80, 50)];
    label.font = [UIFont fontWithName:SemiboldFontName size:14.0];
    [cell.contentView addSubview:label];
    
    if (indexPath.row == 0) {
        imageview.image = [UIImage imageNamed:@"name"];
        label.text = @"NAME";
    }
    else if (indexPath.row == 1)
    {
        imageview.image = [UIImage imageNamed:@"s_date_dark"];
        label.text = @"EFFECT FROM";
    }
    else if (indexPath.row == 2)
    {
        imageview.image = [UIImage imageNamed:@"rotation"];
        label.text = @"ROTATION";
    }
    else if (indexPath.row == 3)
    {
        imageview.image = [UIImage imageNamed:@"s_notes_dark"];
        label.text = @"NOTE";
        imageview.frame = CGRectMake(15, 10, 25, 25);
        label.frame = CGRectMake(50, 10, 80, 25);
    }
    
    if (indexPath.row == 0) {
        
        _textFiled = [[UITextField alloc]initWithFrame:CGRectMake(140, 0, _tableView.frame.size.width-150, 50)];
        _textFiled.delegate = self;
        _textFiled.textColor = TextColorAlpha_54;
        _textFiled.textAlignment = NSTextAlignmentRight;
        _textFiled.text = [dict objectForKey:Availability_Configuration_Title];
        _textFiled.font = [UIFont systemFontOfSize:14.0];
        [cell.contentView addSubview:_textFiled];
    }
    else if (indexPath.row == 3)
    {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(47, 30, _tableView.frame.size.width-60, 70)];
        _textView.textColor = TextColorAlpha_54;
        _textView.delegate = self;
        _textView.text = [dict objectForKey:Availability_Configuration_Notes];
        if ([_textView.text length] == 0) {
            _textView.text = placeHolder;
        }
        _textView.font = [UIFont systemFontOfSize:14.0];
        [cell.contentView addSubview:_textView];
    }
    else
    {
        UILabel *labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(140, 0, _tableView.frame.size.width - 150, 50)];
        labelDetail.textColor = TextColorAlpha_54;
        labelDetail.font = [UIFont systemFontOfSize:14.0];
        labelDetail.textAlignment = NSTextAlignmentRight;
        if (indexPath.row == 1) {
            
            imageview.frame = CGRectMake(16, 18, 24, 24);
            label.frame = CGRectMake(50, 13, ScreenWidth-66, 16);
            UILabel *lab_title2 = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2+30, 13, 100, 16)];
            lab_title2.font = [UIFont fontWithName:SemiboldFontName size:14.0];
            lab_title2.text = @"EFFECT TO";
            [cell.contentView addSubview:lab_title2];
            
            UILabel *fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 31, ScreenWidth/2-40, 16)];
            fromLabel.textColor = TextColorAlpha_54;
            fromLabel.font = [UIFont systemFontOfSize:14.0];
            fromLabel.text = [dict objectForKey:Availability_Configuration_StringEffectiveDate1];
            [cell.contentView addSubview:fromLabel];
            
            UILabel *toLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2+30, 31, ScreenWidth/2-30, 16)];
            toLabel.textColor = TextColorAlpha_54;
            toLabel.font = [UIFont systemFontOfSize:14.0];
            [cell.contentView addSubview:toLabel];
            NSString *eff = @"";
            if ([[dict objectForKey:Availability_Configuration_StringEffectiveDate2] isEqualToString:@"0"]) {
                eff = @"ongoing";
            }
            else
            {
                eff = [dict objectForKey:Availability_Configuration_StringEffectiveDate2];
            }
            toLabel.text = eff;
            
            UIImageView *ima = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2, 0, 15, 60)];
            ima.image = [UIImage imageNamed:@"s_path"];
            [cell.contentView addSubview:ima];
            
            UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn1.frame = CGRectMake(0, 0, ScreenWidth/2, 60);
            btn1.tag = 0;
            [cell.contentView addSubview:btn1];
            UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn2.frame = CGRectMake(ScreenWidth/2+30, 0, ScreenWidth/2, 60);
            btn2.tag = 1;
            [cell.contentView addSubview:btn2];
            [btn1 addTarget:self action:@selector(showEffectivePickerView) forControlEvents:UIControlEventTouchUpInside];
            [btn2 addTarget:self action:@selector(showEffectivePickerView2) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (indexPath.row == 2)
        {
            if ([[dict objectForKey:Availability_Configuration_Rotation] isEqualToString:@"0"]) {
                labelDetail.text = @"every week";
            }
            else if ([[dict objectForKey:Availability_Configuration_Rotation] isEqualToString:@"1"]) {
                labelDetail.text = @"every other week";
            }
            else if ([[dict objectForKey:Availability_Configuration_Rotation] isEqualToString:@"2"]) {
                labelDetail.text = @"every 3 week";
            }
            else if ([[dict objectForKey:Availability_Configuration_Rotation] isEqualToString:@"3"]) {
                labelDetail.text = @"every 4 week";
            }
        }
        
        [cell.contentView addSubview:labelDetail];
    }
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(16, 49.5, ScreenWidth-16, 0.5)];
    line.backgroundColor = SepearateLineColor;
    [cell.contentView addSubview:line];
    
    if (indexPath.row == 1) {
        line.frame = CGRectMake(16, 59.5, ScreenWidth-16, 0.5);
    }
    else if (indexPath.row == 3)
    {
        line.frame = CGRectMake(0, 99.5, ScreenWidth, 0.5);
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        [self showEffectivePickerView];
    }
    else if (indexPath.row == 2)
    {
        [self showRotationPickerView];
    }
}

-(void) showEffectivePickerView
{
    [_textView resignFirstResponder];
    [_textFiled resignFirstResponder];
    
    _bgBlackView.hidden = NO;
    
    [UIView animateWithDuration:AnimatedDuration animations:^{
    
        _bgWhiteView.frame = CGRectMake(0, ScreenHeight-PickerViewHeight, ScreenWidth, PickerViewHeight);
        _effectivePickerView.hidden = NO;
        _effectivePickerView2.hidden = YES;
        _rotationPickerView.hidden = YES;
        
    } completion:^(BOOL finished){
    }];
}
-(void) showEffectivePickerView2
{
    _bgBlackView.hidden = NO;
    
    [UIView animateWithDuration:AnimatedDuration animations:^{
        
        _bgWhiteView.frame = CGRectMake(0, ScreenHeight-PickerViewHeight, ScreenWidth, PickerViewHeight);
        _effectivePickerView.hidden = YES;
        _effectivePickerView2.hidden = NO;
        _rotationPickerView.hidden = YES;
        
    } completion:^(BOOL finished){
    }];
}
-(void) showRotationPickerView
{
    _bgBlackView.hidden = NO;
    
    [UIView animateWithDuration:AnimatedDuration animations:^{
        
        _bgWhiteView.frame = CGRectMake(0, ScreenHeight-PickerViewHeight, ScreenWidth, PickerViewHeight);
        _effectivePickerView.hidden = YES;
        _effectivePickerView2.hidden = YES;
        _rotationPickerView.hidden = NO;
        
    } completion:^(BOOL finished){
    }];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([pickerView isEqual:_rotationPickerView]) {
        return arr_rotaion.count;
    }
    else if([pickerView isEqual:_effectivePickerView]){
        return arr_effective1.count;
    }
    else
            return arr_effective2.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([pickerView isEqual:_rotationPickerView]) {
        return [arr_rotaion objectAtIndex:row];
    }
    else if([pickerView isEqual:_effectivePickerView]){
        return [[arr_effective1 objectAtIndex:row] objectForKey:@"show"];
    }
    else {
        return [[arr_effective2 objectAtIndex:row] objectForKey:@"show"];
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if ([pickerView isEqual:_rotationPickerView]) {

        if (row == 0) {
            [dict setObject:@"0" forKey:Availability_Configuration_Rotation];
        }
        else if (row == 1)
        {
            [dict setObject:@"1" forKey:Availability_Configuration_Rotation];
        }
        else if (row == 2)
        {
            [dict setObject:@"2" forKey:Availability_Configuration_Rotation];
        }
        else if (row == 3)
        {
            [dict setObject:@"3" forKey:Availability_Configuration_Rotation];
        }
        [_tableView reloadData];
    }
    else if([pickerView isEqual:_effectivePickerView])
    {
        [dict setObject:[[arr_effective1 objectAtIndex:row] objectForKey:@"show"] forKey:Availability_Configuration_StringEffectiveDate1];
        [dict setObject:[[arr_effective1 objectAtIndex:row] objectForKey:@"hiden"] forKey:Availability_Configuration_YearMonthDay1];
        
        [_tableView reloadData];
    }
    else {
        [dict setObject:[[arr_effective2 objectAtIndex:row] objectForKey:@"show"] forKey:Availability_Configuration_StringEffectiveDate2];
        [dict setObject:[[arr_effective2 objectAtIndex:row] objectForKey:@"hiden"] forKey:Availability_Configuration_YearMonthDay2];
        
        [_tableView reloadData];
    }
}

-(void)hidenBgView:(UITapGestureRecognizer *)tap
{
    _bgBlackView.hidden = YES;
    [UIView animateWithDuration:AnimatedDuration animations:^{
        
        _bgWhiteView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, PickerViewHeight);
        
    } completion:^(BOOL finished)
     {
     }];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textFiled resignFirstResponder];
    [_textView resignFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [dict setObject:[NSString stringWithFormat:@"%@%@",_textFiled.text,string] forKey:Availability_Configuration_Title];
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [dict setObject:[NSString stringWithFormat:@"%@%@",_textView.text,text] forKey:Availability_Configuration_Notes];
    //获得textView的初始尺寸
//    CGFloat width = CGRectGetWidth(textView.frame);
//    CGFloat height = CGRectGetHeight(textView.frame);
//    CGSize newSize = [textView sizeThatFits:CGSizeMake(width,MAXFLOAT)];
//    newFrame = textView.frame;
//    newFrame.size = CGSizeMake(fmax(width, newSize.width), fmax(height, newSize.height));
//    _textView.frame= newFrame;
    
    return YES;
}

-(void) textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:placeHolder])
    {
        textView.text = @"";
    }
}

-(void) textViewDidEndEditing:(UITextView *)textView
{
    NSString *string = textView.text;
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([string length] < 1){
        textView.text = placeHolder;
    }
}

- (IBAction)back:(UIButton *)sender {
    [self.delegate getConfigurationSetting:ori_dict];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveConfiguration:(UIButton *)sender {
    
    [_textFiled resignFirstResponder];
    [_textView resignFirstResponder];
    [dict setObject:_textFiled.text forKey:Availability_Configuration_Title];
    if (![[_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""] && [_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] != nil) {
        [dict setObject:_textView.text forKey:Availability_Configuration_Notes];
    }
    NSString *year1 = [dict objectForKey:Availability_Configuration_YearMonthDay1];
    NSString *year2 = [dict objectForKey:Availability_Configuration_YearMonthDay2];
    NSNumber *number1 = [StringManager stringDateTransferTimeStamp:year1];
    NSNumber *number2 = [StringManager stringDateTransferTimeStamp:year2];
    if ([year2 isEqualToString:@"0"]) {
        [self.delegate getConfigurationSetting:dict];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        if ([number2 longLongValue] >= [number1 longLongValue]) {
            [self.delegate getConfigurationSetting:dict];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Effective to date is less than effective from date." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}
@end
