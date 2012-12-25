//
//  LoginScreen.h
//  STBReview
//
//  Created by Rudd Fawcett on 11/2/12.
//  Copyright (c) 2012 Rudd Fawcett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface LoginScreen : UITableViewController <UIAlertViewDelegate, MFMailComposeViewControllerDelegate>
{
    //the login form fields
    IBOutlet UITextField *fieldUsername;
    IBOutlet UITextField *fieldPassword;
}

//action for when either button is pressed
-(IBAction)btnLoginWhenTapped:(id)sender;
-(IBAction)btnOfflineModeWhenTapped:(id)sender;

@end