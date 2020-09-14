//
//  ViewController.m
//  111111
//
//  Created by 张星 on 2020/7/27.
//  Copyright © 2020 artvoi. All rights reserved.
//

#import "ViewController.h"
#import <SceneKit/SceneKit.h>

@interface ViewController ()

{
    BOOL _isRotating;
    SCNVector3 _position;
    SCNVector3 _eularAngle;
    SCNVector3 _position1;
    SCNVector3 _eularAngle1;
}


@property (weak, nonatomic) IBOutlet SCNView *scnView;

@property (nonatomic, strong) SCNNode *earthNode;

@property (nonatomic, strong) SCNAction *rotateAction;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SCNScene *scene = [SCNScene sceneNamed:@"model.scnassets/earth.scn"];
    scene.background.contents = @"bg.png";
    _earthNode = [scene.rootNode childNodeWithName:@"rotate" recursively:YES];
    
    //添加旋转
    [_earthNode runAction:self.rotateAction];
    _isRotating = YES;
    
    _scnView.scene = scene;
    _scnView.showsStatistics = YES;
    
    _position = [_scnView.scene.rootNode childNodeWithName:@"camera" recursively:YES].position;
    _eularAngle = [_scnView.scene.rootNode childNodeWithName:@"camera" recursively:YES].eulerAngles;
    
    _position1 = [_scnView.scene.rootNode childNodeWithName:@"camera1" recursively:YES].position;
    _eularAngle1 = [_scnView.scene.rootNode childNodeWithName:@"camera1" recursively:YES].eulerAngles;
        
}


//点击检测（碰撞检测）
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint tapPoint  = [touch locationInView:_scnView];//该点就是手指的点击位置
    NSDictionary *hitTestOptions = [NSDictionary dictionaryWithObjectsAndKeys:@(true),SCNHitTestOptionSearchMode, nil];
    NSArray<SCNHitTestResult *> * results= [_scnView hitTest:tapPoint options:hitTestOptions];
    for (SCNHitTestResult *res in results) {//遍历所有的返回结果中的node
        if ([res.node.name isEqualToString:@"country"]) {
            NSLog(@"点击了城市---%@", res.node.childNodes.firstObject.name);
            if (_isRotating) {
                [_earthNode removeAllActions];
                SCNNode *camera = [res.node childNodeWithName:@"camera" recursively:YES];
                [SCNTransaction begin];
                [SCNTransaction setAnimationDuration:1];
                [SCNTransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
                _scnView.pointOfView = camera;
                [SCNTransaction commit];
                _isRotating = false;
            }
            break;
        }   else {
            NSLog(@"点击了---%@", res.node.childNodes.firstObject.name);
        }
    }
}


- (IBAction)rotate:(UIButton *)sender {
    if (!_isRotating) {
        [_earthNode runAction:_rotateAction];
        [SCNTransaction begin];
        [SCNTransaction setAnimationDuration:1];
        [SCNTransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        _scnView.pointOfView = [_scnView.scene.rootNode childNodeWithName:@"camera" recursively:YES];
        [SCNTransaction commit];
        _isRotating = true;
    }
}



- (SCNAction *)rotateAction {
    if (!_rotateAction) {
        _rotateAction = [SCNAction repeatActionForever:[SCNAction rotateByX:0 y:0.1 z:0 duration:1]];
    }
    return _rotateAction;
}

@end
