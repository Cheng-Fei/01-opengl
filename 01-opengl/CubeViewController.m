//
//  CubeViewController.m
//  01-opengl
//
//  Created by CF on 2017/3/26.
//  Copyright © 2017年 CF. All rights reserved.
//

#import "CubeViewController.h"

@interface CubeViewController ()

@property (nonatomic,assign) GLuint count;
/** effect */
@property (nonatomic, strong) GLKBaseEffect *baseEffect;

/** angle */
@property (nonatomic, assign) GLuint angle;

@end

@implementation CubeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // 1. 创建glcontext
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    GLKView *view = (GLKView *)self.view;
    view.context = context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [EAGLContext setCurrentContext:context];
    
    glEnable(GL_DEPTH_TEST);
    
    // 2. 创建顶点，纹理
    
    GLfloat vao[] = {
      
        0.5,    0.5,    -0.5,       1.0, 0.0, 0.0,      1.0, 0.0,//0
        -0.5,   0.5,    -0.5,       0.0, 1.0, 0.0,      0.0, 0.0,//1
        -0.5,   -0.5,   -0.5,       0.0, 0.0, 1.0,      0.0, 1.0,//2
        0.5,    -0.5,   -0.5,       1.0, 1.0, 0.0,      1.0, 1.0,//3
        0.5,    0.5,    0.5,        1.0, 0.0, 0.0,      1.0, 1.0,
        -0.5,   0.5,    0.5,        0.0, 1.0, 0.0,      0.0, 1.0,
        -0.5,   -0.5,   0.5,        0.0, 0.0, 1.0,      0.0, 0.0,
        0.5,    -0.5,   0.5,        1.0, 1.0, 0.0,      1.0, 0.0

    };
    
    GLuint vbo[] = {
      
        0,1,2,
        2,3,0,
        
        0,1,4,
        1,4,5,
        
        1,5,6,
        1,2,6,
        
        2,3,6,
        3,6,7,
        
        3,0,4,
        4,7,3,
        
        4,6,5,
        6,4,7
        
        
        
    };
    
    self.count = sizeof(vbo) / sizeof(GLuint);
    
    GLuint vaoBuffer;
    glGenBuffers(1, &vaoBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vaoBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vao), vao, GL_STATIC_DRAW);
    
    
    GLuint vboBuffer;
    glGenBuffers(1, &vboBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vboBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(vbo), vbo, GL_STATIC_DRAW);
    
    
    
    // 着色器
    self.baseEffect = [[GLKBaseEffect alloc] init];
    
  
    /*
    CGSize size = self.view.bounds.size;
    float aspect = fabs(size.width / size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90.0), aspect, 0.1f, 100.f);
    projectionMatrix = GLKMatrix4Scale(projectionMatrix, 0.2f, 0.2f, 0.2f);
    self.baseEffect.transform.projectionMatrix = projectionMatrix;
    */
    self.baseEffect.transform.modelviewMatrix = GLKMatrix4MakeScale(0.5, 0.5, 0.5);
    
    
    
  
    
    
    // 3. 纹理贴图
    NSString *path = [[NSBundle mainBundle] pathForResource:@"icon.jpg" ofType:nil];
    
    NSDictionary *option = [NSDictionary dictionaryWithObjectsAndKeys:@(1),GLKTextureLoaderOriginBottomLeft, nil];
    GLKTextureInfo * info = [GLKTextureLoader textureWithContentsOfFile:path options:option error:nil];
    
    self.baseEffect.texture2d0.enabled = GL_TRUE;
    self.baseEffect.texture2d0.name = info.name;
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    btn.center = CGPointMake(self.view.center.x, self.view.frame.size.height - 40);
    [btn setTitle:@"dismiss" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(cubeClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)update{
    
    
    
}



- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.5, 0.5, 0.5, 1);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    self.angle = (self.angle + 1) % 360;
    
    self.baseEffect.transform.modelviewMatrix = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(self.angle), 1, 1, 1);
    
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat), (GLfloat *)NULL);
    
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat), (GLfloat *)NULL + 3);
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat), (GLfloat *)NULL + 6);
    
    /*
    GLKMatrixStackRef stack = GLKMatrixStackCreate(kCFAllocatorDefault);
    GLKMatrixStackPush(stack);
    
    GLKMatrixStackRotate(stack, GLKMathDegreesToRadians(self.angle), 1, 0, 0);
    
    self.baseEffect.transform.modelviewMatrix = GLKMatrixStackGetMatrix4(stack);
    
    
    GLKMatrixStackPop(stack);
    */
    
    
    [self.baseEffect prepareToDraw];
    glDrawElements(GL_TRIANGLES, self.count, GL_UNSIGNED_INT, 0);
    
}




















- (void)cubeClick{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
