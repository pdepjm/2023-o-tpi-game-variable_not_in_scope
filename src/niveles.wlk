import wollok.game.*
import logo.*
import Obstaculo.*
import juego.*
import config.*




object portal{
		var property position = game.at(game.width(),config.piso())
		
		method image() = "./assets/portal.jpg"
		
		method aparecer(nivel){
		self.position(game.at(game.width(),nivel))
		game.addVisual(self)
		self.moverse(nivel)
	}
		
		method moverse(nivel) {
		game.onTick(config.velRetroceso(),"portal",{self.autoControl(nivel)})
	}
	
	method autoControl(nivel){
			
				self.position(game.at(self.position().x()-1,nivel))
				
				if(self.position().x()==0){
				game.removeTickEvent("portal") 
				game.removeVisual(self)
				
			}
			
	}
	
	method choque() = return 0
	
}



class Plataforma {
	var property position = game.at(game.width(),config.nivel2())
	
	method image() = "./assets/bloque.png"
	
	method aparecer(){
		game.addVisual(self)
		self.moverse()
	}
	
		method moverse() {
		game.onTick(config.velRetroceso(),"plataforma",{self.autoControl()})
	}
	
	method autoControl(){
			
				self.position(position.left(1))
				
				if(self.position().x()==0){
				game.removeTickEvent("plataforma") 
				game.removeVisual(self)
				
			}
			
	}
}



