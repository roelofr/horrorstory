
-- Cry of Fear Lantern
resource.AddWorkshop( 132470017 )

local Workshop = {}
table.insert( Workshop, {
	id = 104578853,
	maps = {
		"death_of_the_dream3",
		"anotherscreamer",
		"death_of_the_dream",
		"death_of_the_dream2",
		"death_of_the_dream3",
		"gm_hellsresort",
		"horror_experiment",
		"nightmansion",
		"nightmansion2",
		"scary_united_coop",
		"screamer",
		"screamer_v2"
	}
})
table.insert( Workshop, {
	id = 127328627,
	maps = {
		"gm_nightmare_church_rc3"
	}
})
table.insert( Workshop, {
	id = 132010781,
	maps = {
		"sm_nightville_complete_v2"
	}
})
table.insert( Workshop, {
	id = 104526521,
	maps = {
		"gm_deathhouse"
	}
})

local match, wid = false, 0
local cmap = string.lower( game.GetMap() )

for _, workshopitem in ipairs( Workshop ) do		
	for _, map in pairs( workshopitem.maps ) do		
		if string.lower( map ) == cmap then
			match = true
			wid = workshopitem.id
		end
	end
end

Workshop = nil

if match then
	resource.AddWorkshop( wid )
	print( "[Horror Story] Mounting addon " .. wid .. " from workshop. contains loaded map." )
end

resource.AddFile( "materials/horrorstory/skin/HorrorStory.png" )

resource.AddFile( "materials/horrorstory/gradient.png" )
resource.AddFile( "materials/horrorstory/logo_settings.png" )
resource.AddFile( "materials/horrorstory/pixel.png" )

resource.AddFile( "materials/horrorstory/bartypes/angry.png" )
resource.AddFile( "materials/horrorstory/bartypes/cool.png" )
resource.AddFile( "materials/horrorstory/bartypes/firstaid_1.png" )
resource.AddFile( "materials/horrorstory/bartypes/firstaid_2.png" )
resource.AddFile( "materials/horrorstory/bartypes/firstaid_3.png" )
resource.AddFile( "materials/horrorstory/bartypes/firstaid_4.png" )
resource.AddFile( "materials/horrorstory/bartypes/happy.png" )
resource.AddFile( "materials/horrorstory/bartypes/hysterical.png" )
resource.AddFile( "materials/horrorstory/bartypes/laugh.png" )
resource.AddFile( "materials/horrorstory/bartypes/pirate.png" )
resource.AddFile( "materials/horrorstory/bartypes/sad.png" )
resource.AddFile( "materials/horrorstory/bartypes/shock.png" )
resource.AddFile( "materials/horrorstory/bartypes/surprise.png" )

resource.AddFile( "materials/horrorstory/gradients/blue.png" )
resource.AddFile( "materials/horrorstory/gradients/blue_v.png" )
resource.AddFile( "materials/horrorstory/gradients/drag_32.png" )
resource.AddFile( "materials/horrorstory/gradients/drag_32_v.png" )
resource.AddFile( "materials/horrorstory/gradients/green.png" )
resource.AddFile( "materials/horrorstory/gradients/green_v.png" )
resource.AddFile( "materials/horrorstory/gradients/red.png" )
resource.AddFile( "materials/horrorstory/gradients/red_v.png" )
resource.AddFile( "materials/horrorstory/gradients/yellow.png" )
resource.AddFile( "materials/horrorstory/gradients/yellow_v.png" )