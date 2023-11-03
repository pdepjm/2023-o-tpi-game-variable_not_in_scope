import wollok.game.*
import juego.*
import player.*
import config.*
import niveles.onTickIdHandler

const portalesInvisiblesOnTick = []

const portalesInvisiblesByOnTick = new Dictionary()

class Desplazable {
	
	var property position = game.at(game.width(),config.alturaPiso())
	
	var property image //pasar por parametro
	
	method aparecer(altura, ontickID)
	
	method choque ()
		
	
	method moverse(altura, ontickID) {
		game.onTick(config.velRetroceso(),ontickID,{
			self.position(game.at(self.position().x()-1,altura))
			if(self.position().x()==2){
				game.removeTickEvent(ontickID) 
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
	
	override method aparecer(altura, ontickID){
		game.addVisual(self)
		self.moverse(altura, ontickID)
	}
}

class Plataforma inherits Desplazable {
	
	override method choque ()= 0
	
	override method aparecer(altura, ontickID){
		game.addVisual(self)
		self.moverse(altura, ontickID)
	}

}

class Portal inherits Desplazable{
		
	//ya se genero como visual previamente, ahora solo se coloca en la pantalla
	override method aparecer(altura, ontickID){
		self.position(game.at(game.width(),altura))
		self.moverse(altura, ontickID)
	}
	
	override method moverse(altura, ontickID){
		game.onTick(config.velRetroceso(),ontickID,{
			self.position(game.at(self.position().x()-1,altura))
			if(self.position().x()==2){
				game.removeTickEvent(ontickID) 
				self.offBoard()
			}
		})
	}
	
	override method choque(){
		
		//se le debe preguntar a juego cual es el modo que se esta jugando ahora
		const siguienteModoJuego = juego.currentGameMode().siguienteNivel()
		juego.currentGameMode(siguienteModoJuego)
		
		siguienteModoJuego.iniciar()
		
	}
	
}

const portal = new Portal(image = config.imgPortal())

class PortalRotado inherits Portal{
	
	override method aparecer(nivel, ontickID){
		self.position(game.at(game.width(),nivel))
		10.times({i=>
			const onTickID = onTickIdHandler.newID()
				portalesInvisiblesOnTick.add(onTickID) //luego realizar foreach eliminar el ontick
			const nuevo_portal = new PortalInvisible()
				portalesInvisiblesByOnTick.put(onTickID, nuevo_portal)
			game.addVisualCharacter(nuevo_portal)
			nuevo_portal.aparecer(nivel+2*i+1, onTickID)
		})
		self.moverse(nivel, ontickID)
	}
	
	override method choque(){}

}

const portalRotado = new PortalRotado(image = config.imgPortalRotado())

class PortalInvisible{
	
	//var property image = config.imgPortalRotado()
	
	var property position = game.at(game.width(),config.alturaPiso())
	
		//ya se genero como visual previamente, ahora solo se coloca en la pantalla
	method aparecer(altura, ontickID){
		self.position(game.at(game.width(),altura))
		self.moverse(altura, ontickID)
	}
	
	method choque(){
		
		game.removeTickEvent("movimiento nave")
		
		portalesInvisiblesOnTick.forEach({ontickID=>
			game.removeTickEvent(ontickID) 
				const portal_invisible = portalesInvisiblesByOnTick.get(ontickID)
			game.removeVisual(portal_invisible)
		})
		portalesInvisiblesOnTick.clear()
		portalesInvisiblesByOnTick.clear()
		
		//se le debe preguntar a juego cual es el modo que se esta jugando ahora
		const siguienteModoJuego = juego.currentGameMode().siguienteNivel()

		siguienteModoJuego.iniciar()
		
	}
	
	method moverse(altura, ontickID){
		game.onTick(config.velRetroceso(),ontickID,{
			self.position(game.at(self.position().x()-1,altura))
			if(self.position().x()==2){
				game.removeTickEvent(ontickID) 
				game.removeVisual(self)
			}
		})
	}
}

