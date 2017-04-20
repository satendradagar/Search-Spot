//
//  NSFileManager+UnhiddenDirectories.h
//  Search Spot
//
//  Created by admin on 19/04/17.
//  Copyright © 2017 Reboot Computer Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (UnhiddenDirectories)

-(NSArray<NSURL *> *) directoriesAtPath:(NSString *)parentPath;

@end
