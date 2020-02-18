//
//  NSURL+RestoreAccessPermissions.h
//  Big Event Reminder
//
//  Created by Satendra Singh on 05/11/14.
//
//

#import <Foundation/Foundation.h>

@interface NSURL (RestoreAccessPermissions)

+(NSURL *) urlForFilePathByRestoringPermissions:(NSString *)filePath;
-(void) storeAccessPermissions;
- (NSData *)bookmarkData;

@end
