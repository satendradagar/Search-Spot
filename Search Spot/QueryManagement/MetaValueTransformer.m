//
//  MetaValueTransformer.m
//  Search Spot
//
//  Created by admin on 03/04/17.
//  Copyright © 2017 Satendra Singh. All rights reserved.
//

#import "MetaValueTransformer.h"


@implementation IsRunningTransformer

+ (Class)transformedValueClass {
    return [NSString class];
}

- (id)transformedValue:(id)value {
    if (value == nil) {
        return nil;
    }
    if (![value respondsToSelector:@selector(integerValue)]) {
        [NSException raise:NSInternalInconsistencyException format:@"Value %@ does not respond to integerValue", [value class]];
    }
    NSInteger val = [value integerValue];
    if (val) {
        return NSLocalizedString(@"Query is alive...", @"String to be shown when the query is alive and maintaining results");
    } else {
        return NSLocalizedString(@"Query is dead...", @"String to be shown when the query is not alive and not maintaining results");
    }
}

@end

@implementation MBTransformer

+ (Class)transformedValueClass {
    return [NSString class];
}

- (id)transformedValue:(id)value {
    if (value == nil) {
        return NSLocalizedString(@"0 Bytes", @"File size shown for 0 byte files");
    }
    if (![value respondsToSelector:@selector(integerValue)]) {
        [NSException raise:NSInternalInconsistencyException format:@"Value %@ does not respond to integerValue", [value class]];
    }
    NSInteger fsSize = [value integerValue];
    // special case for small files
    if (fsSize == 0) {
        return NSLocalizedString(@"0 Bytes", @"File size shown for 0 byte files");
    }
    
    const NSInteger cutOff = 900;
    
    if (fsSize < cutOff) {
        return [NSString stringWithFormat:NSLocalizedString(@"%ld Bytes", @"File size shown formatted as bytes"), (long)fsSize];
    }
    
    double numK = (double)fsSize / 1024;
    if (numK < cutOff) {
        return [NSString stringWithFormat:NSLocalizedString(@"%.2f KB", @"File size shown formatted as kilobytes"), numK];
    }
    
    double numMB = numK / 1024;
    if (numMB < cutOff) {
        return [NSString stringWithFormat:NSLocalizedString(@"%.2f MB", @"File size shown formatted as megabytes"), numMB];
    }
    
    double numGB = numMB / 1024;
    return [NSString stringWithFormat:NSLocalizedString(@"%.2f GB", @"File size shown formatted as gigabytes"), numGB];
}

@end

@implementation MetadataItemIconTransformer

+ (Class)transformedValueClass {
    return [NSImage class];
}

- (id)transformedValue:(id)value {
    if (value == nil) {
        return nil;
    }
    if ([value isMemberOfClass:[NSMetadataItem class]]) {
        NSMetadataItem *item = value;
        NSString *filename = [item valueForAttribute:(id)kMDItemPath];
        return [[NSWorkspace sharedWorkspace] iconForFile:filename];
    } else {
        [NSException raise:NSInvalidArgumentException format:@"Expecting only an NSMetadataitem"];
        return nil;
    }
}

@end

@implementation VersionTransformer

+ (Class)transformedValueClass {
    return [NSString class];
}

- (id)transformedValue:(id)value {
    if (value == nil) {
        return nil;
    }
    if ([value isKindOfClass:[NSString class]]) {
        NSString *versionNumber = (NSString *)value;
        return [NSString stringWithFormat:@"Version %@",versionNumber];
    } else {
        [NSException raise:NSInvalidArgumentException format:@"Expecting only an NSMetadataitem"];
        return nil;
    }
}

@end
