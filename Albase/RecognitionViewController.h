#import <UIKit/UIKit.h>
#import "Client.h"
#import "OCRAppDelegate.h"

@interface RecognitionViewController : UIViewController<ClientDelegate,NSXMLParserDelegate>
{    
    NSXMLParser *parser;
    NSMutableString *element;
    
    
    OCRAppDelegate *appdelegate;
}

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *statusIndicator;

@property (nonatomic, retain) NSMutableString *curElem;

- (RecognitionViewController*) initXMLParser;
@end
