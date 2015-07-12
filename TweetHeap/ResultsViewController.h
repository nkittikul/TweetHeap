//
//  ResultsViewController.h
//  TweetHeap
//
//  Created by Narin Kittikul on 7/7/15.
//  Copyright (c) 2015 Narin Kittikul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetListViewController.h"

@interface ResultsViewController : TweetListViewController
- (void)prepareSearchWithQuery:(NSString*)query;

@end