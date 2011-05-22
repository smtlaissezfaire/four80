@protocol ScrollTrackingProtocol <NSObject>

@property (nonatomic) CGPoint scrollViewContentOffset;
@property (nonatomic) BOOL    contentSizeAlreadySet;

#define DEFINE_SCROLL_TRACKING_PROTOCOL_INSTANCE_VARIABLES() \
  CGPoint scrollViewContentOffset;                           \
  BOOL    contentSizeAlreadySet

#define SYNTHESIZE_SCROLL_TRACKING_PROTOCOL_INSTANCE_VARIABLES() \
  @synthesize scrollViewContentOffset;                           \
  @synthesize contentSizeAlreadySet


@end