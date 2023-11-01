import wollok.game.*
import juego.*
import Obstaculo.*
import config.*



object logo{
	
	var property entity = cube
	
	method position() = entity.position()
	
	method image() = entity.image()
	
	method saltar(){
		entity.saltar()
	}
	
	
	method atravesar(new_height){

		if(new_height==config.nivel3() && !(entity.isShip())){
			entity.position(game.at(config.x(),new_height))
			entity = ship
			entity.moverse()
		}
		else if (new_height!=config.nivel3() && !(entity.isShip())){
			entity.position(game.at(config.x(),new_height))
			entity = cube
		}
		else if(self.entity()==arania){
			self.entity(cube)
		}
		else if (new_height!=config.nivel3() && entity.isShip()){
			entity.position(game.at(config.x(),new_height))
			game.removeTickEvent("movimiento")	
			entity = cube
		}
		else if(!(entity.isShip())){
			
			entity = arania
		}

	}
	
	
}

object cube {
	
	var property position = game.at(config.x(),config.piso())


	var property image = "./assets/Cube23.png"
	
	method saltar() {
		//Use el if para que no se pueda volver a saltar en el aire
		
		if(self.position().y() <800 && self.position().y()>=config.piso()){
			//self.salto_preciso()
		//self.image("Espina.png")
			self.position(position.up(config.alturaSalto()))
			game.schedule(320,{self.position(position.down(config.alturaSalto()))})
		}
	}
	
	method isShip()=false
	
}

object arania {
	
	var property position = game.at(config.x(),config.piso())
	
	var property image = "./assets/arania/arania1-1.png"
	
	var property paso = 0
	
	var property pisoActual = 0
	
	method saltar() {
		//self.position().y(config.columnaAlta()+300)
		game.removeTickEvent("movimiento arania")	
		
		if(self.pisoActual()==0){
			self.position(position.up(config.techo()))
			game.onTick(config.velRetroceso(),"movimiento arania",{self.trepar()})
			self.pisoActual(1)
		
		}else{
			self.position(position.down(config.techo()))
			game.onTick(config.velRetroceso(),"movimiento arania",{self.caminar()})
			self.pisoActual(0)
			
		}
		
		
		
	
		
	
	}
	

	method moverse(){
		self.pisoActual(0)
		game.onTick(config.velRetroceso(),"movimiento arania",{self.caminar()})
	}
	
	method caminar(){
		if(self.paso()==0){
			self.image("./assets/arania/arania1-1.png")
			self.paso(1)	
			
		}else{
			self.image("./assets/arania/arania2-1.png")
			self.paso(0)
		}
		}
	method trepar(){
		
			if(self.paso()==0){
			self.image("./assets/arania/arania1-2.png")
			self.paso(1)	
			
		}else{
			self.image("./assets/arania/arania2-2.png")
			self.paso(0)	
	}}
	
	method isShip()=false
	
}

object ship {
	
	var property position = game.at(config.x(),config.nivel3())
	
	const image_vector = ["./assets/triangle_ship_down.png", "./assets/triangle_ship_up.png"]

	var property image = image_vector.get(0)
	
	var movement_direction = -1
	
	method moverse(){
		game.onTick(config.velRetroceso(),"movimiento",{self.autoControl()})
	}
	
	method autoControl(){
		self.position(game.at(self.position().x(),self.position().y()+movement_direction))
		const y_position = self.position().y()
		if(y_position==game.height() || y_position==config.piso()){
			self.choque()
		}
	}
	
	method saltar(){
		if(movement_direction==-1){
			self.image(image_vector.get(1))			
		}else{
			self.image(image_vector.get(0))
		}
		movement_direction*=-1
	}
	
	method choque(){
		game.say(logo,"Perdiste")
		game.schedule(config.loseDelay(),{game.stop()})
		game.addVisual(perder)	
	}
	
	method isShip()=true
	
}



