import wollok.game.*
import juego.*
import player.*
import config.*


class Desplazable {
	
	var property position = game.at(game.width(),config.alturaPiso())
	
	var property image = "" //pasar por parametro
	
	method aparecer(altura)
	
	method choque ()
		
	
	method moverse(altura) {
		game.onTick(config.velRetroceso(),"desplazamiento",{
			self.position(game.at(self.position().x()-1,altura))
			if(self.position().x()==2){
				game.removeTickEvent("desplazamiento") 
				game.removeVisual(self)
			}
		})
	}
	
	//solo lo usan los portales, para "desaparecer", saliendo de la pantalla
	method offBoard(){
		self.position(game.at(game.width(),25))
	}
	
	method autoelminarse(){
				game.removeVisual(self)
	}
	method atravesar(some_number){
				return 0
	}
	
}

//portal es un chocable con metodo chocar distinto
class Obstaculo inherits Desplazable{
	override method choque (){
		game.say(player,"Perdiste")
		
		game.schedule(config.loseDelay(),{game.stop()})
		game.addVisual(perder)	
	}
	
	override method aparecer(altura){
		game.addVisual(self)
		self.moverse(altura)
	}
}

class Plataforma inherits Desplazable {
	
	override method choque ()= 0
	
	override method aparecer(altura){
		game.addVisual(self)
		self.moverse(altura)
	}

}

class Portal inherits Desplazable{
		
	//ya se genero como visual previamente, ahora solo se coloca en la pantalla
	override method aparecer(altura){
		self.position(game.at(game.width(),altura))
		self.moverse(altura)
	}
	
	override method moverse(altura){
		game.onTick(config.velRetroceso(),"desplazar portal",{
			self.position(game.at(self.position().x()-1,altura))
			if(self.position().x()==2){
				game.removeTickEvent("desplazar portal") 
				self.offBoard()
			}
		})
	}
	
	override method choque(){
		
		//se le debe preguntar a juego cual es el modo que se esta jugando ahora
		const siguienteModoJuego = juego.currentGameMode().siguienteNivel()
		juego.currentGameMode(siguienteModoJuego)
		
		player.entity(siguienteModoJuego.entity())
		player.entity().position(game.at(config.x(),siguienteModoJuego.altura()))
		siguienteModoJuego.iniciar()
		
	}
	
}

const portal = new Portal(image = config.imgPortal())

class PortalRotado inherits Portal{
	
	override method aparecer(nivel){
		self.position(game.at(game.width(),nivel))
		12.times({i=>
			const nuevo_portal = new PortalInvisible(position = game.at(game.width(),nivel+i+4))
			game.addVisualCharacter(nuevo_portal)
			nuevo_portal.aparecer(nivel+i)
		})
		self.moverse(nivel)
	}

}

const portalRotado = new PortalRotado(image = config.imgPortalRotado())

class PortalInvisible inherits Portal{
	override method moverse(altura){
		game.onTick(config.velRetroceso(),"mover portal invisible",{
			self.position(game.at(self.position().x()-1,altura))
			if(self.position().x()==2){
				game.removeTickEvent("mover portal invisible") 
				game.removeVisual(self)
			}
		})
	}
}

