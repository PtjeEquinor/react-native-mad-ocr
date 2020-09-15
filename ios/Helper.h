//
//  Helper.h
//  MadOcr
//
//  Created by Trond Eskeland on 15/09/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

#ifndef Helper_h
#define Helper_h
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Helper : NSObject
+ (instancetype)Helper;

 - (NSInteger)computeLevenshteinDistanceFrom:(NSString *)source to:(NSString *)target;
@end

#endif /* Helper_h */
