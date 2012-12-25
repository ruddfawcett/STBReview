//
//  QuickLookViewController.h
//  STBReview
//
//  Created by Rudd Fawcett on 11/17/12.
//  Copyright (c) 2012 Rudd Fawcett. All rights reserved.
//

#import "ViewController.h"

@interface QuickLookViewController : ViewController
{
    NSString *FilePathForSheet;
    IBOutlet UIWebView *webView;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSString *FilePathForSheet;
@end
