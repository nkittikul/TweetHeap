//
//  TweetCell.m
//  TweetHeap
//
//  Created by Narin Kittikul on 7/10/15.
//  Copyright (c) 2015 Narin Kittikul. All rights reserved.
//

#import "TweetCell.h"
@interface TweetCell ()
@property (nonatomic, strong) NSMutableData *data;
@end

@implementation TweetCell


- (void)getProfileImageFromRequest:(NSURLRequest *)request
{
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self
                                   startImmediately:NO];
    [connection scheduleInRunLoop:[NSRunLoop currentRunLoop]
                          forMode:NSRunLoopCommonModes];
    [connection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    UIImage *playerImage = [UIImage imageWithData:self.data];
    [self.imageView setImage:playerImage];
    [self setNeedsLayout];
}



@end
