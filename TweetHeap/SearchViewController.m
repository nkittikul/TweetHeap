//
//  SearchViewController.m
//  TweetHeap
//
//  Created by Narin Kittikul on 7/7/15.
//  Copyright (c) 2015 Narin Kittikul. All rights reserved.
//

#import "SearchViewController.h"
#import "ResultsViewController.h"

@interface SearchViewController ()
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Search Tweets";
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:self.view.bounds];
    searchBar.delegate = self;
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:searchBar];

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    ResultsViewController *results = [[ResultsViewController alloc] init];
    [results prepareSearchWithQuery:[searchBar text]];
    
    //needs to be done to avoid choppy animation for some reason
    [results.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.navigationController pushViewController:results animated:YES];
    [self.view endEditing:YES];
    searchBar.text = @"";
}


@end
