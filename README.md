# Mesh Color Mapping - sample project

This sample project demonstrates a module for mapping/indexing vertex colors from a mesh buffer for real-time manipulation in defold. Playing the project allows the user to change the colors of the mesh objects using the displayed gui options. Similar to something you may find in a game with gear customization mechanics. However this method can be used for many different visual effects and mechanics.

[: Play The DEMO :]()

The main focus of this sample is the module `color_mapping.lua` contains functions that are used to map and re-color the mesh.

|                                               	|                                                                                                          	|
|-----------------------------------------------	|----------------------------------------------------------------------------------------------------------	|
| `M.map_vertex_colors(mesh_url)`               	| Takes in mesh url. Maps indexes of all triangle faces and their vertex color values with matching colors 	|
| `M.color_on_mesh(mesh_url, mapped_id, color)` 	| Takes in mesh url, map id(mapped index), vector 4. Changes mesh mapped color to new color                	|
| `M.mesh_info(mesh_url)`                       	| Takes in mesh url. Prints out data of mapped mesh                                                        	|
| `M.remove_mesh(mesh_url)`                     	| Takes in mesh url. Removes mesh data and buffer stored in module tables                                  	|


note: Vertex colors were applied to the sword and shield 3d models in blender and then exported using the [CLEAN Asset Exporter](https://extensions.blender.org/add-ons/clean-game-asset-exporter/) extension.


Learn more about the [Defold game engine](https://defold.com/). Visit the community forums at [Defold Community](https://forum.defold.com).

