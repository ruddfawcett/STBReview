//
//  LikeViewController.m
//  STBReview
//
//  Created by Rudd Fawcett on 12/4/12.
//  Copyright (c) 2012 Rudd Fawcett. All rights reserved.
//

#import "LikeViewController.h"

@interface LikeViewController ()

@end

@implementation LikeViewController


@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = @"https://m.facebook.com/STBReview";
    
    NSLog(@"Link: %@",path);
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:path];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [webView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
