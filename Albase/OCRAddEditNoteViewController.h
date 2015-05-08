//
//  OCRAddEditNoteViewController.h
//  Albase
//
//  Created by Mac on 27/10/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCRGlobalMethods.h"

@class OCRAddEditNoteViewController;

typedef enum {
  NoteWritingStatusNil,
  NoteWritingStatusNewNote,
  NoteWritingStatusEditNote
} NoteWritingStatus;

@protocol OCRAddEditNoteViewControllerDelegate <NSObject>

@optional
- (void)HandleDataObject:(OCRAddEditNoteViewController *)myObj ObjectCarrier:(id)ObjectCarrier;
@end

@interface OCRAddEditNoteViewController : OCRGlobalMethods
{
    __weak id <OCRAddEditNoteViewControllerDelegate> _delegate;
}
@property (nonatomic, weak) id <OCRAddEditNoteViewControllerDelegate> delegate;
@property (assign) NoteWritingStatus UserNoteWritingStatus;
@property (assign) id ObjectCarrier;
@end
