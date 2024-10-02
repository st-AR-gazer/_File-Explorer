
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

array<string> selectedPaths;
array<FileExplorer::ElementInfo> selectedElements;

void RenderInterface() {
    if (!S_displayInterface) return;

    if (UI::Begin("File Explorer Example", S_displayInterface)) {
        UI::Text("This is an example implementation of how the 'File Explorere' can be used to get the user to select any arbitrary file(s) from their system.");

        UI::Separator();

        UI::Text("Opening a file explorer expects a path to be returned.");

        if (UI::Button(Icons::FolderOpen + " Open File Explorer")) {
            FileExplorer::fe_Start(
                "Local Files",
                true,
                "path",
                vec2(1, -1),
                IO::FromUserGameFolder("Replays/"),
                "",
                { "replay", "ghost" }
            );
        }

        auto exampleExlorer_Paths = FileExplorer::fe_GetExplorerById("Local Files");
        if (exampleExlorer_Paths !is null && exampleExlorer_Paths.exports.IsSelectionComplete()) {
            auto paths = exampleExlorer_Paths.exports.GetSelectedPaths();
            if (paths !is null) {
                selectedPaths = paths;
                exampleExlorer_Paths.exports.SetSelectionComplete();
            }
        }

        UI::SameLine();
        UI::Text("Selected Files: " + selectedPaths.Length);
        for (uint i = 0; i < selectedPaths.Length; i++) {
            UI::PushItemWidth(1100);
            selectedPaths[i] = UI::InputText("File Path " + (i + 1), selectedPaths[i]);
            UI::PopItemWidth();
        }

        UI::Separator();

        UI::Text("Opening a file explorer expects ElementInfo to be returned.");

        if (UI::Button(Icons::FolderOpen + " Open File Explorer (ElementInfo)")) {
            FileExplorer::fe_Start(
                "Local Files (ElementInfo)",
                true,
                "elementInfo",
                vec2(1, -1),
                IO::FromUserGameFolder("Replays/"),
                "",
                { "replay", "ghost" }
            );
        }

        auto exampleExlorer_ElementInfo = FileExplorer::fe_GetExplorerById("Local Files (ElementInfo)");

        if (exampleExlorer_ElementInfo !is null && exampleExlorer_ElementInfo.exports.IsSelectionComplete()) {
            auto elements = exampleExlorer_ElementInfo.exports.GetSelectedElements();
            if (elements !is null) {
                selectedElements = elements;
                exampleExlorer_ElementInfo.exports.SetSelectionComplete();
            }
        }

        UI::SameLine();
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
        }
    }
    UI::End();
}