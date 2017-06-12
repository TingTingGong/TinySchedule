//
//  MostColor.m
//  OneKey
//
//  Created by WH on 15/10/23.
//  Copyright © 2015年 WH. All rights reserved.
//

#import "MostColor.h"

@implementation MostColor

+ (UIColor *) getPositionColor:(NSNumber *)number;
{
    UIColor*color;
    
    if ([number integerValue] == 0)
    {
        color = [UIColor  colorWithRed:0/255.0 green:188/255.0 blue:212/255.0 alpha:1];
    }
    
    else if ([number integerValue] == 1)
    {
        color = [UIColor  colorWithRed:3/255.0 green:169/255.0 blue:244/255.0 alpha:1];
    }
    
    else if ([number integerValue] == 2)
    {
        color = [UIColor  colorWithRed:63/255.0 green:81/255.0 blue:181/255.0 alpha:1];
    }
    
    else if ([number integerValue] == 3)
    {
        color = [UIColor  colorWithRed:103/255.0 green:58/255.0 blue:183/255.0 alpha:1];
    }
    
    else if ([number integerValue] == 4)
    {
        color = [UIColor  colorWithRed:233/255.0 green:30/255.0 blue:99/255.0 alpha:1];
    }
    
    else if ([number integerValue] == 5)
    {
        color = [UIColor  colorWithRed:244/255.0 green:67/255.0 blue:54/255.0 alpha:1];
    }
    
    else if ([number integerValue] == 6)
    {
        color = [UIColor  colorWithRed:255/255.0 green:193/255.0 blue:7/255.0 alpha:1];
    }
    
    else if ([number integerValue] == 7)
    {
        color = [UIColor  colorWithRed:255/255.0 green:152/255.0 blue:0/255.0 alpha:1];
    }
    
    else if ([number integerValue] == 8)
    {
        color = [UIColor  colorWithRed:128/255.0 green:194/255.0 blue:74/255.0 alpha:1];
    }
    
    else if ([number integerValue] == 9)
    {
        color = [UIColor  colorWithRed:76/255.0 green:175/255.0 blue:80/255.0 alpha:1];
    }
    
    else if ([number integerValue] == 10)
    {
        color = [UIColor  colorWithRed:0/255.0 green:150/255.0 blue:136/255.0 alpha:1];
    }
    
    else if ([number integerValue] == 11)
    {
        color = [UIColor  colorWithRed:72/255.0 green:191/255.0 blue:186/255.0 alpha:1];
    }
    
    else if ([number integerValue] == 12)
    {
        color = [UIColor  colorWithRed:118/255.0 green:118/255.0 blue:118/255.0 alpha:1];
    }
    
    else if ([number integerValue] == 13)
    {
        color = [UIColor  colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1];
    }
    
    
    return color;
}

@end
