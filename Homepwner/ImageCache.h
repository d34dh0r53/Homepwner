//
//  ImageCache.h
//  Homepwner
//
//  Created by Dave Wilde on 6/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ImageCache : NSObject {
    
    NSMutableDictionary *dictionary;
    
}

+ (ImageCache *)sharedImageCache;
- (void)setImage:(UIImage *)i forKey:(NSString *)s;
- (UIImage *)imageForKey:(NSString *)s;
- (void)deleteImageForKey:(NSString *)s;

@end
