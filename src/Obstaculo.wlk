import wollok.game.*
import juego.*
import player.*
import config.*
import generadorEstructuras.onTickIdHandler

const portalesInvisiblesOnTick = []

const portalesInvisiblesByOnTick = new Dictionary()

class Desplazable {
	
	var property position = game.at(game.width(),config.alturaPiso())
	
	method aparecer(altura, ontickID){
		game.addVisual(self)
		self.moverse(altura, ontickID)
	}
	
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
	
}

class Obstaculo inherits Desplazable{
	
	var property image //pasar por parametro
	
	override method choque (){
		juego.perder()
	}

}

class Plataforma inherits Desplazable {
	
	var property image //pasar por parametro
	
	override method choque (){}

}

class Portal inherits Desplazable{
	
	var property image //pasar por parametro
	
	override method choque(){
		
		//se le debe preguntar a juego cual es el modo que se esta jugando ahora
		const siguienteModoJuego = juego.currentGameMode().siguienteNivel()
		juego.currentGameMode(siguienteModoJuego)
		
		siguienteModoJuego.iniciar()
		
	}
	
}

class PortalRotado inherits Desplazable{
	
	var property image //pasar por parametro
	
	override method aparecer(nivel, ontickID){
		
		super(nivel, ontickID)
		12.times({i=>
			const onTickID = onTickIdHandler.newID()
				portalesInvisiblesOnTick.add(onTickID) //luego realizar foreach eliminar el ontick
			const nuevo_portal = new PortalInvisible()
				portalesInvisiblesByOnTick.put(onTickID, nuevo_portal)
			nuevo_portal.aparecer(nivel+i+1, onTickID)
		})
		
	}
	
	override method choque(){}

}

class PortalInvisible inherits Desplazable{

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

