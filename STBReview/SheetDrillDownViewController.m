//
//  SheetDrillDownViewController.m
//  STBReview
//
//  Created by Rudd Fawcett on 11/14/12.
//  Copyright (c) 2012 Rudd Fawcett. All rights reserved.
//

#import "SheetDrillDownViewController.h"
#import "QuickLookViewController.h"
#import "DescriptionViewController.h"
#import "AFHTTPRequestOperation.h"
#import "MBProgressHUD.h"
#import <EventKit/EventKit.h>

@interface SheetDrillDownViewController ()

@end

@implementation SheetDrillDownViewController

@synthesize selectedItem, selectedIndex, detailDataSourceDict;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

/* -(void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
} */

- (void)viewDidLoad
{
    [super viewDidLoad];

    //self.navigationItem.title = selectedItem;
    self.navigationItem.title = @"Sheet Details";
    //NSLog(@"Data: %@",detailDataSourceDict);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(IBAction)initActionSheet:(id)sender{
    
    UIActionSheet *actionSheet;
    actionSheet = [[[UIActionSheet alloc] initWithTitle:selectedItem
                                             delegate:nil
                                    cancelButtonTitle:@"Cancel"
                               destructiveButtonTitle:nil
                                    otherButtonTitles:@"Add to Calendar",@"Quick Look",@"Email Author",@"Download Sheet",nil] autorelease];
    
    actionSheet.delegate = self;
    [actionSheet showInView:self.view];
    //[actionSheet showFromTabBar:self.tabBarController.tabBar];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/* - (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *buttonTitle=[actionSheet buttonTitleAtIndex:buttonIndex];
    
    //NSLog(@"Button: %@",buttonTitle);
    
} */

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    ////NSLog(@"Button index: %d",buttonIndex);
    switch (buttonIndex) {
        case 0:
            [TestFlight passCheckpoint:@"User wants to add sheet to calendar..."];
        {
            EKEventStore *eventStore = [[EKEventStore alloc] init];
            
            [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                if (granted) {
                    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                    NSString *sheet = [detailDataSourceDict valueForKey:@"subject"];
                    event.title     = [sheet stringByAppendingString:@" Test"];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                    
                    NSDate *date = [[NSDate alloc] init];
                    
                    date = [dateFormatter dateFromString:[detailDataSourceDict valueForKey:@"event"]];
                    NSLog(@"Test Date: %@",date);
                    
                    EKAlarm *reminder = [EKAlarm alarmWithRelativeOffset:-28800];
                    [event addAlarm:reminder];
                    event.location = @"School";
                    event.startDate = date;
                    event.endDate   = [[NSDate alloc] initWithTimeInterval:600 sinceDate:event.startDate];
                    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                    NSError *err;
                    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                    
                    BOOL saved = [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                    
                    if (saved) {
                        UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                                        message:[NSString stringWithFormat:@"You have successfully created a reminder for the %@ test.",[detailDataSourceDict valueForKey:@"subject"]]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                        [Alert show];
                        [Alert release];
                        [TestFlight passCheckpoint:[NSString stringWithFormat:@"User added %@ test to calendar...",[detailDataSourceDict valueForKey:@"subject"]]];
                    }
                    else {
                        UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                        message:[NSString stringWithFormat:@"A reminder could not be created for the %@ test.",[detailDataSourceDict valueForKey:@"subject"]]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                        [Alert show];
                        [Alert release];
                        [TestFlight passCheckpoint:[NSString stringWithFormat:@"Error adding %@ test to calendar...",[detailDataSourceDict valueForKey:@"subject"]]];
                    }
                }
                else {
                    UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                    message:@"STBReview does not have permission to write to your calendar.\n\nTo allow it to, navigate to Settings -> Privacy -> Calendars, and make sure STBReview is turned on."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                    [Alert show];
                    [Alert release];
                    [TestFlight passCheckpoint:@"User does not have calendar permissions enabled..."];
                }
            }];

        }
            break;
        case 1:
            //NSLog(@"Quick Look");
            [TestFlight passCheckpoint:[NSString stringWithFormat:@"User wants to quicklook sheet \"%@\"...",[detailDataSourceDict valueForKey:@"title"]]];
            [self performSegueWithIdentifier:@"quickLook" sender:nil];
            break;
        case 2:
            //NSLog(@"Email Author");
            [TestFlight passCheckpoint:[NSString stringWithFormat:@"User wants to contact author \"%@\"...",[detailDataSourceDict valueForKey:@"author"]]];
            [self sendMail];
            break;
        case 3:
            //NSLog(@"Download Sheet");
        [TestFlight passCheckpoint:[NSString stringWithFormat:@"User wants to download sheet \"%@\"...",[detailDataSourceDict valueForKey:@"title"]]];
        {
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            [self.navigationController.view addSubview:hud];
            hud.labelText = @"Downloading...";
            
            [hud showAnimated:YES whileExecutingBlock:^{
                [self dlFiles];
            } completionBlock:^{
                [hud removeFromSuperview];
                [hud release];
            }];
        }
            break;
        default:
            //NSLog(@"Cancel");
            break;
    }
}

-(void)dlFiles {
    //NSLog(@"Saving File...");
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[detailDataSourceDict valueForKey:@"filepath"]]];
    NSString *title = [detailDataSourceDict valueForKey:@"title"];
    NSString *ext = [detailDataSourceDict valueForKey:@"ext"];
    NSString *lowerExt = [NSString stringWithFormat: @".%@",[ext lowercaseString]];
    //NSLog(@"This is the link you are downloading: %@",request);
    AFHTTPRequestOperation *operation = [[[AFHTTPRequestOperation alloc] initWithRequest:request] autorelease];
    NSString *fileName = [title stringByAppendingString: lowerExt];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    
    NSString *msg = [NSString stringWithFormat:@"You have successfully downloaded %@.\n\nYou may open this file using the \"Downloads\" tab.\n\nIf you are unable to see the file, then it is most likely an unsupported file type.",fileName];
    NSString *msg2 = [NSString stringWithFormat:@"Uh oh... There was a problem downloading %@.\n\nPlease try again.",fileName];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"Successfully downloaded file to %@", path);
        UIAlertView *dlAlert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                             message:msg
                                                            delegate:nil
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles:nil];
        [dlAlert show];
        [dlAlert release];
        [TestFlight passCheckpoint:[NSString stringWithFormat:@"Downloading sheet \"%@\" was a success...",[detailDataSourceDict valueForKey:@"title"]]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"Error: %@", error);
        UIAlertView *dlAlert2 = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                          message:msg2
                                                         delegate:nil
                                                cancelButtonTitle:@"Ok"
                                                otherButtonTitles:nil];
        [dlAlert2 show];
        [dlAlert2 release];
        [TestFlight passCheckpoint:[NSString stringWithFormat:@"Downloading sheet \"%@\" failed...",[detailDataSourceDict valueForKey:@"title"]]];
    }];
    
    [operation start];
}

-(void)sendMail {
if([MFMailComposeViewController canSendMail]) {
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    mailer.mailComposeDelegate = self;
    NSString *subject = [detailDataSourceDict valueForKey:@"title"];
    NSString *to = [detailDataSourceDict valueForKey:@"email"];
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
            [TestFlight passCheckpoint:@"User cancelled email..."];
            break;
        case MFMailComposeResultSaved:
            //NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            [TestFlight passCheckpoint:@"User saved email as draft..."];
            break;
        case MFMailComposeResultSent:
            //NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            [TestFlight passCheckpoint:@"User sent email..."];
            break;
        case MFMailComposeResultFailed:
            //NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            [TestFlight passCheckpoint:@"Sending email failed..."];
            break;
        default:
            //NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"At a Glance";
    }
    else if (section == 1){
        return @"Detailed Information";
    }
    else if (section == 2){
        return @"Statistics";
    }
    else {
        return nil;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    if (section == 0) {
        return 3;
    }
    else if (section == 1) {
        return 3;
    }
    else if (section == 2) {
        return 2;
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
    
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"infoCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        NSString *title = [detailDataSourceDict valueForKey:@"title"];
        //NSLog(@"Title:  %@",title);
        cell.textLabel.text = @"Title";
        cell.detailTextLabel.text = title;
        return cell;
    }
    
    if (indexPath.row == 1) {
        static NSString *CellIdentifier = @"infoCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        NSString *subject = [detailDataSourceDict valueForKey:@"subject"];
        //NSLog(@"Subject:  %@",subject);
        cell.textLabel.text = @"Subject";
        cell.detailTextLabel.text = subject;
        return cell;
        
    }
    
    if (indexPath.row == 2) {
        static NSString *CellIdentifier = @"infoCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        NSString *uploader = [detailDataSourceDict valueForKey:@"author"];
        //NSLog(@"Uploaded by:  %@",uploader);
        cell.textLabel.text = @"Uploaded by";
        cell.detailTextLabel.text = uploader;
        return cell;
    }
    }
    
    else if (indexPath.section == 1) {
    
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"infoCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        NSString *fortest = [detailDataSourceDict valueForKey:@"fortest"];
        //NSLog(@"For test on:  %@",fortest);
        cell.textLabel.text = @"For test on";
        cell.detailTextLabel.text = fortest;
        return cell;
    }
    
    if (indexPath.row == 1) {
        static NSString *CellIdentifier = @"infoCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        NSString *description = [detailDataSourceDict valueForKey:@"description"];
        //NSLog(@"Description:  %@",description);
        cell.textLabel.text = @"Description";
        cell.detailTextLabel.text = description;
        cell.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        return cell;
    }
        
    if (indexPath.row == 2) {
        static NSString *CellIdentifier = @"infoCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        NSString *date = [detailDataSourceDict valueForKey:@"date"];
        //NSLog(@"Date:  %@",date);
        cell.textLabel.text = @"Uploaded on";
        if ([[detailDataSourceDict valueForKey:@"date"] isEqual: [NSNull null]]) {
            date = @"Error retriving value...";
        }
        cell.detailTextLabel.text = date;
        return cell;
    }
    }
    
    else {
    
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"infoCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        NSString *dl = [detailDataSourceDict valueForKey:@"dl"];
        //NSLog(@"Downloads:  %@",dl);
        cell.textLabel.text = @"Downloads";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"This sheet has %@.",dl];
        return cell;
            
    }
        
    if (indexPath.row == 1) {
        static NSString *CellIdentifier = @"infoCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        NSNumber *rating = [detailDataSourceDict valueForKey:@"rating"];
        //NSLog(@"Rating:  %@",rating);
        if ([rating intValue] == 0) {
            cell.detailTextLabel.text = @"This sheet has not yet been rated.";
        }
        else {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"This sheet has a %@ star rating.",rating];
        }
        cell.textLabel.text = @"Rating";
        return cell;
        
    }
    }
        
    // Configure the cell...
    
    return nil;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            [self performSegueWithIdentifier:@"description" sender:nil];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //NSLog(@"Attempting to identify segue...");
    // Make sure we're referring to the correct segue
    if ([[segue identifier] isEqualToString:@"quickLook"]) {
        
        //NSLog(@"Segue has been identified...");
        // Get reference to the destination view controller
        QuickLookViewController *vc = [segue destinationViewController];
        
        // Pass the name and index of our film
        
        NSString *filepath = [detailDataSourceDict valueForKey:@"filepath"];
        [vc setFilePathForSheet:filepath];
        //[vc setSelectedIndex:selectedIndex];
        
        //[self performSegueWithIdentifier:@"subjectDrillDown" sender:nil];
    }
    else if ([[segue identifier] isEqualToString:@"description"]) {
        
        //NSLog(@"Segue has been identified...");
        // Get reference to the destination view controller
        DescriptionViewController *vc = [segue destinationViewController];
        
        // Pass the name and index of our film
        
        NSString *description = [detailDataSourceDict valueForKey:@"description"];
        [vc setDescription:description];
        [TestFlight passCheckpoint:[NSString stringWithFormat:@"User wants to see the description of sheet \"%@\"...",[detailDataSourceDict valueForKey:@"title"]]];
        //[vc setSelectedIndex:selectedIndex];
        
        //[self performSegueWithIdentifier:@"subjectDrillDown" sender:nil];
    }
    else {
        //NSLog(@"ERROR, DOUBLE CHECK SEGUE'S NAME!");
    }

}

@end
