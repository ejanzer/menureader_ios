//
//  CMRJSONParser.m
//  Menu Reader
//
//  Created by Emily Janzer on 4/2/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRJSONParser.h"
#import "CMRSection.h"
#import "CMRImage.h"
#import "CMRDish.h"
#import "CMRReview.h"
#import "CMRTag.h"
#import "CMRTranslation.h"
#import "CMRSimilar.h"

@implementation CMRJSONParser


-(NSArray *)parseJSON:(id)jsonObject withImage: (UIImage *)image {
    NSMutableArray *sectionObjects = [[NSMutableArray alloc]init];
    
        
    if (image) {
        CMRImage *imageCell = [[CMRImage alloc] initWithImage:image];
        NSArray *imageCells = [[NSArray alloc] initWithObjects:imageCell, nil];
        
        CMRSection *imageSection = [[CMRSection alloc] initWithCells:imageCells section:@"Search" cellId:@"ImageCell" type:CMRCellTypeImage];
        [sectionObjects addObject:imageSection];
    }
    
    NSArray *dishData = [jsonObject objectForKey:@"dish"];
    if (dishData && dishData != (id)[NSNull null]) {
        NSMutableArray *dishCells = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [dishData count]; i++) {
            NSDictionary *dishDict = [dishData objectAtIndex:i];
            CMRDish *dishCell = [[CMRDish alloc] initWithData:dishDict];
            [dishCells addObject:dishCell];
        }
        
        CMRSection *dishSection = [[CMRSection alloc] initWithCells:dishCells section:@"Dish" cellId:@"DishCell" type:CMRCellTypeDish];
        
        [sectionObjects addObject:dishSection];
    }
    
    NSArray *imageData = [jsonObject objectForKey:@"images"];
    if (imageData && imageData != (id)[NSNull null]) {
        
        // Will it be a problem that this is a mutable array?
        NSMutableArray *imageCells = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [imageData count]; i++) {
            NSDictionary *imageDict = [imageData objectAtIndex:i];
            
            //TODO: I think this is base64 encoded...
            UIImage *image = [[UIImage alloc] initWithData:[imageDict objectForKey:@"data"]];
            CMRImage *imageCell = [[CMRImage alloc] initWithImage:image];
            [imageCells addObject:imageCell];
        }
        CMRSection *dishImageSection = [[CMRSection alloc] initWithCells:imageCells section:@"Images" cellId:@"ImageCell" type:CMRCellTypeImage];
        [sectionObjects addObject:dishImageSection];
    }
    
    NSArray *reviewData = [jsonObject objectForKey:@"reviews"];
    if (reviewData && reviewData != (id)[NSNull null]) {
        
        NSMutableArray *reviewCells = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [reviewData count]; i++) {
            NSDictionary *reviewDict = [reviewData objectAtIndex:i];
            CMRReview *reviewCell = [[CMRReview alloc] initWithData:reviewDict];
            [reviewCells addObject:reviewCell];
        }
        
        CMRSection *reviewSection = [[CMRSection alloc] initWithCells:reviewCells section:@"Reviews" cellId:@"ReviewCell" type:CMRCellTypeReview];
        
        [sectionObjects addObject:reviewSection];
    }
    
    NSArray *tagData = [jsonObject objectForKey:@"tags"];
    if (tagData && tagData != (id)[NSNull null]) {
        
        NSMutableArray *tagCells = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [tagData count]; i++) {
            NSDictionary *tagDict = [tagData objectAtIndex:i];
            CMRTag *tagCell = [[CMRTag alloc] initWithData:tagDict];
            [tagCells addObject:tagCell];
        }
        
        CMRSection *tagSection = [[CMRSection alloc] initWithCells:tagCells section:@"Tags" cellId:@"TagCell" type:CMRCellTypeTag];
        
        [sectionObjects addObject:tagSection];
    
    }

    NSArray *translationData = [jsonObject objectForKey:@"translation"];
    if (translationData && translationData != (id)[NSNull null]) {
        NSMutableArray *translationCells = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [translationData count]; i++) {
            NSDictionary *translationDict = [translationData objectAtIndex:i];
            CMRTranslation *translationCell = [[CMRTranslation alloc] initWithData:translationDict];
            [translationCells addObject:translationCell];
        }
        
        CMRSection *translationSection = [[CMRSection alloc] initWithCells:translationCells section:@"Translation" cellId:@"TranslationCell" type:CMRCellTypeTranslation];
        
        [sectionObjects addObject:translationSection];
    
    }

    NSArray *similarData = [jsonObject objectForKey:@"similar"];
    if (similarData && similarData != (id)[NSNull null]) {
        NSMutableArray *similarCells = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [similarData count]; i++) {
            NSDictionary *similarDict = [similarData objectAtIndex:i];
            CMRSimilar *similarCell = [[CMRSimilar alloc] initWithData:similarDict];
            [similarCells addObject:similarCell];
        }
        
        CMRSection *similarSection = [[CMRSection alloc] initWithCells:similarCells section:@"Similar Dishes" cellId:@"SimilarCell" type:CMRCellTypeSimilar];
        
        [sectionObjects addObject:similarSection];
    
    }

    return sectionObjects;
}


@end
