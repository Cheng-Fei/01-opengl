//
//  ViewController.m
//  01-opengl
//
//  Created by CF on 2017/3/24.
//  Copyright © 2017年 CF. All rights reserved.
//

#import "ViewController.h"
#import "CubeViewController.h"



#import <GLKit/GLKit.h>
#import "GLESMath.h"

@interface ViewController () <GLKViewDelegate>
/** context */
//@property (nonatomic, strong) EAGLContext *context;
/** effect */
@property (nonatomic, strong) GLKBaseEffect *baseEffect;
/** <#注释#> */
@property (nonatomic, assign) GLKMatrixStackRef stack;
/** <#注释#> */
@property (nonatomic, assign) GLfloat whatFuck;
/** array */
@property (nonatomic, assign) GLuint count;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    
    // 1. 创建glview
    
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];
    
    GLKView* view = (GLKView *)self.view;
    view.context = context;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    glEnable(GL_DEPTH_TEST);
    
    //GLKView *glView = [[GLKView alloc] initWithFrame:self.view.bounds context:context];
    
    //glView.delegate = self;
    
   // [self.view addSubview:glView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    btn.center = CGPointMake(self.view.center.x, self.view.frame.size.height - 40);
    [btn setTitle:@"cube" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(cubeClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 2. 设置图形
    
    GLfloat verteArray[] = {
    
        0.0, 0.25, 0.0,     1.0, 0.0, 0.0,
        -0.5, -0.35, 0.0,   0.0, 1.0, 0.0,
        0.5, -0.35, 0.0,    0.0, 0.0, 1.0,
        0.0, 0.0, 0.5,      1.0, 1.0, 0.0
    
    };
    
    GLuint vboArray[] = {
      
        0,2,1,
        3,2,1,
        3,0,1,
        3,2,0
        
        
    };
    
    self.count = sizeof(vboArray) / sizeof(GLuint);
    
    // 缓存顶点数组
    GLuint buffer;
    glGenBuffers(1, &buffer);
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(verteArray), verteArray, GL_STATIC_DRAW);
    
    GLuint VBO;
    glGenBuffers(1, &VBO);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, VBO);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(vboArray), vboArray, GL_STATIC_DRAW);

   
    // 3. 设置着色
    
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    
    self.stack = GLKMatrixStackCreate(kCFAllocatorDefault);
    
    GLKMatrixStackLoadMatrix4(self.stack, self.baseEffect.transform.modelviewMatrix);
    
    self.baseEffect.transform.modelviewMatrix = GLKMatrixStackGetMatrix4(self.stack);
    
    
}


- (void)draw{
    
    
    //self.baseEffect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(0, 0, 0.3);
    
    
    GLKMatrixStackPush(self.stack);
    
    GLKMatrixStackTranslate(self.stack, -0.5, 0.5, 0);
    
    GLKMatrixStackRotate(self.stack, GLKMathDegreesToRadians(self.whatFuck), 0,1, 0);
    
    self.baseEffect.transform.modelviewMatrix = GLKMatrixStackGetMatrix4(self.stack);
    
    [self.baseEffect prepareToDraw];
    
    glDrawElements(GL_TRIANGLES,self.count , GL_UNSIGNED_INT, 0);
    
    GLKMatrixStackPop(self.stack);
    
    
}


- (void)drawOther{
    
    
    //self.baseEffect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(0, 0, 0.3);
    
    
    GLKMatrixStackPush(self.stack);
    
    GLKMatrixStackTranslate(self.stack, 0.5, -0.2, 0);
    
    GLKMatrixStackScale(self.stack, -0.5, -0.5, 0);
    
    GLKMatrixStackRotate(self.stack, GLKMathDegreesToRadians(self.whatFuck), 0, 1, 0);
    
    self.baseEffect.transform.modelviewMatrix = GLKMatrixStackGetMatrix4(self.stack);
    
    [self.baseEffect prepareToDraw];
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
    GLKMatrixStackPop(self.stack);
    
    
}

-(void)update
{
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    
    glClearColor(0, 0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    self.whatFuck += 360.0 / 60;
    
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(GLfloat), (GLfloat *)NULL + 0);
    
    
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(GLfloat), (GLfloat *)NULL + 3);
    
    
    [self draw];
    [self drawOther];
    
}


#pragma mark - cubeClick
- (void)cubeClick
{
    CubeViewController * cube = [[CubeViewController alloc] init];
    
    [self presentViewController:cube animated:YES completion:nil];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
