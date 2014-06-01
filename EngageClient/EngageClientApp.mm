//
//  EngageClientApp.cpp
//  EngageClient
//
//  Created by Eduardo Díaz on 5/31/14.
//  Copyright (c) 2014 EngageWall. All rights reserved.
//


#include "EngageClientApp.h"


EngageClientApp::EngageClientApp(PolycodeView *view) : EventHandler() {
    core = new POLYCODE_CORE(view, 640,480,false,false,0,0,90, 1, true);
    
    CoreServices::getInstance()->getResourceManager()->addArchive("/Users/iamedu/Development/iamedu/Polycode/Examples/C++/Resources/default.pak");
    CoreServices::getInstance()->getResourceManager()->addDirResource("default", false);
    
    core->setVideoMode(1024, 768, true, true, 1, 1);
    
    Scene *scene = new Scene(Scene::SCENE_2D);
    scene->getActiveCamera()->setOrthoSize(640, 480);
    SceneLabel *label = new SceneLabel("Hello, Polycode!", 32);
    scene->addChild(label);
}

EngageClientApp::~EngageClientApp() {
}
 
bool EngageClientApp::Update() {
    return core->updateAndRender();
}



