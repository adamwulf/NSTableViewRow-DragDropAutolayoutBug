//
//  AppDelegate.m
//  NSTableViewRow-DragDropAutolayoutBug
//
//  Created by Adam Wulf on 3/26/16.
//  Copyright © 2016 Milestone Made. All rights reserved.
//

#import "AppDelegate.h"
#import "NSCustomSelectionRowView.h"

@interface AppDelegate ()<NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTableView *tableView;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[self tableView] registerForDraggedTypes:[NSArray arrayWithObject:NSStringPboardType]];
}

#pragma mark - NSTableViewDelegate

-(NSTableRowView*) tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row{
    NSCustomSelectionRowView *result = [tableView makeViewWithIdentifier:@"NSCustomSelectionRowView" owner:self];
    
    return result;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTableCellView *result = [tableView makeViewWithIdentifier:@"NSTableCellView" owner:self];
    
    result.textField.stringValue = [self tableView:tableView objectValueForTableColumn:tableColumn row:row];
    
    return result;
}


#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return 100;
}

- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    return [NSString stringWithFormat:@"Table Row %ld", row];
}

- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard{
    NSMutableArray *pasteboardItems = [NSMutableArray array];
    [rowIndexes enumerateIndexesUsingBlock:^(NSUInteger rowIndex, BOOL *_Nonnull stop) {
        NSPasteboardItem *pasteboardItem = [[NSPasteboardItem alloc] init];
        
        [pasteboardItem setPropertyList:@{ @"foo" : @"bar" } forType:@"public.text"];
        [pasteboardItem setString:[NSString stringWithFormat:@"Row %ld", rowIndex] forType:NSPasteboardTypeString];

        [pasteboardItems addObject:pasteboardItem];
    }];
    
    if ([pasteboardItems count]) {
        [pboard writeObjects:pasteboardItems];
    }

    return [pasteboardItems count] > 0;
}

- (NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation{
    if(dropOperation == NSTableViewDropOn){
        return NSDragOperationMove;
    }
    return NSDragOperationNone;
}

- (BOOL)tableView:(NSTableView *)tableView acceptDrop:(id <NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)dropOperation{
    return YES;
}




@end
