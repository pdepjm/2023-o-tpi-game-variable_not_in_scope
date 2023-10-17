import wollok.game.*
import juego.*
import logo.*

class Obstaculo {
	
	var property position = game.at(game.width(),piso)
	
	method image() = "./assets/Espina.png"
	
	method aparecer(){
		game.addVisual(self)
		self.moverse()
	}
	
	method choque (){
		game.say(logo,"Perdiste")
		game.schedule(500,{game.stop()})	
	}
		
	
	method moverse() {
		game.onTick(velRetroceso,"espina",{
			self.position(position.left(1))
			if(self.position().x()==0){
				game.removeTickEvent("espina") 
				game.removeVisual(self)
			}
		})
	}
	
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
