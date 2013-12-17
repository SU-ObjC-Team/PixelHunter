//
//  SUTheme.h
//  PixelHunter
//
//  Created by Alex Saenko on 12/10/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUTheme.h"
#import "SUColorProvider.h"


@interface SUTheme ()

@property (nonatomic, strong, readonly) SUColorProvider *colors;

@end


@implementation SUTheme;

#pragma mark - Singleton stuff

static SUTheme *_sharedTheme = nil;

+ (SUTheme *)sharedTheme
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
	    _sharedTheme = [[SUTheme alloc] init];
        [_sharedTheme performSelector:@selector(setColors:) withObject:[[SUColorProvider alloc] init]];
	});
    
	return _sharedTheme;
}

+ (id)allocWithZone:(NSZone *)zone
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
	    _sharedTheme = nil;
	    _sharedTheme = [super allocWithZone:zone];
	});
    
	return _sharedTheme;
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

#pragma mark - Public

+ (SUColorProvider *)colors
{
    return [SUTheme sharedTheme].colors;
}

#pragma mark - Private

- (void)setColors:(SUColorProvider *)colors
{
    _colors = colors;
}

@end
