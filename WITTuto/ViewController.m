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
    UILabel *labelView;
    UITextView *entitiesView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // set the WitDelegate object
    [Wit sharedInstance].delegate = self;
    
    // create the button
    CGRect screen = [UIScreen mainScreen].bounds;
    CGFloat w = 100;
    CGRect rect = CGRectMake(screen.size.width/2 - w/2, 60, w, 100);
    
    WITMicButton* witButton = [[WITMicButton alloc] initWithFrame:rect];
    [self.view addSubview:witButton];
    
    // create the label
    labelView = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, screen.size.width, 50)];
    labelView.textAlignment = NSTextAlignmentCenter;
    
    

    entitiesView = [[UITextView alloc] initWithFrame:CGRectMake(0, 250, screen.size.width, screen.size.height - 270)];
    entitiesView.backgroundColor = UIColorFromRGB(0xF4F4F4);

    [self.view addSubview:entitiesView];
    [self.view addSubview:labelView];
    labelView.text = @"Intent will show up here";
    entitiesView.textAlignment = NSTextAlignmentCenter;
    entitiesView.text = @"Entities will show up here";
    entitiesView.editable = NO;
    entitiesView.font = [UIFont systemFontOfSize:17];
    
    
//    [[Wit sharedInstance] interpretString:@"Wake me up at 7am"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)witDidStartRecording {
    labelView.text = @"Listening...";
    entitiesView.text = @"";
}

- (void)witDidStopRecording {
    labelView.text = @"Processing...";
    entitiesView.text = @"";
}

- (void)witDidGraspIntent:(NSString *)intent entities:(NSDictionary *)entities body:(NSString *)body error:(NSError *)e {
    if (e) {
        NSLog(@"[Wit] error: %@", [e localizedDescription]);
        labelView.text = @"Something went wrong";
        entitiesView.text = [e localizedDescription];
        
        return;
    }
    NSError *error = nil;
    NSData *json;
    
    labelView.text = [NSString stringWithFormat:@"Intent = %@", intent];
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
    
    [self.view addSubview:labelView];
}

@end
