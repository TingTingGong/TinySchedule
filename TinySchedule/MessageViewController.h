//
//  MessageViewController.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 17/4/11.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputMessageDelegate <NSObject>

-(void) getInputMessageString:(NSString *) messagestring;

@end

@interface MessageViewController : UIViewController<UITextViewDelegate>

@property (strong, nonatomic) NSString *passMessage;
@property (strong, nonatomic) id <InputMessageDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextView *textview;

- (IBAction)back:(UIButton *)sender;
- (IBAction)save:(UIButton *)sender;

@end
