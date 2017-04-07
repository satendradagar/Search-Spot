//
//  SearchResultItemCell.m
//  Search Spot
//
//  Created by admin on 04/04/17.
//  Copyright © 2017 Satendra Singh. All rights reserved.
//

#import "SearchResultItemCell.h"

@interface SearchResultItemCell ()
{
}

@property (weak) IBOutlet NSImageView *iconView;

@property (nonatomic,assign) IBOutlet NSTextField *itemTitle;
@property (nonatomic,assign) IBOutlet NSTextField *sizeLabel;
@property (nonatomic,assign) IBOutlet NSTextField *pathLabel;

@end

@implementation SearchResultItemCell

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void) setHighlightState:(NSCollectionViewItemHighlightState)highlightState{
    switch (highlightState) {
            
        case NSCollectionViewItemHighlightForSelection:
        {
            
        }
            break;
            
        case NSCollectionViewItemHighlightNone:
        {
            
        }
            break;
     
        default:
            break;
    }
}

-(void)configureWithMeta:(NSMetadataItem *)item{
    self.itemObject = item;
//    _itemTitle.stringValue = [self.itemObject valueForAttribute:(NSString *)kMDItemFSName];

}

-(void)prepareForReuse{
    self.customSelection = NO;
    [super prepareForReuse];
}
@end
