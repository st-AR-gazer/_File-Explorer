// File Explorer example integration
// author "ar"

bool S_displayInterface = false;
void RenderMenu() {
    if (UI::MenuItem(Colorize(Icons::FolderOpen + " File Explorer", { "#e0e0e0", "#a0a0a0" }, colorize::GradientMode::linear ))) {
        if (S_displayInterface) {
            S_displayInterface = false;
        } else {
            S_displayInterface = true;
        }
    }
}

// To save the selected file path(s)/information we need a variable to to capture the selected data.
// This can be done by creating an array of strings to store the selected file path(s).
// Or by creating an array of the ElementInfo struct to store some more detailed information of the selected file(s).

// Array to store selected file paths (simple path strings)
array<string> selectedPaths;

// Array to store detailed selected file information (ElementInfo struct)
array<FileExplorer::ElementInfo> selectedElements;


void RenderInterface() {

    // The File Explorer requires the FILE_EXPLORER_BASE_RENDERER function to be called in your main Render pipeline, 
    // if this is not included the file explorer will 'open', but it will not be visible to the user.
    FILE_EXPLORER_BASE_RENDERER();

    if (!S_displayInterface) return;

    if (UI::Begin(Colorize(Icons::FolderOpen + " File Explorer Example", { "#e0e0e0", "#a0a0a0" }, colorize::GradientMode::linear ), S_displayInterface)) {
        UI::Text("This is an example implementation of how the 'File Explorere' can be used to get the user to select any arbitrary file(s) from their system.");
        UI::Separator();
        UI::Text("Opening a file explorer expects a path to be returned.");


        // To open the file explorer we need to call the FileExplorer::fe_Start function.
        // This opens the file explorer with the specified instance settings.

        // The first   parameter is the ID of the file explorer instance, we will use this later to get the selected data.
        // The second  parameter is a boolean to determine if the file explorer should return a value, since you are implementing 
        // this so that it's actually usefull this sohuld always be set to true.
        // The third   parameter is the type of data to return, in this case we want the path to the selected file(s).
        // The fourth  parameter is a vec2 that determines the minimum and maximum number of files the user can select a negative value means no limit.
        // The fifth   parameter is the default path to open the file explorer, in this case we are opening the file explorer in the 'Replays' folder.
        // The sixth   parameter is the 'search' [a filter based on file name], in this case we are not using a search filter.
        // The seventh parameter is the 'filter' [a filter based on file extension], in this case we are only allowing the user to select files with the extensions 'replay' and 'ghost'.
        // The eighth  parameter is another filter, whilst the first filter is only visual, this filter dissallows specific file types from being returned.

        if (UI::Button(Icons::FolderOpen + " Open File Explorer")) {
            FileExplorer::fe_Start(
                "Paths Example",    // The ID of the file explorer instance
                true, // If the file explorer should be visible
                "path",             // The type of data to return (path, elementInfo)
                vec2(1, -1),        // The minimum and maximum number of files the user can select
                IO::FromUserGameFolder("Replays/"), // The default path to open the file explorer
                "", // The 'search' [a filter based on file name]
                { "replay", "ghost" }, // The 'filter' [a filter based on file extension]
                { "replay", "ghost" } // Another filter, whilst the first filter is only visual, this filter dissallows specific file types from being returned.

            );
        }

        // To get the selected data from the file explorer we need to call the FileExplorer::fe_GetExplorerById function.
        // This function returns the file explorer instance with the specified ID, (this is the same ID we used to open the file explorer).
        // We then check if the file explorer instance is not null, and if the selection is complete.
        // If the selection is complete we get the selected data and store it in the selectedPaths array.
        // Do note that if the selection takes a while this will block the UI, keep that in mind when implementing this in your own scripts.

        auto exampleExlorer_Paths = FileExplorer::fe_GetExplorerById("Paths Example");
        if (exampleExlorer_Paths !is null && exampleExlorer_Paths.exports.IsSelectionComplete()) {
            auto paths = exampleExlorer_Paths.exports.GetSelectedPaths();
            if (paths !is null) {
                selectedPaths = paths;
                exampleExlorer_Paths.exports.SetSelectionComplete();
            }
        }

        UI::SameLine();
        // finally we display the selected file paths to the user.
        UI::Text("Selected Files: " + selectedPaths.Length);
        for (uint i = 0; i < selectedPaths.Length; i++) {
            UI::PushItemWidth(1100);
            selectedPaths[i] = UI::InputText("File Path " + (i + 1), selectedPaths[i]);
            UI::PopItemWidth();
        }

        UI::Separator();
        UI::Separator();

        UI::Text("Opening a file explorer expects ElementInfo to be returned.");

        // The same as above, but this time we are using the 'elementInfo' type to get more detailed information about the selected file(s).

        if (UI::Button(Icons::FolderOpen + " Open File Explorer (ElementInfo)")) {
            FileExplorer::fe_Start(
                "ElementInfo Example",
                true,
                "ElementInfo", // notice the type is 'ElementInfo' here this time, the rest remains the same.
                vec2(1, -1),
                IO::FromUserGameFolder("Replays/"),
                "",
                { "replay", "ghost" },
                { "replay", "ghost" }
            );
        }

        auto exampleExlorer_ElementInfo = FileExplorer::fe_GetExplorerById("ElementInfo Example");
        if (exampleExlorer_ElementInfo !is null && exampleExlorer_ElementInfo.exports.IsSelectionComplete()) {
            auto elements = exampleExlorer_ElementInfo.exports.GetSelectedElements();
            if (elements !is null) {
                
                // The biggest difference between the 'path' and 'ElementInfo' type is that 'ElementInfo' cannot be directly stored in an array.
                // We need to loop through the elements and store them in the selectedElements array.
                // Curses opAssign :ShakingFist:

                selectedElements.Resize(elements.Length);
                for (uint i = 0; i < elements.Length; i++) {
                    selectedElements[i] = elements[i];
                }
            }
            exampleExlorer_ElementInfo.exports.SetSelectionComplete();
        }
        
        UI::SameLine();
        // finally we once again display the selected file information to the user.
        UI::Text("Selected Files: " + selectedElements.Length);
        for (uint i = 0; i < selectedElements.Length; i++) {
            UI::PushItemWidth(1100);
            UI::Text("File Path " + (i + 1) + ": " + selectedElements[i].path);
            UI::Text("File Name " + (i + 1) + ": " + selectedElements[i].name);
            UI::Text("File Extension " + (i + 1) + ": " + selectedElements[i].type);
            if (selectedElements[i].gbxType != "") {
                UI::Text("File GBX Type " + (i + 1) + ": " + selectedElements[i].gbxType);
            }
            UI::Text("File Size " + (i + 1) + ": " + selectedElements[i].size);
            UI::Text("File Last Modified " + (i + 1) + ": " + selectedElements[i].lastModifiedDate);
            UI::Text("File Created " + (i + 1) + ": " + selectedElements[i].creationDate);
            UI::PopItemWidth();
            UI::Separator();
        }
    }
    UI::End();
}