//
//  CreateProfileViewController.m
//  RoomIn
//
//  Created by Jonathan Wang on 12/8/16.
//  Copyright © 2016 JonathanWang. All rights reserved.
//

#import "CreateProfileViewController.h"
#import "RoomInUser.h"
@import Firebase;

@interface CreateProfileViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *companyAndPositionLabel;
@property (strong, nonatomic) IBOutlet UILabel *industryLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UISwitch *petsSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *smokeSwitch;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation CreateProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    self.ref = [[FIRDatabase database] reference];
    [self setLabels];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dismissKeyboard {
    [_descriptionTextView resignFirstResponder];
}

- (void) setLabels {
    NSData *data = [[NSData alloc] initWithContentsOfURL:
                    [NSURL URLWithString:self.currentUser.pictureURL]];
    
    UIImage *image = [[UIImage alloc] initWithData:data];
    _profileImageView.image = image;
    
    NSString* fullName = [[self.currentUser.firstname stringByAppendingString:@" "] stringByAppendingString:self.currentUser.lastname];
    _fullNameLabel.text = fullName;
    
    _locationLabel.text = _currentUser.location;
    
    NSString* companyAndPosition = [[self.currentUser.company stringByAppendingString:@" | "] stringByAppendingString:self.currentUser.positions[@"positions"][@"values"][0][@"title"]];
    _companyAndPositionLabel.text = companyAndPosition;
    
    _industryLabel.text = _currentUser.industry;
    
    _descriptionTextView.text = [[_currentUser.headline stringByAppendingString:@"\n\nSummary:\n" ]  stringByAppendingString:_currentUser.summary];
    
}

- (IBAction)doneClicked:(id)sender {
    
    NSString* description = _descriptionTextView.text;
    NSString* petFriendly = _petsSwitch.isOn ? [NSString stringWithFormat: @"YES"] : [NSString stringWithFormat: @"NO"];
    NSString* smokeFriendly = _smokeSwitch.isOn ? [NSString stringWithFormat: @"YES"] : [NSString stringWithFormat: @"NO"];
    
    FIRDatabaseReference *newUserDb = [[_ref child:@"Users"] child: _currentUser.idNumber];
    
    [[newUserDb child:@"First Name"] setValue: _currentUser.firstname];
    [[newUserDb child:@"Last Name"] setValue: _currentUser.lastname];
    [[newUserDb child:@"Company"] setValue: _currentUser.company];
    [[newUserDb child:@"Industry"] setValue: _currentUser.industry];
    [[newUserDb child:@"Location"] setValue: _currentUser.location];
    [[newUserDb child:@"Summary"] setValue: _currentUser.summary];
    [[newUserDb child:@"Headline"] setValue: _currentUser.headline];
    [[newUserDb child:@"Profile Picture URL"] setValue: _currentUser.pictureURL];
    [[newUserDb child:@"LinkedIn URL"] setValue: _currentUser.profileURL];
    [[newUserDb child:@"Pet-Friendly"] setValue: petFriendly];
    [[newUserDb child:@"Smoke-Friendly"] setValue: smokeFriendly];
    [[newUserDb child:@"Description"] setValue: description];
    
    [[[[_ref child:@"Cities"] child: _currentUser.location] child: _currentUser.idNumber] setValue:_currentUser.firstname];
    
    [self performSegueWithIdentifier:@"Created Segue" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
