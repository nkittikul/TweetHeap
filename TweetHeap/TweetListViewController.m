//
//  TweetListViewController.m
//  TweetHeap
//
//  Created by Narin Kittikul on 7/11/15.
//  Copyright (c) 2015 Narin Kittikul. All rights reserved.
//

#import "TweetListViewController.h"
#import "TweetCell.h"

@interface TweetListViewController ()

@end

@implementation TweetListViewController

-(id)init {
    if (self = [super init]){
        _tweetsInfo = [NSArray array];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tweetsInfo count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[UITableViewCell alloc] init];
}


@end
