//
//  QuickLookViewController.m
//  STBReview
//
//  Created by Rudd Fawcett on 11/17/12.
//  Copyright (c) 2012 Rudd Fawcett. All rights reserved.
//

#import "QuickLookViewController.h"

@interface QuickLookViewController ()

@end

@implementation QuickLookViewController

@synthesize FilePathForSheet, webView;

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
    
    NSLog(@"Link: %@",FilePathForSheet);
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:FilePathForSheet];
    
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
