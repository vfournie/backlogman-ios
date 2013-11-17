//
//  BKGMasterViewController.m
//  Backlogman
//
//  Created by Vincent Fournié on 11.11.13.
//  Copyright (c) 2013 VFE. All rights reserved.
//

#import "BKGMasterViewController.h"
#import "BKGDetailViewController.h"
#import "BKGLoginViewController.h"
#import "BKGAPIClient.h"
#import "BKGModel.h"

#define SECTION_ORGANIZATION 0
#define SECTION_PROJECT 1
#define NB_OF_SECTIONS 2

@interface BKGMasterViewController () <BKGLoginViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *organizations;
@property (nonatomic, strong) NSMutableArray *projects;
@property (nonatomic, assign) BOOL hasOrganization;
@property (nonatomic, assign) BOOL hasProject;

@end

@implementation BKGMasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.organizations = [NSMutableArray new];
    self.projects = [NSMutableArray new];

    self.detailViewController = (BKGDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

    self.title = NSLocalizedString(@"Dashboard", nil);

    if ([[BKGAPIClient sharedClient] isLoggedIn]) {
        [self loadObjects];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (![[BKGAPIClient sharedClient] isLoggedIn]) {
        BKGLoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BKGLoginViewController"];
        vc.signInDelegate = self;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
            navVC.modalPresentationStyle = UIModalPresentationFormSheet;
            [self presentViewController:navVC animated:YES completion:nil];
        }
        else {
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NB_OF_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 1;
    if (section == SECTION_ORGANIZATION) {
        NSInteger count = [self.organizations count];
        if (count > 0) {
            numberOfRows = count;
        }
    }
    else {
        NSInteger count = [self.projects count];
        if (count > 0) {
            numberOfRows = count;
        }
    }
    return numberOfRows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == SECTION_ORGANIZATION) {
        return NSLocalizedString(@"Organizations", nil);
    }
    else {
        return NSLocalizedString(@"Projects", nil);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    if (indexPath.section == SECTION_ORGANIZATION) {
        if ([self.organizations count] == 0) {
            // Placeholder cell
            cell.textLabel.text = NSLocalizedString(@"No active organization", nil);
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.userInteractionEnabled = NO;
        }
        else {
            BKGOrganization *org = self.organizations[indexPath.row];
            cell.textLabel.text = org.name;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.userInteractionEnabled = YES;
        }
    }
    else {
        if ([self.projects count] == 0) {
            // Placeholder cell
            cell.textLabel.text = NSLocalizedString(@"No active stand-alone project", nil);
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.userInteractionEnabled = NO;
        }
        else {
            BKGProject *project = self.projects[indexPath.row];
            cell.textLabel.text = project.name;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.userInteractionEnabled = YES;
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        BKGObject *object = [self objectForIndexPath:indexPath];

        // Load object detail from the server
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[BKGAPIClient sharedClient]
             getObjectDetail:object
             success:^(BKGObject *object) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     self.detailViewController.detailItem = object;
                 });
             }
             failure:^(NSError *error) {
             }];
        });
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        BKGObject *object = [self objectForIndexPath:indexPath];

        // Load object detail from the server
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[BKGAPIClient sharedClient]
             getObjectDetail:object
             success:^(BKGObject *object) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [[segue destinationViewController] setDetailItem:object];
                 });
             }
             failure:^(NSError *error) {
             }];
        });
    }
}

#pragma mark - BKGLoginViewControllerDelegate

- (void)signInDidSucceed:(BKGLoginViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:^{
        if ([[BKGAPIClient sharedClient] isLoggedIn]) {
            [self loadObjects];
        }
    }];
}

#pragma mark - Loading

- (void)loadObjects
{
    [self loadOrganizations];
    [self loadProjects];
}

#pragma mark - Private methods

- (BKGObject *)objectForIndexPath:(NSIndexPath *)indexPath
{
    BKGObject *object;
    if (indexPath.section == SECTION_ORGANIZATION) {
        object = self.organizations[indexPath.row];
    }
    else {
        object = self.projects[indexPath.row];
    }
    return object;
}

- (void)loadOrganizations
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[BKGAPIClient sharedClient]
         getOrganizationsWithSuccess:^(NSArray *list) {
            [self.organizations removeAllObjects];
            [self.organizations addObjectsFromArray:list];
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.tableView reloadData];
             });
        } failure:^(NSError *error) {
            [self.organizations removeAllObjects];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
    });
}

- (void)loadProjects
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[BKGAPIClient sharedClient]
         getStandaloneProjectsWithSuccess:^(NSArray *list) {
             [self.projects removeAllObjects];
             [self.projects addObjectsFromArray:list];
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.tableView reloadData];
             });
         } failure:^(NSError *error) {
             [self.projects removeAllObjects];
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.tableView reloadData];
             });
         }];
    });
}

@end
