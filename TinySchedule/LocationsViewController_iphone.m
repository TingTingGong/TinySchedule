//
//  LocationsViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/9/6.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "LocationsViewController_iphone.h"

#define cellHeight 108

@interface LocationsViewController_iphone ()
{
    NSArray *arr_allLocations;
}
@end

@implementation LocationsViewController_iphone

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
    
    [self setbeginRefreshing];
    
    if ([UIDevice currentDevice].systemVersion.intValue >= 8) {
        for (UIView *currentView in _tableView.subviews) {
            if ([currentView isKindOfClass:[UIScrollView class]]) {
                ((UIScrollView *)currentView).delaysContentTouches = NO;
                break;
            }
        }
    }
    // Do any additional setup after loading the view from its nib.
}

-(void)initData
{
    arr_allLocations = [NSArray arrayWithArray:[DatabaseManager getAllLocations]];
//    arr_allLocations = [arr_allLocations sortedArrayUsingComparator:
//                        ^NSComparisonResult(Locations *obj1, Locations *obj2) {
//                            
//                            return [obj1.createDate compare:obj2.createDate];
//                        }];
    [_tableView reloadData];
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addlocation:(UIButton *)sender {
    LocationDetailViewController_iphone *location = [LocationDetailViewController_iphone new];
    location.isEmployeeSeeDetail = NO;
    location.isCreateLocation = YES;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:location];
    [self presentViewController:nav animated:YES completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr_allLocations.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 16;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor whiteColor];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"locationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    if (arr_allLocations.count != 0) {
        
        Locations *location = [arr_allLocations objectAtIndex:indexPath.row];
        
        UILabel *lab_bg = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, ScreenWidth - 32, cellHeight-8)];
        lab_bg.layer.masksToBounds = YES;
        lab_bg.layer.cornerRadius = 12.0;
        
        GMSMapView *mapView_ = [[GMSMapView alloc]initWithFrame:CGRectMake(0, 0, lab_bg.frame.size.width, lab_bg.frame.size.height)];
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.latitude longitude:location.longitude zoom:15];
        mapView_ = [GMSMapView mapWithFrame:mapView_.frame camera:camera];
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(location.latitude, location.longitude);
        marker.title = location.name;
        marker.snippet = location.address;
        marker.map = mapView_;
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = mapView_.frame;
        effectView.alpha = .8f;
        [mapView_ addSubview:effectView];
        
        float viewWidth = lab_bg.frame.size.width;
        
        UILabel *lab_name = [[UILabel alloc]initWithFrame:CGRectMake(10, 17, viewWidth-20, 24)];
        lab_name.textAlignment = NSTextAlignmentCenter;
        if(location.name != nil)
        {
            [lab_name setAttributedText:SetAttributeText(location.name, SetColor(0, 0, 0, 0.76), SemiboldFontName, 20.0)];
        }
        
        UILabel *lab_addr = [[UILabel alloc]initWithFrame:CGRectMake(37, 44, viewWidth-37*2, 40)];
        lab_addr.text = location.address;
        lab_addr.numberOfLines = 0;
        lab_addr.lineBreakMode = NSLineBreakByWordWrapping;
        lab_addr.textAlignment = NSTextAlignmentCenter;
        if(location.address != nil)
        {
            [lab_addr setAttributedText:SetAttributeText(location.address, TextColorAlpha_54, RegularFontName, 14.0)];
        }
          lab_addr.font = [UIFont systemFontOfSize:14.0];
        
        [cell.contentView addSubview:lab_bg];
        [lab_bg addSubview:mapView_];
        [lab_bg addSubview:lab_name];
        [lab_bg addSubview:lab_addr];

    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Locations *location = [arr_allLocations objectAtIndex:indexPath.row];
    LocationDetailViewController_iphone *detail = [LocationDetailViewController_iphone new];
    detail.uuid = location.uuid;
    detail.isEmployeeSeeDetail = NO;
    detail.isCreateLocation = NO;
    [self.navigationController pushViewController:detail animated:YES];
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
}
-(void)refreshTableView:(UIRefreshControl *)refresh{
                 
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *urlstring = [NSString stringWithFormat:@"%@/%@/location",api_workplace,appdelegate.currentWorkplace.uuid];
    
    [HttpRequestManager requestWithType:requestType_GET withUrlString:urlstring withParaments:nil withSuccessBlock:^(NSData *data,NSHTTPURLResponse *response){
        
        NSArray *arr_locations = (NSArray *)[DatabaseManager dictionaryWithJsondata:data];
        
        if (response.statusCode == 200) {
            
            NSManagedObjectContext *context = [appdelegate managedObjectContext];
            
            NSArray *arr_getAllLocalLocation = [DatabaseManager getAllLocations];
            NSString *locationUuids = @"";
            
            for (NSDictionary *dict in arr_locations) {
                Locations *locaiton = [DatabaseManager getLocationByUuid:[dict objectForKey:@"id"]];
                if (locaiton == nil) {
                    locaiton = [NSEntityDescription insertNewObjectForEntityForName:@"Locations" inManagedObjectContext:context];
                }
                locaiton.uuid = [dict objectForKey:@"id"];
                locaiton.name = [dict objectForKey:@"name"];
                locaiton.address = [dict objectForKey:@"address"];
                locaiton.latitude = [[dict objectForKey:@"latitude"] doubleValue];
                locaiton.longitude = [[dict objectForKey:@"longitude"] doubleValue];
                [context save:nil];

                locationUuids = [NSString stringWithFormat:@"%@,%@",locationUuids,[dict objectForKey:@"id"]];
            }
            
            for (Locations *location in arr_getAllLocalLocation) {
                if (![locationUuids containsString:location.uuid]) {
                    [context deleteObject:location];
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
