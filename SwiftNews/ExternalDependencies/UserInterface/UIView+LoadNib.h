@import UIKit;

@interface UIView (LoadNib)

/**
    @description This method will take a nibName and return the first
                 UIView instance it finds in the loaded nib. It's useful
                 for loading static table cells or custom UIView objects
                 whose interface is defined in a .xib file.
    @param nibName The name of the .xib file excluding the .xib extension
    @return A UIView instance initialized from a .xib file
 */
+ (UIView *)loadViewFromNibName:(NSString *)nibName;

@end
