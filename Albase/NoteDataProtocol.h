//
//  NoteDataProtocol.h
//  Albase
//
//  Created by Mac on 20/11/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NoteDataProtocol;

@protocol NoteDataProtocolDelegate <NSObject>

@required

-(void)SaveNoteDataIntoDataBase:(NoteDataProtocol *)DataProtocol WithSuccess:(id)NoteObject;
-(void)SaveNoteDataIntoDataBase:(NoteDataProtocol *)DataProtocol WithError:(NSError *)ErrorData;

@end

@interface NoteDataProtocol : NSObject
{
    __weak id <NoteDataProtocolDelegate> _delegate;
}
@property (nonatomic,weak) id <NoteDataProtocolDelegate> delegate;

-(void)SaveNoteDataIntoLocaldatabase;
-(void)EditNoteInLocalDatabase;
-(void)DeleteNoteFromLocalDataBase;
@end
