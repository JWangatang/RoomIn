//
//  User.m
//  RoomIn
//
//  Created by Jonathan Wang on 12/8/16.
//  Copyright © 2016 JonathanWang. All rights reserved.
//

#import "RoomInUser.h"

@implementation RoomInUser

- (instancetype) initWithFirstName: (NSString*) fn
                          lastName: (NSString*) ln
                           company: (NSString*) c
                          industry: (NSString*) indus
                          location: (NSString*) loc
                           summary: (NSString*) sum
                          headline: (NSString*) hl
                        profileURL: (NSString*) prof
                        pictureURL: (NSString*) pic
                         positions: (NSDictionary*) pos
                       andIdNumber: (NSString*) idnum {
    self = [super init];
    if(self) {
        _firstname = fn;
        _lastname = ln;
        _company = c;
        _industry = indus;
        _location = loc;
        _summary = sum;
        _headline = hl;
        _profileURL = prof;
        _pictureURL = pic;
        _profileURL = prof;
        _positions = pos;
        _idNumber = idnum;
        
    }
    return self;
}

@end
