//
//  NSFileManager+UnhiddenDirectories.m
//  Search Spot
//
//  Created by admin on 19/04/17.
//  Copyright © 2017 Reboot Computer Services. All rights reserved.
//

#import "NSFileManager+UnhiddenDirectories.h"

@implementation NSFileManager (UnhiddenDirectories)

-(NSArray<NSURL *> *) directoriesAtPath:(NSString *)parentPath{
    
    NSArray *theFiles =  [self contentsOfDirectoryAtURL:[NSURL fileURLWithPath:parentPath]
                                    includingPropertiesForKeys:[NSArray arrayWithObjects:NSURLNameKey,NSURLIsDirectoryKey,nil]
                                                       options:NSDirectoryEnumerationSkipsHiddenFiles
                                                         error:nil];
    NSMutableArray *finalDirs = [NSMutableArray new];
    for (NSURL *theURL in theFiles) {
        
        // Retrieve the file name. From NSURLNameKey, cached during the enumeration.
//        NSString *fileName;
//        [theURL getResourceValue:&fileName forKey:NSURLNameKey error:NULL];
        
        // Retrieve whether a directory. From NSURLIsDirectoryKey, also
        // cached during the enumeration.
        
        NSNumber *isDirectory;
        [theURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];
        
        
        if([isDirectory boolValue] == YES)
        {
            [finalDirs addObject: theURL];
        }
    }
    
    return finalDirs;

}

@end
