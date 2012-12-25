//
//  DescriptionViewController.h
//  STBReview
//
//  Created by Rudd Fawcett on 11/17/12.
//  Copyright (c) 2012 Rudd Fawcett. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DescriptionViewController : UIViewController
{
    NSString *Description;
    IBOutlet UITextView *textView;
}

@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) NSString *Description;
@end
