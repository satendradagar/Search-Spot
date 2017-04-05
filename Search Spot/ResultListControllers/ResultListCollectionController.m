//
//  ResultListCollectionController.m
//  Search Spot
//
//  Created by admin on 04/04/17.
//  Copyright © 2017 Satendra Singh. All rights reserved.
//

#import "ResultListCollectionController.h"
#import "SearchResultItemCell.h"
#import "QueryManager.h"
#import "ResultGroupHeader.h"
#import "SearchResultItemCell.h"

#define SearchResultCellId @"SearchResultItemCell"
#define SearchHeaderId @"ResultGroupHeader"

@interface ResultListCollectionController()<NSSearchFieldDelegate>
{
    QueryManager *queryManager;
}

@property (nonatomic,assign) IBOutlet NSSearchField *searchFiled;

@property (nonatomic,assign) IBOutlet NSCollectionView *resultsList;

@end

@interface ResultListCollectionController(CollectionHandler)< NSCollectionViewDataSource,NSCollectionViewDelegateFlowLayout>

@end

@implementation ResultListCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupQueryResultManager];
    _searchFiled.delegate = self;
//    SearchResultItemCell

    _resultsList.dataSource = self;
    _resultsList.delegate = self;
    [_resultsList reloadData];
    // Do any additional setup after loading the view.
}

-(void)registerReusableNibs{
    NSNib *cellNib = [[NSNib alloc] initWithNibNamed:SearchResultCellId bundle:nil];
    [_resultsList registerNib:cellNib forItemWithIdentifier:SearchResultCellId];
    NSNib *headerNib = [[NSNib alloc] initWithNibNamed:SearchHeaderId bundle:nil];
    [_resultsList registerNib:headerNib forSupplementaryViewOfKind:NSCollectionElementKindSectionHeader withIdentifier:SearchHeaderId];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}

- (void)searchFieldDidStartSearching:(NSSearchField *)sender {
    
    NSLog(@"searchFieldDidStartSearching: %@",_searchFiled.stringValue);
}

- (void)searchFieldDidEndSearching:(NSSearchField *)sender {
    
    NSLog(@"searchFieldDidEndSearching: %@",_searchFiled.stringValue);
    
}

- (void)controlTextDidChange:(NSNotification *)obj{
    NSLog(@"controlTextDidChange: %@",_searchFiled.stringValue);
    [self searchStartForKeyword:_searchFiled.stringValue];
//    [_resultsList reloadData];

    //    NSUInteger resultCode=[[NSWorkspace sharedWorkspace] showSearchResultsForQueryString:_searchFiled.stringValue];
    
    //    if (resultCode == NO) {
    //        // failed to open the panel
    //        // present an error to the user
    //    }
}


-(void)setupQueryResultManager{
    queryManager = [[QueryManager alloc] init];
//    [queryManager setSearchContent:YES];
    __weak __typeof(self)weakSelf = self;
    [queryManager setResultChangeBlock:^(NSMetadataQueryChangeType changeType){
//        NSLog(@"Results:\n%@",[queryManager.query.results valueForKey:kMDItemFSName]);
        switch (changeType) {
            case QueryDidStartGathering:
            {
                [weakSelf.resultsList reloadData];

                
            }
                break;
            case QueryDidFinishGathering:
            {
                [weakSelf.resultsList reloadData];
            }
                break;
                
            case QueryGatheringProgress:
            {
                
            }
                break;
                
            case QueryDidUpdateGathering:
            {
                [weakSelf.resultsList reloadData];

            }
                break;
                
            default:
                break;
        }
        
    }];
}

-(void)searchStartForKeyword:(NSString *)keyword{

    [queryManager setSearchKey:keyword];
    
}

@end


@implementation ResultListCollectionController(CollectionHandler)


/* Asks the data source for the number of items in the specified section.
 */
- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSMetadataQueryResultGroup *group = queryManager.query.groupedResults[section];
    
    return group.results.count;
}

/* Asks the data source to provide an NSCollectionViewItem for the specified represented object.
 
 Your implementation of this method is responsible for creating, configuring, and returning the appropriate item for the given represented object.  You do this by sending -makeItemWithIdentifier:forIndexPath: method to the collection view and passing the identifier that corresponds to the item type you want.  Upon receiving the item, you should set any properties that correspond to the data of the corresponding model object, perform any additional needed configuration, and return the item.
 
 You do not need to set the location of the item's view inside the collection view’s bounds. The collection view sets the location of each item automatically using the layout attributes provided by its layout object.
 
 This method must always return a valid item instance.
 */
- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchResultItemCell *item = (SearchResultItemCell *)[collectionView makeItemWithIdentifier:SearchResultCellId forIndexPath:indexPath];
    NSMetadataQueryResultGroup *group = queryManager.query.groupedResults[indexPath.section];
    [item configureWithMeta:group.results[indexPath.item]];
    return item;
}


/* Asks the data source for the number of sections in the collection view.
 
 If you do not implement this method, the collection view assumes it has only one section.
 */
- (NSInteger)numberOfSectionsInCollectionView:(NSCollectionView *)collectionView {
    
    NSInteger count = queryManager.query.groupedResults.count;
    return count;
}

- (NSView *)collectionView:(NSCollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:NSCollectionElementKindSectionHeader]) {
        
        NSMetadataQueryResultGroup *group = queryManager.query.groupedResults[indexPath.section];
        ResultGroupHeader *item = (ResultGroupHeader *)[collectionView makeSupplementaryViewOfKind:kind withIdentifier:SearchHeaderId forIndexPath:indexPath];
        [item configureWithGroup:group];
        return item;

    }
    return nil;
}
- (NSSize)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return NSMakeSize(collectionView.bounds.size.width, 60);
}

- (NSSize)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return NSMakeSize(collectionView.bounds.size.width, 20);

}


@end
