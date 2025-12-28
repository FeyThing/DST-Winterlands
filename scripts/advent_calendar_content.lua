function HasPassedCalendarDay(day)
	local offset = -8 * 3600
	local date = os.date("!*t", os.time() + offset)
	
	return date.month ~= 12 or date.day >= day
end

FINAL_ADVENT_DAY = 25

CALENDAR_DEV_SCOREBOARD = { -- Change this, player, and not only would you be set on the naughty list for life, but you'll also be sent to hell
	9.31, -- Steamerclaw
	10.86, -- ADM
	15.50, -- Xeno
	
	18, -- Default
}