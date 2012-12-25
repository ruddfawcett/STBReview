//
//  ChangelogViewController.m
//  STBReview
//
//  Created by Rudd Fawcett on 11/30/12.
//  Copyright (c) 2012 Rudd Fawcett. All rights reserved.
//

#import "ChangelogViewController.h"

@interface ChangelogViewController ()

@end

@implementation ChangelogViewController

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
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Version 1.1.1 (Current Version)";
    }
    else if (section == 1) {
        return @"Version 1.1.0";
    }
    else if (section == 2) {
        return @"Version 1.0.0";
    }
    else {
        return @"";
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return @"";
    }
    else if (section == 1) {
        return @"";
    }
    else if (section == 2) {
        return @"";
    }
    else {
        return @"";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return 8;
    }
    else if (section == 2) {
        return 1;
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"changelog";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0){
        if (indexPath.row == 0) {
            NSString *feature = @"Add tests to calendar";
            cell.textLabel.text = feature;
            return cell;
        }
        else {
            return nil;
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            NSString *feature = @"iPad support!";
            cell.textLabel.text = feature;
            return cell;
        }
        else if (indexPath.row == 1) {
            NSString *feature = @"Export files via iTunes";
            cell.textLabel.text = feature;
            return cell;
        }
        else if (indexPath.row == 2) {
            NSString *feature = @"TestFlight integration";
            cell.textLabel.text = feature;
            return cell;
        }
        else if (indexPath.row == 3) {
            NSString *feature = @"Minor bug fixes";
            cell.textLabel.text = feature;
            return cell;
        }
        else if (indexPath.row == 4) {
            NSString *feature = @"Cleaner changelog";
            cell.textLabel.text = feature;
            return cell;
        }
        else if (indexPath.row == 5) {
            NSString *feature = @"Icons now show in Downloads";
            cell.textLabel.text = feature;
            return cell;
        }
        else if (indexPath.row == 6) {
            NSString *feature = @"Swipe to delete in Downloads";
            cell.textLabel.text = feature;
            return cell;
        }
        else if (indexPath.row == 7) {
            NSString *feature = @"Expanded \"More\" tab";
            cell.textLabel.text = feature;
            return cell;
        }
        else {
            return nil;
        }
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            NSString *feature = @"Initial release";
            cell.textLabel.text = feature;
            return cell;
        }
        else {
            return nil;
        }
    }
    else {
        NSLog(@"Not one of those sections...");
        return nil;
    }
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
