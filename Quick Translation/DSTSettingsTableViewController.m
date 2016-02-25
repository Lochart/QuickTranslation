//
//  DSTSettingsTableViewController.m
//  Quick Translation
//
//  Created by Danil Gailes on 06.11.15.
//  Copyright © 2015 DSTech. All rights reserved.
//

#import "DSTSettingsTableViewController.h"

typedef NS_ENUM(NSInteger, DSTSectionType) {
    DSTSectionTypeHelp,
    DSTSectionTypeTranslation,
    DSTSectionTypeService,
    DSTSectionTypeInfo
};

@interface DSTSettingsTableViewController ()

@end

@implementation DSTSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows;
    
    switch ((DSTSectionType) section) {
        case DSTSectionTypeHelp:
        case DSTSectionTypeTranslation: {
            numberOfRows = 2;
            break;
        }
        case DSTSectionTypeService: {
            // Need to count from plist
            numberOfRows = 2;
            break;
        }
        case DSTSectionTypeInfo: {
            numberOfRows = 0;
            break;
        }
    }
    
    return numberOfRows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *titleForHeader = [NSString new];
    
    switch ((DSTSectionType)section) {
        case DSTSectionTypeHelp: {
            break;
        }
        case DSTSectionTypeTranslation: {
            titleForHeader = @"Select Translation";
            break;
        }
        case DSTSectionTypeService: {
            titleForHeader = @"Translation Service";
            break;
        }
        case DSTSectionTypeInfo: {
            titleForHeader = @"Quick Translation, ver. 0.1";
            break;
        }
    }
    
    return titleForHeader;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    NSString *titleForFooter = [NSString new];
    
    if ((DSTSectionType)section == DSTSectionTypeInfo) {
        titleForFooter = @"DSTech, 2015";
    }
    
    return titleForFooter;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"settingsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    switch ((DSTSectionType)indexPath.section) {
        case DSTSectionTypeHelp: {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (indexPath.row == 0) {
                cell.textLabel.text = @"How To Use";
            }
            if (indexPath.row == 1) {
                cell.textLabel.text = @"Translation Form";
            }
            break;
        }
        case DSTSectionTypeTranslation: {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (indexPath.row == 0) {
                cell.textLabel.text = @"From";
                cell.detailTextLabel.text = @"English"; // get from plist!
            }
            if (indexPath.row == 1) {
                cell.textLabel.text = @"To";
                cell.detailTextLabel.text = @"Russian"; // get from plist!
            }
            break;
        }
        case DSTSectionTypeService: { // get from plist
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            if (indexPath.row == 0) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                cell.textLabel.text = @"Google Translate";
            }
            if (indexPath.row == 1) {
                cell.textLabel.text = @"Bing Translator";
            }
            break;
        }
        case DSTSectionTypeInfo: {
            break;
        }
    }
    
    return cell;
}


/*
#pragma mark - Navigation NEED!

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
