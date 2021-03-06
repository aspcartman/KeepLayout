//
//  NSArray+KeepLayout.m
//  Keep Layout
//
//  Created by Martin Kiss on 23.6.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import "NSArray+KeepLayout.h"
#import "KeepAttribute.h"
#import "View+KeepLayout.h"





@implementation NSArray (KeepLayout)





#pragma mark General


- (BOOL)keep_onlyContainsUIViews {
    for (KIT_VIEW_CLASS *view in self) {
        if ( ! [view isKindOfClass:[KIT_VIEW_CLASS class]]) {
            return NO;
        }
    }
    return YES;
}


- (KeepGroupAttribute *)keep_groupAttributeForSelector:(SEL)selector {
    KeepAssert([self keep_onlyContainsUIViews], @"%@ can only be called on array of KIT_VIEW_CLASS objects", NSStringFromSelector(selector));
    
    return [[KeepGroupAttribute alloc] initWithAttributes:[self valueForKeyPath:NSStringFromSelector(selector)]];
}


- (KeepGroupAttribute *)keep_groupAttributeForSelector:(SEL)selector relatedView:(KIT_VIEW_CLASS *)relatedView {
    KeepAssert([self keep_onlyContainsUIViews], @"%@ can only be called on array of KIT_VIEW_CLASS objects", NSStringFromSelector(selector));
    
    NSMutableArray *builder = [[NSMutableArray alloc] initWithCapacity:self.count];
    for (KIT_VIEW_CLASS *view in self) {
        KeepAttribute *(^block)(KIT_VIEW_CLASS *) = [view valueForKeyPath:NSStringFromSelector(selector)];
        [builder addObject:block(relatedView)];
    }
    return [[KeepGroupAttribute alloc] initWithAttributes:builder];
}


- (void)keep_invoke:(SEL)selector each:(void(^)(KIT_VIEW_CLASS *view))block {
    KeepAssert([self keep_onlyContainsUIViews], @"%@ can only be called on array of KIT_VIEW_CLASS objects", NSStringFromSelector(selector));
    
    for (KIT_VIEW_CLASS *view in self) {
        block(view);
    }
}


- (void)keep_invoke:(SEL)selector eachTwo:(void(^)(KIT_VIEW_CLASS *this, KIT_VIEW_CLASS *next))block {
    KeepAssert([self keep_onlyContainsUIViews], @"%@ can only be called on array of KIT_VIEW_CLASS objects", NSStringFromSelector(selector));
    
    if (self.count < 2) return;
    
    for (NSUInteger index = 0; index < self.count - 1; index++) {
        KIT_VIEW_CLASS *this = [self objectAtIndex:index];
        KIT_VIEW_CLASS *next = [self objectAtIndex:index + 1];
        block(this, next);
    }
}





#pragma mark Dimensions


- (KeepAttribute *)keepWidth {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepHeight {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepSize {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (void)keepSize:(CGSize)size {
    [self keep_invoke:_cmd each:^(KIT_VIEW_CLASS *view) {
        [view keepSize:size];
    }];
}


- (void)keepSize:(CGSize)size priority:(KeepPriority)priority {
    [self keep_invoke:_cmd each:^(KIT_VIEW_CLASS *view) {
        [view keepSize:size priority:priority];
    }];
}


- (KeepAttribute *)keepAspectRatio {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepRelatedAttributeBlock)keepWidthTo {
    return ^KeepAttribute *(KIT_VIEW_CLASS *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepRelatedAttributeBlock)keepHeightTo {
    return ^KeepAttribute *(KIT_VIEW_CLASS *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepRelatedAttributeBlock)keepSizeTo {
    return ^KeepAttribute *(KIT_VIEW_CLASS *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (void)keepWidthsEqualWithPriority:(KeepPriority)priority {
    [self keep_invoke:_cmd eachTwo:^(KIT_VIEW_CLASS *this, KIT_VIEW_CLASS *next) {
        this.keepWidthTo(next).equal = KeepValueMake(1, priority);
    }];
}


- (void)keepHeightsEqualWithPriority:(KeepPriority)priority {
    [self keep_invoke:_cmd eachTwo:^(KIT_VIEW_CLASS *this, KIT_VIEW_CLASS *next) {
        this.keepHeightTo(next).equal = KeepValueMake(1, priority);
    }];
}


- (void)keepSizesEqualWithPriority:(KeepPriority)priority {
    [self keep_invoke:_cmd eachTwo:^(KIT_VIEW_CLASS *this, KIT_VIEW_CLASS *next) {
        this.keepSizeTo(next).equal = KeepValueMake(1, priority);
    }];
}


- (void)keepWidthsEqual {
    [self keepWidthsEqualWithPriority:KeepPriorityRequired];
}


- (void)keepHeightsEqual {
    [self keepHeightsEqualWithPriority:KeepPriorityRequired];
}


- (void)keepSizesEqual {
    [self keepSizesEqualWithPriority:KeepPriorityRequired];
}





#pragma mark Superview Insets


- (KeepAttribute *)keepLeftInset {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepRightInset {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepTopInset {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepBottomInset {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepInsets {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepHorizontalInsets {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepVerticalInsets {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (void)keepInsets:(KIT_VIEW_EDGE_INSETS)insets priority:(KeepPriority)priority {
    [self keep_invoke:_cmd each:^(KIT_VIEW_CLASS *view) {
        [view keepInsets:insets priority:priority];
    }];
}


- (void)keepInsets:(KIT_VIEW_EDGE_INSETS)insets {
    [self keepInsets:insets priority:KeepPriorityRequired];
}





#pragma mark Center

- (KeepAttribute *)keepHorizontalCenter {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepVerticalCenter {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepCenter {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (void)keepCenteredWithPriority:(KeepPriority)priority {
    [self keep_invoke:_cmd each:^(KIT_VIEW_CLASS *view) {
        [view keepCenteredWithPriority:priority];
    }];
}


- (void)keepHorizontallyCenteredWithPriority:(KeepPriority)priority {
    [self keep_invoke:_cmd each:^(KIT_VIEW_CLASS *view) {
        [view keepHorizontallyCenteredWithPriority:priority];
    }];
}


- (void)keepVerticallyCenteredWithPriority:(KeepPriority)priority {
    [self keep_invoke:_cmd each:^(KIT_VIEW_CLASS *view) {
        [view keepVerticallyCenteredWithPriority:priority];
    }];
}


- (void)keepCenter:(CGPoint)center priority:(KeepPriority)priority {
    [self keep_invoke:_cmd each:^(KIT_VIEW_CLASS *view) {
        [view keepCenter:center priority:priority];
    }];
}


- (void)keepCentered {
    [self keepCenteredWithPriority:KeepPriorityRequired];
}


- (void)keepHorizontallyCentered {
    [self keepHorizontallyCenteredWithPriority:KeepPriorityRequired];
}


- (void)keepVerticallyCentered {
    [self keepVerticallyCenteredWithPriority:KeepPriorityRequired];
}


- (void)keepCenter:(CGPoint)center {
    [self keepCenter:center priority:KeepPriorityRequired];
}





#pragma mark Offsets


- (KeepRelatedAttributeBlock)keepLeftOffset {
    return ^KeepAttribute *(KIT_VIEW_CLASS *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepRelatedAttributeBlock)keepRightOffset {
    return ^KeepAttribute *(KIT_VIEW_CLASS *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepRelatedAttributeBlock)keepTopOffset {
    return ^KeepAttribute *(KIT_VIEW_CLASS *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepRelatedAttributeBlock)keepBottomOffset {
    return ^KeepAttribute *(KIT_VIEW_CLASS *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (void)keepHorizontalOffsets:(KeepValue)value {
    [self keep_invoke:_cmd eachTwo:^(KIT_VIEW_CLASS *this, KIT_VIEW_CLASS *next) {
        this.keepRightOffsetTo(next).equal = value;
    }];
}


- (void)keepVerticalOffsets:(KeepValue)value {
    [self keep_invoke:_cmd eachTwo:^(KIT_VIEW_CLASS *this, KIT_VIEW_CLASS *next) {
        this.keepBottomOffsetTo(next).equal = value;
    }];
}





#pragma mark Alignments


- (KeepRelatedAttributeBlock)keepLeftAlignTo {
    return ^KeepAttribute *(KIT_VIEW_CLASS *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepRelatedAttributeBlock)keepRightAlignTo {
    return ^KeepAttribute *(KIT_VIEW_CLASS *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepRelatedAttributeBlock)keepTopAlignTo {
    return ^KeepAttribute *(KIT_VIEW_CLASS *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepRelatedAttributeBlock)keepBottomAlignTo {
    return ^KeepAttribute *(KIT_VIEW_CLASS *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepRelatedAttributeBlock)keepVerticalAlignTo {
    return ^KeepAttribute *(KIT_VIEW_CLASS *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepRelatedAttributeBlock)keepHorizontalAlignTo {
    return ^KeepAttribute *(KIT_VIEW_CLASS *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepRelatedAttributeBlock)keepBaselineAlignTo {
    return ^KeepAttribute *(KIT_VIEW_CLASS *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (void)keep_alignedSelector:(SEL)selector invokeSelector:(SEL)invokeSelector value:(KeepValue)value {
    [self keep_invoke:selector eachTwo:^(KIT_VIEW_CLASS *this, KIT_VIEW_CLASS *next) {
        KeepAttribute *(^block)(KIT_VIEW_CLASS *) = [this valueForKey:NSStringFromSelector(invokeSelector)];
        KeepAttribute *attribute = block(next);
        attribute.equal = value;
    }];
}


- (void)keepLeftAlignments:(KeepValue)value {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepLeftAlignTo) value:value];
}


- (void)keepRightAlignments:(KeepValue)value {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepRightAlignTo) value:value];
}


- (void)keepTopAlignments:(KeepValue)value {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepTopAlignTo) value:value];
}


- (void)keepBottomAlignments:(KeepValue)value {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepBottomAlignTo) value:value];
}


- (void)keepVerticalAlignments:(KeepValue)value {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepVerticalAlignTo) value:value];
}


- (void)keepHorizontalAlignments:(KeepValue)value {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepHorizontalAlignTo) value:value];
}


- (void)keepBaselineAlignments:(KeepValue)value {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepBaselineAlignTo) value:value];
}


- (void)keepLeftAligned {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepLeftAlignTo) value:KeepRequired(0)];
}


- (void)keepRightAligned {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepRightAlignTo) value:KeepRequired(0)];
}


- (void)keepTopAligned {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepTopAlignTo) value:KeepRequired(0)];
}


- (void)keepBottomAligned {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepBottomAlignTo) value:KeepRequired(0)];
}


- (void)keepVerticallyAligned {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepVerticalAlignTo) value:KeepRequired(0)];
}


- (void)keepHorizontallyAligned {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepHorizontalAlignTo) value:KeepRequired(0)];
}


- (void)keepBaselineAligned {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepBaselineAlignTo) value:KeepRequired(0)];
}





@end
