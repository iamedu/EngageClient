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
     
    width = 1920;//rect.size.width
    height = 1080;//rect.size.height;
    
    
    
    core = new POLYCODE_CORE(view,
                             width,
                             height,
                             true,
                             true,
                             6,
                             0,
                             90,
                             index,
                             [screen backingScaleFactor] == 2.0f);
    
    
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
    NSArray *realArray = [data componentsSeparatedByString:@" "];
    NSArray *array = [[NSArray alloc] init];
    NSArray *statuses = [[NSArray alloc] init];
    NSString *current = @"";
    
    int i = 0;
    
    for(id part in realArray) {
        NSString *newPart = [part stringByAppendingString:@" "];
        
        if([newPart length] > maxChars) {
            int partNumber = (int)ceil(1.0f * [newPart length] / maxChars);
            for(int i = 0; i < partNumber; i++) {
                unsigned long last = maxChars;
                int currentMax = (i + 1) * maxChars;

                
                if(currentMax > [newPart length]) {

                    last = maxChars - (currentMax - [newPart length]);
                }
                
                NSString *customPart = [newPart substringWithRange: NSMakeRange(i * maxChars, last)];
                array = [array arrayByAddingObject:customPart];
            }
        } else {
            array = [array arrayByAddingObject:newPart];
        }
        
    }
    
    for(id part in array) {
        NSString *proposed = [current stringByAppendingString:part];
        if([proposed length] <= maxChars) {
            current = proposed;
        } else {
            statuses = [statuses arrayByAddingObject:current];
            current = part;
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
    int firstWidth = -1;
    for(id str in statuses) {
        NSString *strData = str;
        SceneLabel *status = new SceneLabel([strData UTF8String], size);
        int width = status->getTextWidthForString([strData UTF8String]);
        float newX;
        
        if(firstWidth == -1) {
            firstWidth = width;
            newX = x;
        } else {
            newX = x - (firstWidth - width) / 2;
        }
        
        status->setColor(1, 1, 1, 1);
        status->setPosition(newX, y - step * idx);
        status->setAnchorPoint(SceneLabel::defaultAnchor);
        
        
        //status->setWidth(status->getTextWidthForString([strData UTF8String]));
        
        textReferences.push_back(status);
        
        scene->addEntity(status);
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
    SceneImage *background = new SceneImage("../Resources/twitter_fondo.png");
    background->Scale(width / background->getImageWidth(), height / background->getImageHeight());
    scene->addEntity(background);
    
    /*
    SceneImage *twitterBackground = new SceneImage("../Resources/twitter.png");
    twitterBackground->Scale(0.5, 0.5);
    twitterBackground->Translate(-width / 4, height / 6);
    scene->addEntity(twitterBackground);
    */
    
    NSString *pictureUrl = [data objectForKey:@"picture_url"];
    
    if(![[NSNull null] isEqual:pictureUrl]) {
        NSString *picture = [data objectForKey:@"twitter_id"];
        picture = [picture stringByAppendingString:@".png"];
        picture = [[@"~/.engage/resources" stringByExpandingTildeInPath]
                   stringByAppendingFormat:@"/%@", picture];
        
        if([[NSFileManager defaultManager] fileExistsAtPath:picture]) {
            twitterPicture = new SceneImage([picture UTF8String]);
            
            float w = 600.0f / twitterPicture->getImageWidth();
            
            twitterPicture->Scale(w,w);
            
            twitterPicture->Translate(-410, 200);
            scene->addEntity(twitterPicture);

        }
        
        NSString *status = [data objectForKey:@"status"];
        
        NSLog(@"%@", status);
        
        
        drawStrings(scene, status, 260, 450, 18, 70, 40, 68);
        
        
    } else {
        
        NSString *status = [data objectForKey:@"status"];
        
        NSLog(@"%@", status);
        
        
        drawStrings(scene, status, -60, 380, 36, 70, 40, 68);
        
    }
    
    NSString *slugString = [data objectForKey:@"slug"];
    const char *slug = [[@"@" stringByAppendingString:slugString] UTF8String];
    SceneLabel *slugLabel = new SceneLabel(slug, 50);
    slugLabel->setColor(1, 1, 1, 1);
    slugLabel->Translate(-350, -110);
    scene->addEntity(slugLabel);
    
    slugString = [[@"~/.engage/resources" stringByExpandingTildeInPath]
                  stringByAppendingFormat:@"/%@.png", slugString];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:slugString]) {
        user = new SceneImage([slugString UTF8String]);
        float s = 120 / user->getWidth();
        user->Scale(s, s);
        user->Translate(-640, -110);
        scene->addEntity(user);
    }
    
    
    
    
    
}

void EngageClientApp::instagram(Scene* scene, float width, float height, NSDictionary* data) {
    SceneImage *background = new SceneImage("../Resources/instagram_fondo.png");
    background->Scale(width / background->getImageWidth(), height / background->getImageHeight());
    scene->addEntity(background);
    /*
    SceneImage *instagramPicture = new SceneImage("../Resources/instagram.png");
    instagramPicture->Scale(0.5, 0.5);
    instagramPicture->Translate(-width / 4 + 20, height / 14);
     
    
    scene->addEntity(instagramPicture);
     */
    

    
    NSString *slugString;
    
    slugString = [data objectForKey:@"profile_url"];
    slugString = [slugString lastPathComponent];
    slugString = [slugString stringByReplacingOccurrencesOfString:@".jpg" withString:@".png"];
    slugString = [slugString stringByReplacingOccurrencesOfString:@".jpeg" withString:@".png"];
    slugString = [[@"~/.engage/resources" stringByExpandingTildeInPath]
                  stringByAppendingFormat:@"/%@", slugString];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:slugString]) {
        user = new SceneImage([slugString UTF8String]);
        float s = 120 / user->getWidth();
        user->Scale(s, s);
        user->Translate(70, -50);
        scene->addEntity(user);
    }
    
    
    slugString = [data objectForKey:@"name"];
    const char *slug = [[@"@" stringByAppendingString:slugString] UTF8String];
    SceneLabel *slugLabel = new SceneLabel(slug, 40);
    slugLabel->setColor(1, 1, 1, 1);
    
    
    
    int length = (int)[slugString length];
    
    if(length <= 2) {
        length = 8;
    }
        
    slugLabel->Translate(120 + length * 14.8, -50);
    scene->addEntity(slugLabel);
    
    NSString *tags = @"";
    
    for(id tagEntity in [data objectForKey:@"instagram_tags"]) {
        tags = [tags stringByAppendingFormat:@"#%@ ", [tagEntity objectForKey:@"tag"]];
    }
    
    
    drawStrings(scene, tags, 260, 460, 15, 70, 10, 68);
    
    NSString *pictureUrl = [data objectForKey:@"standard_resolution"];
    
    
    
    
    
    
    NSString *picture = [pictureUrl lastPathComponent];
    picture = [picture stringByReplacingOccurrencesOfString:@".jpeg" withString:@".png"];
    picture = [picture stringByReplacingOccurrencesOfString:@".jpg" withString:@".png"];
    picture = [[@"~/.engage/resources" stringByExpandingTildeInPath]
               stringByAppendingFormat:@"/%@", picture];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:picture]) {
        twitterPicture = new SceneImage([picture UTF8String]);
        float size = 600.0f / twitterPicture->getImageWidth();
        twitterPicture->Scale(size, size);
        twitterPicture->Translate(-360, 180);
        scene->addEntity(twitterPicture);
    }
    
    
    
}

void EngageClientApp::background(Scene* scene, float width, float height) {
    SceneImage *background = new SceneImage("../Resources/fondo_academy-summit2.png");
    background->Scale(width / background->getImageWidth(), height / background->getImageHeight());
    scene->addEntity(background);
    
}

void EngageClientApp::topbar(Scene* scene, float width, float height) {
    //Image
    SceneImage *image = new SceneImage("../Resources/footer.png");
    
    image->Scale(width / image->getImageWidth(), width / image->getImageWidth());
    float newHeight = image->getImageHeight() * (width / image->getImageWidth())* 4 / 3;
    
    
    ScenePrimitive *tbar = new ScenePrimitive(ScenePrimitive::TYPE_BOX, width, newHeight, 0);
    tbar->Translate(0, (height / 2) - (newHeight / 2));
    tbar->setColor(0, 0, 0, 1);
    
    scene->addEntity(tbar);
    
    image = new SceneImage("../Resources/logo.png");
    image->Translate(- (width / 2) + image->getImageHeight() * 0.6, (height / 2) - (newHeight / 2));
    image->Scale(0.6, 0.6);
    scene->addEntity(image);
    
    int fontSize = 40 * (height / 768);
    
    SceneLabel *participaLabel = new SceneLabel("Trabajo", fontSize);
    participaLabel->setPosition(1 * width / 20, height / 2 - fontSize *  3 / 2);
    scene->addEntity(participaLabel);
    
    SceneLabel *boldLabel = new SceneLabel("sin Fronteras", fontSize, "Gill Sans Bold");
    boldLabel->setPosition(6 * width / 20, height / 2 - fontSize *  3 / 2);
    scene->addEntity(boldLabel);
    
}


void EngageClientApp::footer(Scene* scene, float width, float height) {
    //Image
    SceneImage *image = new SceneImage("../Resources/footer.png");
    
    image->Scale(width / image->getImageWidth(), width / image->getImageWidth());
    float newHeight = image->getImageHeight() * (width / image->getImageWidth());
    image->Translate(0, - (height / 2) + (newHeight / 2));
    
    scene->addEntity(image);
    
    int fontSize = 40 * (height / 768);
    
    SceneLabel *ciscoLabel = new SceneLabel("@CiscoMexico", fontSize);
    ciscoLabel->setPosition(- 7 * width / 20, - height / 2 + fontSize *  15 / 14);
    scene->addEntity(ciscoLabel);
    
    SceneLabel *participaLabel = new SceneLabel("Participa", fontSize);
    participaLabel->setPosition(4 * width / 20, - height / 2 + fontSize *  15 / 14);
    scene->addEntity(participaLabel);
    
    SceneLabel *boldLabel = new SceneLabel("#TSF14", fontSize, "Gill Sans Bold");
    boldLabel->setPosition(8 * width / 20, - height / 2 + fontSize *  15 / 14);
    scene->addEntity(boldLabel);

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



