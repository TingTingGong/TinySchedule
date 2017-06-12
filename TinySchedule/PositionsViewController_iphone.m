//
//  PositionsViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/9/6.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "PositionsViewController_iphone.h"

@interface PositionsViewController_iphone ()
{
    NSMutableArray *arr_allPositions;
    UIImageView *bgImageView;
}
@end

@implementation PositionsViewController_iphone

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
   [self initData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (bgImageView == nil) {
        bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, _tableView.frame.size.height)];
        bgImageView.image = [UIImage imageNamed:@"noPosition"];
        [_tableView addSubview:bgImageView];
    }

    [self setbeginRefreshing];

    // Do any additional setup after loading the view from its nib.
}

-(void) initData
{
    arr_allPositions = [NSMutableArray arrayWithArray:[DatabaseManager getAllPositions]];

    if (arr_allPositions.count == 0) {
        bgImageView.hidden = NO;
    }
    else
    {
        bgImageView.hidden = YES;
    }
    [_tableView reloadData];
}


- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addposition:(UIButton *)sender {
    PositionDetailViewController_iphone *position = [PositionDetailViewController_iphone new];
    position.isEmployeeSeePositionDetail = NO;
    position.isCreatePosition = YES;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:position];
    [self presentViewController:nav animated:YES completion:nil];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr_allPositions.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Delete";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"positionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    if (arr_allPositions.count != 0) {
        
        Positions *position = [arr_allPositions objectAtIndex:indexPath.row];
        
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(23, 23, 10, 10)];
        imageview.backgroundColor = [MostColor getPositionColor:[NSNumber numberWithShort:position.color]];
        imageview.layer.cornerRadius = 10/2.0;
        imageview.layer.masksToBounds = YES;
        [cell.contentView addSubview:imageview];
        
        NSArray *arr_employees = [position.employees componentsSeparatedByString:@","];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(49, 0, ScreenWidth - 62, 56)];
        NSString *string = [NSString stringWithFormat:@"%@ (%lu)",position.name,(unsigned long)arr_employees.count];
        [label setAttributedText:SetAttributeText(string, TextColorAlpha_87, LightFontName, 17.0)];
        [cell.contentView addSubview:label];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(16, 55.5, ScreenWidth-16, 0.5)];
        line.backgroundColor = SepearateLineColor;
        [cell.contentView addSubview:line];
         
        if(indexPath.row == arr_allPositions.count-1)
        {
            line.frame = CGRectMake(0, 55.5, ScreenWidth, 0.5);
        }
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [UIView animateWithDuration:AnimatedDuration animations:^{

        Positions *position = [arr_allPositions objectAtIndex:indexPath.row];
        PositionDetailViewController_iphone *vi = [PositionDetailViewController_iphone new];
        vi.uuid = position.uuid;
        vi.isEmployeeSeePositionDetail = NO;
        vi.isCreatePosition = NO;
        [self.navigationController pushViewController:vi animated:YES];
        
    }completion:^(BOOL finish){
    }];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [_tableView setEditing:NO animated:YES];
        
        Positions *position = [arr_allPositions objectAtIndex:indexPath.row];
        
        NSString *message = [NSString stringWithFormat:@"Delete “%@”?",position.name];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:InternationalL(@"cancel") style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        alertController.view.tintColor = AppMainColor;
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Delete Position" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
            
            [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
            
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            NSManagedObjectContext *context = [appDelegate managedObjectContext];
            
            NSString *urlstring = [NSString stringWithFormat:@"%@/%@",api_position,position.uuid];
            
            [HttpRequestManager requestWithType:requestType_DELETE withUrlString:urlstring withParaments:nil withSuccessBlock:^(NSData *data,NSHTTPURLResponse *response){
                
                [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                
                if (response.statusCode == 200) {
                    
                    [arr_allPositions removeObject:position];
                    [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self initData];
                    
                    [context deleteObject:position];
                    [context save:nil];
                }
                
            } withFailureBlock:^(NSError *error){
                
                [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                NSString *errorstring = [DatabaseManager serverReturnErrorMessage:error];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:errorstring preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }];
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
         
- (void)setbeginRefreshing
{
    if (_refreshControl == nil) {
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refreshControl];
}
}
-(void) refreshView:(UIRefreshControl *)refresh
{
    if (_refreshControl.refreshing) {
        [self performSelector:@selector(refreshTableView:) withObject:refresh afterDelay:0];
    }
    [DynamoDBManager getNewEmployee];
}
-(void)refreshTableView:(UIRefreshControl *)refresh{

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *urlstring = [NSString stringWithFormat:@"%@/%@/position",api_workplace,appdelegate.currentWorkplace.uuid];
    
    [HttpRequestManager requestWithType:requestType_GET withUrlString:urlstring withParaments:nil withSuccessBlock:^(NSData *data,NSHTTPURLResponse *response){
        
        NSArray *arr_positions = (NSArray *)[DatabaseManager dictionaryWithJsondata:data];
        
        if (response.statusCode == 200) {
            
            NSManagedObjectContext *context = [appdelegate managedObjectContext];
            
            NSArray *arr_getAllLocalPosition = [DatabaseManager getAllPositions];
            NSString *positionUuids = @"";
            
            for (NSDictionary *dict in arr_positions) {
                Positions *position = [DatabaseManager getPositionByUuid:[dict objectForKey:@"id"]];
                if (position == nil) {
                    position = [NSEntityDescription insertNewObjectForEntityForName:@"Positions" inManagedObjectContext:context];
                }
                position.uuid = [dict objectForKey:@"id"];
                position.name = [dict objectForKey:@"name"];
                position.color = [[dict objectForKey:@"color"] intValue];
                [context save:nil];
                
                positionUuids = [NSString stringWithFormat:@"%@,%@",positionUuids,[dict objectForKey:@"id"]];
            }
            
            for (Positions *position in arr_getAllLocalPosition) {
                if (![positionUuids containsString:position.uuid]) {
                    [context deleteObject:position];
                    [context save:nil];
                }
            }
            
            [self initData];
        }

        [refresh endRefreshing];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    } withFailureBlock:^(NSError *error){
        
        [refresh endRefreshing];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}
         
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
