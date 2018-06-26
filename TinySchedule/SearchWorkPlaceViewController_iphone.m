//
//  SearchWorkPlaceViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/9/22.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "SearchWorkPlaceViewController_iphone.h"

@interface SearchWorkPlaceViewController_iphone ()
{
    NSInteger selectRow;
    
    UILabel *noWorkplaceLabel;
    
    NSMutableArray *arr_workplaces;
}
@end

@implementation SearchWorkPlaceViewController_iphone

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        selectRow = -1;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.hidden = YES;
    [_textField becomeFirstResponder];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    _textField.text = @"";
    [_tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(16, 27, ScreenWidth-16-76, 30)];
    imageview.image = [UIImage imageNamed:@"fieldBg"];
    imageview.userInteractionEnabled = YES;
    [self.view addSubview:imageview];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, imageview.frame.size.width-10, 30)];
    _textField.delegate = self;
    _textField.placeholder = @"workplace name";
    _textField.tintColor = AppMainColor;
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    _textField.returnKeyType = UIReturnKeySearch;
    _textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    [_textField becomeFirstResponder];
    [imageview addSubview:_textField];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _cancelBtn.frame = CGRectMake(ScreenWidth-76, 20, 76, 44);
    [_cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:SetColor(0, 0, 0, 0.54) forState:UIControlStateNormal];
    [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    [_cancelBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelBtn];
    
    noWorkplaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, NavibarHeight+10, ScreenWidth-32, 40)];
    [noWorkplaceLabel setAttributedText:SetAttributeText(@"Due to the privacy issues exactly correct name of the workplace is required", SetColor(0, 0, 0, 0.3), RegularFontName, 14.0)];
     noWorkplaceLabel.font = [UIFont systemFontOfSize:14.0];
     noWorkplaceLabel.textAlignment = NSTextAlignmentCenter;
     noWorkplaceLabel.numberOfLines = 0;
     noWorkplaceLabel.lineBreakMode = NSLineBreakByWordWrapping;
     [self.view addSubview:noWorkplaceLabel];
    
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSRange lowercaseCharRange = [string rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]];
    
    if (lowercaseCharRange.location != NSNotFound) {
        textField.text = [textField.text stringByReplacingCharactersInRange:range withString:[string lowercaseString]];
        return NO;
    }
    
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [_textField resignFirstResponder];
    _textField.text = [_textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if([_textField.text length] > 0)
    {
        [KLoadingView showKLoadingViewto:self.view andText:nil animated:YES];
        
        NSString *urlstring = [NSString stringWithFormat:@"%@?name=%@",api_workplace,_textField.text];
        
        [HttpRequestManager requestWithType:requestType_GET withUrlString:urlstring withParaments:nil withSuccessBlock:^(NSData *data , NSHTTPURLResponse *response){
            
            [KLoadingView hideKLoadingViewForView:self.view animated:YES];
            NSDictionary *dict = [DatabaseManager dictionaryWithJsondata:data];
            if (response.statusCode == 200) {
                
                if (dict == nil) {
                    
                    _tableView.hidden = YES;
                    noWorkplaceLabel.hidden = NO;
                }
                else
                {
                    arr_workplaces = [NSMutableArray arrayWithObject:dict];
                    _tableView.hidden = NO;
                    noWorkplaceLabel.hidden = YES;
                    [self setTableFrame];
                }
            }
            else
            {
                _tableView.hidden = YES;
                noWorkplaceLabel.hidden = NO;
            }
            
        } withFailureBlock:^(NSError *error){
            
            [KLoadingView hideKLoadingViewForView:self.view animated:YES];
            NSString *errorstring = [DatabaseManager serverReturnErrorMessage:error];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:errorstring preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }];
    }

    return NO;
}

-(void) setTableFrame
{
    selectRow = -1;
    [_tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr_workplaces.count;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identity];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    if (arr_workplaces.count != 0) {
        
        NSDictionary *dict = [arr_workplaces objectAtIndex:indexPath.row];
        
        NSString *namestring = [dict objectForKey:@"name"];
        NSString *addressstring = [dict objectForKey:@"address"];
        
        UILabel *labName = [[UILabel alloc]initWithFrame:CGRectMake(16, 10, ScreenWidth - 30, 30)];
        labName.text = namestring;
        [cell.contentView addSubview:labName];
        
        UILabel *labAddress = [[UILabel alloc]initWithFrame:CGRectMake(16, 40, ScreenWidth - 100, 60)];
        labAddress.numberOfLines = 0;
        labAddress.lineBreakMode = NSLineBreakByWordWrapping;
        labAddress.text = [dict objectForKey:@""];
        labAddress.textColor = [UIColor grayColor];
        labAddress.font = [UIFont systemFontOfSize:14.0];
        [cell.contentView addSubview:labAddress];
        
        CGRect frame = labAddress.frame;
         NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:labAddress.font,NSFontAttributeName,nil];
        CGSize size =CGSizeMake(ScreenWidth-100,CGFLOAT_MAX);
        CGSize actualsize =[addressstring boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
        frame.size = CGSizeMake(actualsize.width, actualsize.height);
        labAddress.frame = frame;
        labAddress.text = addressstring;
        if ([addressstring length] < 30) {
            labName.frame = CGRectMake(16, 7, ScreenWidth - 30, 40);
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(ScreenWidth - 66, 35, 50, 30);
        btn.backgroundColor = AppMainColor;
        [btn setTitle:@"Join" forState:UIControlStateNormal];
        [btn setTintColor:[UIColor whiteColor]];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 15;
        btn.tag = indexPath.row;
        [cell.contentView addSubview:btn];
        [btn addTarget:self action:@selector(joinWorkplace:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(15, 99, ScreenWidth-15, 0.5)];
        line.backgroundColor = SepearateLineColor;
        [cell.contentView addSubview:line];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(void)joinWorkplace:(UIButton *)sender
{
    [_textField resignFirstResponder];
    [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];

    NSDictionary *selectDict = [arr_workplaces objectAtIndex:sender.tag];
    
    NSString *urlstring = [NSString stringWithFormat:@"%@/%@",api_employeeWorkplaces,[selectDict objectForKey:@"id"]];
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    
    [HttpRequestManager requestWithType:requestType_POST withUrlString:urlstring withParaments:nil withSuccessBlock:^(NSData *data , NSHTTPURLResponse *response){
        
        [KLoadingView hideKLoadingViewForView:self.view animated:YES];
        NSDictionary *dict = [DatabaseManager dictionaryWithJsondata:data];
        if (response.statusCode == 200) {
            
            //本地保存workplace，然后进入wait join view controller
            WorkPlaces *workplace = [NSEntityDescription insertNewObjectForEntityForName:@"WorkPlaces" inManagedObjectContext:context];
            workplace.uuid = [selectDict objectForKey:@"id"];
            workplace.name = [selectDict objectForKey:@"name"];
            workplace.address = [selectDict objectForKey:@"address"];
            workplace.type = [[selectDict objectForKey:@"type"] intValue];
            workplace.isCreator = 0;
            workplace.isPermitted = 0;
            
            [context save:nil];
            
            WaitJoinWorkplaceViewController_iphone *wait = [WaitJoinWorkplaceViewController_iphone new];
            [self.navigationController pushViewController:wait animated:YES];
        }
        else
        {
            NSString *errorstring = [dict objectForKey:@"error"];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:errorstring preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
    } withFailureBlock:^(NSError *error){
        
        [KLoadingView hideKLoadingViewForView:self.view animated:YES];
        NSString *errorstring = [DatabaseManager serverReturnErrorMessage:error];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:errorstring preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

-(void) back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) clearText
{
    _textField.text = @"";
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
