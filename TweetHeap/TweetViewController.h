//
//  TweetViewController.h
//  TweetHeap
//
//  Created by Narin Kittikul on 7/7/15.
//  Copyright (c) 2015 Narin Kittikul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetViewController : UIViewController
- (id)initForSaveWithTweet:(Tweet*)tweet;
- (id)initForDeleteWithTweet:(Tweet*)tweet;
@end