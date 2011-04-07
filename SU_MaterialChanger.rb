#-----------------------------------------------------------------------------
#
# Copyright 2010 Dana Woodman, Phoenix Woodworks. All Rights Reserved.
#
# Permission to use, copy, modify, and distribute this software for
# any purpose and without fee is hereby granted, provided the above
# copyright notice appear in all copies.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
#
#-----------------------------------------------------------------------------
#
# Name        : Material Changer
# Based On    : n/a
# Type        : Tool
# Author      : Dana Woodman
# Email       : <dana@danawoodman.com>
# Website     : https://github.com/danawoodman/Google-SketchUp-Material-Changer
# Blog        : 
#
# Maintenance : Please report all bugs or strange behavior to <dana@danawoodman.com>
#
# Version     : 1.0
#
# Menu Items  : Edit -> Change Material
#
# Toolbar     : Change Material - Includes one large and one small icon.
#
# Context-Menu: Change Material
#
# Description : Changes materials of selected entities.
#             
#             : When the tool is activated, a pop-up dialog appears asking you 
#             : to select the face and back materials for the selection.
#
# To Install  : Place the SU_MaterialChanger.rb Ruby script and the 
#             : `SU_MaterialChanger` directory in the SketchUp Plugins folder.
#-----------------------------------------------------------------------------

require 'sketchup.rb'
require 'extensions.rb'

# Turns on or off debugging in the SU_ChangeMaterial Class.
MATERIAL_CHANGER_DEBUG = false
MATERIAL_CHANGER_BASE_PATH = File.dirname(__FILE__)

# Register plugin as an extension.
material_changer_extension = SketchupExtension.new "Material Changer", File.join(MATERIAL_CHANGER_BASE_PATH, "SU_MaterialChanger/MaterialChanger.rb")
material_changer_extension.version = '1.0'
material_changer_extension.creator = 'Dana Woodman'
material_changer_extension.copyright = '2010-2011'
material_changer_extension.description = "Changes materials of selected entities."
Sketchup.register_extension material_changer_extension, true
