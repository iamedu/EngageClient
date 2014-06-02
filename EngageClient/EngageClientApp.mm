//
//  EngageClientApp.cpp
//  EngageClient
//
//  Created by Eduardo Díaz on 5/31/14.
//  Copyright (c) 2014 EngageWall. All rights reserved.
//


#include "EngageClientApp.h"

EngageClientApp::EngageClientApp(PolycodeView *view, int screenIndex) : EventHandler() {
    int index = screenIndex;
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
    
    
    CoreServices::getInstance()->getResourceManager()->addArchive("../Resources/default.pak");
    CoreServices::getInstance()->getResourceManager()->addDirResource("default", false);
    
    animationTimer = new Timer(true, 10);
    animationTimer->addEventListener(this, Timer::EVENT_TRIGGER);
    
    scene = new Scene(Scene::SCENE_2D);
    color = new Color(0x34495eff);
    scene->clearColor = color;
    scene->useClearColor = true;
    scene->getActiveCamera()->setOrthoSize(1024, 768);
    image = new SceneImage("../Resources/logo_engagewall.png");
    scene->addChild(image);
    
    ScenePrimitive *planet = new ScenePrimitive(ScenePrimitive::TYPE_VPLANE, 1200.0, 400.0);
    planet->setPosition(0,0);
    planet->setColor(0, 0, 0, 0.4);
    planet->colorAffectsChildren = false;
    scene->addChild(planet);
}

void EngageClientApp::handleEvent(Event *e) {
    
}

EngageClientApp::~EngageClientApp() {
}
 
bool EngageClientApp::Update() {
    return core->updateAndRender();
}



