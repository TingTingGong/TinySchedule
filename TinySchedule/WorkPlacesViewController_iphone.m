
//
//  WorkPlacesViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/9/6.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "WorkPlacesViewController_iphone.h"

@interface WorkPlacesViewController_iphone ()
{
    NSArray *arr_workPlaces;
    NSIndexPath *selectIndexPath;
}
@end

@implementation WorkPlacesViewController_iphone

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.hidden = YES;
}
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
    arr_workPlaces = [NSArray arrayWithArray:[DatabaseManager getAllWorkPlaces]];
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr_workPlaces.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkPlaces *workplace = [arr_workPlaces objectAtIndex:indexPath.row];
    CGSize size = [StringManager labelAutoCalculateRectWith:workplace.address FontSize:14.0 MaxSize:CGSizeMake(ScreenWidth-32-56-16, 100)];
    return 16+24+4+size.height+16;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor whiteColor];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"placeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    
    WorkPlaces *workplace = [arr_workPlaces objectAtIndex:indexPath.row];
    
    CGSize size = [StringManager labelAutoCalculateRectWith:workplace.address FontSize:14.0 MaxSize:CGSizeMake(ScreenWidth-32-56-16, 100)];
    
    UILabel *view = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, ScreenWidth - 32, 16+24+4+size.height+16-8)];
    view.backgroundColor = SetColor(251, 251, 251, 1.0);
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 12.0;
    
    float viewWidth = view.frame.size.width;
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 24, 24)];
    NSString *imagename = @"";
    if (workplace.type == 1) {
        
        imagename = @"entertainmant";
        if ([appdelegate.currentWorkplace.name isEqualToString:workplace.name]) {
            imagename = @"entertainmant_white";
        }
    }
    else if (workplace.type == 2) {
        
        imagename = @"restaurant";
        if ([appdelegate.currentWorkplace.name isEqualToString:workplace.name]) {
            imagename = @"restaurant_white";
        }
    }
    else if (workplace.type == 3) {
        
        imagename = @"technology";
        if ([appdelegate.currentWorkplace.name isEqualToString:workplace.name]) {
            imagename = @"technology_white";
        }
    }
    else if (workplace.type == 4) {
        
        imagename = @"health";
        if ([appdelegate.currentWorkplace.name isEqualToString:workplace.name]) {
            imagename = @"health_white";
        }
    }
    else if (workplace.type == 5) {
        
        imagename = @"education";
        if ([appdelegate.currentWorkplace.name isEqualToString:workplace.name]) {
            imagename = @"education_white";
        }
    }
    else if (workplace.type == 6) {
        
        imagename = @"Shop";
        if ([appdelegate.currentWorkplace.name isEqualToString:workplace.name]) {
            imagename = @"Shop_white";
        }
    }
    else if (workplace.type == 7) {
        
        imagename = @"typeOther";
        if ([appdelegate.currentWorkplace.name isEqualToString:workplace.name]) {
            imagename = @"typeOther_white";
        }
    }
    else
    {
        imagename = @"typeOther";
        if ([appdelegate.currentWorkplace.name isEqualToString:workplace.name]) {
            imagename = @"typeOther_white";
        }
    }
    imageview.image = [UIImage imageNamed:imagename];
    
    UILabel *lab_name = [[UILabel alloc]initWithFrame:CGRectMake(56, 16, viewWidth-56-16, 24)];
    lab_name.text = workplace.name;
    lab_name.textAlignment = NSTextAlignmentLeft;
    lab_name.alpha = 0.54;
    lab_name.font = [UIFont boldSystemFontOfSize:20];
    
    UILabel *lab_addr = [[UILabel alloc]initWithFrame:CGRectMake(56, 16+24+4, viewWidth-56-16, size.height)];
    lab_addr.text = workplace.address;
    lab_addr.font = [UIFont systemFontOfSize:14.0];
    lab_addr.numberOfLines = 0;
    lab_addr.lineBreakMode = NSLineBreakByWordWrapping;
    lab_addr.alpha = 0.54;

    if ([appdelegate.currentWorkplace.uuid isEqualToString:workplace.uuid]) {

        view.backgroundColor = SetColor(44, 192, 44, 1.0);
        lab_name.alpha = 1.0;
        lab_name.textColor = [UIColor whiteColor];
        lab_addr.alpha = 1.0;
        lab_addr.textColor = [UIColor whiteColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell.contentView addSubview:view];
    [view addSubview:imageview];
    [view addSubview:lab_name];
    [view addSubview:lab_addr];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    WorkPlaces *workplace = [arr_workPlaces objectAtIndex:indexPath.row];
    if (![workplace.uuid isEqualToString:appDelegate.currentWorkplace.uuid]) {
        NSString *message = [NSString stringWithFormat:@"Switch Workplace “%@”?",workplace.name];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:InternationalL(@"cancel") style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        alertController.view.tintColor = AppMainColor;
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Switch Workplace" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
            
            //[KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
            
            //NSManagedObjectContext *context = [appDelegate managedObjectContext];
            
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)createWorkplace:(UIButton *)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"A mailbox can only have one workplace at present!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    /*
     [UIView animateWithDuration:1.5 animations:^{
     CreateWorkplaceViewController_iphone *create = [CreateWorkplaceViewController_iphone new];
     create.isReturnWorkplaceList = YES;
     [self presentViewController:create animated:YES completion:nil];
     }completion:^(BOOL finish){
     }];
     */
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
