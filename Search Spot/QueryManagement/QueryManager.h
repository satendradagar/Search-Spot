//
//  QueryManager.h
//  Search Spot
//
//  Created by admin on 03/04/17.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    QueryDidStartGathering,
    QueryDidFinishGathering,
    QueryGatheringProgress,
    QueryDidUpdateGathering,
} NSMetadataQueryChangeType;

typedef void(^QueryResultChange)(NSMetadataQueryChangeType changeType);

@interface QueryManager : NSObject <NSMetadataQueryDelegate>
{

}



// Through the miracle of bindings, by exposing the query in the controller, we can bind to anything in the query with expressions such as "query.results". The NSArrayController in the nib file named "AllResults" binds to the query results in this matter.
@property(retain) NSMetadataQuery *query;

// Expose searchKey so that the NSTextField for searching can easily be typed into and update the query as needed
//@property(copy) NSString *searchKey;
- (void)setSearchKey:(NSString *) value;

- (void)setScopePath:(NSArray *) values;

- (void)setGroupByKey:(NSString *) key;

- (void)setSearchByKey:(NSString *) key;

- (void)setSearchByKeys:(NSArray *) keys;

- (void)setSortResultInOrder :(BOOL) isAscending;

//@property BOOL searchContent;
- (void)setSearchContent:(BOOL)value;

@property (nonatomic, copy) QueryResultChange resultChangeBlock;

@end
