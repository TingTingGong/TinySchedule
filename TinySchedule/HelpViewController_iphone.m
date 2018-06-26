//
//  HelpViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 17/3/16.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import "HelpViewController_iphone.h"

#define row1Height_320 68
#define row1Height_375 84
#define otherRowHeight_320 40
#define otherRowHeight_375 48

@interface HelpViewController_iphone ()
{
    UITableView *tableview;
    NSArray *arr_imagename;
    NSArray *arr_title;
}
@end

@implementation HelpViewController_iphone

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.hidden = YES;
}
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:nil];
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
    _scrollView.frame = CGRectMake(0, 144, _scrollView.frame.size.width, ScreenHeight-144-96);
    
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, _scrollView.frame.size.height)];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:tableview];
    
    arr_imagename = [NSArray arrayWithObjects:@"circle_green_done",@"circle_green",@"circle_green_done",@"circle_green",@"circle_red_1",@"circle_gary",@"", nil];
    arr_title = [NSArray arrayWithObjects:@"12:00 p.m. - 3:30 p.m.",@"Successful Publish Shift",@"Employee Acknowledged Shift",@"Open Shift",@"Unpublish Shift",@"Overdue Shift",@"Example: “S” is the abbreviation of Sweeper (Position Name)", nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendFeedBackEmail)];
    [_feedbackView addGestureRecognizer:tap];
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr_title.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (ScreenWidth == 320) {
            return 68;
        }
        return 84;
    }
    else
    {
        if (ScreenWidth == 320) {
            if (indexPath.row == arr_title.count - 1) {
                return 62;
            }
            return 40;
        }
        else
        {
            if (indexPath.row == arr_title.count - 1) {
                return 76;
            }
            return 48;
        }
    }
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"helpcell";
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(32, 6, 28, 28)];
    imageview.image = [UIImage imageNamed:[arr_imagename objectAtIndex:indexPath.row]];
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(69, 10, ScreenWidth-79, 20)];
    titlelabel.text = [arr_title objectAtIndex:indexPath.row];
    titlelabel.font = [UIFont systemFontOfSize:14.0];
    titlelabel.textColor = TextColorAlpha_54;
    
    if (indexPath.row == arr_title.count - 1) {
        titlelabel.numberOfLines = 2;
        titlelabel.lineBreakMode = NSLineBreakByCharWrapping;
        titlelabel.frame = CGRectMake(69, 6, ScreenWidth-84, 42);
    }
    
    if (ScreenWidth > 320) {
        imageview.frame = CGRectMake(32, 10, imageview.frame.size.width, imageview.frame.size.height);
        titlelabel.frame = CGRectMake(69, 14, ScreenWidth-79, titlelabel.frame.size.height);
        titlelabel.font = [UIFont systemFontOfSize:17.0];
        
        if (indexPath.row == arr_title.count - 1) {
             titlelabel.frame = CGRectMake(69, 10, ScreenWidth-84, 48);
        }
    }
    
    if (indexPath.row == 3) {
        UILabel *lab = [[UILabel alloc] initWithFrame:imageview.frame];
        lab.textColor = AppMainColor;
        lab.text = @"5";
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:14.0];
        [cell.contentView addSubview:lab];
    }
    
    [cell.contentView addSubview:imageview];
    [cell.contentView addSubview:titlelabel];
    
    if (indexPath.row == 0) {
        
        UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        line1.backgroundColor = SetColor(0, 0, 0, 0.1);
        
        UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 59, ScreenWidth, 1)];
        line2.backgroundColor = SetColor(0, 0, 0, 0.1);
        
        imageview.frame = CGRectMake(32, 16, 28, 28);
        
        titlelabel.frame = CGRectMake(69, 10, ScreenWidth-79, 20);
        titlelabel.textColor = SetColor(3, 3, 3, 1.0);
        titlelabel.font = [UIFont systemFontOfSize:17.0];
        
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(69, 34, ScreenWidth-79, 16)];
        detailLabel.text = @"At Location Name";
        detailLabel.textColor = SetColor(0, 0, 0, 0.3);
        detailLabel.font = [UIFont systemFontOfSize:14.0];
        
        UILabel *positionLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-32-29, 32, 29, 18)];
        positionLabel1.backgroundColor = SetColor(63, 81, 181, 1.0);
        positionLabel1.layer.masksToBounds = YES;
        positionLabel1.layer.cornerRadius = positionLabel1.frame.size.height/2;
        UILabel *positionLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-32-29, 32, 29, 18)];
        positionLabel2.textColor = [UIColor whiteColor];
        positionLabel2.text = @"S";
        positionLabel2.font = [UIFont systemFontOfSize:11.0];
        positionLabel2.textAlignment = NSTextAlignmentCenter;
        
        if (ScreenWidth > 320) {
            line1.frame = CGRectMake(line1.frame.origin.x, line1.frame.origin.y+16, line1.frame.size.width, line1.frame.size.height);
            line2.frame = CGRectMake(line2.frame.origin.x, line2.frame.origin.y+16, line2.frame.size.width, line2.frame.size.height);
            imageview.frame = CGRectMake(imageview.frame.origin.x, imageview.frame.origin.y+16, imageview.frame.size.width, imageview.frame.size.height);
            titlelabel.frame = CGRectMake(titlelabel.frame.origin.x, titlelabel.frame.origin.y+16, titlelabel.frame.size.width, titlelabel.frame.size.height);
            detailLabel.frame = CGRectMake(detailLabel.frame.origin.x, detailLabel.frame.origin.y+16, detailLabel.frame.size.width, detailLabel.frame.size.height);
            positionLabel1.frame = CGRectMake(positionLabel1.frame.origin.x, positionLabel1.frame.origin.y+16, positionLabel1.frame.size.width, positionLabel1.frame.size.height);
            positionLabel2.frame = CGRectMake(positionLabel2.frame.origin.x, positionLabel2.frame.origin.y+16, positionLabel2.frame.size.width, positionLabel2.frame.size.height);
        }
        
        [cell.contentView addSubview:line1];
        [cell.contentView addSubview:line2];
        [cell.contentView addSubview:detailLabel];
        [cell.contentView addSubview:positionLabel1];
        [cell.contentView addSubview:positionLabel2];
    }
    else
    {
        if (indexPath.row == arr_title.count-1)
        {
            UILabel *positionLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(32, 11, 29, 18)];
            positionLabel1.backgroundColor = SetColor(63, 81, 181, 1.0);
            positionLabel1.layer.masksToBounds = YES;
            positionLabel1.layer.cornerRadius = positionLabel1.frame.size.height/2;
            UILabel *positionLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(32, 11, 29, 18)];
            positionLabel2.textColor = [UIColor whiteColor];
            positionLabel2.text = @"S";
            positionLabel2.font = [UIFont systemFontOfSize:11.0];
            positionLabel2.textAlignment = NSTextAlignmentCenter;
            
            if (ScreenWidth > 320) {
                positionLabel1.frame = CGRectMake(positionLabel1.frame.origin.x, 14, positionLabel1.frame.size.width, positionLabel1.frame.size.height);
                positionLabel2.frame = CGRectMake(positionLabel2.frame.origin.x, 14, positionLabel2.frame.size.width, positionLabel2.frame.size.height);
            }
            
            [cell.contentView addSubview:positionLabel1];
            [cell.contentView addSubview:positionLabel2];
        }
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) sendFeedBackEmail
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appdelegate sendFeedBackEmail:self];
            [appdelegate.rootController_iphone presentViewController:appdelegate.appMailController animated:YES completion:^{[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            }];
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Email is not configured." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}



- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark email
- (void)mailComposeController: (MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"发送失败!");
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
