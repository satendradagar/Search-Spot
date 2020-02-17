//
//  ResultListCollectionController.h
//  Search Spot
//
//  Created by admin on 04/04/17.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//

@class SearchScopeController;

#import <Cocoa/Cocoa.h>
#import "QueryManager.h"

@interface ResultListCollectionController : NSViewController

@property (nonatomic, weak) IBOutlet SearchScopeController *scopeController;

@property (nonatomic,retain) QueryManager *queryManager;

- (void)rearrangeWithGroupBy:(NSString *) key;

-(void)searchScopeForLocation:(NSArray *)locations;

-(void)searchStartForKeyword:(NSString *)keyword;

- (void)setSearchByKey:(NSString *) key;

- (void)setSearchByKeys:(NSArray *) keys;

-(IBAction)showPreferences:(id)sender;

@end
