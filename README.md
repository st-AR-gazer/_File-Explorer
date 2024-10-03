![Signed](https://img.shields.io/badge/Signed-No-FF3333)
![Trackmania2020](https://img.shields.io/badge/Game-Trackmania-blue)

## Example Implementation of the File Explorer

This repository contains an example implementation of the File Explorer to get the user to select any arbitrary file(s) from their system.
I tried to make integrating the File Explorer as easy as possible :D


### How to use

1. Copy and paste the code in `src/Conditions/FileExplorer.as` to your script.
2. Add FILE_EXPLORER_BASE_RENDERER() to your main Render pipeline.
3. Call FileExplorer::fe_Start() to open the file explorer, (see example in `src/Main.as`)
4. Call FileExplorer::fe_GetExplorerById() to get the selected data, (see example in `src/Main.as`)
5. Use the selected data in your script.
