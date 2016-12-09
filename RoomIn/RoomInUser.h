//
//  RoomInUser.h
//  RoomIn
//
//  Created by Jonathan Wang on 12/8/16.
//  Copyright © 2016 JonathanWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoomInUser : NSObject
@property (strong, nonatomic) NSString* firstname, *lastname,
                                        *company, *industry,
                                        *summary, *headline,
                                        *profileURL, *pictureURL,
                                        *idNumber;

@property (strong, nonatomic) NSDictionary* positions;


- (instancetype) initWithFirstName: (NSString*) fn
                          lastName: (NSString*) ln
                           company: (NSString*) c
                          industry: (NSString*) indus
                           summary: (NSString*) sum
                          headline: (NSString*) hl
                        profileURL: (NSString*) prof
                        pictureURL: (NSString*) pic
                       andIdNumber: (NSString*) idnum;

@end
