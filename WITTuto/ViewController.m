//
//  ViewController.m
//  WITTuto
//
//  Created by Aric Lasry on 10/2/14.
//  Copyright (c) 2014 Aric Lasry. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    UILabel *statusView;
    UILabel *intentView;
    UITextView *entitiesView;
    WITMicButton* witButton;
    UIButton *settingsBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [Wit sharedInstance].accessToken = [self getWitAccessTokenFromDevice];

    // Do any additional setup after loading the view, typically from a nib.
    
    // set the WitDelegate object
    [Wit sharedInstance].delegate = self;
    [self setupUI];
    
}

-(void)setupUI {
    // create the button
    CGRect screen = [UIScreen mainScreen].bounds;
    CGFloat w = 100;
    CGRect rect = CGRectMake(screen.size.width/2 - w/2, 60, w, 100);
    
    witButton = [[WITMicButton alloc] initWithFrame:rect];
    [self.view addSubview:witButton];
    
    // create the label
    intentView = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, screen.size.width, 50)];
    intentView.textAlignment = NSTextAlignmentCenter;
    entitiesView = [[UITextView alloc] initWithFrame:CGRectMake(0, 250, screen.size.width, screen.size.height - 300)];
    entitiesView.backgroundColor = UIColorFromRGB(0xF4F4F4);
    [self.view addSubview:entitiesView];
    [self.view addSubview:intentView];
    intentView.text = @"Intent will show up here";
    entitiesView.textAlignment = NSTextAlignmentCenter;
    entitiesView.text = @"Entities will show up here";
    entitiesView.editable = NO;
    entitiesView.font = [UIFont systemFontOfSize:17];
    
    statusView = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, screen.size.width, 50)];
    statusView.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:statusView];
    
    //adding settings button
    settingsBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    settingsBtn.frame = CGRectMake(screen.size.width - 150, screen.size.height - 50, 140, 30);
    [self.view addSubview:settingsBtn];
    
    [settingsBtn addTarget:self action:@selector(pressedSettingsBtn) forControlEvents:UIControlEventTouchUpInside];
    [self updateSettingsButtonDisplay];
    
}

-(void)pressedSettingsBtn{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Set Wit Token" message:@"Enter the Wit Client Access token of your instance" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.text = [self getWitAccessTokenFromDevice];
}

/**
 * Delegate for the settings alert
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *accessToken = [[alertView textFieldAtIndex:0] text];
    
    if (accessToken.length > 0) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:accessToken forKey:kWitAccessToken];
        [userDefaults synchronize];
        [Wit sharedInstance].accessToken = accessToken;
        [self updateSettingsButtonDisplay];
    }
}

-(void)updateSettingsButtonDisplay {
    if ([Wit sharedInstance].accessToken.length > 0) {
        [settingsBtn setTitle:@"Change Wit token" forState:UIControlStateNormal];
        [settingsBtn setTitleColor:nil forState:UIControlStateNormal];
    } else {
        [settingsBtn setTitle:@"Set Wit Token" forState:UIControlStateNormal];
        [settingsBtn setTitleColor:UIColorFromRGB(0xFF0000) forState:UIControlStateNormal];
    }
}

-(NSString *)getWitAccessTokenFromDevice {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kWitAccessToken];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)witDidGraspIntent:(NSString *)intent entities:(NSDictionary *)entities body:(NSString *)body error:(NSError *)e {
    statusView.text = @"";
    if (e) {
        NSLog(@"[Wit] error: %@", [e localizedDescription]);
        statusView.text = @"Something went wrong";
                entitiesView.text = [e localizedDescription];
        return;
    }
    
    NSError *error = nil;
    NSData *json;
    
    
    intentView.text = [NSString stringWithFormat:@"Intent = %@", intent];
    // Dictionary convertable to JSON ?
    if ([NSJSONSerialization isValidJSONObject:entities])
    {
        entitiesView.textAlignment = NSTextAlignmentLeft;
        // Serialize the dictionary
        json = [NSJSONSerialization dataWithJSONObject:entities options:NSJSONWritingPrettyPrinted error:&error];
        
        // If no errors, let's view the JSON
        if (json != nil && error == nil)
        {
            NSString *jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
            
            NSLog(@"JSON: %@", jsonString);
            entitiesView.text = jsonString;
        }
    }

}

-(void)witDidStartRecording {
        statusView.text = @"Listening...";
        entitiesView.text = @"";
    }

- (void)witDidStopRecording {
        statusView.text = @"Processing...";
        entitiesView.text = @"";
    }

@end
