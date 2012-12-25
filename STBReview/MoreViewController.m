//
//  MoreViewController.m
//  STBReview
//
//  Created by Rudd Fawcett on 11/30/12.
//  Copyright (c) 2012 Rudd Fawcett. All rights reserved.
//

#import "MoreViewController.h"
#import "API.h"
#import <Parse/Parse.h>

@interface MoreViewController ()

@end

@implementation MoreViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"";
            break;
        case 1:
            return @"Account Information";
            break;
        case 2:
            return @"Details";
            break;
        case 3:
            return @"How you can help";
            break;
            
        default:
            return @"";
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"";
            break;
        case 1:
            return @"";
            break;
        case 2:
            return @"";
            break;
        case 3:
            return @"Copyright 2012 Rudd Fawcett";
            break;
        default:
            return @"";
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 3;
            break;
        case 3:
            return 3;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"site" forIndexPath:indexPath];
            cell.textLabel.text = @"STBReview";
            cell.detailTextLabel.text = @"Visit Website";
            return cell;
        }
    }
    else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"version" forIndexPath:indexPath];
            cell.textLabel.text = @"Username";
            cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
            return cell;
        }
        if (indexPath.row == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"version" forIndexPath:indexPath];
            cell.textLabel.text = @"Group";
            cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"group"];
            return cell;
        }
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"generic" forIndexPath:indexPath];
            cell.textLabel.text = @"Changelog";
            return cell;
        }
        if (indexPath.row == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"version" forIndexPath:indexPath];
            cell.textLabel.text = @"Version";
            cell.detailTextLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            return cell;
        }
        else if (indexPath.row == 2) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"version" forIndexPath:indexPath];
            cell.textLabel.text = @"Build";
            cell.detailTextLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
            return cell;
        }
    }
    else {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"generic2" forIndexPath:indexPath];
            cell.textLabel.text = @"Provide Feedback";
            cell.imageView.image = [UIImage imageNamed:@"mail.png"];
            //cell.textLabel.textAlignment = NSTextAlignmentCenter;
            //cell.accessoryType = UITableViewCellAccessoryNone;
            return cell;
        }
        if (indexPath.row == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"generic3" forIndexPath:indexPath];
            cell.textLabel.text = @"Become a Beta Tester";
            cell.imageView.image = [UIImage imageNamed:@"testflight.png"];
            //cell.textLabel.textAlignment = NSTextAlignmentCenter;
            //cell.accessoryType = UITableViewCellAccessoryNone;
            return cell;
        }
        if (indexPath.row == 2) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"generic4" forIndexPath:indexPath];
            cell.textLabel.text = @"Like STBReview";
            cell.imageView.image = [UIImage imageNamed:@"facebook.png"];
            //cell.textLabel.textAlignment = NSTextAlignmentCenter;
            //cell.accessoryType = UITableViewCellAccessoryNone;
            return cell;
        }
    }
    return nil;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
        NSLog(@"Email button pressed...");
        if([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
            mailer.mailComposeDelegate = self;
            [mailer setSubject:@"STBReview - Feedback"];
            NSArray *toRecipients = [NSArray arrayWithObjects:@"rudd@stbreview.com", nil];
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
        if (indexPath.row == 2) {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]])
            {
                NSURL *fbPage = [NSURL URLWithString:@"fb://profile/224770560990001"];
                [[UIApplication sharedApplication] openURL:fbPage];
            }
            else {
                [self performSegueWithIdentifier:@"like" sender:nil];
            }
        }
    }
    else if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSURL *url = [NSURL URLWithString:@"http://stbreview.com/login.php?page=1"];
            if (![[UIApplication sharedApplication] openURL:url]) {
                NSLog(@"%@%@",@"Failed to open URL:",[url description]);
            }
        }
    }
}

-(void)LogoutAction {
    //logout the user from the server, and also upon success destroy the local authorization
	[[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"logout", @"command", nil] onCompletion:^(NSDictionary *json) {
        //logged out from server
        [API sharedInstance].user = nil;
        [self performSegueWithIdentifier:@"showLogin" sender:nil];
	}];
    [PFPush unsubscribeFromChannelInBackground:[[NSUserDefaults standardUserDefaults] objectForKey:@"group"]];
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
