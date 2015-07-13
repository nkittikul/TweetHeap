//
//  ResultsViewController.m
//  TweetHeap
//
//  Created by Narin Kittikul on 7/7/15.
//  Copyright (c) 2015 Narin Kittikul. All rights reserved.
//

#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "ResultsViewController.h"
#import "TweetViewController.h"
#import "CoreDataHandler.h"
#import "TweetCell.h"
#import "Tweet.h"

@interface ResultsViewController ()
@property (nonatomic, strong) ACAccountStore *accountStore;
@end

@implementation ResultsViewController

- (id)init {
    if (self = [super init]){
        _accountStore = [ACAccountStore alloc];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Results";
}

- (void)prepareSearchWithQuery:(NSString*)query {
    SLRequest *request = [self slRequestFromQuery:query];
    self.accountStore = [self.accountStore init];
    ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [self.accountStore requestAccessToAccountsWithType:twitterAccountType
                                               options:nil
                                            completion:^(BOOL granted, NSError *error)
    {
        if (granted){
            NSArray *accounts = [self.accountStore accountsWithAccountType:twitterAccountType];
            ACAccount *firstAccount = [accounts firstObject];
            request.account = firstAccount;
            [self searchWithRequest:request];
            
        } else {
            NSLog(@"Problem accessing twitter account, can't execute search");
        }
    }];
                              
    
}

- (void)storeTweetInfoFromJSONDict:(NSDictionary*)dict {
    NSArray *statuses = [dict objectForKey:@"statuses"];
    NSMutableArray *tweetsInfoBuild = [[NSMutableArray alloc] initWithCapacity:[statuses count]];
    for (NSDictionary *tweetInfo in statuses){
        
        NSDictionary *userInfo = [tweetInfo objectForKey:@"user"];
        NSString *name = [userInfo objectForKey:@"name"];
        NSString *screenName = [userInfo objectForKey:@"screen_name"];
        NSString *text = [tweetInfo objectForKey:@"text"];
        NSString *imageURL = [userInfo objectForKey:@"profile_image_url"];
        
        NSArray *keys = [NSArray arrayWithObjects:@"name",@"screen_name",@"text",@"profile_image_url", nil];
        NSArray *objects = [NSArray arrayWithObjects:name, screenName, text, imageURL, nil];
        
        NSDictionary *savedTweetInfo = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        [tweetsInfoBuild addObject:savedTweetInfo];
    }
    self.tweetsInfo = [tweetsInfoBuild copy];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}

- (void)searchWithRequest:(SLRequest*)request {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [NSURLConnection sendAsynchronousRequest:[request preparedURLRequest]
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (error){
            NSLog(@"Error retrieving data: %@", [error localizedDescription]);
        } else {
            NSError *error;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:&error];
            [self storeTweetInfoFromJSONDict:dict];
            
        }
     
    }];
}

- (SLRequest*)slRequestFromQuery:(NSString*)query {
    NSString *encodedQuery = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"https://api.twitter.com/1.1/search/tweets.json?q=%@", encodedQuery];
    NSURL *url = [NSURL URLWithString:urlString];
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:url
                                               parameters:nil];
    return request;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = (TweetCell*) [tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *tweetInfo = [self.tweetsInfo objectAtIndex:indexPath.row];
    CoreDataHandler *cdh = [CoreDataHandler sharedInstance];
    NSManagedObjectContext *moc = [cdh searchMoc];
    Tweet *tweet = (Tweet *)[NSEntityDescription insertNewObjectForEntityForName:@"Tweet" inManagedObjectContext:moc];
    tweet.name = [tweetInfo objectForKey:@"name"];
    tweet.screenName = [tweetInfo objectForKey:@"screen_name"];
    tweet.text = [tweetInfo objectForKey:@"text"];
    tweet.image = UIImagePNGRepresentation(cell.imageView.image);
    TweetViewController *tweetViewController = [[TweetViewController alloc] initForSaveWithTweet:tweet];
    [tweetViewController.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController pushViewController:tweetViewController animated:YES];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    NSDictionary *tweetInfo = [self.tweetsInfo objectAtIndex:indexPath.row];
    if (cell == nil){
        cell = [[TweetCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TweetCell"];
    }
    NSString *imageURL = [tweetInfo objectForKey:@"profile_image_url"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]];
    [cell getProfileImageFromRequest:request];
    NSString *names = [NSString stringWithFormat:@"%@ (@%@)", [tweetInfo objectForKey:@"name"], [tweetInfo objectForKey:@"screen_name"]];
    cell.textLabel.text = names;
    cell.detailTextLabel.text = [tweetInfo objectForKey:@"text"];
    
    return cell;
}

@end
