# Google SketchUp Material Changer Plugin


## Description

A Google SketchUp plugin that allows you to change the face and back materials of a selection within your model.

The plug-in adds a context menu item called "Change Materials", a toolbar button and a menu entry under the "Edit" main menu (also called "Change Materials").

Once you select something and select "Change Materials" a pop-up dialog will come up asking you what you want to change the materials to. You can choose to only change the face material, only the back material or to change both face and back materials.


## Notes and Caveats

You **MUST** have materials already in your model for this plugin to work. What that means is that the plugin cannot read from your list of materials but can only see materials in your model. If you want to replace the material of some selection, you must first have the material you want to change to in the model.

The material changer will change the **material** of Components, Groups, Edges and Faces. It will also change the **back material** of Faces.

The plugin works recursively through your selection. What this means is that if it will change the material of *every* item you select, including sub-groups/components. If you select a group of multiple groups it will change the material of the parent group and all its child groups and those child group's edges/faces.

If you do not select anything in your model, you will be prompted to select everything in the model.


## Installation

Copy the file `SU_MaterialChanger.rb` file and the `SU_MaterialChanger` directory into your SketchUp plugin directory:

On a **Mac** it is usually here:

    Macintosh HD/Library/Application Support/Google SketchUp X/SketchUp/

On **Windows** it should be here:

    C:\Program Files\Google\Google Sketchup X\Plugins\

.. where `X` is the version of SketchUp you are running.


## Compatibility

Testing and working on SketchUp 8 but probably works for versions 6+. Let me know if you get it working on any version pervious to 8.

Should work fine for both Mac and PC.

If you have any problems or bugs using this plugin, please report them here:

<https://github.com/danawoodman/Google-SketchUp-Material-Changer/issues>


## Credits

This plug-in is written and maintained by [Dana Woodman](dana@danawoodman.com)

[Fugue Icons](http://www.iconfinder.com/search/?q=iconset%3Afugue) by [Yusuke Kamiyamane](http://p.yusukekamiyamane.com/).


## License

Released under the MIT License. See the `LICENCE` file for more information.
