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
#include <PolyString.h>
#include <PolycodeView.h>
#include <string>
#include <vector>

using namespace Polycode;

#define TWITTER 0
#define INSTAGRAM 1


class EngageClientApp : public EventHandler {
public:
    EngageClientApp(PolycodeView *view, int screenIndex);
    ~EngageClientApp();
    
    void clean(Scene* scene);
    void twitter(Scene *scene, float width, float height, NSDictionary *data);
    void instagram(Scene *scene, float width, float height, NSDictionary *data);
    void topbar(Scene* scene, float width, float height);
    void footer(Scene* scene, float width, float height);
        
    void updateScene(int action, NSDictionary *data);
    void drawStrings(Scene* scene, NSString* data, float x, float y, int maxChars, int step);

    bool Update();
    
private:
    SceneImage *user;
    SceneImage *biggerBox;
    
    //Twitter
    SceneImage *smallerBox;
    SceneImage *vectorsImage;
    SceneImage *twitterPicture;
    SceneImage *twitterBackground;
    
    Core *core;
    Scene *scene;
    Color *color;
    SceneImage *image;
    Timer *animationTimer;
    std::vector<SceneLabel *> textReferences;
    
    int current = 0;
    int changeEvery = 60 * 2;
    int width;
    int height;
};


#endif /* defined(__EngageClient__EngageClientApp__) */
