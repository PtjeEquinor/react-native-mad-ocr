//
//  Helper.m
//  MadOcr
//
//  Created by Trond Eskeland on 15/09/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <Helper.h>
#import <Foundation/Foundation.h>


@implementation Helper
- (instancetype)init {
    self = [super init];
    return self;
}

+ (instancetype)Helper {
    return [[self alloc] init];
}

- (NSInteger)computeLevenshteinDistanceFrom:(NSString *)source to:(NSString *)target {
    NSUInteger sourceLength = [source length] + 1;
    NSUInteger targetLength = [target length] + 1;

    NSMutableArray *cost = [NSMutableArray new];
    NSMutableArray *newCost = [NSMutableArray new];

    for (NSUInteger i = 0; i < sourceLength; i++) {
        cost[i] = @(i);
    }

    for (NSUInteger j = 1; j < targetLength; j++) {
        newCost[0] = @(j - 1);

        for (NSUInteger i = 1; i < sourceLength; i++) {
            NSInteger match = ([source characterAtIndex:i - 1] == [target characterAtIndex:j - 1]) ? 0 : 1;
            NSInteger costReplace = [cost[i - 1] integerValue] + match;
            NSInteger costInsert = [cost[i] integerValue] + 1;
            NSInteger costDelete = [newCost[i - 1] integerValue] + 1;
            newCost[i] = @(MIN(MIN(costInsert, costDelete), costReplace));
        }

        NSMutableArray *swap = cost;
        cost = newCost;
        newCost = swap;
    }

    return [cost[sourceLength - 1] integerValue];
}
@end
