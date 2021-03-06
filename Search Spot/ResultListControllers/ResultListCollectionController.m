//
//  ResultListCollectionController.m
//  Search Spot
//
//  Created by admin on 04/04/17.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//

#import "ResultListCollectionController.h"
#import "SearchResultItemCell.h"
#import "QueryManager.h"
#import "ResultGroupHeader.h"
#import "SearchResultItemCell.h"
#import "ItemDetailsController.h"
#import "SearchScopeController.h"
#import "PreferencesWindowController.h"

#define SearchResultCellId @"SearchResultItemCell"
#define SearchHeaderId @"ResultGroupHeader"

@interface ResultListCollectionController()<NSSplitViewDelegate>
{
//   __block QueryManager *queryManager;
    NSIndexPath *lastSelectedPath;
    PreferencesWindowController *prefWindowController;
}

@property (nonatomic,assign) IBOutlet NSTextField *bottomMessageFiled;

@property (nonatomic,assign) IBOutlet NSCollectionView *resultsList;

@property (nonatomic,assign) IBOutlet NSView *rightPaneView;

@property (nonatomic,assign) IBOutlet ItemDetailsController *detailController;

@property (nonatomic,assign) IBOutlet NSMenu *arrangeBy;

@end

@interface ResultListCollectionController(CollectionHandler)< NSCollectionViewDataSource,NSCollectionViewDelegateFlowLayout>

@end

@implementation ResultListCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupQueryResultManager];

    _resultsList.delegate = self;
    [_resultsList reloadData];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear{
    [super viewDidAppear];
//    [[[NSApplication sharedApplication] mainWindow] performSelector:@selector(makeFirstResponder:) withObject:_searchFiled afterDelay:0.5];

    
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

-(QueryManager *)queryManager{
    return _queryManager;
}

-(void)setupQueryResultManager{
    _queryManager = [[QueryManager alloc] init];
//    [queryManager setSearchContent:YES];
    __weak __typeof(self)weakSelf = self;
    [_queryManager setResultChangeBlock:^(NSMetadataQueryChangeType changeType){
//        NSLog(@"Results:\n%@",[queryManager.query.results valueForKey:kMDItemFSName]);
        NSLog(@"changeType: %lu",(unsigned long)changeType);

        switch (changeType) {
            case QueryDidStartGathering:
            {
//                [weakSelf.resultsList reloadData];

                
                
            }
                break;
            case QueryDidFinishGathering:
            {
//                [weakSelf.queryManager.query disableUpdates];

                [weakSelf refreshViewWithNewItemData];
//                [weakSelf.queryManager.query enableUpdates];

            }
                break;
                
            case QueryGatheringProgress:
            {
                
            }
                break;
                
            case QueryDidUpdateGathering:
            {
//                [weakSelf.queryManager.query disableUpdates];
                [weakSelf refreshViewWithNewItemData];
//                [weakSelf.queryManager.query enableUpdates];

            }
                break;
                
            default:
                break;
        }
        
    }];
}

-(void)searchStartForKeyword:(NSString *)keyword{

    [_queryManager.query enableUpdates];
    [_queryManager setSearchKey:keyword];
    
}

-(void)searchScopeForLocation:(NSArray *)locations{

    [_queryManager setScopePath:locations];

}


- (void)rearrangeWithGroupBy:(NSString *) key{
    
    [_queryManager setGroupByKey:key];
    
}

- (void)setSearchByKey:(NSString *) key{

    [_queryManager setSearchByKey:key];
}

- (void)setSearchByKeys:(NSArray *) keys{
    
    [_queryManager setSearchByKeys:keys];
    
}

-(void) refreshViewWithNewItemData{

//    [_detailController previewItemDetailsForItem:nil];

    [self.resultsList reloadData];
//    [self collectionView:_resultsList didSelectItemsAtIndexPaths:[NSSet setWithObject:path]];
    [self performSelector:@selector(selectFirstObject) withObject:nil afterDelay:0.5];
}

-(void)selectFirstObject{
    
    if (_queryManager.query.results.count) {
        NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:0];
        [self collectionView:_resultsList didSelectItemsAtIndexPaths:[NSSet setWithObject:path]];
        [self.resultsList selectItemsAtIndexPaths:[NSSet setWithObject:path] scrollPosition:NSCollectionViewScrollPositionNone];
        self.bottomMessageFiled.stringValue = [NSString stringWithFormat:@"Showing results for %lu items in %lu  Categories", [self queryManager].query.results.count,[self queryManager].query.groupedResults.count];

    }
    else{
        self.bottomMessageFiled.stringValue = @"";
   
    }
 

}


-(IBAction)showPreferences:(id)sender{
    NSStoryboard *storyBoard = [NSStoryboard storyboardWithName:@"Main" bundle:nil]; // get a reference to the storyboard
    prefWindowController = [storyBoard instantiateControllerWithIdentifier:@"prefWindowController"]; // instantiate your window controller
    [prefWindowController setContent:self.scopeController.cutomUrls];
    [prefWindowController showWindow:self]; // show the window
    
}


@end


@implementation ResultListCollectionController(CollectionHandler)


/* Asks the data source for the number of items in the specified section.
 */
- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSMetadataQueryResultGroup *group = _queryManager.query.groupedResults[section];
    
    return group.results.count;
}

/* Asks the data source to provide an NSCollectionViewItem for the specified represented object.
 
 Your implementation of this method is responsible for creating, configuring, and returning the appropriate item for the given represented object.  You do this by sending -makeItemWithIdentifier:forIndexPath: method to the collection view and passing the identifier that corresponds to the item type you want.  Upon receiving the item, you should set any properties that correspond to the data of the corresponding model object, perform any additional needed configuration, and return the item.
 
 You do not need to set the location of the item's view inside the collection view’s bounds. The collection view sets the location of each item automatically using the layout attributes provided by its layout object.
 
 This method must always return a valid item instance.
 */
- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchResultItemCell *item = (SearchResultItemCell *)[collectionView makeItemWithIdentifier:SearchResultCellId forIndexPath:indexPath];
    NSMetadataQueryResultGroup *group = _queryManager.query.groupedResults[indexPath.section];
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
    
    NSInteger count = _queryManager.query.groupedResults.count;
    return count;
}

- (NSView *)collectionView:(NSCollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:NSCollectionElementKindSectionHeader]) {
        
        NSMetadataQueryResultGroup *group = _queryManager.query.groupedResults[indexPath.section];
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
        
        NSMetadataQueryResultGroup *group = _queryManager.query.groupedResults[path.section];
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
