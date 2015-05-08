//
//  NoteDataFetcher.h
//  Albase
//
//  Created by Mac on 19/11/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import <Foundation/Foundation.h>


@class NoteDataFetcher;

@protocol NoteDataFetcherDelegate <NSObject>

@required

-(void)GetNoteListWithError:(NoteDataFetcher *)DataFatcher
              WithErrorData:(NSError *)DataError;

-(void)GetNoteListWithSuccess:(NoteDataFetcher *)DataFatcher
              WithSuccessdata:(id)Objectcarrier;

@end

@interface NoteDataFetcher : NSObject
{
    __weak id <NoteDataFetcherDelegate> _delegate;
}
@property (nonatomic, weak) id <NoteDataFetcherDelegate> delegate;

-(void)GetNoteList;

@end
