//
//  DedicationViewController.h
//  STBReview
//
//  Created by Rudd Fawcett on 11/23/12.
//  Copyright (c) 2012 Rudd Fawcett. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DedicationViewController : UIViewController
{
    NSString *text;
    IBOutlet UITextView *textView;
}

@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) NSString *text;
@end
