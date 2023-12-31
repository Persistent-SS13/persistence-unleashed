/client/proc/spawn_chemdisp_cartridge(size in list("small", "medium", "large"))
	set name = "Spawn Chemical Dispenser Cartridge"
	set category = "Admin"

	var/reagent
	reagent = select_subpath(/datum/reagent, /datum/reagent)

	var/obj/item/reagent_containers/chem_disp_cartridge/C
	switch(size)
		if("small") C = new /obj/item/reagent_containers/chem_disp_cartridge/small(usr.loc)
		if("medium") C = new /obj/item/reagent_containers/chem_disp_cartridge/medium(usr.loc)
		if("large") C = new /obj/item/reagent_containers/chem_disp_cartridge(usr.loc)
	C.reagents.add_reagent(reagent, C.volume)
	var/datum/reagent/R = reagent
	C.setLabel(initial(R.name))
	log_and_message_admins("spawned a [size] reagent container containing [reagent]")
