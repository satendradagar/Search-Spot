//
//  ItemDetailsController.m
//  Search Spot
//
//  Created by admin on 07/04/17.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//

#import "ItemDetailsController.h"
#import <QuickLook/QuickLook.h>
#import <Quartz/Quartz.h>
#import "MetaLookObject.h"

@interface ItemDetailsController ()
{
    __weak QLPreviewView *quickView;
}
@property (weak) IBOutlet NSView *previewView;
@property (weak) IBOutlet NSView *metaInfoView;
@property (weak) IBOutlet NSBox *veritcalLine;

@property (nonatomic, strong) NSMetadataItem *itemObject;;


@end

@implementation ItemDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_veritcalLine setFillColor:[NSColor colorWithCalibratedRed:0 green:0 blue:0 alpha:0.5]];
    _veritcalLine.transparent = YES;
//    QLPreviewView *preview = [[QLPreviewView alloc] initWithFrame:self.view.bounds style:QLPreviewViewStyleNormal];
//    [self.view addSubview:preview];
//    quickView = preview;
    // Do view setup here.
}

-(void)awakeFromNib{
    [super awakeFromNib];
    QLPreviewView *preview = [[QLPreviewView alloc] initWithFrame:self.view.bounds style:QLPreviewViewStyleNormal];
    [_previewView addSubview:preview];
    quickView = preview;
//    quickView.autostarts = YES;
    [ItemDetailsController addAutoresizingConstraintsToChild:preview withParent:_previewView];
}

-(void)previewItemDetailsForItem:(NSMetadataItem *)item{
    MetaLookObject *obj = [MetaLookObject lookObjectWithMeta:item];
    [quickView setPreviewItem:obj];
    [quickView refreshPreviewItem];
    self.itemObject = item;
//    [quickView setPreviewItem:(id<QLPreviewItem>)]
}

+(void)addAutoresizingConstraintsToChild:(NSView *)childView withParent:(NSView *)parentView{
    
    childView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [parentView addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];
    [parentView addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f]];
    [parentView addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f]];
    [parentView addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
    
}

@end
