------- global changes -------

NotificationService = function()
    local ServiceMetatable = {cache = {}}

    ServiceMetatable.AddNotification = function(self, text, logo, glow_color)
        self.cache[#self.cache + 1] = {RemovalTime = globals.realtime + 4, Text2Render = text, Logo2Render = logo, AlphaRender = 0.00001, TextSizeCLC = render.measure_text(1, nil, text), GlowColor = glow_color, AlreadyRemoving = false}
    end

    ServiceMetatable.RenderAllNotifications = function(self)
        local PositionY = 1

        for NotificationId = #self.cache, 1, -1 do
            local NotificationData = self.cache[NotificationId]

            local RemovalTime = NotificationData.RemovalTime
            local Text2Render = NotificationData.Text2Render
            local Logo2Render = NotificationData.Logo2Render
            local AlphaRender = NotificationData.AlphaRender
            local TextSizeCLC = NotificationData.TextSizeCLC
            local GlowColor = NotificationData.GlowColor

            local Appending = (RemovalTime - globals.realtime) > 2

            if #self.cache - NotificationId > 5 and RemovalTime - globals.realtime > 0.3 and not NotificationData.AlreadyRemoving then
                self.cache[NotificationId].RemovalTime = globals.realtime + 0.3
                NotificationData.AlreadyRemoving = true
            end

            if AlphaRender == 0 then
                table.remove(self.cache, NotificationId)
                goto CBO
            end

            --PositionY = PositionY + AlphaRender*

            local m = {math.floor(TextSizeCLC.x * 1.03), math.floor(TextSizeCLC.y * 1.03)}
            local o = {TextSizeCLC.x, TextSizeCLC.y}
            local p = {global.sc.x * 0.5 - m[1] * 0.5 + 3, global.sc.y - global.sc.y / 50 * 13.4 + PositionY}

            render.shadow(vector(p[1] + m[1] * 0.5 - o[1] * 0.5 - 21, p[2] + 150), vector(p[1] + m[1] * 0.5 - o[1] * 0.5, p[2] + 171), color(GlowColor.r, GlowColor.g, GlowColor.b, AlphaRender * 255), 25, 1, 3)
            render.shadow(vector(p[1] + m[1] * 0.5 - o[1] * 0.5 + 6, p[2] + 150), vector(p[1] + m[1] * 0.5 - o[1] * 0.5 + o[1] + 15, p[2] + 171), color(GlowColor.r, GlowColor.g, GlowColor.b, AlphaRender * 255), 25, 1, 3)

            render.rect(vector(p[1] + m[1] * 0.5 - o[1] * 0.5 - 21, p[2] + 150), vector(p[1] + m[1] * 0.5 - o[1] * 0.5, p[2] + 171), color(3, AlphaRender * 255), 3)
            render.rect(vector(p[1] + m[1] * 0.5 - o[1] * 0.5 + 6, p[2] + 150), vector(p[1] + m[1] * 0.5 - o[1] * 0.5 + o[1] + 16, p[2] + 171), color(3, AlphaRender * 255), 3)

            render.push_clip_rect(vector(p[1] + m[1] * 0.5 - o[1] * 0.5 - 21, p[2] + 150 + (21 * (globals.realtime - RemovalTime + 3.5) / 4)), vector(p[1] + m[1] * 0.5 - o[1] * 0.5, p[2] + 171))
            render.text(1, vector(p[1] + m[1] * 0.5 - o[1] * 0.5 - 10, p[2] + 160), color(GlowColor.r, GlowColor.g, GlowColor.b, AlphaRender * 255), 'c', ui.get_icon(Logo2Render))
            render.pop_clip_rect()

            render.text(1, vector(p[1] + m[1] * 0.5 - o[1] * 0.5 - 11, p[2] + 160), color(GlowColor.r, GlowColor.g, GlowColor.b, AlphaRender * 80), 'c', ui.get_icon(Logo2Render))

            render.text(1, vector(p[1] + m[1] * 0.5 + 12, p[2] + 160), color(250, AlphaRender * 255), 'c', Text2Render)

            PositionY = PositionY - 30 - 15 * (Appending and AlphaRender - 1 or 1 - AlphaRender)

            --Alpha Modulation
            self.cache[NotificationId].AlphaRender = Appending and math.clamp((globals.realtime - RemovalTime + 4) * 4, 0.00001, 1) or math.clamp((RemovalTime - globals.realtime) * 4, 0, 1)
            ::CBO::
        end
    end

    return ServiceMetatable
end

_G.GlobalNotificationService = NotificationService()

events.render(function() GlobalNotificationService:RenderAllNotifications() end)


