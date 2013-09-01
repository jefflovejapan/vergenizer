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
    NSInteger numRows = [self.handler.groups count];
    return numRows;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"albumCell" forIndexPath:indexPath];
    ALAssetsGroup *group = [self.handler.groups objectAtIndex:[indexPath item]];
    NSString *cellText = [group valueForProperty:ALAssetsGroupPropertyName];
    cell.textLabel.text = cellText;
    
    cell.imageView.image = [UIImage imageWithCGImage:[group posterImage]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"Inside PFS in PVC");
    //Initializing the destination AlbumViewController
    AlbumViewController *albumController;
    albumController = (AlbumViewController *)segue.destinationViewController;
    NSIndexPath *indexPath = [self.albumTable indexPathForSelectedRow];
    ALAssetsGroup *group = self.handler.groups[indexPath.item];
    if (!self.handler) {
        NSLog(@"Handler doesn't exist");
    }
    NSLog(@"The selected asset group is %@", [group description]);
    albumController.group = group;
    albumController.handler =self.handler;
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [albumController.albumImages addObject:[UIImage imageWithCGImage:[result thumbnail]]];
        }
    }];
//    NSLog(@"Preparing for segue. There are %d objects in self.albumController.albumPhotos. The first has class %@", albumController.albumImages.count, [albumController.albumImages[0] class]);
}


@end
