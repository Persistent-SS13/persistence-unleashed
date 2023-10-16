/jukebox //abstraction of music player behavior for jukeboxes, headphones, etc
	var/atom/owner
	var/sound_id
	var/datum/sound_token/token
	var/list/tracks
	var/index = 1
	var/volume = 20
	var/volume_max = 50
	var/volume_step = 10
	var/frequency = 1
	var/range = 7
	var/falloff = 1
	var/template
	var/ui_title
	var/ui_width
	var/ui_height
	var/playing


/jukebox/New(atom/_owner, _template, _ui_title, _ui_width, _ui_height)
	. = ..()
	if (QDELETED(_owner) || !isatom(_owner))
		qdel(src)
		return
	owner = _owner
	tracks = list()
	for (var/path in GLOB.jukebox_tracks)
		var/singleton/audio/track/track = GET_SINGLETON(path)
		AddTrack(track.display || track.title, track.source)
	sound_id = "[/jukebox]_[sequential_id(/jukebox)]"
	template = _template
	ui_title = _ui_title
	ui_width = _ui_width
	ui_height = _ui_height


/jukebox/Destroy()
	QDEL_NULL_LIST(tracks)
	QDEL_NULL(token)
	owner = null
	. = ..()


/jukebox/proc/AddTrack(title = "Track [length(tracks) + 1]", source)
	tracks += new /jukebox_track (title, source)


/jukebox/proc/ClearTracks()
	QDEL_NULL_LIST(tracks)
	tracks = list()


/jukebox/proc/Next()
	if (++index > length(tracks))
		index = 1
	if (playing)
		Stop()
		Play()


/jukebox/proc/Last()
	if (--index < 1)
		index = length(tracks)
	if (playing)
		Stop()
		Play()


/jukebox/proc/Track(_index)
	_index = text2num(_index)
	if (!IsInteger(_index))
		return
	index = clamp(_index, 1, length(tracks))
	if (playing)
		Stop()
		Play()


/jukebox/proc/Stop()
	playing = FALSE
	QDEL_NULL(token)
	owner.queue_icon_update()


/jukebox/proc/Play()
	if (playing)
		return
	var/jukebox_track/track = tracks[index]
	if (!track.source)
		return
	playing = TRUE
	token = GLOB.sound_player.PlayLoopingSound(owner, sound_id, track.source,
		volume, range, falloff, frequency = frequency, prefer_mute = TRUE)
	owner.queue_icon_update()


/jukebox/proc/Volume(_volume)
	_volume = text2num(_volume)
	if (!isfinite(_volume))
		return
	if (_volume >= 0)
		volume = min(_volume, volume_max)
	else if (_volume == -1)
		volume = max(volume - volume_step, 0)
	else if (_volume == -2)
		volume = min(volume + volume_step, volume_max)
	if (token)
		token.SetVolume(volume)


/jukebox/nano_host()
	return owner


/jukebox/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui, force_open = TRUE, datum/topic_state/state = GLOB.default_state)//, datum/topic_state/state = GLOB.jukebox_state)
	var/list/data_tracks = list()
	for (var/i = 1 to length(tracks))
		var/jukebox_track/track = tracks[i]
		data_tracks += list(list("track" = track.title, "index" = i))
	var/jukebox_track/track = tracks[index]
	var/list/data = list(
		"track" = track.title,
		"playing" = playing,
		"volume" = volume,
		"tracks" = data_tracks
	)
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new (user, src, ui_key, template, ui_title, ui_width, ui_height, state = state)
		ui.set_initial_data(data)
		ui.open()


/jukebox/Topic(href, href_list)
	switch ("[href_list["act"]]")
		if ("next") Next()
		if ("last") Last()
		if ("stop") Stop()
		if ("play") Play()
		if ("volume") Volume("[href_list["dat"]]")
		if ("track") Track("[href_list["dat"]]")
	return TOPIC_REFRESH



/jukebox_track
	var/title
	var/source


/jukebox_track/New(_title, _source, _volume)
	title = _title
	source = _source



GLOBAL_LIST_INIT(jukebox_tracks, list(
/singleton/audio/track/jukebox/ambiaesthetic/deepend,
/singleton/audio/track/jukebox/ambiaesthetic/falling,
/singleton/audio/track/jukebox/ambiaesthetic/flutegrass,
/singleton/audio/track/jukebox/ambiaesthetic/mysteriousfigure,
/singleton/audio/track/jukebox/ambiaesthetic/radiance,
/singleton/audio/track/jukebox/ambiaesthetic/rainyday,
/singleton/audio/track/jukebox/ambiaesthetic/tropicalmystery,
/singleton/audio/track/jukebox/ambiaesthetic/twilightmarket,
/singleton/audio/track/jukebox/ambiaesthetic/whatnow,
/singleton/audio/track/jukebox/amptunes/battlesarrived,
/singleton/audio/track/jukebox/amptunes/blastnight,
/singleton/audio/track/jukebox/amptunes/enguard,
/singleton/audio/track/jukebox/amptunes/enemyinbound,
/singleton/audio/track/jukebox/amptunes/instructions,
/singleton/audio/track/jukebox/amptunes/sonice,
/singleton/audio/track/jukebox/amptunes/standproud,
/singleton/audio/track/jukebox/amptunes/wegotthis,
/singleton/audio/track/jukebox/classirelaxi/beachvibes,
/singleton/audio/track/jukebox/classirelaxi/chilledtunes,
/singleton/audio/track/jukebox/classirelaxi/chillestyouvebeen,
/singleton/audio/track/jukebox/classirelaxi/countrysideending,
/singleton/audio/track/jukebox/classirelaxi/countrysidemanner,
/singleton/audio/track/jukebox/classirelaxi/endingmarch,
/singleton/audio/track/jukebox/classirelaxi/happyending,
/singleton/audio/track/jukebox/classirelaxi/museumtour,
/singleton/audio/track/jukebox/electroswing/detectivemolasses,
/singleton/audio/track/jukebox/electroswing/jungleshuffle,
/singleton/audio/track/jukebox/electroswing/malljustice,
/singleton/audio/track/jukebox/electroswing/withoutacare,
/singleton/audio/track/jukebox/newhip/ballgame,
/singleton/audio/track/jukebox/newhip/clubhouse,
/singleton/audio/track/jukebox/newhip/dancingwithdrums,
/singleton/audio/track/jukebox/newhip/mafia,
/singleton/audio/track/jukebox/novelaud/charmingbeauty,
/singleton/audio/track/jukebox/novelaud/daylight,
/singleton/audio/track/jukebox/novelaud/hogsofwar,
/singleton/audio/track/jukebox/novelaud/makesmecry,
/singleton/audio/track/jukebox/novelaud/property,
/singleton/audio/track/jukebox/oldworld/arrmate,
/singleton/audio/track/jukebox/oldworld/classicalblues,
/singleton/audio/track/jukebox/oldworld/classydinner,
/singleton/audio/track/jukebox/oldworld/cornerstore,
/singleton/audio/track/jukebox/oldworld/futuristicdance,
/singleton/audio/track/jukebox/oldworld/modernblues,
/singleton/audio/track/jukebox/oldworld/piratelover,
/singleton/audio/track/jukebox/oldworld/sexyromance,
/singleton/audio/track/jukebox/oldworld/tango,
/singleton/audio/track/jukebox/royaljams/canon,
/singleton/audio/track/jukebox/royaljams/conte,
/singleton/audio/track/jukebox/royaljams/elise,
/singleton/audio/track/jukebox/royaljams/savior,
/singleton/audio/track/jukebox/royaljams/stan,
/singleton/audio/track/jukebox/royaljams/weddingmarch,
/singleton/audio/track/jukebox/royaljams/yuan,
/singleton/audio/track/jukebox/slovibe/barman,
/singleton/audio/track/jukebox/slovibe/deserttown,
/singleton/audio/track/jukebox/slovibe/diningwithfriends,
/singleton/audio/track/jukebox/slovibe/mindboggler,
/singleton/audio/track/jukebox/slovibe/southernwalk,
/singleton/audio/track/jukebox/technopop/assistanceneeded,
/singleton/audio/track/jukebox/technopop/citywalker,
/singleton/audio/track/jukebox/technopop/dusk,
/singleton/audio/track/jukebox/technopop/gameafoot,
/singleton/audio/track/jukebox/technopop/intothefuture,
/singleton/audio/track/jukebox/technopop/purejoy,
/singleton/audio/track/jukebox/technopop/rising,
/singleton/audio/track/jukebox/technopop/undergroundrave,
/singleton/audio/track/jukebox/technopop/technopirate,
/singleton/audio/track/jukebox/xianxinxiao/beginning,
/singleton/audio/track/jukebox/xianxinxiao/ending,
/singleton/audio/track/jukebox/xianxinxiao/middle
))
