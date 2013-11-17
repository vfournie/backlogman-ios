//
//  BKGLoginViewController.m
//  Backlogman
//
//  Created by Vincent Fournié on 15.11.13.
//  Copyright (c) 2013 VFE. All rights reserved.
//

#import "BKGLoginViewController.h"
#import "BKGAPIClient.h"

@interface BKGLoginViewController ()

@property (strong, nonatomic) IBOutlet UILabel *errorLabel;
@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation BKGLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIColor *mainColor = [UIColor colorWithRed:108/255.0f green:167/255.0f blue:170/255.0f alpha:1.0f];
    UIColor *darkColor = [UIColor colorWithRed:20/255.0f green:114/255.0f blue:119/255.0f alpha:1.0f];

    self.view.backgroundColor = mainColor;

    self.infoView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    self.infoLabel.textColor =  [UIColor darkGrayColor];
    self.infoLabel.text = NSLocalizedString(@"Welcome, please sign-in", nil);

    [self configureTextField:self.usernameField withPlaceholder:@"Email"];
    [self configureTextField:self.passwordField withPlaceholder:@"Password"];

    self.loginButton.backgroundColor = darkColor;
    [self.loginButton setTitle:NSLocalizedString(@"LOGIN", nil)
                      forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor]
                           forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f]
                           forState:UIControlStateHighlighted];
    self.loginButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.loginButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
}

- (void)configureTextField:(UITextField *)textField withPlaceholder:(NSString *)placeholder
{
    textField.backgroundColor = [UIColor whiteColor];
    textField.placeholder = placeholder;
    textField.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
    textField.layer.borderWidth = 1.0f;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 20)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftView;
}

#pragma mark - Action

- (IBAction)signIn:(id)sender
{
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];

    NSString *email = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = self.passwordField.text;

    [self clearError];

    BOOL error = NO;
    if ([password length] <= 0) {
        [self showError:NSLocalizedString(@"Password should not be empty", nil)];
        error = YES;
    }
    if ([email length] <= 0) {
        [self showError:NSLocalizedString(@"Email should not be empty", nil)];
        error = YES;
    }
    if (error) {
        return;
    }

    [self signInWithUsername:email password:password];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.usernameField) {
        [self.passwordField becomeFirstResponder];
    } else if (textField == self.passwordField) {
        [textField resignFirstResponder];
    }
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

#pragma mark - Private methods

- (void)showError:(NSString *)errorText
{
    self.errorLabel.text = errorText;
    self.errorLabel.hidden = NO;
}

- (void)clearError
{
    self.errorLabel.text = nil;
    self.errorLabel.hidden = YES;
}

- (void)signInWithUsername:(NSString *)username password:(NSString *)password
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[BKGAPIClient sharedClient] signInWithUsername:username
                                               password:password
                                                success:^(BKGAuthToken *token) {
                                                    id<BKGLoginViewControllerDelegate> delegate = self.signInDelegate;
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        if (delegate) {
                                                            [delegate signInDidSucceed:self];
                                                        }
                                                    });
                                                }
                                                failure:^(NSError *error) {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        [self showError:[error localizedDescription]];
                                                    });
                                                }
         ];
    });
}

@end
