//
//  ViewController.m
//  01-opengl
//
//  Created by CF on 2017/3/24.
//  Copyright © 2017年 CF. All rights reserved.
//

#import "ViewController.h"
#import <GLKit/GLKit.h>
#import 

@interface ViewController () <GLKViewDelegate>
/** context */
//@property (nonatomic, strong) EAGLContext *context;
/** effect */
@property (nonatomic, strong) GLKBaseEffect *effect;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    // 1. 创建glview
    
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];
    
    GLKView *glView = [[GLKView alloc] initWithFrame:self.view.bounds context:context];
    
    glView.delegate = self;
    
    [self.view addSubview:glView];
    
    
    // 2. 设置图形
    
    const GLfloat verteArray[] = {
    
        0.0, 0.5, 1.0,    //
        -1.0, -0.35, 0.0,
        1.0, -0.35, 0.0
    
    
    };
    
    
    
    GLuint buffer;
    glGenBuffers(1, &buffer);
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(verteArray), verteArray, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GLfloat), 0);

    glRotatef(M_PI, 0, 0, 1);
    // 3. 设置纹理
    
    
    
    
    self.effect = [[GLKBaseEffect alloc] init];
    self.effect.useConstantColor = GL_TRUE;
    self.effect.constantColor = GLKVector4Make(0.0, 1.0, 0.0, 1.0);
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    
    [self.effect prepareToDraw];
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
