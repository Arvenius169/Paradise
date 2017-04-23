/obj/structure/dresser
	name = "dresser"
	desc = "A nicely-crafted wooden dresser. It's filled with lots of undies."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "dresser"
	density = 1
	anchored = 1
	burn_state = FLAMMABLE
	burntime = 25

/obj/structure/dresser/attack_hand(mob/user as mob)
	if(!Adjacent(user))//no tele-grooming
		return
	if(ishuman(user) && anchored)
		var/mob/living/carbon/human/H = user

		var/choice = input(user, "Underwear, Undershirt, or Socks?", "Changing") as null|anything in list("Underwear","Undershirt","Socks")

		if(!Adjacent(user))
			return
		switch(choice)
			if("Underwear")
				var/list/valid_underwear = list()
				for(var/underwear in underwear_list)
					var/datum/sprite_accessory/S = underwear_list[underwear]
					if(!(H.species.name in S.species_allowed))
						continue
					valid_underwear[underwear] = underwear_list[underwear]
				var/new_underwear = input(user, "Choose your underwear:", "Changing") as null|anything in valid_underwear
				if(new_underwear)
					H.underwear = new_underwear

			if("Undershirt")
				var/list/valid_undershirts = list()
				for(var/undershirt in undershirt_list)
					var/datum/sprite_accessory/S = undershirt_list[undershirt]
					if(!(H.species.name in S.species_allowed))
						continue
					valid_undershirts[undershirt] = undershirt_list[undershirt]
				var/new_undershirt = input(user, "Choose your undershirt:", "Changing") as null|anything in valid_undershirts
				if(new_undershirt)
					H.undershirt = new_undershirt

			if("Socks")
				var/list/valid_sockstyles = list()
				for(var/sockstyle in socks_list)
					var/datum/sprite_accessory/S = socks_list[sockstyle]
					if(!(H.species.name in S.species_allowed))
						continue
					valid_sockstyles[sockstyle] = socks_list[sockstyle]
				var/new_socks = input(user, "Choose your socks:", "Changing")  as null|anything in valid_sockstyles
				if(new_socks)
					H.socks = new_socks

		add_fingerprint(H)
		H.update_body()

/obj/structure/dresser/attackby(obj/item/weapon/W, mob/living/user, params)
	add_fingerprint(user)
	user.changeNext_move(CLICK_CD_MELEE)
	if(iswrench(W))
		if(anchored)
			playsound(loc, W.usesound, 100, 1)
			user.visible_message("[user] is loosening the [name]'s bolts.", \
								 "<span class='notice'>You are loosening the [name]'s bolts...</span>")
			if(do_after(user, 40 * W.toolspeed, target = src))
				if(!loc || !anchored)
					return
				user.visible_message("[user] loosened the [name]'s bolts!", \
									 "<span class='notice'>You loosen the [name]'s bolts!</span>")
				anchored = 0
		else
			if(!isfloorturf(loc))
				user.visible_message("<span class='warning'>A floor must be present to secure the [name]!</span>")
				return
			playsound(loc, W.usesound, 100, 1)
			user.visible_message("[user] is securing the [name]'s bolts...", \
								 "<span class='notice'>You are securing the [name]'s bolts...</span>")
			if(do_after(user, 40 * W.toolspeed, target = src))
				if(!loc || anchored)
					return
				user.visible_message("[user] has secured the [name]'s bolts.", \
									 "<span class='notice'>You have secured the [name]'s bolts.</span>")
				anchored = 1
//		return ..()