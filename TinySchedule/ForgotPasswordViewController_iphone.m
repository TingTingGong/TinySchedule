//
//  ForgotPasswordViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 17/3/14.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import "ForgotPasswordViewController_iphone.h"

@interface ForgotPasswordViewController_iphone ()

@end

@implementation ForgotPasswordViewController_iphone

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.hidden = YES;
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _emailFieled.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)resetPassword:(UIButton *)sender {
    
    [_emailFieled resignFirstResponder];
    _emailFieled.text = [_emailFieled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *emailString = [_emailFieled.text lowercaseString];
    if ([_emailFieled.text length] > 0 && ![_emailFieled.text isEqualToString:@""] && [StringManager isEmpty:_emailFieled.text] == NO) {
        if ([StringManager isValidEmail:_emailFieled.text] == NO) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"For real? Your email does not look normal." preferredStyle:UIAlertControllerStyleAlert];
            alertController.view.tintColor = AppMainColor;
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else
        {
            [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
            AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
            AWSDynamoDBQueryExpression *queryExpression = [AWSDynamoDBQueryExpression new];
            queryExpression.scanIndexForward = 0;
            queryExpression.indexName = @"EmailIsRegister-Index";
            
            //查询其他数据时，可以用AND,比如，当前用户，当前workplace下的position，shifts，locations等等
            //queryExpression.keyConditionExpression = [NSString stringWithFormat:@"employeeEmail = :email AND create_date = :create"];
            queryExpression.keyConditionExpression = [NSString stringWithFormat:@"email = :Email"];
            queryExpression.expressionAttributeValues = @{@":Email" : emailString};
            
            [[dynamoDBObjectMapper query:[DDBEmployeesInfoModel class] expression:queryExpression] continueWithBlock:^id(AWSTask *task) {
                if (task.error) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                        NSString *error = [DatabaseManager AWSDynamoDBErrorMessage:task.error.code];
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:error preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:okAction];
                        [self presentViewController:alertController animated:YES completion:nil];
                    });
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        AWSDynamoDBPaginatedOutput *output = task.result;
                        NSArray *arr = [NSArray arrayWithArray:output.items];
                        if (arr.count != 0) {
                            
                            DDBEmployeesInfoModel *employeemodel = [arr objectAtIndex:0];
                            if (employeemodel != nil) {
                                
                                [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                            }
                        }
                        else
                        {
                            [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                            
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Seems you have not signed up yet. Back to sign up or try again." preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                            [alertController addAction:okAction];
                            [self presentViewController:alertController animated:YES completion:nil];
                        }
                    });
                }
                
                return nil;
            }];
        }
    }
}
@end
