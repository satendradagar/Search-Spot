//
//  NSFileManager+UnhiddenDirectories.h
//  Search Spot
//
//  Created by admin on 19/04/17.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (UnhiddenDirectories)

-(NSArray<NSURL *> *) directoriesAtPath:(NSString *)parentPath;

@end
