//
//  SUTheme.h
//  PixelHunter
//
//  Created by Alex Saenko on 12/10/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUPixelHunterTheme.h"
#import "SUPixelHunterColorProvider.h"


@interface SUPixelHunterTheme ()

@property (nonatomic, strong, readonly) SUPixelHunterColorProvider *colors;

@end


@implementation SUPixelHunterTheme;

#pragma mark - Singleton stuff

static SUPixelHunterTheme *_sharedTheme = nil;

+ (SUPixelHunterTheme *)sharedTheme
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
	    _sharedTheme = [[SUPixelHunterTheme alloc] init];
        [_sharedTheme performSelector:@selector(setColors:) withObject:[[SUPixelHunterColorProvider alloc] init]];
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

+ (SUPixelHunterColorProvider *)colors
{
    return [SUPixelHunterTheme sharedTheme].colors;
}

#pragma mark - Private

- (void)setColors:(SUPixelHunterColorProvider *)colors
{
    _colors = colors;
}

@end
