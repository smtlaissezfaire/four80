//
//  FourEighty.m
//  A library of Application Helpers
//
//  Created by Scott Taylor <scott@railsnewbie.com> on 2010 - 2011.
//  Copyright 2010 Scott Taylor / Eastmedia. All rights reserved.
//

#import "FourEighty.h"
#import "Constants.h"
#import <time.h>
#import "NavigationControllerProtocol.h"

@implementation FourEighty

+ (void) setHeightOn: (UIView *) view toView: (UIView *) otherView {
  CGFloat height = UI_VIEW_HEIGHT(otherView);

  [self setHeightTo: &height forView: view];
}

+ (void) setHeightTo: (CGFloat *) height_ptr forView: (UIView *) a_view {
  CGFloat height = *height_ptr;

  CGRect existing_frame = [[a_view layer] frame];
  existing_frame.size.height = height;

  // need to reassign the same frame !?
  NSLog(@"setting text view: %@ to height: %f", a_view, (float) height);
  SET_FRAME_FOR(a_view, existing_frame);
}

+ (void) setTopOf: (UIView *) a_view toView: (UIView *) another_view {
  CGFloat other_view_y = UI_VIEW_COORDINATE_MIN_Y(another_view);

  CGRect existing_frame = [[a_view layer] frame];
  existing_frame.origin.y = other_view_y;
  SET_FRAME_FOR(a_view, existing_frame);
}

+ (void) setTopOf: (UIView *) a_view toCoordinate: (CGFloat *) a_float {
  CGRect existing_frame = [[a_view layer] frame];
  existing_frame.origin.y = *a_float;
  SET_FRAME_FOR(a_view, existing_frame);
}

+ (void) setTopOf: (UIView *) a_view toBottomOfView: (UIView *) another_view {
  CGFloat y_coord = UI_VIEW_COORDINATE_MAX_Y(another_view);
  [self setTopOf: a_view toCoordinate: &y_coord];
}

+ (void) setBottomOf: (UIView *) a_view toBottomOfView: (UIView *) another_view {
  CGFloat y_coord = UI_VIEW_COORDINATE_MAX_Y(another_view) - UI_VIEW_HEIGHT(a_view);
  [self setTopOf: a_view toCoordinate: &y_coord];
}

+ (void) setLeftOf: (UIView *) a_view toView: (UIView *) other_view {
  CGRect frame = [[other_view layer] frame];
  CGFloat coordinate = frame.origin.x;

  [self setLeftOf: a_view toCoordinate: &coordinate];
}

+ (void) setLeftOf: (UIView *) a_view toCoordinate: (CGFloat *) a_float {
  CGRect existing_frame = [[a_view layer] frame];
  existing_frame.origin.x = *a_float;
  SET_FRAME_FOR(a_view, existing_frame);
}

+ (void) place: (UIView *) topView onTopOf: (UIView *) bottomView {
  CGFloat y_coordinate = UI_VIEW_COORDINATE_MIN_Y(bottomView);
  y_coordinate -= UI_VIEW_HEIGHT(topView);

  DLOG("max y: %f", UI_VIEW_COORDINATE_MAX_Y(bottomView));
  DLOG("min y: %f", UI_VIEW_COORDINATE_MIN_Y(bottomView));
  DLOG("y coordinate: %f", y_coordinate);

  [self setTopOf: topView toCoordinate: &y_coordinate];
}

// see http://stackoverflow.com/questions/50467/how-do-i-size-a-uitextview-to-its-content
+ (void) resizeTextView: (UITextView *) view {
  float height = view.contentSize.height;

  [self setHeightTo: &height forView: view];
}

+ (void) resizeWebView: (UIWebView *) webView {
  NSString *js = @"                                                                                               \
    var __html_element = document.getElementsByTagName('html')[0];                                                \
    var __height_string = document.defaultView.getComputedStyle(__html_element, null).getPropertyValue('height'); \
    __height_string.replace('px', ''); \
  ";

  NSString *heightString = [webView stringByEvaluatingJavaScriptFromString: js];
  float height = [heightString floatValue];

  if (height != UI_VIEW_HEIGHT(webView)) {
    [self setHeightTo: &height forView: webView];

    // resize scrollView inside webview to the same height
    UIScrollView *webScroller = [self scrollViewInWebView: webView];
    [self setHeightTo: &height forView: webScroller];
  }
}

+ (UIScrollView *) scrollViewInWebView: (UIWebView *) webView {
  UIScrollView *scrollView;

  for (id subview in webView.subviews) {
    if ([[subview class] isSubclassOfClass: [UIScrollView class]]) {
      scrollView = ((UIScrollView *) subview);
    }
  }

  return scrollView;
}

+ (void) setWhiteBackgroundColorOnWebView: (UIWebView *) webView {
  [self setWebView: webView toBackgroundColor: [UIColor whiteColor]];
}

// http://stackoverflow.com/questions/3009063/remove-gradient-background-from-uiwebview
+ (void) setWebView: (UIWebView *) webView toBackgroundColor: (UIColor *) bgColor {
  webView.backgroundColor = bgColor;

  UIScrollView *scrollView = [self scrollViewInWebView: webView];

  for (UIView* shadowView in [scrollView subviews]) {
    if ([shadowView isKindOfClass: [UIImageView class]]) {
      [shadowView setHidden: YES];
    }
  }
}

// see http://stackoverflow.com/questions/500761/stop-uiwebview-from-bouncing-vertically
+ (void) disableScrollInWebView: (UIWebView *) webView {
  UIScrollView *scrollView = [self scrollViewInWebView: webView];
  scrollView.bounces = NO;
}

+ (void) roundCornersOf: (UIView *) view To: (CGFloat) a_float {
  // without this, the corner radius doesn't get set on webviews
  // see: http://efreedom.com/Question/1-3316424/Add-Corner-Radius-Shadow
  [view.layer setMasksToBounds:YES];
  [view.layer setCornerRadius: a_float];
}

+ (void) pushView: (Class) viewControllerClass
               To: (UIViewController *) target
       showTabBar: (BOOL) show_tab_bar
          perform: (SEL) selector
               on: (id) obj {

  UIViewController *controller = [[viewControllerClass alloc] initWithNibName: nil bundle: nil];

  if (show_tab_bar == YES) {
    controller.hidesBottomBarWhenPushed = NO;
  } else {
    controller.hidesBottomBarWhenPushed = YES;
  }

  DLOG(@"setting hidesBottomBarWhenPushed: %i", controller.hidesBottomBarWhenPushed);

  if ([controller respondsToSelector: @selector(setNavigationController:)]) {
    [(<NavigationControllerProtocol>) controller setNavigationController: [target navigationController]];
  }

  if (obj) {
    [obj performSelector: selector withObject: controller];
  }

  [target.navigationController pushViewController: controller animated: YES];
  [controller release];
}

+ (void) pushView: (Class) viewControllerClass
               To: (UIViewController *) target
       showTabBar: (BOOL) show_tab_bar {

  [self pushView: viewControllerClass To: target showTabBar: show_tab_bar perform: nil on: nil];
}

+ (void) pushView: (Class) viewControllerClass To: (UIViewController *) target {
  [self pushView: viewControllerClass To: target showTabBar: NO];
}

/*
  Traverse the hierarchy of view controllers to find the top parent controller so that we can dismiss
  modals.  From: https://developer.apple.com/library/ios/prerelease/#featuredarticles/ViewControllerPGforiPhoneOS/ModalViewControllers/ModalViewControllers.html

  "Any view controller object can present any other single view controller modally.
  This is true even for view controllers that were themselves presented modally...

  Each view controller in a chain of modally presented view controllers has pointers
  to the other objects surrounding it in the chain. In other words, a modal view
  controller that presents another modal view controller has valid objects in both
  its parentViewController and modalViewController properties. You can use
  these relationships to trace through the chain of view controllers as needed.
  For example, if the user cancels the current operation, you could remove all
  objects in the chain by dismissing the first modally presented view controller."
*/
+ (id) topParentViewControllerFor: (id) current {
  if (current && [current respondsToSelector: @selector(parentViewController)] && [current parentViewController]) {
    return [self topParentViewControllerFor: [current parentViewController]];
  } else {
    return current;
  }
}

+ (NSDate *) parseDate: (NSString *) text {
  return [self parseDate: text withFormat: @"yyyy-MM-dd HH:mm:ss ZZ"];
}

+ (NSString *) convertCStringToNSString: (char *) cString {
  return [NSString stringWithCString: cString encoding: NSASCIIStringEncoding];
}

+ (char *) convertNSStringToCString: (NSString *) string {
  return (char *) [string cStringUsingEncoding: NSASCIIStringEncoding];
}

+ (NSString *) date: (NSDate *) date formattedWithstrftimeString: (NSString *) formattedString {
  time_t time  = [date timeIntervalSince1970];
  struct tm timeStruct;
  char buffer[80];

  localtime_r(&time, &timeStruct);
  strftime(buffer, 80, [self convertNSStringToCString: formattedString], &timeStruct);

  return [self convertCStringToNSString: buffer];
}

+ (NSDate *) parseDate: (NSString *) text withFormat: (NSString *) format {
  NSDate *date;
  NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];

  [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
  [dateFormatter setDateFormat: format];
  date = [dateFormatter dateFromString: text];
  TT_RELEASE_SAFELY(dateFormatter);

  return date;
}

+ (void) keepPaddingOf: (NSArray *) views perform: (SEL) selector on: (id) object {
  NSMutableArray *viewPaddingDifferences = [NSMutableArray arrayWithCapacity: [views count]];
  UIView *view1;
  UIView *view2;
  NSNumber *difference;
  NSNumber *number;
  CGRect frame;
  int i;

  // don't look at the last view, since there are none after that.
  for (i = 0; i < [views count] - 1; i++) {
    view1 = [views objectAtIndex: i];
    view2 = [views objectAtIndex: i+1];

    difference = [NSNumber numberWithFloat: UI_VIEW_COORDINATE_MIN_Y(view2) - UI_VIEW_COORDINATE_MAX_Y(view1)];

    [viewPaddingDifferences addObject: difference];
  }

  DLOG("viewPaddingDifferences: %@", viewPaddingDifferences);
  DLOG(@"calling action block");
  [object performSelector: selector withObject: object];

  // start at the first view, and set the the top Y (min y)
  // to the top of the previous frame + original padding offset
  for (i = 1; i < [views count]; i++) {
    view1 = [views objectAtIndex: i - 1];
    view2 = [views objectAtIndex: i];

    number = [viewPaddingDifferences objectAtIndex: i - 1];

    frame = FRAME_FOR(view2);
    frame.origin.y = UI_VIEW_COORDINATE_MAX_Y(view1) + number.floatValue;

    SET_FRAME_FOR(view2, frame);
  }
}

+ (void) keepContainer: (UIView *) containerView aroundViews: (NSArray *) views perform: (SEL) selector on: (id) object {
  UIView *firstView = ARRAY_FIRST(views);
  UIView *lastView = ARRAY_LAST(views);
  CGFloat topDifference;
  CGFloat bottomDifference;
  CGFloat height;
  CGFloat newCoordinate;

  topDifference    = PADDING_TOP_BETWEEN(containerView, firstView);
  bottomDifference = PADDING_BOTTOM_BETWEEN(lastView, containerView);

  DLOG("top difference: %f", topDifference);
  DLOG("bottom difference: %f", bottomDifference);

  [object performSelector: selector withObject: object];

  // readjust the element to a corresponding coordinate
  newCoordinate = UI_VIEW_COORDINATE_MIN_Y(firstView) - topDifference;
  [self setTopOf: containerView toCoordinate: &newCoordinate];

  // set the height to contain the views + the offsets
  height = topDifference + [[self heightBetween: firstView and: lastView] floatValue] + bottomDifference;
  [self setHeightOn: containerView toFloat: &height];
}

+ (void) stretchContainer: (UIView *) viewContainer aroundView: (UIView *) a_view perform: (SEL) selector on: (id) object {
  [self keepContainer: viewContainer aroundViews: A(a_view, a_view) perform: selector on: object];
}

+ (NSNumber *) heightBetween: (UIView *) view1 and: (UIView *) view2 {
  return [NSNumber numberWithFloat: HEIGHT_BETWEEN(view1, view2)];
}

+ (void) moveFields: (NSArray *) array intoView: (UIView *) view {
  for (id obj in array) {
    [view addSubview: obj];
  }
}

+ (void) setHeightOn: (UIView *) view toFloat: (CGFloat *) a_float {
  CGRect frame = FRAME_FOR(view);
  CGFloat height = *a_float;
  CGFloat width = UI_VIEW_WIDTH(view);

  NSLog(@"Setting view: width: %f, height: %f", width, height);
  frame.size.width = width;
  frame.size.height = height;

  SET_FRAME_FOR(view, frame);
}

+ (void) setScrollHeightOn: (UIScrollView *)scrollView
                     start: (UIView *) startView
                       end: (UIView *) endView {

  CGFloat height = 0;
  [self setScrollHeightOn: scrollView start: startView end: endView padding: &height];
}

+ (void) setScrollHeightOn: (UIScrollView *)scrollView
                     start: (UIView *) startView
                       end: (UIView *) endView
                   padding: (CGFloat *) padding {

  CGFloat width  = UI_VIEW_WIDTH(scrollView);
  CGFloat height = HEIGHT_BETWEEN(startView, endView) + *padding;

  [self setScrollSize: CGSizeMake(width, height) onScrollView: scrollView];
}

+ (void) setScrollHeight: (CGFloat) scrollHeight
            onScrollView: (UIScrollView *) scrollView {
  CGFloat width = UI_VIEW_WIDTH(scrollView);

  [self setScrollSize: CGSizeMake(width, scrollHeight) onScrollView: scrollView];
}

+ (void) setScrollSize: (CGSize) size
          onScrollView: (UIScrollView *) scrollView {

  NSLog(@"Setting scroll view: width: %f, height: %f", size.width, size.height);
  scrollView.contentSize = size;
}

+ (NSString *) filePathForFile: (NSString *) filename ofType: (NSString *) type {
  NSString *filePath = [[NSBundle mainBundle] pathForResource: filename
                                                       ofType: type];
  if (!filePath) {
    [NSException raise: @"FileMissingError"
                 format: @"Couldn't find the file: %@", filename];
  }

  return filePath;
}

+ (NSString *) loadProjectFile: (NSString *) filename ofType: (NSString *) type {
  return [NSString stringWithContentsOfFile: [self filePathForFile: filename ofType: type]
                                   encoding: NSASCIIStringEncoding
                                      error: nil];
}

+ (void) loadWebView: (UIWebView *) webView fromString: (NSString *) string {
  [self loadWebView: webView fromString: string withParameters: nil];
}

+ (void) loadWebView: (UIWebView *) webView fromString: (NSString *) string withParameters: (NSArray *) args {
  NSString *html;

  if (args) {
    html = [self stringWithFormat: string array: args];
  } else {
    html = string;
  }

  NSString *path = [[NSBundle mainBundle] bundlePath];
  NSURL *baseURL = [NSURL fileURLWithPath: path];

  DLOG(@"loading webview with html: %@", html);

  [webView loadHTMLString: html baseURL: baseURL];
}

// Override delegate method webView:shouldStartLoadWithRequest:navigationType: and call this:
//
//    -(BOOL) webView: (UIWebView *) webView
//            shouldStartLoadWithRequest: (NSURLRequest *) request
//            navigationType: (UIWebViewNavigationType) navigationType {
//
//      return [FourEighty launchExternalLinksInSafariForWebView: webView
//                                                   withRequest: request
//                                             andNavigationType: navigationType];
//    }
//
//
// see: http://stackoverflow.com/questions/2532453/force-a-webview-link-to-launch-safari
+ (BOOL) launchExternalLinksInSafariForWebView: (UIWebView *) webView
                                   withRequest: (NSURLRequest *) request
                             andNavigationType: (UIWebViewNavigationType) navigationType {
  NSURL *requestURL = [[request URL] retain];

  if (([[requestURL scheme] isEqualToString: @"http"] ||
       [[requestURL scheme] isEqualToString: @"https"] ||
       [[requestURL scheme] isEqualToString: @"mailto"])
      && ( navigationType == UIWebViewNavigationTypeLinkClicked)) {

    return ![[UIApplication sharedApplication] openURL: [requestURL autorelease]];
  }

  [requestURL release];
  return YES;
}

+ (void) loadWebView: (UIWebView *) webView
             fromUrl: (NSString *) url_string {

  NSURL *url = [NSURL URLWithString: url_string];
  NSURLRequest *request = [NSURLRequest requestWithURL: url];
  [webView loadRequest: request];
}

// see: http://stackoverflow.com/questions/1058736/how-to-create-a-nsstring-from-a-format-string-like-xxx-yyy-and-a-nsarra
+ (NSString *) stringWithFormat: (NSString *) format array: (NSArray *) arguments {
  char *argList = (char *)malloc(sizeof(NSString *) * [arguments count]);
  [arguments getObjects:(id *)argList];
  NSString* result = [[[NSString alloc] initWithFormat:format arguments:argList] autorelease];
  free(argList);
  return result;
}

+ (void) loadWebView: (UIWebView *) webView fromTemplate: (NSString *) template withArguments: (NSArray *) args {
  NSString *template_string = [self loadProjectFile: template ofType: HTML_SUFFIX];
  [self loadWebView: webView fromString: template_string withParameters: args];
}

+ (void) setClearTableViewBackground: (UITableView *) tableView {
  tableView.backgroundColor = [UIColor clearColor];
}

+ (void) popUpScreenForKeyboardWithView: (UIView *) theView usingScrollView: (UIScrollView *) scrollView fromController: (UIViewController <ScrollTrackingProtocol> *) controller {
  CGFloat viewCenterY = theView.center.y;
  CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
  CGFloat availableHeight = applicationFrame.size.height - KEYBOARD_HEIGHT;
  CGFloat y = viewCenterY - availableHeight / 2.0;
  if (y < 0) {
    y = 0;
  }

  CGSize contentSize = scrollView.contentSize;

  controller.scrollViewContentOffset = scrollView.contentOffset;

  if (controller.contentSizeAlreadySet != NO && controller.contentSizeAlreadySet != YES) {
    controller.contentSizeAlreadySet = NO;
  }

  // if the keyboard has already been popped by a previous field,
  // don't add the extra 216 pixels to the scroll
  if (controller.contentSizeAlreadySet == NO) {
    controller.contentSizeAlreadySet = YES;
    contentSize.height = contentSize.height + KEYBOARD_HEIGHT;
  }

  [scrollView setContentOffset: CGPointMake(0, y) animated:YES];
  scrollView.contentSize = contentSize;
}

+ (void) popDownScreenForKeyboardUsingScrollView: (UIScrollView <ScrollTrackingProtocol> *) scrollView fromController: (UIViewController <ScrollTrackingProtocol> *) controller {
  if (controller.contentSizeAlreadySet == YES) {
    CGSize contentSize = scrollView.contentSize;
    contentSize.height = contentSize.height - KEYBOARD_HEIGHT;
    scrollView.contentSize = contentSize;

    controller.contentSizeAlreadySet = NO;
  }

  if (scrollView.contentSize.height - controller.scrollViewContentOffset.y < UI_VIEW_HEIGHT(scrollView)) {
    [scrollView setContentOffset: CGPointZero animated: YES];
  } else {
    [scrollView setContentOffset: controller.scrollViewContentOffset animated: YES];
  }
}

+ (void) disableButton: (UIButton *) button {
  button.enabled = NO;
}

+ (void) enableButton: (UIButton *) button {
  button.enabled = YES;
}

+ (UIViewController *) controllerAtIndex: (int) index withTabBar: (UITabBarController *) tabBar {
  return A_LOOKUP([tabBar viewControllers], index);
}

+ (void) setViewController: (UIViewController *) controller
       forTabBarController: (UITabBarController *) tabBarController
                   atIndex: (int) index
                  animated: (BOOL) animated
                withWindow: (UIWindow *) window {

  NSArray *originalViewControllers   = [tabBarController viewControllers];
  NSMutableArray *newViewControllers = [originalViewControllers mutableCopy];

  [newViewControllers replaceObjectAtIndex: index
                                withObject: controller];

  [tabBarController setViewControllers: [NSArray arrayWithArray: newViewControllers]
                              animated: animated];

  [tabBarController.view removeFromSuperview];
  [window addSubview: tabBarController.view];

  [newViewControllers release];
}

+ (void) setTabBarWithTitle: (NSString *) title
              andImageNamed: (NSString *) image_name
                 atPosition: (int) position
                   onObject: (UIViewController *) object  {

  UITabBarItem *tbi = [[UITabBarItem alloc] initWithTitle: title image: [UIImage imageNamed: image_name] tag: position];
  [object setTabBarItem:tbi];
  [tbi release];
}

// takes an array of arrays, where each subarray has two keys: a name and value,
// and reorders them based on the first key found in the dictionary
// used for rails errors that come in as: [["last_name", "is not valid"], ["first_name", "is not valid"]]
+ (NSMutableArray *) orderArray: (NSArray *) array
                         byKeys: (NSArray *) keys {

  NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity: [array count]];
  NSString *currentKey;

  for (id key in keys) {
    for (id obj in array) {
      currentKey = [obj objectAtIndex: 0];

      if (EQUAL_STRINGS(currentKey, key)) {
        [mutableArray addObject: obj];
      }
    }
  }

  return mutableArray;
}

+ (void) applyMethod: (SEL) selector onObjects: (NSArray *) array {
  for (id obj in array) {
    [obj performSelector: selector];
  }
}

+ (void) unsuspendThreeTwentyQueue {
  [TTURLRequestQueue mainQueue].suspended = NO;
}

+ (UIViewController *) initViewController: (Class) viewControllerClass {
  return [[viewControllerClass alloc] initWithNibName: nil bundle: nil];
}

+ (void) presentModalViewControllerClass: (Class) viewControllerClass animated: (BOOL) animated fromController: (UIViewController *) controller {
  UIViewController *viewController = [self initViewController: viewControllerClass];
  [controller presentModalViewController: viewController animated: animated];
  [viewController release];
}

+ (void) animateAction: (SEL) action onObject: (id) obj duringTime: (CGFloat) time {
  [UIView beginAnimations: nil context: nil];
  [UIView setAnimationDuration: time];

  [obj performSelector: action];

  [UIView commitAnimations];
}


+ (void) flipLeftTo: (UIViewController *) controller
               from: (UINavigationController *) navController
            perform: (SEL) action
                 on: (id) obj {

  [self flipTo: controller
          from: navController
 withAnimation: UIViewAnimationTransitionFlipFromLeft
       perform: action
            on: obj];
}

+ (void) flipRightTo: (UIViewController *) controller
                from: (UINavigationController *) navController
             perform: (SEL) action
                  on: (id) obj {

  [self flipTo: controller
          from: navController
 withAnimation: UIViewAnimationTransitionFlipFromRight
       perform: action
            on: obj];
}


+ (void) flipTo: (UIViewController *) controller
           from: (UINavigationController *) navController
  withAnimation: (UIViewAnimationTransition) animation
        perform: (SEL) action
             on: (id) obj {

  [UIView beginAnimations: @"flipAnimation" context: nil];

  if (obj) {
    [obj performSelector: action withObject: controller];
  }

  [UIView setAnimationDuration: 0.8];
  [UIView setAnimationTransition: animation forView: navController.view cache: NO];
  [UIView commitAnimations];
}

// makes an copy of a view - spitting out a UIImageView
// see http://ga.rbers.net/?p=301 for more info
+ (UIImageView *) copyView: (UIView *) a_view {
  UIGraphicsBeginImageContext(a_view.bounds.size);
  [a_view.layer renderInContext: UIGraphicsGetCurrentContext()];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
  [self setTopOf: imageView toView: a_view];
  [self setLeftOf: imageView toView: a_view];

  return imageView;
}

+ (void) performAsync: (SEL) selector on: (id) object {
  [object performSelector: selector withObject: nil afterDelay: 0];
}

+ (void) performAsync: (SEL) selector before: (SEL) before after: (SEL) after on: (id) object {
  [object performSelector: before];
  [self performAsync: selector on: object];
  [self performAsync: after    on: object];
}

// Collection methods

+ (NSArray *) map: (NSArray *) collection perform: (SEL) action on: (id) object {
  NSMutableArray *newCollection = [NSMutableArray arrayWithCapacity: [collection count]];

  for (id obj in collection) {
    [newCollection addObject: [object performSelector: action withObject: obj]];
  }

  return newCollection;
}

+ (NSArray *) detect: (NSArray *) collection perform: (SEL) action on: (id) target {
  for (id obj in collection) {
    if ([target performSelector: action withObject: obj]) {
      return obj;
    }
  }

  return nil;
}

+ (BOOL) any: (NSArray *) collection {
  for (id _ in collection) {
    return YES;
  }

  return NO;
}

+ (BOOL) any: (NSArray *) collection in: (NSArray *) otherCollection {
  for (id currentObject in collection) {
    for (id otherObject in otherCollection) {
      if ([currentObject isEqual: otherObject]) {
        return YES;
      }
    }
  }

  return NO;
}

+ (NSArray *) select: (NSArray *) collection perform: (SEL) action on: (id) target {
  NSMutableArray *filteredCollection = [NSMutableArray arrayWithCapacity: [collection count]];
  id returnResult;

  for (id obj in collection) {
    returnResult = [target performSelector: action withObject: obj];

    if (!(returnResult == nil || returnResult == NO)) {
      [filteredCollection addObject: obj];
    }
  }

  return filteredCollection;
}

+ (NSArray *) flatten: (NSArray *) collection {
  NSMutableArray *newCollection = [NSMutableArray arrayWithCapacity: [collection count]];

  for (id obj in collection) {
    if ([obj isKindOfClass: [NSArray class]]) {
      for (id collectionObject in [self flatten: obj]) {
        [newCollection addObject: collectionObject];
      }
    } else {
      [newCollection addObject: obj];
    }
  }

  return newCollection;
}

+ (NSArray *) uniq: (NSArray *) collection {
  NSMutableArray *returnArray = [NSMutableArray array];

  for (id obj in collection) {
    if (![returnArray containsObject: obj]) {
      [returnArray addObject: obj];
    }
  }

  return returnArray;
}

+ (NSMutableDictionary *) mergeDictionary: (NSDictionary *) first withDictionary: (NSDictionary *) second {
  NSMutableDictionary *copy = [first mutableCopy];
  [copy addEntriesFromDictionary: second];
  [copy retain];
  return copy;
}


@end
