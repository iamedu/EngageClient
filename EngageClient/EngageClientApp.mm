//
//  EngageClientApp.cpp
//  EngageClient
//
//  Created by Eduardo Díaz on 5/31/14.
//  Copyright (c) 2014 EngageWall. All rights reserved.
//


#include "EngageClientApp.h"


EngageClientApp::EngageClientApp(PolycodeView *view) : EventHandler() {
    int index = 0;
    NSArray *screenArray = [NSScreen screens];
    NSScreen *screen = [screenArray objectAtIndex: index];
    
    NSRect rect = [screen frame];
    
    int width = rect.size.width;
    int height = rect.size.height;
    
    
    core = new POLYCODE_CORE(view,
                             width,
                             height,
                             true,
                             true,
                             0,
                             0,
                             90,
                             index,
                             true);
    
    NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString* archive = [bundlePath stringByAppendingString:@"/Contents/Resources/default.pak"];
    
    CoreServices::getInstance()->getResourceManager()->addArchive([archive cStringUsingEncoding:NSASCIIStringEncoding]);
    CoreServices::getInstance()->getResourceManager()->addDirResource("default", false);
    
    //core->setVideoMode(1024, 768, true, true, 1, 1);
    
    Scene *scene = new Scene(Scene::SCENE_2D);
    scene->getActiveCamera()->setOrthoSize(width, height);
    SceneLabel *label = new SceneLabel("Hello, Polycode!", 60);
    scene->addChild(label);
}

EngageClientApp::~EngageClientApp() {
}
 
bool EngageClientApp::Update() {
    return core->updateAndRender();
}



