#import <UIKit/UIKit.h>
#import "OCRGlobalMethods.h"
#import "SimpleCam.h"

@interface ImageViewController : OCRGlobalMethods <SimpleCamDelegate,UIActionSheetDelegate>

- (IBAction)Recognize:(id)sender;
@end
