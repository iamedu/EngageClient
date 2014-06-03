//
//  EngageClientApp.h
//  EngageClient
//
//  Created by Eduardo Díaz on 5/31/14.
//  Copyright (c) 2014 EngageWall. All rights reserved.
//

#ifndef __EngageClient__EngageClientApp__
#define __EngageClient__EngageClientApp__

#include <Polycode.h>
#include <PolycodeView.h>
#include <PolycodeUI.h>

using namespace Polycode;

class EngageClientApp : public EventHandler {
public:
    EngageClientApp(PolycodeView *view, int screenIndex);
    ~EngageClientApp();
    
    void footer(Scene* scene, float width, float height);
    
    void handleEvent(Event *e);
    
    bool Update();
    
private:
    UIButton *code;
    
    Core *core;
    Scene *scene;
    Color *color;
    SceneImage *image;
    Timer *animationTimer;
};


#endif /* defined(__EngageClient__EngageClientApp__) */
