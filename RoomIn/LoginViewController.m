//
//  LoginViewController.m
//  RoomIn
//
//  Created by Jonathan Wang on 12/6/16.
//  Copyright © 2016 JonathanWang. All rights reserved.
//

#import "LoginViewController.h"
#import "RoomInUser.h"
#import <linkedin-sdk/LISDK.h>
#import "CreateProfileViewController.h"
#import "ResultsViewController.h"

@import Firebase;

@interface LoginViewController ()

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) __block RoomInUser * currentUser;
@property BOOL userIsRegistered;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.ref = [[FIRDatabase database] reference];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDictionary*) parseJsonString: (NSString*) jsonString {
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    return dict;
}

- (IBAction) signInClicked:(id)sender {
    __block NSString * firstname = nil, *lastname = nil , *company = nil,
    *industry = nil, *summary = nil, *headline = nil,
    *profileURL = nil, *pictureURL = nil, *idNumber = nil;
    __block NSDictionary* positions = nil;
    
    [LISDKSessionManager
     createSessionWithAuth:[NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION, nil]
     state:nil
     showGoToAppStoreDialog:YES
     successBlock:^(NSString *returnState) {
         NSLog(@"%s","success called!");
         
         if ([LISDKSessionManager hasValidSession]) {
             
             LISDKAPIHelper * apiHelper = [LISDKAPIHelper sharedInstance];
             
             //1st API call getting name, id, and headline
             NSString *url1 = [NSString stringWithFormat:
                              @"https://api.linkedin.com/v1/people/~?format=json"];
             
             [apiHelper getRequest:url1 success:^(LISDKAPIResponse *response) {
                 NSDictionary *profileDictionary = [self parseJsonString:response.data];
                 firstname = [NSString stringWithString:profileDictionary[@"firstName"]];
                 lastname = [NSString stringWithString:profileDictionary[@"lastName"]];
                 idNumber = [NSString stringWithString:profileDictionary[@"id"]];
                 headline = [NSString stringWithString:profileDictionary[@"headline"]];
                 //2nd API call getting profile url
                 NSString *url2 = [NSString stringWithFormat:
                        @"https://api.linkedin.com/v1/people/~:(public-profile-url)?format=json"];
                 
                 [apiHelper getRequest:url2 success:^(LISDKAPIResponse *response) {
                     NSDictionary* profileDict = [self parseJsonString:response.data];
                     profileURL = [NSString stringWithString: profileDict[@"publicProfileUrl"]];
                     
                     //3rd API call getting picture url
                     NSString *url3 = [NSString stringWithFormat:
                            @"https://api.linkedin.com/v1/people/~:(picture-url)?format=json"];
                     
                     [apiHelper getRequest:url3 success:^(LISDKAPIResponse *response) {
                         NSDictionary* pictureDict = [self parseJsonString:response.data];
                         pictureURL = [NSString stringWithString: pictureDict[@"pictureUrl"]];
                         
                         //4th API call getting industry
                         NSString* url4 = [NSString stringWithFormat:
                                @"https://api.linkedin.com/v1/people/~:(industry)?format=json"];
                         
                         [apiHelper getRequest:url4 success:^(LISDKAPIResponse *response) {
                             NSDictionary* industryDict = [self parseJsonString:response.data];
                             industry = [NSString stringWithString: industryDict[@"industry"]];
                             
                         } error:^(LISDKAPIError *apiError) {
                             NSLog(@"%@", [apiError debugDescription]);
                         }];
                         
                         //5th API call getting positions
                         NSString* url5 = [NSString stringWithFormat:
                                @"https://api.linkedin.com/v1/people/~:(positions)?format=json"];
                         
                         [apiHelper getRequest:url5 success:^(LISDKAPIResponse *response) {
                             positions = [self parseJsonString:response.data];
                             
                             //6th API call getting summary
                             NSString *url6 = [NSString stringWithFormat:
                                    @"https://api.linkedin.com/v1/people/~:(summary)?format=json"];
                             
                             [apiHelper getRequest:url6 success:^(LISDKAPIResponse *response) {
                                 NSDictionary* summaryDict = [self parseJsonString:response.data];
                                 summary = [NSString stringWithString: summaryDict[@"summary"]];
                                 
                                 NSLog(@"ID NUMBER: %@", idNumber);
                                 
                                 //Set Current User
                                 _currentUser = [[RoomInUser alloc] initWithFirstName:firstname lastName:lastname company:company industry:industry summary:summary headline:headline profileURL:profileURL pictureURL:pictureURL andIdNumber:idNumber];
                                 
                                 [self checkIfUserIsRegistered];

                             } error:^(LISDKAPIError *apiError) {
                                 NSLog(@"%@", [apiError debugDescription]);
                             }];
                         } error:^(LISDKAPIError *apiError) {
                             NSLog(@"%@", [apiError debugDescription]);
                         }];
                     } error:^(LISDKAPIError *apiError) {
                         NSLog(@"%@", [apiError debugDescription]);
                     }];
                 } error:^(LISDKAPIError *apiError) {
                     NSLog(@"%@", [apiError debugDescription]);
                 }];
             } error:^(LISDKAPIError *apiError) {
                 NSLog(@"%@", [apiError debugDescription]);
             }];
        }
     }
     errorBlock:^(NSError *error) {
         NSLog(@"%s","error called!");
     }];
}

- (void) checkIfUserIsRegistered {
    [[[self.ref child:@"Users"] child:_currentUser.idNumber] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        // Get user value
        if([snapshot exists]){
            self.userIsRegistered = YES;
            [self performSegueWithIdentifier:@"Home Segue" sender:self];
        } else {
            self.userIsRegistered = NO;
            [self performSegueWithIdentifier:@"Create Profile Segue" sender:self];
        }
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", [error debugDescription]);
    }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if(self.userIsRegistered) {
        ResultsViewController *dest = [segue destinationViewController];
        dest.currentUser = _currentUser;
        
    } else {
        CreateProfileViewController *dest = [segue destinationViewController];
        dest.currentUser = _currentUser;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
