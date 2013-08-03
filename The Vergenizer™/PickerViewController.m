//
//  PickerViewController.m
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 7/6/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//


#import <AssetsLibrary/AssetsLibrary.h>
#import "PickerViewController.h"
#import "PhotoHandler.h"
#import "AlbumViewController.h"

@interface PickerViewController ()
@end

@implementation PickerViewController
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger numRows = [self.handlerDelegate.handler.groups count];
    return numRows;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"albumCell" forIndexPath:indexPath];
    ALAssetsGroup *group = [self.handlerDelegate.handler.groups objectAtIndex:[indexPath item]];
    NSString *cellText = [group valueForProperty:ALAssetsGroupPropertyName];
    cell.textLabel.text = cellText;
    
    cell.imageView.image = [UIImage imageWithCGImage:[group posterImage]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.albumController.albumIndex = indexPath.item;
    

}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.albumController = (AlbumViewController *)segue.destinationViewController;
    self.albumController.albumDelegate = self;
    self.albumController.albumDelegate.handler = self.handlerDelegate.handler;
    NSIndexPath *indexPath = [self.albumTable indexPathForSelectedRow];
    self.albumController.albumIndex = indexPath.item;

}


@end
