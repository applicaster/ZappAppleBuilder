#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "FlipperReactPerformancePlugin.h"

FOUNDATION_EXPORT double flipper_plugin_react_native_performanceVersionNumber;
FOUNDATION_EXPORT const unsigned char flipper_plugin_react_native_performanceVersionString[];

