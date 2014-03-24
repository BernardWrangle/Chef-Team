#include "s3e.h"
#include "IwDebug.h"
#include "IwNUI.h"

using namespace IwNUI;

// Main entry point for the application
int main()
{
    CAppPtr app = CreateApp();
    CWindowPtr window = CreateWindow();

    app->AddWindow(window);

    CViewPtr view = CreateView("canvas");
    window->SetChild(view);

    //IWNUI TIP:
    //Next you should create some UI elements and handlers to deal with their events. See the NUI examples for more details.

    //Create your UI elements here

    app->ShowWindow(window);

    app->Run();

    //Terminate modules being used
    
    // Return
    return 0;
}
