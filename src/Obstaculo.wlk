import wollok.game.*
import juego.*
import logo.*
import config.*

class Obstaculo {
	
	
	
	var property position = game.at(game.width(),config.piso())
	
	method image()
	
	method aparecer(altura){
		game.addVisual(self)
		self.moverse(altura)
	}
	
	method choque (){
		game.say(logo,"Perdiste")
		game.schedule(config.loseDelay(),{game.stop()})
		game.addVisual(perder)	
	}
		
	
	method moverse(altura) {
		game.onTick(config.velRetroceso(),"espina",{self.autoControl(altura)})
	}
	
	method autoControl(altura){
			
				self.position(game.at(self.position().x()-1,altura))
				
				if(self.position().x()==2){
				game.removeTickEvent("espina") 
				game.removeVisual(self)
				
			}
			
	}
	
	method autoelminarse(){
	
				game.removeVisual(self)
	}
	method atravesar(some_number){
	
				return 0
	}
	
}

class Pincho inherits Obstaculo{
	override method image() = "./assets/Espina.png"
}

class Bloque inherits Obstaculo{
	override method image() = "./assets/bloque.png"
}


//La imagen solo choca en la esquina inferior izquierda
/*
class ObstaculoDoble{
	
	var property position = game.at(game.width(),piso)
	method image() = "./assets/EspinaDoble.png"
	method aparecer(){
		game.addVisual(self)
		self.moverse()
	}
	method choque (){
		game.say(logo,"Perdiste")
		game.schedule(500,{game.stop()})	
}
		
	
	method moverse() {
		if(position.x()==0){
			game.removeTickEvent("espina") 
			game.removeVisual(self)
		}else{
			game.onTick(velRetroceso,"espina",{self.position(position.left(30))})
		}
	}
	
}


class ObstaculoTriple{
	
	var property position = game.at(game.width(),piso)
	method image() = "./assets/EspinaTriple.png"
	method aparecer(){
		game.addVisual(self)
		self.moverse()
	}
	method choque (){
		game.say(logo,"Perdiste")
		game.schedule(500,{game.stop()})	
}
		
	
	method moverse() {
		if(position.x()==0){
			game.removeTickEvent("espina") 
			game.removeVisual(self)
		}else{
			game.onTick(velRetroceso,"espina",{self.position(position.left(30))})
		}
	}
	
}
*/
