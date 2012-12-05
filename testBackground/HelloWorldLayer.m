//
//  HelloWorldLayer.m
//  testBackground
//
//  Created by  on 12-3-26.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


#import "HelloWorldLayer.h"

@implementation HelloWorldLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	[scene addChild: layer];
	
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
		
        lastScale = 1.f;	
        
        UIPinchGestureRecognizer *gestureRecognizer = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchFrom:)] autorelease];	
        [[[CCDirector sharedDirector] openGLView] addGestureRecognizer:gestureRecognizer];
        
        UIPanGestureRecognizer *gestureRecognizer1 = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)] autorelease];
        [[[CCDirector sharedDirector] openGLView] addGestureRecognizer:gestureRecognizer1];

        backGround = [CCSprite spriteWithFile:@"ground.jpg"];
        
		size = [[CCDirector sharedDirector] winSize];
	
        self.anchorPoint = CGPointZero;
		self.position =  CGPointZero;
        backGround.position = ccp( size.width /2 , size.height/2 );
		
		[self addChild: backGround];
        
//        self.isTouchEnabled = YES;
 
	}
	return self;
}

- (void) dealloc
{
	
	[super dealloc];
}

-(CGRect) rectOfPositionAllow
{
    CGRect theRect;
    theRect.origin.x = size.width - self.boundingBox.size.width;
    theRect.origin.y = size.height - self.boundingBox.size.height;
    theRect.size.width = abs(size.width - self.boundingBox.size.width);
    theRect.size.height = abs(size.height - self.boundingBox.size.height);
    return theRect;
}


-(void) handlePinchFrom:(UIPinchGestureRecognizer*)recognizer
{
    CGPoint onePoint = [recognizer locationOfTouch:0 inView:recognizer.view];
    CGPoint anotherPoint = [recognizer locationOfTouch:1 inView:recognizer.view];
    
    _currentLength = ccpDistance(onePoint, anotherPoint);
    
    if([recognizer state] == UIGestureRecognizerStateBegan)
    {	
        lastScale = self.scale;
        _beganLength = _currentLength;
    }
    
    CCLOG(@"recognizerScale:%f, touch Point calculate:%f",recognizer.scale,_currentLength/_beganLength);
    
    float nowScale;
    nowScale = (lastScale - 1) + _currentLength/_beganLength;//recognizer.scale;
//    CGPoint location = [self convertToGL:[recognizer locationInView:recognizer.view]];
    CGPoint location = [self convertToGL:[recognizer locationInView:recognizer.view]];
    CCLOG(@"location:%f,%f",location.x,location.y);
    
    
    
    nowScale = MIN(nowScale,2);
    nowScale = MAX(nowScale,1);  
   
    allowRect = [self rectOfPositionAllow];
    
    if (lastScale > nowScale)
    {
        
        CGPoint newPosition =  ccpSub(self.position, ccpMult ( ccpNormalize(self.position) ,ccpLength(self.position) *(lastScale - nowScale)/(lastScale - 1))) ;
        if (CGRectContainsPoint(allowRect, newPosition))
        {
            CCLOG(@"containsPoint");
            self.position = newPosition;
        }
    }
    self.scale = nowScale;
    CCLOG(@"scale:%f--%f,%f,%f,%f",self.scale,self.position.x,self.position.y,ccpNormalize(self.position).x,ccpNormalize(self.position).y);
}

- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer
{
    CGPoint location = [self convertToGL:[recognizer locationInView:recognizer.view]];
    CCLOG(@"location:%f,%f",location.x,location.y);
    if (recognizer.state == UIGestureRecognizerStateBegan) 
    {   
        lastPosition = self.position;
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) 
    { 
        
        CGPoint translation = [recognizer translationInView:recognizer.view];
        translation = ccp(translation.x, -translation.y);
        translation = ccpMult(translation, 0.7f);
        CGPoint newPos = ccpAdd(lastPosition, translation);
        if (CGRectContainsPoint(allowRect, newPos))
        {
            self.position = newPos;
        }     
        
    }  
}

//屏幕坐标转化成GL坐标
- (CGPoint)convertToGL:(CGPoint)location {
	location = [[CCDirector sharedDirector]convertToGL:location];
	location = ccpSub(location, self.position);
	location = ccpMult(location, 1/self.scale);
	return location;
}

#pragma mark TouchMehtod
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CCLOG(@"count:%i",[touches count]);
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{

}




@end
