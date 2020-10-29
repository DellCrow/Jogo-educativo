//Controles
#region Controles
key_right = keyboard_check(ord("D"));	//direita
key_left = keyboard_check(ord("A"));	//esquerda
key_down = keyboard_check(ord("S"));	//baixo
key_jump = keyboard_check(vk_space);	//pula
key_run = keyboard_check(vk_lshift);   //corre
#endregion

//movimentação
#region movimentação

	#region velocidade vertical e horizontal

		var move = key_right - key_left;

		global.hspd = move * global.playerspd;

		global.vspd = global.vspd + grv;

#endregion

	#region troca sprite

		//ajusta a direção do sprite do jogador
		if global.hspd!=0 
			image_xscale = sign(global.hspd);
		//troca o sprite para o de corrida
		//if global.hspd!=0 
		//	sprite_index = spr_player_run;
			//troca o sprite para o de afk
		//else 
			sprite_index = spr_final_player_idle;

	#endregion

	#region dash
	
		//verifica se o jogador está tentando usar o dash pra direita
		if keyboard_check_pressed(vk_lcontrol) and key_right and candash {
		//verifica se é possivel usar o dash sem entrar em uma parede
			if !place_meeting(x+150,y,obj_wall) {
				x += 150;
				candash = false;
				alarm[1] = 45;
			}
			else if !place_meeting(x+125,y,obj_wall) {
				x += 125;
				candash = false;
				alarm[1] = 45;
			}
			else if !place_meeting(x+100,y,obj_wall) {
				x += 100;
				candash = false;
				alarm[1] = 45;
			}
			else if !place_meeting(x+75,y,obj_wall) {
				x += 75;
				candash = false;
				alarm[1] = 45;
			}
			else if !place_meeting(x+50,y,obj_wall) {
				x += 50;
				candash = false;
				alarm[1] = 45;
			}
			else if !place_meeting(x+25,y,obj_wall) {
				x += 25;
				candash = false;
				alarm[1] = 45;
			}
			else if !place_meeting(x+1,y,obj_wall) {
				x = x;
				candash = false;
				alarm[1] = 45;
			}
		}
	
		//verifica se o jogador está tentando usar o dash pra esquerda
		if keyboard_check_pressed(vk_lcontrol)  and key_left and candash{
		//verifica se é possível usar o dash sem entrar em uma parede
			if !place_meeting(x-150,y,obj_wall) {
				x -= 150;
				candash = false;
				alarm[1] = 45;
			}
			else if !place_meeting(x-125,y,obj_wall) {
				x -= 125;
				candash = false;
				alarm[1] = 45;
			}
			else if !place_meeting(x-100,y,obj_wall) {
				x -= 100;
				candash = false;
				alarm[1] = 45;
			}
			else if !place_meeting(x-75,y,obj_wall) {
				x -= 75;
				candash = false;
				alarm[1] = 45;
			}
			else if !place_meeting(x-50,y,obj_wall) {
				x -= 50;
				candash = false;
				alarm[1] = 45;
			}
			else if !place_meeting(x-25,y,obj_wall) {
				x -= 25;
				candash = false;
				alarm[1] = 45;
			}
			else if !place_meeting(x-1,y,obj_wall) {
				x = x;
				candash = false;
				alarm[1] = 45;
			}
		}
		
	#endregion

	#region correr
		
		//verifica se o jogador está tentando correr
		 if key_run
		 //altera a velocidade para a de corrida
			global.playerspd = 5*2;
		else
			global.playerspd = 5;
	
	#endregion



	#region colisão horizontal

		
		//confere se o jogador está tocando o objeto parede horizontalmente
		if place_meeting(x+global.hspd,y,obj_wall)
		{
			//enquanto não tocar o objeto parede horizontalmente
			while !place_meeting(x+sign(global.hspd),y,obj_wall)
			{
				x = x + sign(global.hspd);
			}
			
			while place_meeting(x+sign(global.hspd),y,obj_wall) 
				and place_meeting(x+sign(global.hspd),y,obj_step) 
					and !place_meeting(x,y-sign(global.hspd),obj_wall)
					{ 
						global.vspd = global.vspd - sign(global.hspd);
						y = y + global.vspd*400;
						
					}
			
			global.hspd = 0;
		}
		x = x + global.hspd;
		
	#endregion
	
	

	#region colisão vertical
	
		 //confere se o jogador está tocando o objeto parede verticalmente
		 if place_meeting(x,y+global.vspd,obj_wall)
		 {
			//enquanto não tocar o objeto parede verticalmente
			while !place_meeting(x,y+sign(global.vspd),obj_wall)
			{
				y = y + sign(global.vspd);
			}
			global.vspd = 0;
		 }
		y = y + global.vspd;

	#endregion

	#region pular

		//permite o pulo se o jogador estiver no chão
		if place_meeting(x,y+1,obj_wall) and key_jump and canjump and !key_down 
		{
			canjump = false;
			alarm[2] = 45;
			global.vspd -=13;		
		}

	#endregion

	#region queda acelerada

		//acelera a velocidade da queda
		if !place_meeting(x,y+1,obj_wall) and key_down and !key_jump
		{
				global.vspd += 13;
		}
		
	#endregion
	
	#region abaixar
		if keyboard_check(ord("S"))
			sprite_index = spr_player_down;
			
	#endregion

#endregion

//modo de ataque
#region modo
	
	//verifica se o jogador está querendo trocar o modo
	if keyboard_check_pressed(ord("Q")) and mode
		mode = false;
	else if keyboard_check_pressed(ord("Q"))
		mode = true;
	
#endregion

//ataque a distancia
#region a distancia
	
	//define a direção da flecha
	if global.hspd!=0{
			direcao = global.hspd;	
	}
	var arrow;
	//define a rotação da flecha
	rot = point_direction(x,y,mouse_x,mouse_y);

	//velocidade da flecha
	if mouse_check_button(mb_right) and mode{
		if global.arrow_speed < arrow_max_speed{
			global.arrow_speed += 0.3;	
		}
	}
	
	//verifica se o jogador quer disparar a flecha
	if mouse_check_button_pressed(mb_left) and mode{
		if (global.canshoot==true){
			alarm[0] = 50;
			//verifica se o jogador está mirando para a esquerda ou direita
			if (sign(mouse_x-x)>0)
			{
				image_xscale = sign(mouse_x-x);
				//cria a flecha na direita
				arrow = instance_create_depth(x+50,y-20,+1,obj_flecha);
			}
			else
			{
				image_xscale = sign(mouse_x-x);
				//cria a flecha na esquerda
				arrow = instance_create_depth(x-50,y-20,+1,obj_flecha);
			}
			arrow.direction = rot;
			arrow.image_angle = rot;
			arrow.gravity = 1;
			arrow.gravity_direction = 270;
			arrow.speed = global.arrow_speed;
			with arrow {
				motion_add(direction,global.arrow_speed)
			}
			global.arrow_speed = 6;
		}
	}
	
#endregion

//ataque corpo a corpo
#region corpo a corpo
	var melee;
	
	//verifica se o jogador está tentando atacar
	if mouse_check_button(mb_left) and !mode and canmelee
		//verifica em qual direção o jogador quer atacar
		if sign(mouse_x-x)>0
		{
			image_xscale = sign(mouse_x-x);
			melee = instance_create_depth(x+70,y-10,+1,obj_melee);
			melee.image_xscale = sign(mouse_x-x);
			canmelee = false;
			alarm[3] = 45;
		}
		else
		{
			image_xscale = sign(mouse_x-x);
			melee = instance_create_depth(x-70,y-10,+1,obj_melee);
			melee.image_xscale = sign(mouse_x-x);
			canmelee = false;
			alarm[3] = 45;
		}
#endregion