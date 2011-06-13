//
//  Possession.h
//  RandomPossessions
//
//  Created by Dave Wilde on 6/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Possession : NSObject {
    NSString *possessionName;
    NSString *serialNumber;
    int valueInDollars;
    NSDate *dateCreated;
    NSString *imageKey;
}

@property (nonatomic, copy) NSString *possessionName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, readonly) NSDate *dateCreated;
@property (nonatomic, copy) NSString *imageKey;

+ (id)randomPossession;

- (id)initWithPossessionName:(NSString *)pName valueInDollars:(int)value serialNumber:(NSString *)sNumber;
- (id)initWithPossessionName:(NSString *)pName;

@end
