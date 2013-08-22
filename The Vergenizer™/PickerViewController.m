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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //Initializing the destination AlbumViewController
    self.albumController = (AlbumViewController *)segue.destinationViewController;
    self.albumController.albumDelegate = self;
    self.albumController.albumDelegate.handler = self.handlerDelegate.handler;
    NSIndexPath *indexPath = [self.albumTable indexPathForSelectedRow];
    self.albumController.albumIndex = indexPath.item;
    
    ALAssetsGroup *group = self.handler.groups[indexPath.item];
    self.albumController.group = group;
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [self.albumController.albumPhotos addObject:[[AssetObject alloc]initWithAsset:result]];
        }
    }];
    NSLog(@"Preparing for segue. There are %d objects in self.albumController.albumPhotos. The first has class %@", self.albumController.albumPhotos.count, [self.albumController.albumPhotos[0] class]);
}


@end
