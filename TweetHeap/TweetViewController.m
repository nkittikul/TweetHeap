//
//  TweetViewController.m
//  TweetHeap
//
//  Created by Narin Kittikul on 7/7/15.
//  Copyright (c) 2015 Narin Kittikul. All rights reserved.
//

#import "TweetViewController.h"
#import "CoreDataHandler.h"
#import "Tweet.h"

@interface TweetViewController ()
@property (nonatomic, assign) BOOL save;
@property (nonatomic, assign) BOOL delete;
@property (nonatomic, strong) Tweet* tweet;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UILabel* screenNameLabel;
@property (nonatomic, strong) UILabel* textLabel;
@property (nonatomic, strong) UIImageView* imageLabel;

@end

@implementation TweetViewController

- (id)initForSaveWithTweet:(Tweet*)tweet {
    if (self = [super init]){
        _tweet = tweet;
        _save = YES;
        _delete = NO;
    }
    return self;
}

- (id)initForDeleteWithTweet:(Tweet*)tweet {
    if (self = [super init]){
        _tweet = tweet;
        _save = NO;
        _delete = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureSubviews];
    [self configureNavItem];
    
}

- (void)viewWillLayoutSubviews {
    int height = self.view.bounds.size.height;
    int width = self.view.bounds.size.width;
    self.nameLabel.frame = CGRectMake(width*0.5, height*0.25, width*0.4, height*0.05);
    self.screenNameLabel.frame = CGRectMake(width*0.5, height*0.3, width*0.4, height*0.05);
    self.textLabel.frame = CGRectMake(width*0.2, height*0.4, width*0.6, height*0.4);
    self.imageLabel.frame = CGRectMake(width*0.2, height*0.25, width*0.2, height*0.1);
    
}

- (void)configureSubviews {
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = self.tweet.name;
    self.nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.screenNameLabel = [[UILabel alloc] init];
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@",self.tweet.screenName];
    self.screenNameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.text = self.tweet.text;
    self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.textLabel.numberOfLines = 0;
    [self.textLabel sizeToFit];
    
    UIImage *image = [UIImage imageWithData:self.tweet.image];
    self.imageLabel = [[UIImageView alloc] initWithImage:image];
    self.imageLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.screenNameLabel];
    [self.view addSubview:self.textLabel];
    [self.view addSubview:self.imageLabel];
}

- (void)configureNavItem {
    self.navigationItem.title = @"Tweet";
    if (self.save){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save Tweet"
                                                                                  style:UIBarButtonItemStyleDone
                                                                                 target:self
                                                                                 action:@selector(saveTweet)];
    }
    if (self.delete){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Delete Tweet"
                                                                                  style:UIBarButtonItemStyleDone
                                                                                 target:self
                                                                                 action:@selector(deleteTweet)];

    }

}

- (void)saveTweet {
    CoreDataHandler *cdh = [CoreDataHandler sharedInstance];
    NSManagedObjectContext *moc = [cdh managedObjectContext];
    Tweet *tweet = (Tweet *)[NSEntityDescription insertNewObjectForEntityForName:@"Tweet" inManagedObjectContext:moc];
    tweet.name = self.tweet.name;
    tweet.screenName = self.tweet.screenName;
    tweet.text = self.tweet.text;
    tweet.image = self.tweet.image;
    tweet.date = [NSDate date];
    NSError *error;
    if ([moc hasChanges] && ![moc save:&error]){
        NSLog(@"Error saving tweet: %@", [error localizedDescription]);
    }
}

- (void)deleteTweet {
    CoreDataHandler *cdh = [CoreDataHandler sharedInstance];
    NSManagedObjectContext *moc = [cdh managedObjectContext];
    [moc deleteObject:self.tweet];
    NSError *error;
    if ([moc hasChanges] && ![moc save:&error]){
        NSLog(@"Error deleting tweet: %@", [error localizedDescription]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
