//
//  HelloWorldLayer.h
//  testBackground
//
//  Created by  on 12-3-26.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    float lastScale;
    CGPoint lastPosition;
    CCSprite* backGround;
    CGSize size;
    CGRect allowRect;
    
    float _beganLength;
    float _currentLength;
}
// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(CGRect) rectOfPositionAllow;
- (CGPoint)convertToGL:(CGPoint)location;

@end
