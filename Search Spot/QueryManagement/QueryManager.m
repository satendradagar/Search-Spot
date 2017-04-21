//
//  QueryManager.m
//  Search Spot
//
//  Created by admin on 03/04/17.
//  Copyright © 2017 Reboot Computer Services. All rights reserved.
//

#import "QueryManager.h"
#import "MetaValueTransformer.h"

@implementation QueryManager
{
    NSMetadataQuery *query;
    NSString *searchKey;
    NSString *groupKey;
    NSString *searchByKey;
    BOOL searchContent;

}

+ (void)initialize {
    if (self == [QueryManager class]) {    // We want to do this once
        // Create some transformers used by the UI.
        // To see where these values are, open up MainMenu.nib, look at the Value item on the Bindings tab and notice how some items specify these transformers in the "Value Transformer" field. For example, the NSTextField labled "Query is alive..." has the "Value Transformer" set to "RunningTransformer".
        NSValueTransformer *runTrans = [[IsRunningTransformer alloc] init];
        [NSValueTransformer setValueTransformer:runTrans forName:@"RunningTransformer"];
        
        // In the "Grouped Results" tab, the final "Size" column uses the "MBTransformer"
        NSValueTransformer *mbTrans = [[MBTransformer alloc] init];
        [NSValueTransformer setValueTransformer:mbTrans forName:@"MBTransformer"];
        
        // In the "Grouped Results" tab, the first column in the bottom NSTableView uses the MetadataItemIconTransformer to display an icon
        NSValueTransformer *iconTrans = [[MetadataItemIconTransformer alloc] init];
        [NSValueTransformer setValueTransformer:iconTrans forName:@"MetadataItemIconTransformer"];
    }
}

- (id)init {
    if (self = [super init]) {
        self.searchKey = @"";
        
        searchByKey = (NSString *)kMDItemFSName;//Default search by File system name
        
        self.query = [[NSMetadataQuery alloc] init] ;
        // To watch results send by the query, add an observer to the NSNotificationCenter
        NSNotificationCenter *nf = [NSNotificationCenter defaultCenter];
        [nf addObserver:self selector:@selector(queryNote:) name:nil object:self.query];
        
        // We want the items in the query to automatically be sorted by the file system name; this way, we don't have to do any special sorting
        [self.query setSortDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:(id)kMDItemFSName ascending:YES] ]];
        // For the groups, we want the first grouping by the kind, and the second by the file size.
        [self.query setGroupingAttributes:[NSArray arrayWithObjects:(id)kMDItemCreator, nil]];
        [self.query setDelegate:self];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@synthesize query;

- (void)queryNote:(NSNotification *)note {
    // The NSMetadataQuery will send back a note when updates are happening. By looking at the [note name], we can tell what is happening
    NSMetadataQueryChangeType updateType = QueryDidStartGathering;
    if ([[note name] isEqualToString:NSMetadataQueryDidStartGatheringNotification]) {
        updateType =QueryDidStartGathering;
        // The gathering phase has just started!
//        if (NO == [self.query.searchScopes containsObject:NSMetadataQueryLocalComputerScope]) {
//            [self.query setSearchScopes:@[NSMetadataQueryLocalComputerScope]];
//
        
//        }
        NSLog(@"Started gathering");
    } else if ([[note name] isEqualToString:NSMetadataQueryDidFinishGatheringNotification]) {
        updateType =QueryDidFinishGathering;

        // At this point, the gathering phase will be done. You may recieve an update later on.
        NSLog(@"Finished gathering");
    } else if ([[note name] isEqualToString:NSMetadataQueryGatheringProgressNotification]) {
        updateType =QueryGatheringProgress;

        // The query is still gatherint results...
        NSLog(@"Progressing...");
    } else if ([[note name] isEqualToString:NSMetadataQueryDidUpdateNotification]) {
        updateType =QueryDidUpdateGathering;

        // An update will happen when Spotlight notices that a file as added, removed, or modified that affected the search results.
        NSLog(@"An update happened.");
    }
    if (nil != _resultChangeBlock) {
        _resultChangeBlock(updateType);

    }

}

// NSMetadataQuery delegate methods.
// metadataQuery:replacementValueForAttribute:value allows the resulting value retrieved from an NSMetadataItem to be changed. When items are grouped, we want to allow all items of a similar size to be grouped together. This allows this to happen.
- (id)metadataQuery:(NSMetadataQuery *)query replacementValueForAttribute:(NSString *)attrName value:(id)attrValue {
    if ([attrName isEqualToString:(id)kMDItemFSSize]) {
        NSInteger fsSize = [attrValue integerValue];
        // Here is a special case for small files
        if (fsSize == 0) {
            return NSLocalizedString(@"0 Byte Files", @"File size, for empty files and directories");
        }
        const NSInteger cutOff = 1024;
        
        if (fsSize < cutOff) {
            return NSLocalizedString(@"< 1 KB Files", @"File size, for items that are less than 1 kilobyte");
        }
        
        // Figure out how many kb, mb, etc, that we have
        NSInteger numK = fsSize / 1024;
        if (numK < cutOff) {
            return NSLocalizedString(@"< 1 MB Files", @"File size, for items that are less than 1 megabytes");

//            return [NSString stringWithFormat:NSLocalizedString(@"%ld KB Files", @"File size, expressed in kilobytes"), (long)numK];
        }
        
        NSInteger numMB = numK / 1024;
        if (numMB < cutOff) {
            return NSLocalizedString(@"< 1 GB Files", @"File size, for items that are less than 1 gegabytes");
//            return [NSString stringWithFormat:NSLocalizedString(@"%ld MB Files", @"File size, expressed in megabytes"), (long)numMB];
        }
        
        return NSLocalizedString(@"Huge files", @"File size, for really large files");
    } else if ((attrValue == nil) || (attrValue == [NSNull null])) {
        // We don't want to display <null> for the user, so, depending on the category, display something better
        if ([attrName isEqualToString:(id)kMDItemKind]) {
            return NSLocalizedString(@"Other", @"Kind to display for unknown file types");
        } else {
            return NSLocalizedString(@"Unknown", @"Kind to display for other unknown values");
        }
    } else if([attrName isEqualToString:(id)kMDItemContentType]){
        
        return [self appPAthForContentType:attrValue];//Specific supported app name
        
    }
    else {
        return attrValue;
    }
    
}

-(NSString *)appPAthForContentType:(NSString *)type{
    CFURLRef url = LSCopyDefaultApplicationURLForContentType((__bridge CFStringRef _Nonnull)(type),kLSRolesAll, nil);
    NSString *appName = [[[(__bridge NSURL *)url path] lastPathComponent] stringByDeletingPathExtension];
    if (NULL != url) {
        CFRelease(url);
        return appName;
    }
    return @"Unknown";
}

- (void)createSearchPredicate {
    
    if (0 == searchKey.length || 0 == searchByKey.length) {
        return;//Skip intitally for wildcard search
    }
    // This demonstrates a few ways to create a search predicate.
    
    // The user can set the checkbox to include this in the search result, or not.
    NSPredicate *predicateToRun = nil;
    if (self.searchContent) {
        // In the example below, we create a predicate with a given format string that simply replaces %@ with the string that is to be searched for. By using "like", the query will end up doing a regular expression search similar to *foo* when you are searching for the word "foo". By using the [c], the NSCaseInsensitivePredicateOption will be set in the created predicate. The particular item type to search for, kMDItemTextContent, is described in MDItem.h.
        NSString *predicateFormat = @"%k contains[c] %@";
        predicateToRun = [NSPredicate predicateWithFormat:predicateFormat,searchByKey, self.searchKey];
    }
    
    // Create a compound predicate that searches for any keypath which has a value like the search key. This broadens the search results to include things such as the author, title, and other attributes not including the content. This is done in code for two reasons: 1. The predicate parser does not yet support "* = Foo" type of parsing, and 2. It is an example of creating a predicate in code, which is much "safer" than using a search string.
    NSPredicateOperatorType type = NSContainsPredicateOperatorType;
    if (searchKey.length <= 2) {
            type = NSBeginsWithPredicateOperatorType;
        }
    NSUInteger options = (NSCaseInsensitivePredicateOption|NSDiacriticInsensitivePredicateOption);
    NSPredicate *compPred = [NSComparisonPredicate
                             predicateWithLeftExpression:[NSExpression expressionForKeyPath:searchByKey]
                             rightExpression:[NSExpression expressionForConstantValue:self.searchKey]
                             modifier:NSDirectPredicateModifier
                             type:type
                             options:options];
//    NSPredicate *compPred = [NSComparisonPredicate
//                             predicateWithLeftExpression:[NSExpression expressionForKeyPath:@"*"]
//                             rightExpression:[NSExpression expressionForConstantValue:self.searchKey]
//                             modifier:NSDirectPredicateModifier
//                             type:NSLikePredicateOperatorType
//                             options:options];
    // Combine the two predicates with an OR, if we are including the content as searchable
    if (self.searchContent) {
        predicateToRun = [NSCompoundPredicate orPredicateWithSubpredicates:[NSArray arrayWithObjects:compPred, predicateToRun, nil]];
    } else {
        // Since we aren't searching the content, just use the other predicate
        predicateToRun = compPred;
    }
    
    // Now, we don't want to include email messages in the result set, so add in an AND that excludes them
    NSPredicate *emailExclusionPredicate = [NSPredicate predicateWithFormat:@"(kMDItemContentType != 'com.apple.mail.emlx') && (kMDItemContentType != 'public.vcard')"];
    predicateToRun = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:predicateToRun, emailExclusionPredicate, nil]];
    
    // Set it to the query. If the query already is alive, it will update immediately
    NSLog(@"predicateToRun:\n%@",predicateToRun);
    [self.query setPredicate:predicateToRun];
//    if (searchKey.length <2) {
//        
//            [self.query setSearchScopes:@[@"/Applications"]];
//    }
//    else if (searchKey.length ==2)
//    {
//        
//        [self.query setSearchScopes:@[@"/Applications",NSMetadataQueryUserHomeScope]];
//
//    }
//    else{
//            [self.query setSearchScopes:@[NSMetadataQueryLocalComputerScope]];
//
//    }
//    [self.query setSearchScopes:@[@"/Applications"]];

    // In case the query hasn't yet started, start it.
    [self.query startQuery];
}

- (void)setSearchContent:(BOOL)value {
    if (searchContent != value) {
        searchContent = value;
        [self createSearchPredicate];
    }
}

- (BOOL)searchContent {
    return searchContent;
}

- (void)setSearchKey:(NSString *) value {
    if (searchKey != value) {
        searchKey = [value copy];
        [self createSearchPredicate];
    }
}

- (void)setScopePath:(NSArray *) values{
    
    [self.query setSearchScopes:values];
}

- (void)setSearchByKey:(NSString *) key{
//    [self.query stopQuery];
    searchByKey = key;
    [self createSearchPredicate];
}



- (void)setGroupByKey:(NSString *) key {
    if (groupKey != key) {
        groupKey = [key copy];
//        [self.query setSortDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:(id)groupKey ascending:YES] ]];
        [self.query setValueListAttributes:@[groupKey]];
        [self.query setGroupingAttributes:[NSArray arrayWithObjects:(id)groupKey, nil]];
    }
}


- (NSString *)searchKey {
    return searchKey;
}

// Connected via bindings, not target/action
- (void)tableViewDoubleClick:(id)path {
    [[NSWorkspace sharedWorkspace] openFile:path];
}

@end

