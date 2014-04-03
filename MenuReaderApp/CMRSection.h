//
//  CMRSection.h
//  Menu Reader
//
//  Created by Emily Janzer on 4/2/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMRSection : NSObject

typedef NS_ENUM(NSInteger, CMRCellType) {
    CMRCellTypeImage,
    CMRCellTypeDish,
    CMRCellTypeReview,
    CMRCellTypeTag,
    CMRCellTypeTranslation,
    CMRCellTypeSimilar
};

@property CMRCellType type;

@property (copy, readonly) NSString *cellIdentifier;
@property (copy, readonly) NSString *sectionTitle;
@property (copy, readonly) NSArray *cells;

-(instancetype)initWithCells:(NSArray *)data section:(NSString *)sectionTitle cellId:(NSString *)cellIdentifier type:(CMRCellType)cellType;

-(NSInteger)getNumberOfRows;

-(NSObject *)cellForRow:(NSUInteger)row;

@end
