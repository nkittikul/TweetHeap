//
//  SavedViewController.m
//  TweetHeap
//
//  Created by Narin Kittikul on 7/7/15.
//  Copyright (c) 2015 Narin Kittikul. All rights reserved.
//

#import "SavedViewController.h"
#import "TweetViewController.h"
#import "TweetCell.h"
#import "CoreDataHandler.h"
#import "Tweet.h"


@interface SavedViewController ()

@end

@implementation SavedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Saved Tweets";
    [self getTweetsInfoFromCoreData];

}

- (void)getTweetsInfoFromCoreData {
    CoreDataHandler *cdh = [CoreDataHandler sharedInstance];
    NSManagedObjectContext *moc = [cdh managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tweet" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSError *error;
    self.tweetsInfo = [[moc executeFetchRequest:request error:&error] copy];
    [self.tableView reloadData];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Tweet *tweet = [self.tweetsInfo objectAtIndex:indexPath.row];
    TweetViewController *tweetViewController = [[TweetViewController alloc] initForDeleteWithTweet:tweet];
    [tweetViewController.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController pushViewController:tweetViewController animated:YES];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = [self.tweetsInfo objectAtIndex:indexPath.row];
    if (cell == nil){
        cell = [[TweetCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TweetCell"];
    }
    UIImage *image = [UIImage imageWithData:tweet.image];
    NSString *names = [NSString stringWithFormat:@"%@ (@%@)", tweet.name, tweet.screenName];
    cell.textLabel.text = names;
    cell.detailTextLabel.text = tweet.text;
    cell.imageView.image = image;
    return cell;
}

#pragma mark - Tab bar controller delegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (viewController == self.navigationController){
        [self getTweetsInfoFromCoreData];
    }
}

#pragma mark - Navigation controller delegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if  (viewController == self){
        [self getTweetsInfoFromCoreData];
    }
}

@end
