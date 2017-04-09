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
#import "ItemDetailsController.h"

#define SearchResultCellId @"SearchResultItemCell"
#define SearchHeaderId @"ResultGroupHeader"

@interface ResultListCollectionController()<NSSearchFieldDelegate, NSSplitViewDelegate>
{
   __block QueryManager *queryManager;
        NSIndexPath *lastSelectedPath;
}

@property (nonatomic,assign) IBOutlet NSSearchField *searchFiled;

@property (nonatomic,assign) IBOutlet NSTextField *bottomMessageFiled;

@property (nonatomic,assign) IBOutlet NSCollectionView *resultsList;

@property (nonatomic,assign) IBOutlet NSView *rightPaneView;

@property (nonatomic,assign) IBOutlet ItemDetailsController *detailController;

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

-(void)viewDidAppear{
    [super viewDidAppear];
    [[[NSApplication sharedApplication] mainWindow] performSelector:@selector(makeFirstResponder:) withObject:_searchFiled afterDelay:0.5];

    
}

-(void)viewDidLayout{
    [super viewDidLayout];
    [_resultsList.collectionViewLayout invalidateLayout];
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex{
    if (0 == dividerIndex) {
        return 200.0;
    }
    else
    {
        return 250.0;//Not used so far. only one divider
    }
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex{
    if (0 == dividerIndex) {
        return self.view.bounds.size.width - 250.0;
    }
    else
    {
        return 250.0;//Not used so far, only one divider
    }
}

- (void)splitViewDidResizeSubviews:(NSNotification *)notification{
    [_resultsList.collectionViewLayout invalidateLayout];

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

    //    NSUInteger resultCodedae=[[NSWorkspace sharedWorkspace] showSearchResultsForQueryString:_searchFiled.stringValue];
    
    //    if (resultCode == NO) {
    //        // failed to open the panel
    //        // present an error to the user
    //    }
}

-(QueryManager *)queryManager{
    return queryManager;
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
//                [weakSelf.resultsList reloadData];

                
            }
                break;
            case QueryDidFinishGathering:
            {
                [weakSelf refreshViewWithNewItemData];
            }
                break;
                
            case QueryGatheringProgress:
            {
                
            }
                break;
                
            case QueryDidUpdateGathering:
            {
                [weakSelf refreshViewWithNewItemData];
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

-(void) refreshViewWithNewItemData{

//    [_detailController previewItemDetailsForItem:nil];

    [self.resultsList reloadData];
//    [self collectionView:_resultsList didSelectItemsAtIndexPaths:[NSSet setWithObject:path]];
    [self performSelector:@selector(selectFirstObject) withObject:nil afterDelay:0.5];
}

-(void)selectFirstObject{
    
    if (queryManager.query.results.count) {
        NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:0];
        [self collectionView:_resultsList didSelectItemsAtIndexPaths:[NSSet setWithObject:path]];
        self.bottomMessageFiled.stringValue = [NSString stringWithFormat:@"Showing results for %lu items in %lu  Categories", [self queryManager].query.results.count,[self queryManager].query.groupedResults.count];

    }
    else{
        self.bottomMessageFiled.stringValue = @"";
   
    }
 

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
    if ([lastSelectedPath isEqual:indexPath]) {
        item.customSelection = YES;
    }
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


- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {

    if (1 == indexPaths.count) {
        
        NSIndexPath *path = [[indexPaths allObjects] firstObject];
        SearchResultItemCell *viewItem = (SearchResultItemCell *)[collectionView itemAtIndexPath:path];
        viewItem.customSelection = YES;
        lastSelectedPath = path;
        
        NSMetadataQueryResultGroup *group = queryManager.query.groupedResults[path.section];
        NSMetadataItem *item = group.results[path.item];
        [_detailController previewItemDetailsForItem:item];

    }
//
}

- (void)collectionView:(NSCollectionView *)collectionView didDeselectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    
    if (1 == indexPaths.count) {
        NSIndexPath *path = [[indexPaths allObjects] firstObject];
//        NSMetadataQueryResultGroup *group = queryManager.query.groupedResults[path.section];
        //            NSMetadataItem *item = group.results[path.item];
        SearchResultItemCell *viewItem = (SearchResultItemCell *)[collectionView itemAtIndexPath:path];
        viewItem.customSelection = NO;
        lastSelectedPath = nil;
        [_detailController previewItemDetailsForItem:nil];

    }
}


@end
