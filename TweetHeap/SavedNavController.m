//
//  SavedNavController.m
//  TweetHeap
//
//  Created by Narin Kittikul on 7/7/15.
//  Copyright (c) 2015 Narin Kittikul. All rights reserved.
//

#import "SavedNavController.h"

@interface SavedNavController ()

@end

@implementation SavedNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *savedIcon = [UIImage imageNamed:@"SavedIcon"];
    UIImage *icon = [self configureTabBarIcon:savedIcon];
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Saved" image:icon tag:1];
}

- (UIImage*)configureTabBarIcon:(UIImage*)icon {
    CGSize iconSize = CGSizeMake(30,30);
    UIGraphicsBeginImageContextWithOptions(iconSize, NO, 0.0);
    [icon drawInRect:CGRectMake(0, 0, iconSize.width, iconSize.height)];
    UIImage *newIcon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newIcon;

}


@end
