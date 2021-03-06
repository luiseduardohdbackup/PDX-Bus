//
//  DepartureHistoryView.m
//  PDX Bus
//
//  Created by Andrew Wallace on 9/15/10.
//  Copyright 2010. All rights reserved.
//



/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */



#import "DepartureHistoryView.h"
#import "DepartureTimesView.h"
#import "UserFaves.h"

#define kPlainId @"plain"

@implementation DepartureHistoryView


- (void)dealloc {
    [super dealloc];
}

#pragma mark TableViewWithToolbar methods

- (UITableViewStyle) getStyle
{
	return UITableViewStyleGrouped;
}

#pragma mark View methods

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = NSLocalizedString(@"Recent stops", @"screen title");
	// self.table.editing = YES;
	self.table.allowsSelectionDuringEditing = YES;
	self.navigationItem.rightBarButtonItem = self.editButtonItem;	
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self reloadData];
}

#pragma mark  Table View methods


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
	if (_userData.recents.count == 0)
	{
		return NSLocalizedString(@"No items in history", @"section title");
	}
	return NSLocalizedString(@"These recently viewed stops can be re-used to get current arrivals.", @"section title");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_userData.recents count];
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *trip = [self.recentTrips objectAtIndex:indexPath.row];
	return [self getTextHeight:[trip valueForKey:kUserFavesChosenName] font:[self getParagraphFont]];
}
*/

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPlainId];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPlainId] autorelease];
	}
	cell.editingAccessoryType = UITableViewCellAccessoryNone;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	// Set up the cell
	NSDictionary *item = (NSDictionary *)[_userData.recents objectAtIndex:indexPath.row];
	cell.textLabel.text = [item valueForKey:kUserFavesOriginalName];
	cell.textLabel.font = [self getBasicFont];
	[self updateAccessibility:cell indexPath:indexPath text:cell.textLabel.text alwaysSaySection:NO];
	cell.imageView.image = [self getFaveIcon:kIconRecent]; 
	cell.textLabel.adjustsFontSizeToFitWidth = YES;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	
	// [self chosenEndpoint:[self.locList objectAtIndex:indexPath.row] ];
	DepartureTimesView *departureViewController = [[DepartureTimesView alloc] init];
	NSDictionary *item = (NSDictionary *)[_userData.recents objectAtIndex:indexPath.row];
	
	departureViewController.displayName = [item valueForKey:kUserFavesOriginalName];
	[departureViewController fetchTimesForLocationInBackground:self.backgroundTask 
														   loc:[item valueForKey:kUserFavesLocation]
														 title:[item valueForKey:kUserFavesOriginalName]];
	[departureViewController release];
	
}

// Override if you support editing the list
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	@synchronized (_userData)
	{
		if (editingStyle == UITableViewCellEditingStyleDelete) {
			[_userData.recents removeObjectAtIndex:indexPath.section];
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		
			_userData.favesChanged = YES;
			[_userData cacheAppData];
		}
	}	
	
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[self.table setEditing:editing animated:animated];
	// self.table.editing = editing;
	[super setEditing:editing animated:animated];
}

// Override if you support rearranging the list
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	
	//	[self dumpPath:@"moveRowAtIndexPath from" path:fromIndexPath];
	//	[self dumpPath:@"moveRowAtIndexPath to  " path:toIndexPath];
	
	@synchronized (_userData)
	{
		NSDictionary *move = [[_userData.recents objectAtIndex:fromIndexPath.row] retain];
		if (fromIndexPath.row < toIndexPath.row)
		{
			[_userData.recents insertObject:move atIndex:toIndexPath.row+1];
			[_userData.recents removeObjectAtIndex:fromIndexPath.row];
		}
		else
		{
			[_userData.recents removeObjectAtIndex:fromIndexPath.row];
			[_userData.recents insertObject:move atIndex:toIndexPath.row];
		}
		[move release];
		_userData.favesChanged = YES;
		[_userData cacheAppData];
	}
	
}




// Override if you support conditional rearranging of the list
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return NO if you do not want the item to be re-orderable.
	return YES;
}


@end
