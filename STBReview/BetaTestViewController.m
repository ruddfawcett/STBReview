//
//  BetaTestViewController.m
//  STBReview
//
//  Created by Rudd Fawcett on 12/2/12.
//  Copyright (c) 2012 Rudd Fawcett. All rights reserved.
//

#import "BetaTestViewController.h"

@interface BetaTestViewController ()

@end

@implementation BetaTestViewController

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
    
    NSString *path = @"http://tflig.ht/YmGAap";
    
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
