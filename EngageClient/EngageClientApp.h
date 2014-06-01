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

using namespace Polycode;

class EngageClientApp : public EventHandler {
public:
    EngageClientApp(PolycodeView *view);
    ~EngageClientApp();
    bool Update();
    
private:
    Core *core;
};


#endif /* defined(__EngageClient__EngageClientApp__) */
