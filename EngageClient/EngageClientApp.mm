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
     
    width = 720;//rect.size.width;
    height = 405;//rect.size.height;
    
    
    
    core = new POLYCODE_CORE(view,
                             width,
                             height,
                             true,
                             true,
                             6,
                             0,
                             90,
                             index,
                             false);
    
    
    CoreServices::getInstance()->getResourceManager()->addArchive("../Resources/default.pak");
    CoreServices::getInstance()->getResourceManager()->addDirResource("default", false);
    
    scene = new Scene(Scene::SCENE_2D);
    color = new Color(0xffffffff);
    scene->clearColor = color;
    scene->useClearColor = true;
    scene->getActiveCamera()->setOrthoSize(width, height);
    
    
    //topbar(scene, width, height);
    //footer(scene, width, height);
    
}

void EngageClientApp::drawStrings(Scene* scene, NSString *data, float x, float y, int maxChars, int step, int maxLines, int size) {
    textReferences.clear();
    
    
    data = [data stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    NSArray *array = [data componentsSeparatedByString:@" "];
    NSArray *statuses = [[NSArray alloc] init];
    NSString *current = @"";
    
    int i = 0;
    
    for(id part in array) {
        NSString *proposed = [current stringByAppendingString:part];
        if([proposed length] <= maxChars) {
            current = proposed;
            current = [current stringByAppendingString:@" "];
        } else {
            statuses = [statuses arrayByAddingObject:current];
            current = part;
            current = [current stringByAppendingString:@" "];
            i++;
        }
        if(maxLines > 0 && i >= maxLines) {
            break;
        }
    }
    
    if(maxLines == 0 || i < maxLines) {
        statuses = [statuses arrayByAddingObject:current];
    }
    
    
    
    int idx = 0;
    for(id str in statuses) {
        NSString *strData = str;
        SceneLabel *status = new SceneLabel([strData UTF8String], size);
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


void EngageClientApp::twitter(Scene* scene, float width, float height, NSDictionary* data) {
    background(scene, width, height);
    
    SceneImage *twitterBackground = new SceneImage("../Resources/twitter.png");
    twitterBackground->Scale(0.3, 0.3);
    twitterBackground->Translate(-width / 4, height / 8);
    
    NSString *pictureUrl = [data objectForKey:@"picture_url"];
    
    if(![[NSNull null] isEqual:pictureUrl]) {
        NSString *picture = [data objectForKey:@"twitter_id"];
        picture = [picture stringByAppendingString:@".png"];
        picture = [[@"~/.engage/resources" stringByExpandingTildeInPath]
                   stringByAppendingFormat:@"/%@", picture];
        
        if([[NSFileManager defaultManager] fileExistsAtPath:picture]) {
            twitterPicture = new SceneImage([picture UTF8String]);
            
            if(twitterPicture->getImageHeight() > width / 4) {
                twitterPicture->Scale(height / (twitterPicture->getImageHeight() * 4), height / (twitterPicture->getImageHeight() * 4));
            } else {
                twitterPicture->Scale(width / (twitterPicture->getImageWidth() * 3), width / (twitterPicture->getImageWidth() * 3));
            }
            
            twitterPicture->Translate(-width / 4, -60);
            scene->addChild(twitterPicture);

        }
        
        
    }
    
    NSString *slugString = [data objectForKey:@"slug"];
    const char *slug = [[@"@" stringByAppendingString:slugString] UTF8String];
    SceneLabel *slugLabel = new SceneLabel(slug, 20);
    slugLabel->setColor(0, 0, 0, 1);
    slugLabel->Translate(60, -70);
    scene->addChild(slugLabel);
    
    slugString = [[@"~/.engage/resources" stringByExpandingTildeInPath]
                  stringByAppendingFormat:@"/%@.png", slugString];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:slugString]) {
        user = new SceneImage([slugString UTF8String]);
        user->Scale(0.5, 0.5);
        user->Translate(-50, -70);
        scene->addChild(user);
    }
    
    
    NSString *status = [data objectForKey:@"status"];
    
    NSLog(@"%@", status);
    
    drawStrings(scene, status, 90, 80, 40, 20);
    
    scene->addChild(twitterBackground);
    
}

void EngageClientApp::instagram(Scene* scene, float width, float height, NSDictionary* data) {
    background(scene, width, height);
    
    SceneImage *instagramPicture = new SceneImage("../Resources/instagram.png");
    instagramPicture->Scale(0.3, 0.3);
    instagramPicture->Translate(-width / 4, height / 14);
    
    scene->addChild(instagramPicture);
    
    NSString *pictureUrl = [data objectForKey:@"standard_resolution"];
    
    
    NSString *picture = [pictureUrl lastPathComponent];
    picture = [picture stringByReplacingOccurrencesOfString:@".jpeg" withString:@".png"];
    picture = [picture stringByReplacingOccurrencesOfString:@".jpg" withString:@".png"];
    picture = [[@"~/.engage/resources" stringByExpandingTildeInPath]
               stringByAppendingFormat:@"/%@", picture];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:picture]) {
        twitterPicture = new SceneImage([picture UTF8String]);
        twitterPicture->Scale(0.12, 0.12);
        twitterPicture->Translate(80, 30);
        scene->addChild(twitterPicture);
    }
    
    NSString *tags = @"";
    
    for(id tagEntity in [data objectForKey:@"instagram_tags"]) {
        tags = [tags stringByAppendingFormat:@"%@ ", [tagEntity objectForKey:@"tag"]];
    }
    
    drawStrings(scene, tags, 80, -72, 40, 20, 4, 15);
    
    NSString *slugString;
    
    slugString = [data objectForKey:@"profile_url"];
    slugString = [slugString lastPathComponent];
    slugString = [slugString stringByReplacingOccurrencesOfString:@".jpg" withString:@".png"];
    slugString = [slugString stringByReplacingOccurrencesOfString:@".jpeg" withString:@".png"];
    slugString = [[@"~/.engage/resources" stringByExpandingTildeInPath]
                  stringByAppendingFormat:@"/%@", slugString];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:slugString]) {
        user = new SceneImage([slugString UTF8String]);
        user->Scale(0.22, 0.22);
        user->Translate(-240, -70);
        scene->addChild(user);
    }
    
    
    slugString = [data objectForKey:@"name"];
    const char *slug = [[@"@" stringByAppendingString:slugString] UTF8String];
    SceneLabel *slugLabel = new SceneLabel(slug, 15);
    slugLabel->setColor(0, 0, 0, 1);
    
    
    
    int length = (int)[slugString length] + 1;
        
    slugLabel->Translate(-170 + 2 * length, -75);
    scene->addChild(slugLabel);
    
    
    
}

void EngageClientApp::background(Scene* scene, float width, float height) {
    SceneImage *background = new SceneImage("../Resources/engagewall_AS_fondo.png");
    background->Scale(width / background->getImageWidth(), height / background->getImageHeight());
    scene->addChild(background);
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
    
    SceneLabel *boldLabel = new SceneLabel("sin Fronteras", fontSize, "Gill Sans Bold");
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
    
    SceneLabel *participaLabel = new SceneLabel("Participa", fontSize);
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



