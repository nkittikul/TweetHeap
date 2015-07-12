//
//  TweetListViewController.h
//  TweetHeap
//
//  Created by Narin Kittikul on 7/11/15.
//  Copyright (c) 2015 Narin Kittikul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *tweetsInfo;
@property (nonatomic, strong) UITableView *tableView;

@end
