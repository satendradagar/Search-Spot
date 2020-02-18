//
//  NSURL+RestoreAccessPermissions.m
//  Big Event Reminder
//
//  Created by Satendra Singh on 05/11/14.
//
//

#import "NSURL+RestoreAccessPermissions.h"
#import "AppDelegate.h"
//#import "FileAccessPermission.h"
//#import "AppDelegate+SRFilePermissionManagement.h"

#define defaults [NSUserDefaults standardUserDefaults]

@implementation NSURL (RestoreAccessPermissions)

#pragma mark - 
#pragma mark - Coredata releated methods

+(NSURL *) urlForFilePathByRestoringPermissions:(NSString *)filePath;
{
    NSData *bookMarkData = [self accessPermissionDataForPath:filePath];
    NSLog(@"requesting for filepath : %@, datasize = %lu",filePath,(unsigned long)bookMarkData.length);
    if (bookMarkData != nil) {
        NSURL *accesableUrl = [self urlFromBookmark:bookMarkData];
        if (filePath.length && nil == accesableUrl) {
            accesableUrl = [NSURL fileURLWithPath:filePath];
        }
        [accesableUrl startAccessingSecurityScopedResource];
        return accesableUrl;
    }
    else{
        return nil;
    }
}

-(void) storeAccessPermissions
{
    NSData *bookData = [self bookmarkData];
    [NSURL saveBookMarkData:bookData forPath:self.absoluteString];
//    [[AppDelegate sharedDelegteInstance] storepermissionAccessForURL:self fileID:nil];
//    [self stopAccessingSecurityScopedResource];
}

-(void)clearAccessPermissions{
    
    [NSURL clearAccessPermissionsForPath:self.absoluteString];
    
}

+(void)saveBookMarkData:(NSData *)data forPath:(NSString *)path{
    
    [defaults setObject:data forKey:path];
    
}

+(NSData *)accessPermissionDataForPath:(NSString *)path{

    return [defaults objectForKey:path];

}


+(void)clearAccessPermissionsForPath:(NSString *)path{
    [defaults removeObjectForKey:path];
}

#pragma mark -
#pragma mark - Bookmark related methods
- (NSData *)bookmarkData {
    NSError *error = nil;
    NSData *bookmark = [self bookmarkDataWithOptions:NSURLBookmarkCreationWithSecurityScope | NSURLBookmarkCreationSecurityScopeAllowOnlyReadAccess includingResourceValuesForKeys:NULL relativeToURL:NULL error:&error];
    if (nil != error) {
        NSLog(@"Error in accesing file url data = %@",error);

    }
    return bookmark;
}

+ (NSURL *)urlFromBookmark:(NSData *)bookmark {
    NSError *error = noErr;
    NSURL *url = [NSURL URLByResolvingBookmarkData:bookmark options:NSURLBookmarkResolutionWithSecurityScope relativeToURL:NULL bookmarkDataIsStale:NULL error:&error];
    if (error != noErr)
        NSLog(@"urlFromBookmark:%@, url = %@", [error description], url);
    return url;
}

@end
