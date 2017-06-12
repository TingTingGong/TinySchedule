//
//  WaitJoinWorkplaceViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/11/4.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "WaitJoinWorkplaceViewController_iphone.h"

@interface WaitJoinWorkplaceViewController_iphone ()
{
    NSArray *arr_workplaces;
    NSTimer *myTimer;
}
@end

@implementation WaitJoinWorkplaceViewController_iphone


@synthesize isPopTwoViewControl;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.hidden = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    arr_workplaces = [DatabaseManager getAllWorkPlaces];

    myTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(getAllWorkplaceState:) userInfo:nil repeats:YES];
     
     self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr_workplaces.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 33;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 33)];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 8, view.frame.size.width-120, 25)];
    headerLabel.textColor = SetColor(0, 0, 0, 0.3);
    headerLabel.text = [NSString stringWithFormat:@"%@\n%@",@"If you have been accepted into this workplace.",@"Tap it and get to work!"];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.font = [UIFont systemFontOfSize:10.0];
    headerLabel.numberOfLines = 0;
    headerLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [view addSubview:headerLabel];
    
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identity];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(16, 8, ScreenWidth - 32, 92)];
    view.backgroundColor = SetColor(250, 250, 250, 1.0);
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 12.0;
    [cell.contentView addSubview:view];
    
    WorkPlaces *workplace = [arr_workplaces objectAtIndex:indexPath.row];

    NSString *imagename = @"";
    if (workplace.type == 1) {
        
        imagename = @"entertainmant";
    }
    else if (workplace.type == 2) {
        
        imagename = @"restaurant";
    }
    else if (workplace.type == 3) {
        
        imagename = @"technology";
    }
    else if (workplace.type == 4) {
        
        imagename = @"health";
    }
    else if (workplace.type == 5) {
        
        imagename = @"education";
    }
    else if (workplace.type == 6) {
        
        imagename = @"Shop";
    }
    else if (workplace.type == 7) {
        
        imagename = @"education";
    }
    else
    {
        imagename = @"education";
    }
    
    float s_w = view.frame.size.width;
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(16, 16, 24, 24)];
    imageview.image = [UIImage  imageNamed:imagename];
    [view addSubview:imageview];
    
    UILabel *labName = [[UILabel alloc]initWithFrame:CGRectMake(56, 16, s_w - 130, 24)];
    [labName setAttributedText:SetAttributeText(workplace.name, SetColor(0, 0, 0, 0.54), SemiboldFontName, 20.0)];
    if(ScreenWidth == 320)
    {
        [labName setAttributedText:SetAttributeText(workplace.name, SetColor(0, 0, 0, 0.54), SemiboldFontName, 14.0)];
    }
    [view addSubview:labName];
    
    UILabel *labState = [[UILabel alloc]initWithFrame:CGRectMake(s_w-90, 16, 70, 24)];
    labState.textAlignment = NSTextAlignmentRight;
    if (workplace.isCreator == 0) {
        if (workplace.isPermitted == 0) {
            [labState setAttributedText:SetAttributeText(@"Pending", SetColor(255, 103, 1, 1), LightFontName, 12.0)];
        }
        else if (workplace.isPermitted == 1) {
            [labState setAttributedText:SetAttributeText(@"Accepted", AppMainColor, LightFontName, 12.0)];
        }
        else
        {
            [labState setAttributedText:SetAttributeText(@"Declined", SetColor(250, 67, 63, 1.0), LightFontName, 12.0)];
        }
    }
    [view addSubview:labState];
    
    UILabel *labAddress = [[UILabel alloc]initWithFrame:CGRectMake(56, 42, s_w - 68, 40)];
    labAddress.numberOfLines = 0;
    labAddress.lineBreakMode = NSLineBreakByWordWrapping;
    [labAddress setAttributedText:SetAttributeText(workplace.address, SetColor(0, 0, 0, 0.54), RegularFontName, 14.0)];
     labAddress.font = [UIFont systemFontOfSize:14.0];
    [view addSubview:labAddress];
    
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    
    WorkPlaces *workplace = [arr_workplaces objectAtIndex:indexPath.row];
    if (workplace.isCreator == 1) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:InternationalL(@"cancel") style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelButton];
        UIAlertAction *otherButton = [UIAlertAction actionWithTitle:@"Join workplace" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            //更新currentEmployee  isManager,isPermitted(由服务器返回，暂时先本地保存)
            CurrentEmployee *cuemployee = [DatabaseManager getCurrentEmployeeByUuid:appdelegate.currentEmployee.uuid];
            cuemployee.isManager = 1;
            cuemployee.isPermitted = 1;
            
            appdelegate.currentEmployee = cuemployee;
            
            CurrentWorkPlace *addPlace = [NSEntityDescription insertNewObjectForEntityForName:@"CurrentWorkPlace" inManagedObjectContext:context];
            addPlace.uuid = workplace.uuid;
            addPlace.name = workplace.name;
            addPlace.address = workplace.address;
            addPlace.type = workplace.type;
            addPlace.latitude = workplace.latitude;
            addPlace.longitude = workplace.longitude;
            addPlace.isCreator = workplace.isCreator;
            addPlace.isPermitted = workplace.isPermitted;
            
            appdelegate.currentWorkplace = addPlace;
            
            [context save:nil];
            
            //加载主页面数据，加载成功后，再进入
            
            [myTimer invalidate];
            myTimer = nil;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:UpdateSidebarMenu object:self userInfo:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }];
        [alertController addAction:otherButton];
        alertController.view.tintColor = SetColor(0 ,195, 0,1.0);
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else
    {
        //判断join的workplace是否已经被manager同意
        if (workplace.isPermitted == 1) {
            
            CurrentEmployee *cuemployee = [DatabaseManager getCurrentEmployeeByUuid:appdelegate.currentEmployee.uuid];
            cuemployee.isManager = 0;
            cuemployee.isPermitted = 1;
            
            appdelegate.currentEmployee = cuemployee;
            
            CurrentWorkPlace *addPlace = [NSEntityDescription insertNewObjectForEntityForName:@"CurrentWorkPlace" inManagedObjectContext:context];
            addPlace.uuid = workplace.uuid;
            addPlace.name = workplace.name;
            addPlace.address = workplace.address;
            addPlace.type = workplace.type;
            addPlace.latitude = workplace.latitude;
            addPlace.longitude = workplace.longitude;
            addPlace.isCreator = workplace.isCreator;
            addPlace.isPermitted = workplace.isPermitted;
            
            appdelegate.currentWorkplace = addPlace;
            
            [context save:nil];
            
            //加载主页面数据，加载成功后，再进入
            
            [myTimer invalidate];
            myTimer = nil;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:UpdateSidebarMenu object:self userInfo:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}
     

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)logout:(UIButton *)sender {
    
     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Log out?" message:@"Sure to log out?" preferredStyle:UIAlertControllerStyleAlert];
     UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:InternationalL(@"cancel") style:UIAlertActionStyleDefault handler:nil];
     [alertController addAction:cancelAction];
     UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
     
         [UserEntity loginOut];
         
         [myTimer invalidate];
         myTimer = nil;
     
     for (UIViewController *temp in self.navigationController.viewControllers) {
         if ([temp isKindOfClass:[FirstEnterAppViewController_iphone class]]) {
             [self.navigationController popToViewController:temp animated:YES];
         }
     }
     }];
     [alertController addAction:okAction];
     [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)findOtherWorkpalce:(UIButton *)sender {
    FindWorkPlaceViewController_iphone *find = [FindWorkPlaceViewController_iphone new];
    find.isBack = YES;
    [self.navigationController pushViewController:find animated:YES];
}


-(void)getAllWorkplaceState:(NSTimer *)timer
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    [HttpRequestManager requestWithType:requestType_GET withUrlString:api_employeeWorkplaces withParaments:nil withSuccessBlock:^(NSData *data,NSHTTPURLResponse *response){
        
        [KLoadingView hideKLoadingViewForView:self.view animated:YES];
        NSMutableArray *arr_places = (NSMutableArray *)[DatabaseManager dictionaryWithJsondata:data];
        
        if (response.statusCode == 200) {
            
            for (NSDictionary *dict in arr_places) {
                WorkPlaces *workplace = [DatabaseManager getWorkplaceByUuid:[dict objectForKey:@"id"]];
                if (workplace == nil) {
                    workplace = [NSEntityDescription insertNewObjectForEntityForName:@"WorkPlaces" inManagedObjectContext:context];
                }
                workplace.uuid = [dict objectForKey:@"id"];
                workplace.name = [dict objectForKey:@"name"];
                workplace.isCreator = [[dict objectForKey:@"isCreator"] intValue];
                workplace.isPermitted = [[dict objectForKey:@"isPermitted"] intValue];
                workplace.type = [[dict objectForKey:@"type"] intValue];
                workplace.address = [dict objectForKey:@"address"];
                [context save:nil];
            }
            
            arr_workplaces = [DatabaseManager getAllWorkPlaces];
            [_tableview reloadData];
        }
        
    } withFailureBlock:^(NSError *error){

    }];
}
@end
