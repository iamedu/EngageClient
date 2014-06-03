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
    
    //NSRect rect = [screen frame];
    
    int width = 1024;//rect.size.width;
    int height = 768;//rect.size.height;
    
    
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
    color = new Color(0xffffffff);
    scene->clearColor = color;
    scene->useClearColor = true;
    scene->getActiveCamera()->setOrthoSize(width, height);
    
    topbar(scene, width, height);
    footer(scene, width, height);
    
}

void EngageClientApp::topbar(Scene* scene, float width, float height) {
    //Image
    SceneImage *image = new SceneImage("../Resources/footer.png");
    
    image->Scale(width / image->getImageWidth(), width / image->getImageWidth());
    float newHeight = image->getImageHeight() * (width / image->getImageWidth())* 4 / 3;
    
    ScenePrimitive *tbar = new ScenePrimitive(ScenePrimitive::TYPE_BOX, width, newHeight, 0);
    tbar->Translate(0, (height / 2) - (newHeight / 2));
    tbar->setColor(0, 0, 0, 1);
    
    scene->addChild(tbar);
    
    image = new SceneImage("../Resources/logo.png");
    image->Translate(- (width / 2) + image->getImageHeight() * 0.6, (height / 2) - (newHeight / 2));
    image->Scale(0.6, 0.6);
    scene->addChild(image);
    
    int fontSize = 40 * (height / 768);
    
    SceneLabel *participaLabel = new SceneLabel("Trabajo", fontSize);
    participaLabel->setPosition(2 * width / 20, height / 2 - fontSize *  3 / 2);
    scene->addChild(participaLabel);
    
    SceneLabel *boldLabel = new SceneLabel("Sin fronteras", fontSize, "Gill Sans Bold");
    boldLabel->setPosition(6 * width / 20, height / 2 - fontSize *  3 / 2);
    scene->addChild(boldLabel);
    
}


void EngageClientApp::footer(Scene* scene, float width, float height) {
    //Image
    SceneImage *image = new SceneImage("../Resources/footer.png");
    
    image->Scale(width / image->getImageWidth(), width / image->getImageWidth());
    float newHeight = image->getImageHeight() * (width / image->getImageWidth());
    NSLog(@"%f", newHeight);
    image->Translate(0, - (height / 2) + (newHeight / 2));
    
    scene->addChild(image);
    
    int fontSize = 40 * (height / 768);
    
    SceneLabel *ciscoLabel = new SceneLabel("@CiscoMexico", fontSize);
    ciscoLabel->setPosition(- 7 * width / 20, - height / 2 + fontSize *  15 / 14);
    scene->addChild(ciscoLabel);
    
    SceneLabel *participaLabel = new SceneLabel("@Participa", fontSize);
    participaLabel->setPosition(4 * width / 20, - height / 2 + fontSize *  15 / 14);
    scene->addChild(participaLabel);
    
    SceneLabel *boldLabel = new SceneLabel("#TSF14", fontSize, "Gill Sans Bold");
    boldLabel->setPosition(8 * width / 20, - height / 2 + fontSize *  15 / 14);
    scene->addChild(boldLabel);

}

void EngageClientApp::handleEvent(Event *e) {
    
}

EngageClientApp::~EngageClientApp() {
}
 
bool EngageClientApp::Update() {
    return core->updateAndRender();
}



