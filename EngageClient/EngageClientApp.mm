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
    /*
    NSArray *screenArray = [NSScreen screens];
    NSScreen *screen = [screenArray objectAtIndex: index];
    
    NSRect rect = [screen frame];
    */
     
    width = 1024;//rect.size.width;
    height = 768;//rect.size.height;
    
    
    
    core = new POLYCODE_CORE(view,
                             width,
                             height,
                             true,
                             true,
                             6,
                             0,
                             90,
                             -1,
                             false);
    
    
    CoreServices::getInstance()->getResourceManager()->addArchive("../Resources/default.pak");
    CoreServices::getInstance()->getResourceManager()->addDirResource("default", false);
    
    scene = new Scene(Scene::SCENE_2D);
    color = new Color(0xffffffff);
    scene->clearColor = color;
    scene->useClearColor = true;
    scene->getActiveCamera()->setOrthoSize(width, height);
    
    
    topbar(scene, width, height);
    footer(scene, width, height);
    
}

void EngageClientApp::twitter(Scene* scene, float width, float height, NSDictionary* data) {
    vectorsImage = new SceneImage("../Resources/vectores.png");
    
    vectorsImage->Scale(0.20, 0.20);
    vectorsImage->Translate(width / 4, - (height / 2) + vectorsImage->getImageHeight() * 0.20);
    
    scene->addChild(vectorsImage);
    
    twitterBackground = new SceneImage("../Resources/medium-box.png");
    twitterBackground->Scale(0.5, 0.5);
    twitterBackground->Translate(0, 120);
    scene->addChild(twitterBackground);
    
    smallerBox = new SceneImage("../Resources/smaller-box.png");
    smallerBox->Scale(0.4, 0.4);
    smallerBox->Translate(width / 4, -90);
    scene->addChild(smallerBox);
    
    NSString *pictureUrl = [data objectForKey:@"picture_url"];
    
    if(![[NSNull null] isEqual:pictureUrl]) {
        NSString *picture = [pictureUrl lastPathComponent];
        picture = [picture stringByReplacingOccurrencesOfString:@".jpeg" withString:@".png"];
        picture = [picture stringByReplacingOccurrencesOfString:@".jpg" withString:@".png"];
        picture = [[@"~/.engage/resources" stringByExpandingTildeInPath]
                      stringByAppendingFormat:@"/%@", picture];
        twitterPicture = new SceneImage([picture UTF8String]);
    } else {
        twitterPicture = new SceneImage("../Resources/boy.png");
    }


    if(twitterPicture->getImageHeight() > width / 4) {
        twitterPicture->Scale(height / (twitterPicture->getImageHeight() * 4), height / (twitterPicture->getImageHeight() * 4));
    } else {
        twitterPicture->Scale(width / (twitterPicture->getImageWidth() * 3), width / (twitterPicture->getImageWidth() * 3));
    }
    
    twitterPicture->Translate(- width / 4, -150);
    scene->addChild(twitterPicture);
    
    NSString *slugString = [data objectForKey:@"slug"];
    const char *slug = [[@"@" stringByAppendingString:slugString] UTF8String];
    SceneLabel *slugLabel = new SceneLabel(slug, 20);
    slugLabel->setColor(0, 0, 0, 1);
    slugLabel->Translate(width / 4 + 40, -90);
    scene->addChild(slugLabel);
    
    slugString = [[@"~/.engage/resources" stringByExpandingTildeInPath]
                  stringByAppendingFormat:@"/%@.png", slugString];
    
    user = new SceneImage([slugString UTF8String]);
    user->Scale(0.5, 0.5);
    user->Translate(width / 4 - 150, -90);
    scene->addChild(user);
    
    
    NSString *status = [data objectForKey:@"status"];
    
    drawStrings(scene, status, 80, 200, 40, 50);
    
    //NSLog(@"%@", data);
    
}

void EngageClientApp::drawStrings(Scene* scene, NSString *data, float x, float y, int maxChars, int step) {
    textReferences.clear();
    
    
    data = [data stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    NSArray *array = [data componentsSeparatedByString:@" "];
    NSArray *statuses = [[NSArray alloc] init];
    NSString *current = @"";
    
    for(id part in array) {
        NSString *proposed = [current stringByAppendingString:part];
        if([proposed length] <= maxChars) {
            current = proposed;
            current = [current stringByAppendingString:@" "];
        } else {
            statuses = [statuses arrayByAddingObject:current];
            current = part;
            current = [current stringByAppendingString:@" "];
        }
    }
    
    statuses = [statuses arrayByAddingObject:current];
    
    
    
    int idx = 0;
    for(id str in statuses) {
        NSString *strData = str;
        SceneLabel *status = new SceneLabel([strData UTF8String], 32);
        status->setColor(0, 0, 0, 1);
        status->setPosition(x, y - step * idx);
        
        textReferences.push_back(status);
        
        scene->addChild(status);
        idx++;

    }
    
    
}

void EngageClientApp::clean(Scene* scene) {
    for (unsigned i=0; i<textReferences.size(); i++) {
        SceneLabel *status = textReferences.at(i);
        scene->removeEntity(status);
    }
    if(biggerBox) {
        scene->removeEntity(biggerBox);
    }
    if(smallerBox) {
        scene->removeEntity(smallerBox);
    }
    if(vectorsImage) {
        scene->removeEntity(vectorsImage);
    }
    if(twitterBackground) {
        scene->removeEntity(twitterBackground);
    }
    if(twitterPicture) {
        scene->removeEntity(twitterPicture);
    }
    if(user) {
        scene->removeEntity(user);
    }
}


void EngageClientApp::instagram(Scene* scene, float width, float height, NSDictionary* data) {
    biggerBox = new SceneImage("../Resources/bigger-box.png");
    biggerBox->Scale(0.45, 0.45);
    biggerBox->Translate(0, 50);
    scene->addChild(biggerBox);
    
    NSString *pictureUrl = [data objectForKey:@"standard_resolution"];
    
    
    NSString *picture = [pictureUrl lastPathComponent];
    picture = [picture stringByReplacingOccurrencesOfString:@".jpeg" withString:@".png"];
    picture = [picture stringByReplacingOccurrencesOfString:@".jpg" withString:@".png"];
    picture = [[@"~/.engage/resources" stringByExpandingTildeInPath]
                   stringByAppendingFormat:@"/%@", picture];
    twitterPicture = new SceneImage([picture UTF8String]);
    twitterPicture->Scale(0.28, 0.28);
    twitterPicture->Translate(-240, 60);
    scene->addChild(twitterPicture);
    
    NSString *tags = @"";
    
    for(id tagEntity in [data objectForKey:@"instagram_tags"]) {
        tags = [tags stringByAppendingFormat:@"%@ ", [tagEntity objectForKey:@"tag"]];
    }
    
    drawStrings(scene, tags, 240, 40, 20, 50);
    
    smallerBox = new SceneImage("../Resources/smaller-box.png");
    smallerBox->Scale(0.4, 0.4);
    smallerBox->Translate(width / 4, -220);
    scene->addChild(smallerBox);
    
    NSString *slugString = [data objectForKey:@"name"];
    const char *slug = [[@"@" stringByAppendingString:slugString] UTF8String];
    SceneLabel *slugLabel = new SceneLabel(slug, 20);
    slugLabel->setColor(0, 0, 0, 1);
    slugLabel->Translate(width / 4 + 30, -220);
    scene->addChild(slugLabel);
    
    slugString = [data objectForKey:@"profile_url"];
    slugString = [slugString lastPathComponent];
    slugString = [slugString stringByReplacingOccurrencesOfString:@".jpg" withString:@".png"];
    slugString = [slugString stringByReplacingOccurrencesOfString:@".jpeg" withString:@".png"];
    slugString = [[@"~/.engage/resources" stringByExpandingTildeInPath]
                  stringByAppendingFormat:@"/%@", slugString];
    
    user = new SceneImage([slugString UTF8String]);
    user->Scale(0.25, 0.25);
    user->Translate(width / 4 - 140, -220);
    scene->addChild(user);
    
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
    participaLabel->setPosition(1 * width / 20, height / 2 - fontSize *  3 / 2);
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

void EngageClientApp::updateScene(int action, NSDictionary *data) {
    if(current == 0) {
        clean(scene);
        
        if(action == TWITTER) {
            twitter(scene, width, height, data);
        } else if (action == INSTAGRAM) {
            instagram(scene, width, height, data);
        }
        
    }
    current += 1;
    if(current == changeEvery) {
        current = 0;
    }
    
}

EngageClientApp::~EngageClientApp() {
}
 
bool EngageClientApp::Update() {
    return core->updateAndRender();
}



