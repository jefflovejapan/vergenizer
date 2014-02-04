//
//  PickerViewController.m
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 7/6/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import "PickerViewController.h"


@implementation PickerViewController
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger numRows = [self.handler.groups count];
    return numRows;
}

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
    AlbumViewController *albumController;
    albumController = (AlbumViewController *)segue.destinationViewController;
    NSIndexPath *indexPath = [self.albumTable indexPathForSelectedRow];
    ALAssetsGroup *group = self.handler.groups[indexPath.item];
    if (!self.handler) {
        NSLog(@"Handler doesn't exist");
    }
    albumController.group = group;
    albumController.handler =self.handler;
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [albumController.albumAssets addObject:result];
        }
    }];
}


@end
