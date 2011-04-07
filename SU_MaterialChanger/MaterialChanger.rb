# TODO: Performance improvements. I'm sure the recursion I'm doing here isn't 
# needed. Get material changes working faster for large groups of entities.

class SU_ChangeMaterial
  
  # Intialize the class by creating instance variables that we will use later.
  def initialize
    @model = Sketchup.active_model
    @selection = @model.selection
    @materials = @model.materials.sort # Sort materials alphabetically.
    @material_names = @materials.collect { |m| m.name }
    @material_display_names = @materials.collect { |m| m.display_name }
    @new_face_material = nil
    @new_back_material = nil
    @debug = MATERIAL_CHANGER_DEBUG
  end
  
  # Method to change the material of a given entity, depending on whether or 
  # not it is a face and what the value of the new back material and face 
  # material are.
  def change_material(entity)
    
    # Define the typename of the entity (e.g. "Face", "Group", etc...) so 
    # we can do different things based on the type.
    etype = entity.typename
    
    puts "\nentity: #{entity}" if @debug
    puts "etype: #{etype}" if @debug
    
    # See if the entity is a face, group, component or something else. If the 
    # entity is a face we will change it's face and back material. If it is a 
    # group/component, lets loop through each entity in the group/component and 
    # recurse through this method to find all the faces within it.
    case etype
      
      when "Face"
          
        # Check to see if there is a new face material for the entity, if so 
        # change the material.
        if @new_face_material
          entity.material = @new_face_material
          puts "Face (#{entity}) face material changed to #{@new_face_material}" if @debug
        end
        
        # Check to see if there is a new back material for the entity, if so 
        # change the material.
        if @new_back_material
          entity.back_material = @new_back_material
          puts "Face (#{entity}) back material changed to #{@new_face_material}" if @debug
        end
        
      when "Edge"
        
        # Check to see if there is a new face material for the entity, if so 
        # change the material.
        if @new_face_material
          # Edges can have a face material but not a back material, so let's 
          # just give the edge the face material.
          entity.material = @new_face_material
          puts "Edge (#{entity}) material changed to #{@new_face_material}" if @debug
        end
        
      when "Group"
        
        # Check to see if there is a new face material for the entity, if so 
        # change the material.
        if @new_face_material
          # Groups can have a face material but not a back material, so let's 
          # just give the group the face material.
          entity.material = @new_face_material
          puts "Group (#{entity}) material changed to #{@new_face_material}" if @debug
        end
        
        # Since this is a group, we need to now recurse through it to get all 
        # the entities within it.
        entity.entities.each { |e| change_material(e) }
        
      when "ComponentInstance"
        
        # Check to see if there is a new face material for the entity, if so 
        # change the material.
        if @new_face_material
          # Components can have a face material but not a back material, so let's 
          # just give the component the face material.
          entity.material = @new_face_material
          puts "Component (#{entity}) material changed to #{@new_face_material}" if @debug
        end
        
        # Since this is a component, we need to now recurse through it to get all 
        # the entities within it.
        entity.entities.each { |e| change_material(e) }
      
      else
        
        # Another entity was found that does not have a 
        # material property, do nothing...
        puts "An entity was found that cannot have a material property..." if @debug
      
    end
    
  end
  
  # The main function for the class. This is what you would call when you 
  # want to show the change material dialog.
  def run
    
    # If there are no materials in the model, then prompt the user of this 
    # problem and close out of the action because we can't assign materials 
    # if they don't exist.
    if @materials.length == 0
      
      result = UI.messagebox "You have no materials in your model. For this plugin to work, you need to have a material in your model.", MB_OK
      
      if result == 1
        puts "User has no materials in their model, cancel the action." if @debug
        return
      end
      
    end
    
    # If the selection is empty, prompt the user if they want us to select 
    # everything in the model.
    if @selection.empty?
      
      puts "Selection was empty, ask user if they want to select everything in model..." if @debug
      
      result = UI.messagebox "You did not select anything, do you want to select everything in the model?", MB_YESNO
      
      # If they choose yes, then let's select everything
      if result == 6 # Yes
        
        puts "User chose to select everything in the model, selecting everything now..." if @debug
        
        # If there are no entities in the model, return with an error because 
        # for this plugin to work they need at least one entity.
        if @model.entities.length
          
          no_entities_message = UI.messagebox "There are no entities in your model. Create at least one entity before using this plugin.", MB_OK
          return
        
        # There is at least one entity to select in the model.
        else
        
          # Selects everything in the model.
          @selection.add @model.entities.to_a
          
        end
        
      # They chose not to select anything, which means we have nothing to change 
      # the material of, so let's quit out of the action.
      else
        puts "User chose to not select everything, cancel out of action..." if @debug
        return
      end
      
    end
    
    # Collect all the entities within the selection. This gathers all 
    # entities within the selection, not just the parent entity.
    @selection_entities = @selection.collect { |e| e }
    
    puts "@selection_entities:\n#{@selection_entities}" if @debug

    # Create the input box's prompts.
    prompts = ["Face Material", "Back material"]
    # TODO: Make this dynamic based on if all selected materials are the same.
    
    # Create a list of all the material display names in the model and add 
    # the default value to it so we can know whether or not the user wanted to 
    # change the material of a face or back.
    materials_list = @material_display_names.unshift("Leave unchanged....")
    materials_piped_list = materials_list.join("|")
    
    # Create the input box's default as the newly added default value. This 
    # is used as the default choice in the drop-down list of materials.
    defaults = [materials_list.first, materials_list.first]
    
    # Add the material list that has been "piped". This is used for the 
    # drop-down list of possible values.
    list = [materials_piped_list, materials_piped_list]
    
    puts "\n@selection: \n #{@selection}" if @debug
    puts "prompts:\n#{(prompts).to_a}\n" if @debug
    puts "defaults:\n#{(defaults).to_a}\n" if @debug
    puts "materials_list:\n#{(materials_list).to_a}\n" if @debug
    puts "list:\n #{(list).to_a}" if @debug
    
    # Create the inputbox with the above prompts and values.
    results = inputbox prompts, defaults, list, "Change Materials of Selection"
    
    puts "\nresults: #{results}" if @debug
    
    # Return if the input box was closed or cancelled.
    return if not results
    
    # Construct the new face and back materials, if selected.
    new_face_material_index = @material_display_names.index(results[0])
    new_back_material_index = @material_display_names.index(results[1])
    @new_face_material = materials_list.first == results[0] ? nil : @material_names[new_face_material_index - 1]
    @new_back_material = materials_list.first == results[1] ? nil : @material_names[new_back_material_index - 1]
    
    puts "\n@new_face_material: #{@new_face_material}" if @debug
    puts "@new_back_material: #{@new_back_material}" if @debug
    
    # If there is no change in the face and back materials, exit out of 
    # the action.
    if @new_face_material || @new_back_material
      
      puts "\nA new face or back material was selected." if @debug
      
      # Change the material for each entity in the selection.
      @model.start_operation "Change Materials" # Wrap up everything in one UNDO action.

        puts "\nChanging the material for each item in the selection..." if @debug

        @selection_entities.each { |s| change_material(s) }

      @model.commit_operation
    
    else
      
      puts "No new face or back material selected." if @debug
      
    end
    
  end
  
end


if ( not file_loaded?(File.join(MATERIAL_CHANGER_BASE_PATH, "SU_MaterialChanger/MaterialChanger.rb")) )
  
  # Create the Change Material command.
  change_materials_cmd = UI::Command.new("Change Materials") { 
    SU_ChangeMaterial.new().run()
  }
  change_materials_cmd.small_icon = File.join(MATERIAL_CHANGER_BASE_PATH, "SU_MaterialChanger/images/material_changer_small.png")
  change_materials_cmd.large_icon = File.join(MATERIAL_CHANGER_BASE_PATH, "SU_MaterialChanger/images/material_changer_large.png")
  change_materials_text = "Change Materials"
  change_materials_cmd.tooltip = change_materials_text
  change_materials_cmd.menu_text = change_materials_text
  change_materials_cmd.status_bar_text = change_materials_text
  
  # Create and add the Change Material submenu item to the Edit menu.
  utils_submenu = UI.menu("Edit").add_item change_materials_cmd
  
  # Create and add the context menu shortcuts.
  UI.add_context_menu_handler do |context_menu|
    context_menu.add_separator
    context_menu.add_item change_materials_cmd
  end
  
  # Create and add the Change Material toolbar item.
  change_materials_toolbar = UI::Toolbar.new("Change Materials")
  change_materials_toolbar.add_item change_materials_cmd
  # Only show the toolbar if it was not explicity closed last session.
  if change_materials_toolbar.get_last_state != 0
    change_materials_toolbar.show  
  end
  
end

file_loaded(File.join(MATERIAL_CHANGER_BASE_PATH, "SU_MaterialChanger/MaterialChanger.rb"))
