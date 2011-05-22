//
//  FourEighty.h
//  A library of Application Helpers
//
//  Created by Scott Taylor <scott@railsnewbie.com> on 2010 - 2011.
//  Copyright 2010 Scott Taylor / Eastmedia. All rights reserved.
//

#import "FourEightyConstants.h"
#import <Foundation/Foundation.h>
#import "ScrollTrackingProtocol.h"

@interface FourEighty : NSObject {}

+ (void) setHeightOn: (UIView *) view toView: (UIView *) otherView;
+ (void) setHeightTo: (CGFloat *) height_ptr forView: (UIView *) a_view;
+ (void) setTopOf: (UIView *) a_view toView: (UIView *) another_view;
+ (void) setTopOf: (UIView *) a_view toCoordinate: (CGFloat *) a_float;
+ (void) setTopOf: (UIView *) a_view toBottomOfView: (UIView *) another_view;
+ (void) setBottomOf: (UIView *) a_view toBottomOfView: (UIView *) another_view;
+ (void) setLeftOf: (UIView *) a_view toView: (UIView *) other_view;
+ (void) setLeftOf: (UIView *) a_view toCoordinate: (CGFloat *) a_float;
+ (void) place: (UIView *) topView onTopOf: (UIView *) bottomView;
+ (void) resizeTextView: (UITextView *) view;
+ (void) resizeWebView: (UIWebView *) webView;
+ (void) roundCornersOf: (UIView *) view To: (CGFloat) a_float;

+ (void) pushView: (Class) viewControllerClass
               To: (UIViewController *) target
       showTabBar: (BOOL) show_tab_bar
          perform: (SEL) selector
               on: (id) obj;
+ (void) pushView: (Class) viewControllerClass
               To: (UIViewController *) target
       showTabBar: (BOOL) show_tab_bar;
+ (void) pushView: (Class) viewControllerClass To: (UIViewController *) target;

+ (id) topParentViewControllerFor: (id) current;
+ (NSDate *) parseDate: (NSString *) text;
+ (NSDate *) parseDate: (NSString *) text withFormat: (NSString *) format;

+ (NSString *) convertCStringToNSString: (char *) cString;
+ (char *) convertNSStringToCString: (NSString *) string;
+ (NSString *) date: (NSDate *) date formattedWithstrftimeString: (NSString *) formattedString;

+ (void) keepPaddingOf: (NSArray *) views perform: (SEL) selector on: (id) object;
+ (void) keepContainer: (UIView *) containerView aroundViews: (NSArray *) views perform: (SEL) selector on: (id) object;
+ (NSNumber *) heightBetween: (UIView *) view1 and: (UIView *) view2;
+ (void) moveFields: (NSArray *) array intoView: (UIView *) view;
+ (void) setHeightOn: (UIView *) view toFloat: (CGFloat *) a_float;

+ (void) setScrollHeightOn: (UIScrollView *)scrollView start: (UIView *) startView end: (UIView *) endView;
+ (void) setScrollHeightOn: (UIScrollView *)scrollView
                     start: (UIView *) startView
                       end: (UIView *) endView
                   padding: (CGFloat *) padding;
+ (void) setScrollHeight: (CGFloat) scrollHeight
            onScrollView: (UIScrollView *) scrollView;
+ (void) setScrollSize: (CGSize) size
          onScrollView: (UIScrollView *) scrollView;

+ (NSString *) filePathForFile: (NSString *) filename ofType: (NSString *) type;
+ (NSString *) loadProjectFile: (NSString *) filename ofType: (NSString *) type;
+ (void) loadWebView: (UIWebView *) webView fromString: (NSString *) string;
+ (void) loadWebView: (UIWebView *) webView fromString: (NSString *) string withParameters: (NSArray *) args;
+ (NSString *) stringWithFormat: (NSString *) format array: (NSArray *) arguments;

+ (void) loadWebView: (UIWebView *) webView fromTemplate: (NSString *) template withArguments: (NSArray *) args;
+ (void) loadWebView: (UIWebView *) webView fromUrl: (NSString *) url_string;

+ (void) setClearTableViewBackground: (UITableView *) tableView;

+ (void) popUpScreenForKeyboardWithView: (UIView *) theView usingScrollView: (UIScrollView *) scrollView fromController: (UIViewController <ScrollTrackingProtocol> *) controller;
+ (void) popDownScreenForKeyboardUsingScrollView: (UIScrollView <ScrollTrackingProtocol> *) scrollView fromController: (UIViewController <ScrollTrackingProtocol> *) controller;

+ (void) stretchContainer: (UIView *) viewContainer aroundView: (UIView *) a_view perform: (SEL) selector on: (id) object;

+ (void) disableButton: (UIButton *) button;
+ (void) enableButton: (UIButton *) button;

+ (void) setTabBarWithTitle: (NSString *) title
              andImageNamed: (NSString *) image_name
                 atPosition: (int) position
                   onObject: (UIViewController *) object;

+ (BOOL) launchExternalLinksInSafariForWebView: (UIWebView *) webView
                                   withRequest: (NSURLRequest *) request
                             andNavigationType: (UIWebViewNavigationType) navigationType;

+ (NSMutableArray *) orderArray: (NSArray *) array
                         byKeys: (NSArray *) keys;


+ (void) applyMethod: (SEL) selector onObjects: (NSArray *) array;
+ (void) unsuspendThreeTwentyQueue;
+ (UIViewController *) initViewController: (Class) viewControllerClass;
+ (void) presentModalViewControllerClass: (Class) viewControllerClass animated: (BOOL) animated fromController: (UIViewController *) controller;
+ (void) animateAction: (SEL) action onObject: (id) obj duringTime: (CGFloat) time;

+ (void) flipLeftTo: (UIViewController *) controller
               from: (UINavigationController *) navController
            perform: (SEL) action
                 on: (id) obj;
+ (void) flipRightTo: (UIViewController *) controller
                from: (UINavigationController *) navController
             perform: (SEL) action
                  on: (id) obj;
+ (void) flipTo: (UIViewController *) controller
           from: (UINavigationController *) navController
  withAnimation: (UIViewAnimationTransition) animation
        perform: (SEL) action
             on: (id) obj;

+ (UIScrollView *) scrollViewInWebView: (UIWebView *) webView;
+ (void) setWhiteBackgroundColorOnWebView: (UIWebView *) webView;
+ (void) setWebView: (UIWebView *) webView toBackgroundColor: (UIColor *) bgColor;
+ (void) disableScrollInWebView: (UIWebView *) webView;
+ (UIImageView *) copyView: (UIView *) a_view;

+ (void) performAsync: (SEL) selector before: (SEL) before after: (SEL) after on: (id) object;
+ (void) performAsync: (SEL) selector on: (id) object;

// Collection Methods

+ (NSArray *) map: (NSArray *) collection perform: (SEL) action on: (id) object;
+ (NSArray *) detect: (NSArray *) collection perform: (SEL) action on: (id) target;
+ (BOOL) any: (NSArray *) collection;
+ (BOOL) any: (NSArray *) collection in: (NSArray *) otherCollection;
+ (NSArray *) select: (NSArray *) collection perform: (SEL) action on: (id) target;
+ (NSArray *) flatten: (NSArray *) collection;
+ (NSArray *) uniq: (NSArray *) collection;
+ (NSMutableDictionary *) mergeDictionary: (NSDictionary *) first withDictionary: (NSDictionary *) second;

@end
