
#pragma mark Objective C Helpers
////////////////////////////////
#define AS(A,B) \
  [(A) stringByAppendingString:(B)]
#define A(obj, objs...) \
  [NSArray arrayWithObjects:obj, ## objs , nil]
#define D(val, key, vals...) \
  [NSDictionary dictionaryWithObjectsAndKeys: val, key, ## vals , nil]
#define MD(val, key, vals...) \
  [NSMutableDictionary dictionaryWithObjectsAndKeys: val, key, ## vals , nil]
#define D_LOOKUP(obj, key) \
  [obj objectForKey: key]
#define A_LOOKUP(obj, index) \
  [(obj) objectAtIndex: (index)]

#define OBJECT_TO_STRING(obj)     [NSString stringWithFormat: @"%@", (obj)]

#define STRING_TO_SELECTOR(str)   NSSelectorFromString(str)

#define DEALLOC_AND_NIL(obj)      \
 if ((obj)) {                     \
   [(obj) release]; obj = nil;    \
 }

#define ARRAY_FIRST(array)        [(array) objectAtIndex: 0];
#define ARRAY_LAST(array)         [(array) objectAtIndex: [(array) count] - 1]

#define MERGE_DICTIONARIES(dict1, dict2) \
  [FourEighty mergeDictionary: dict1 withDictionary: dict2]


#define NEGATE(an_int)            ((an_int == 0) ? 1 : 0)
#define EMPTY_STRING(field)       ([(field) length] == 0 ? YES : NO)
#define BLANK_STRING(field)       (field && !EMPTY_STRING((field)) ? NO : YES)

#define EQUAL_STRINGS(s1, s2)             (([(s1) compare: (s2)] == NSOrderedSame) ? YES : NO)
#define NIL_AS_INT                        -1
#define BOOL_OR_NIL_VALUE_TO_INT(obj)     ([(obj) class] == [NSNull class] ? NIL_AS_INT : [(obj) intValue])

#define INT_TO_BOOL(num)                  ((num) == 1 ? YES : NO)
#define NEGATE_INT(num)                   ((num) == 1 ? 0 : 1)
#define NEGATE_BOOL(true_or_false)        ((true_or_false) ? NO : YES)

#define EMPTY_DICTIONARY(dict)            ([[(dict) allKeys] count] == 0 ? YES : NO)

#define TRUTHY(obj)                       ((obj) && [obj class] != [NSNull class] ? YES : NO)

#pragma mark UIViewHelpers
//////////////////////////
#define RETINA()                             ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2 ? YES : NO)
#define LAYER_FOR(ui)                        [(ui) layer]
#define FRAME_FOR(ui)                        [LAYER_FOR((ui)) frame]
#define SET_FRAME_FOR(ui, frame)             [LAYER_FOR((ui)) setFrame: (frame)]
#define UI_VIEW_WIDTH(ui)                    FRAME_FOR(ui).size.width
#define UI_VIEW_HEIGHT(ui)                   CGRectGetHeight(FRAME_FOR(ui))
#define UI_VIEW_COORDINATE_MIN_X(ui)         CGRectGetMinX(FRAME_FOR(ui))
#define UI_VIEW_COORDINATE_MIN_Y(ui)         CGRectGetMinY(FRAME_FOR(ui))
#define UI_VIEW_COORDINATE_MAX_X(ui)         CGRectGetMaxX(FRAME_FOR(ui))
#define UI_VIEW_COORDINATE_MAX_Y(ui)         CGRectGetMaxY(FRAME_FOR(ui))
#define HEIGHT_BETWEEN(view1, view2)         UI_VIEW_COORDINATE_MAX_Y((view2)) - UI_VIEW_COORDINATE_MIN_Y((view1))

#define PADDING_TOP_BETWEEN(view1, view2)    UI_VIEW_COORDINATE_MIN_Y((view2)) - UI_VIEW_COORDINATE_MIN_Y((view1))
#define PADDING_BOTTOM_BETWEEN(view1, view2) UI_VIEW_COORDINATE_MAX_Y((view2)) - UI_VIEW_COORDINATE_MAX_Y((view1))

#define SET_BUTTON_TITLE(obj, title)         [obj setTitle: (title) forState: UIControlStateNormal];            \
                                             [obj setTitle: (title) forState: UIControlStateHighlighted];       \
                                             [obj setTitle: (title) forState: UIControlStateDisabled];          \
                                             [obj setTitle: (title) forState: UIControlStateSelected];          \
                                             [obj setTitle: (title) forState: UIControlStateApplication];       \
                                             [obj setTitle: (title) forState: UIControlStateReserved]


#define SHOW_STATUS_BAR()                    [UIApplication sharedApplication].statusBarHidden = NO;
#define HIDE_STATUS_BAR()                    [UIApplication sharedApplication].statusBarHidden = YES;

#pragma mark Geometry
/////////////////////
#define STATUS_BAR_HEIGHT                  20
#define DEVICE_WIDTH                       320
#define DEVICE_WIDTH_WITH_STATUS_BAR       480
#define DEVICE_HEIGHT                      (DEVICE_WIDTH_WITH_STATUS_BAR - STATUS_BAR_HEIGHT)
#define TITLE_BAR_HEIGHT                   44
#define TITLE_BAR_PADDING_HEIGHT           5
#define TAB_BAR_HEIGHT                     49
#define KEYBOARD_HEIGHT                    216

#pragma mark File Suffixes
#define STYLE_SHEET_SUFFIX            @"css"
#define HTML_SUFFIX                   @"html"
