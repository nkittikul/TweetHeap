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

- (void)configureSubviews {
    int height = self.view.bounds.size.height;
    int width = self.view.bounds.size.width;
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(width*0.5, height*0.25, width*0.4, height*0.05)];
    nameLabel.text = self.tweet.name;
    nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UILabel *screenNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(width*0.5, height*0.3, width*0.4, height*0.05)];
    screenNameLabel.text = [NSString stringWithFormat:@"@%@",self.tweet.screenName];
    screenNameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(width*0.2, height*0.4, width*0.6, height*0.4)];
    textLabel.text = self.tweet.text;
    textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    textLabel.numberOfLines = 0;
    [textLabel sizeToFit];
    UIImage *image = [UIImage imageWithData:self.tweet.image];
    UIImageView *imageLabel = [[UIImageView alloc] initWithImage:image];
    imageLabel.frame = CGRectMake(width*0.2, height*0.25, width*0.2, height*0.1);
    imageLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:nameLabel];
    [self.view addSubview:screenNameLabel];
    [self.view addSubview:textLabel];
    [self.view addSubview:imageLabel];
    
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
