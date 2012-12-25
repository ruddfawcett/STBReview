 //
//  LoginScreen.m
//  STBReview
//
//  Created by Rudd Fawcett on 11/2/12.
//  Copyright (c) 2012 Rudd Fawcett. All rights reserved.
//

#import "LoginScreen.h"
#import "API.h"
#import <Parse/Parse.h>

@implementation LoginScreen

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    fieldUsername.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
    fieldPassword.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    //[PFPush unsubscribeFromChannelInBackground:@""];
    //focus on the username field / show keyboard
    //[fieldUsername becomeFirstResponder];
}

#pragma mark - View lifecycle


/* -(IBAction)btnOfflineModeWhenTapped:(UIButton*)sender {
    //NSLog(@"Entering offline mode...");
    [self performSegueWithIdentifier:@"offlineMode" sender:nil];
} */

-(IBAction)btnOfflineModeWhenTapped:(UIButton*)sender {
    [[[UIAlertView alloc] initWithTitle:@"Help"
                                message:@"To login, use the username and password your grade has been assigned.\n\nStill need help? Email for support."
                               delegate:self
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles: @"Support", nil] show];
 }

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
        //NSLog(@"No support");
    }
    else
    {
        //NSLog(@"Show email view...");
        [self sendMail];
    }
}

-(void)sendMail {
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        NSString *subject = @"Login Support";
        NSString *to = @"support@stbreview.com";
        [mailer setSubject:subject];
        NSArray *toRecipients = [NSArray arrayWithObjects:to, nil];
        [mailer setToRecipients:toRecipients];
        NSString *emailBody = @"";
        [mailer setMessageBody:emailBody isHTML:NO];
        [self presentViewController:mailer animated:YES completion:nil];
        [mailer release];
    }
    else {
        UIAlertView *emailAlert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                             message:@"Please make sure you have an email address configured in your Mail app."
                                                            delegate:nil
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles:nil];
        [emailAlert show];
        [emailAlert release];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            //NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            //NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            //NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            //NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)btnLoginWhenTapped:(UIButton*)sender {
	//form fields validation
	if (fieldUsername.text.length < 4 || fieldPassword.text.length < 3) {
        [[[UIAlertView alloc] initWithTitle:@"Error!"
                                    message:@"Please verfiy your username and password."
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles: nil] show];
		return;
	}
		//check whether it's a login or register
	NSString* command = @"login";
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:command, @"command", fieldUsername.text, @"username", fieldPassword.text, @"password", nil];
	//make the call to the web API
	[[API sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
		//result returned
		NSDictionary* res = [[json objectForKey:@"result"] objectAtIndex:0];
		if ([json objectForKey:@"error"]==nil && [[res objectForKey:@"id"] intValue]>0) {
			[[API sharedInstance] setUser: res];
			[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
			//show message to the user
            if ([res objectForKey:@"group"]==nil) {
                NSLog(@"Server did not return group with login...");
            }
            else {
                //[[[UIAlertView alloc] initWithTitle:@"Success!" message:[NSString stringWithFormat:@"You have been logged into the group %@.",[res objectForKey:@"group"]] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil] show];
                NSLog(@"Group %@ was found in the database!",[res objectForKey:@"group"]);
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:[res objectForKey:@"group"] forKey:@"group"];
                [defaults setObject:@"0" forKey:@"view"];
                [defaults setObject:@"0" forKey:@"view2"];
                [defaults setObject:[res objectForKey:@"username"] forKey:@"username"];
                NSLog(@"Data saved...");
                [PFPush subscribeToChannelInBackground:[defaults objectForKey:@"group"]];
            }
            [TestFlight passCheckpoint:@"User logged in..."];
		} else {
			//error
            [[[UIAlertView alloc] initWithTitle:@"Error!"
                                        message:@"Please verify your username and password."
                                       delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles: nil] show];
		}
	}];

    
}



@end
