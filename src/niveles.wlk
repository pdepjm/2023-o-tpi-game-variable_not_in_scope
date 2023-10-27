import wollok.game.*
import logo.*
import Obstaculo.*
import juego.*
import config.*




object portal{
	var property position = game.at(game.width(),config.piso())
	
	var property nextHeight = 0
	
	method image() = "./assets/portal.jpg"
	
	method offBoard(){
		self.position(game.at(game.width(),25))
	}
	
	method aparecer(nivel){
		self.position(game.at(game.width(),nivel))
		//game.addVisual(self)
		self.moverse(nivel)
	}
		
	method moverse(nivel) {
		game.onTick(config.velRetroceso(),"portal",{self.autoControl(nivel)})
	}
	
	method autoControl(nivel){
			
		self.position(game.at(self.position().x()-1,nivel))
		
		if(self.position().x()==0){
			game.removeTickEvent("portal") 
			self.offBoard()
				
		}
			
	}
	
	method choque() = return 0
	
}

object portalRotado{
	var property position = game.at(game.width(),config.piso())
	
	var property nextHeight = 0
	
	method image() = "./assets/portal_rotado.png"
	
	method offBoard(){
		self.position(game.at(game.width(),28))
	}
	
	method aparecer(nivel){
		self.position(game.at(game.width(),nivel))
		15.times({i=>
			const nuevo_portal = new PortalInvisible(position = game.at(game.width(),nivel+i+4))
			game.addVisualCharacter(nuevo_portal)
			nuevo_portal.aparecer(nivel+i)
		})
		self.moverse(nivel)
	}
		
	method moverse(nivel) {
		game.onTick(config.velRetroceso(),"portalRotado",{self.autoControl(nivel)})
	}
	
	method autoControl(nivel){
			
		self.position(game.at(self.position().x()-1,nivel))
		
		if(self.position().x()==2){
			game.removeTickEvent("portalRotado") 
			self.offBoard()
				
		}
			
	}
	
	method choque() = return 0
	
}

class PortalInvisible{
	var property position = game.at(game.width(),config.piso())
	
	method aparecer(nivel){
		self.position(game.at(game.width(),nivel))
		game.onCollideDo(self,{
			algo=>
				const new_height = portalRotado.nextHeight() //tomara la siguiente altura del portal rotado
				algo.atravesar(new_height)
		})
		self.moverse(nivel)
	}
		
	method moverse(nivel) {
		game.onTick(config.velRetroceso(),"portalInvisible",{self.autoControl(nivel)})
	}
	
	method autoControl(nivel){
			
		self.position(game.at(self.position().x()-1,nivel))
		
		if(self.position().x()==2){
			game.removeTickEvent("portalInvisible") 
			game.removeVisual(self)
				
		}
			
	}
	
	method choque() = return 0
	
}

class Plataforma {
	var property position
	
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



