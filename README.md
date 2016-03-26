## Autolayout bug in NSTableView
This repository provides the following setup:

1. Minimal `NSTableView` delegate/datasource
2. Custom `NSTableRowView` that defines `[drawSelectionInRect:]`
3. `tableView:validateDrop:proposedRow:` that returns `NSDragOperationMove` for `NSTableViewDropOn`

Given this setup, dragging any row in the table to any other row will generate the following warning in the logs:

> Layout still needs update after calling -[NSCustomSelectionRowView layout].  NSCustomSelectionRowView or one of its superclasses may have overridden -layout without calling super. Or, something may have dirtied layout in the middle of updating it.  Both are programming errors in Cocoa Autolayout.  The former is pretty likely to arise if some pre-Cocoa Autolayout class had a method called layout, but it should be fixed.

Note that our custom table row `NSCustomSelectionRowView` doesn't even override the `layout` method. The reason for the dirtied layout seems to be inside of `NSTableView`'s internals when updating the selection of the table row during a drag.

The following StackOverflow issues are related:

1. [http://stackoverflow.com/questions/26815659/nstableview-dragdrop-selected-rows-overrides-row-layout-in-blue](http://stackoverflow.com/questions/30621573/layout-still-needs-update-after-calling-nstablerowview-layout)
2. [http://stackoverflow.com/questions/30621573/layout-still-needs-update-after-calling-nstablerowview-layout](http://stackoverflow.com/questions/30621573/layout-still-needs-update-after-calling-nstablerowview-layout)