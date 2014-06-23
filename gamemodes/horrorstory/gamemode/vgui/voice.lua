--[[

VGUI control,
holds the hud

]]

PANEL = {}
function PANEL:Init( )
	self:SetDrawBackground( false )
	
	self.size = 32
	if ScrH() >= 1080 and ScrW() >= 1920 then
		self.size = 64
	end
	
	self.img = {}
	self.img.green = Material( "horrorstory/gradients/green.png" )
	self.img.red = Material( "horrorstory/gradients/red.png" )
	self.img.yellow = Material( "horrorstory/gradients/yellow.png" )
	self.img.blue = Material( "horrorstory/gradients/blue.png" )
	self.img.drag = Material( "horrorstory/gradients/drag" .. self.size .. ".png" )
	self.img.reset = Material( "horrorstory/pixel.png" )
	
	self.font = "DermaDefaultBold"
	if self.size == 64 then
		self.font = "DermaLarge"
	end
	
	self.players = {}
	
	self.avatarFrames = {}
	
	self.remeasure = 0
	
	self:InvalidateLayout( true )
end
function PANEL:Close()
	for _, frame in pairs( self.avatarFrames ) do
		if frame:IsValid() then
			frame:Remove()
		end
	end
 	self:Remove()
end
function PANEL:Paint( )
	surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
	
	
	local top = ScrH() * 0.8
	local margin, vmargin, rmargin = 8, 16, 16
	
	local qpi = math.pi * 0.5
	
	for _, row in ipairs( self.rows ) do
		if not row.visible then continue end
		
		local width = row.width + 16 + margin*3 + rmargin
		
		local left = ScrW() - width
		
		if row.add > RealTime() - 1 then
			local progress = math.Clamp( ( RealTime() - row.add ) - 0.3, 0, 0.5 ) * 2
			left = ScrW() - width * math.Clamp( math.sin( qpi * progress ), 0, 1 )
		elseif row.out < RealTime() + 1 then
			local progress = math.Clamp( ( RealTime() - row.out ), 0, 0.5 ) * 2
			left = ScrW() - width * math.Clamp( math.sin( qpi + qpi * progress ), 0, 1 )
			
			if row.out < RealTime() - 1.5 then
				row.visible = false
			end
			
		end
		
		local progress = math.Clamp( ( RealTime() - row.add ) / ( row.out - row.add ), 0, 1 )
		
		surface.SetMaterial( self.img[ row.color ] )
		surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
		surface.DrawRect( left, top, 16, self.size )
		surface.SetDrawColor( Color( 255, 255, 255, 100 ) )
		surface.DrawTexturedRect( left, top, width, self.size )
		
		surface.SetMaterial( self.img[ row.color ] )
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.DrawTexturedRect( left + 16, top, width - 16, self.size )
		
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.SetMaterial( self.img.drag )
		surface.DrawTexturedRect( left, top, 16, self.size )
		
		surface.SetDrawColor( Color( 255, 255, 255, 100 ) )
		surface.DrawRect( left + 16, top + self.size - 4, ( width - 16 ) * ( 1 - progress ), 4 )
		
		surface.SetTextColor( Color( 255, 255, 255, 255 ) )
		surface.SetTextPos( left + margin + 16, top + ( self.size - row.height )/2 )
		surface.SetFont( self.font )
		surface.DrawText( row.text )
		
		-- Move all other items above this one
		
		if row.out < RealTime() + 1 then
			local progress = ( math.Clamp( ( RealTime() - row.out ), 0.5, 1 ) - 0.5 ) / 0.5
			top = top - ( self.size + vmargin ) * math.Clamp( math.sin( qpi + qpi * 2 * progress ) + 1, 0, 2 ) / 2
		elseif row.add > RealTime() - 1 then
			local progress = math.Clamp( ( RealTime() - row.add ), 0, 0.5 ) * 2
			top = top - ( self.size + vmargin ) * ( 1 - math.Clamp( math.sin( qpi + qpi * 2 * progress ) + 1, 0, 2 ) / 2 )
		else
			top = top - self.size - vmargin
		end
		
	end
end
function PANEL:PerformLayout( )
	self:SetSize( ScrW(), ScrH() )
	self:SetPos( 0, 0 )
end
function PANEL:Think()
	if self.remeasure < CurTime() then
		self.remeasure = CurTime() + 0.4
		
		local checkValue = math.Rand( 1, 100 )
		
		for _, pl in pairs( player.GetHumans() ) do
			local key = pl:UniqueID()
			if self.players[ key ] != nil then
				self.players[ key ].salt = checkValue
				self.players[ key ].ply = pl
			else
				self.players[ key ] = {}
				self.players[ key ].salt = checkValue
				self.players[ key ].ply = pl
				
				local avatarFrame = vgui.Create( "AvatarImage", self )
				avatarFrame:SetPlayer( pl )
				avatarFrame:SetSize( 24, 24 )
				
				self.players[ key ].avatar = avatarFrame
				self.players[ key ].muted = pl:IsMuted()
			end
		end
		local newArr = {}
		for key, row in pairs( self.players ) do
			if row.salt == checkValue then
				table.insert( newArr, key, row )
			end
		end
		table.CopyFromTo( newArr, self.players )
		table.SortByKey( self.players )
	end
end
vgui.Register( "horrorstory_notifications", PANEL, "DPanel" )