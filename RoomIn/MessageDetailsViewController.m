//
//  MessageDetailsViewController.m
//  RoomIn
//
//  Created by Jonathan Wang on 12/6/16.
//  Copyright © 2016 JonathanWang. All rights reserved.
//

#import "MessageDetailsViewController.h"

@interface MessageDetailsViewController ()
@property (strong, nonatomic) IBOutlet UITextField *chatTF;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MessageDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendClicked:(id)sender {
    
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [self.chatTF resignFirstResponder];
    self.chatTF.text = nil;
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
