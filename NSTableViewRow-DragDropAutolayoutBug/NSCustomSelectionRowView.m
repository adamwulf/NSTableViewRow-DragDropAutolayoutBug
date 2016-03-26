//
//  NSCustomSelectionRowView.m
//  NSTableViewRow-DragDropAutolayoutBug
//
//  Created by Adam Wulf on 3/26/16.
//  Copyright © 2016 Milestone Made. All rights reserved.
//

#import "NSCustomSelectionRowView.h"

@implementation NSCustomSelectionRowView

-(NSTableViewSelectionHighlightStyle) selectionHighlightStyle{
    // If this method is commented out, then the selection
    // will revert to default blue during drag instead of our
    // custom red selection drawn below
    return NSTableViewSelectionHighlightStyleNone;
}

- (void)drawSelectionInRect:(NSRect)dirtyRect
{
    [[NSColor redColor] set];
    NSRectFill(dirtyRect);
}

@end
