#import "ProcessingOperation.h"
#import "Task.h"
#import "GlobalStaticData.h"


@implementation ProcessingOperation

- (void)finishWithError:(NSError*)error
{		
	if (error == nil) {
        
		Task* task = [[Task alloc] initWithData:self.recievedData];
		if ([task isActive]) {
			NSLog(@"%@",[GlobalStringData ScannerWaitingMessage]);
			[self performSelector:@selector(start) withObject:nil afterDelay:1];
			return;
		}
	}
	[super finishWithError:error];
}

@end
