import wollok.game.*
import juego.*
import player.*
import config.*
import generadorEstructuras.onTickIdHandler

const portalesInvisiblesOnTick = []

const portalesInvisiblesByOnTick = new Dictionary()

class Desplazable {
	
	var property position = game.at(game.width(),config.alturaPiso())
	
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

class Obstaculo inherits Desplazable{
	
	var property image //pasar por parametro
	
	override method choque (){
		juego.perder()
	}
	
	override method aparecer(altura, ontickID){
		game.addVisual(self)
		self.moverse(altura, ontickID)
	}
}

class Plataforma inherits Desplazable {
	
	var property image //pasar por parametro
	
	override method choque (){}
	
	override method aparecer(altura, ontickID){
		game.addVisual(self)
		self.moverse(altura, ontickID)
	}

}

class Portal inherits Desplazable{
	
	var property image //pasar por parametro
		
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
		12.times({i=>
			const onTickID = onTickIdHandler.newID()
				portalesInvisiblesOnTick.add(onTickID) //luego realizar foreach eliminar el ontick
			const nuevo_portal = new PortalInvisible()
				portalesInvisiblesByOnTick.put(onTickID, nuevo_portal)
			game.addVisualCharacter(nuevo_portal)
			nuevo_portal.aparecer(nivel+i+1, onTickID)
		})
		self.moverse(nivel, ontickID)
	}
	
	override method choque(){}

}

const portalRotado = new PortalRotado(image = config.imgPortalRotado())

class PortalInvisible inherits Desplazable{
	
	//var property position = game.at(game.width(),config.alturaPiso())

	override method aparecer(altura, ontickID){
		self.position(game.at(game.width(),altura))
		self.moverse(altura, ontickID)
	}

	override method choque(){
		
		game.removeTickEvent("movimiento nave")
		
		//eliminar todos los portales invisibles
		portalesInvisiblesOnTick.forEach({ontickID=>
			game.removeTickEvent(ontickID) 
				const portal_invisible = portalesInvisiblesByOnTick.get(ontickID)
			game.removeVisual(portal_invisible)
		}) //y eliminarlos de las listas
		portalesInvisiblesOnTick.clear()	//listas de ontickID
		portalesInvisiblesByOnTick.clear()	//diccionario
		
		//se le debe preguntar a juego cual es el modo que se esta jugando ahora
		const siguienteModoJuego = juego.currentGameMode().siguienteNivel()

		siguienteModoJuego.iniciar()
		
	}
	
}

