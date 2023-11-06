import wollok.game.*
import player.*
import Obstaculo.*
import juego.*
import config.*
import generadorEstructuras.generador

class Nivel{
		
	const property altura
	
	const property entity
	
	const property siguienteNivel
	
	method iniciar() //override this
	
}

object nivelPiso inherits Nivel (altura = config.alturaPiso(), entity = cube, siguienteNivel = nivelPlataforma){
	
	override method iniciar() {
		
		//setear dato para que lo use el portal al switchear
		juego.currentGameMode(self)
		
		//player configs
		player.entity(self.entity())
		player.entity().position(game.at(config.x(),altura))
		
		generador.generarPinchos(altura, config.tiempoPiso())
		
		game.schedule(config.tiempoPiso(),{
			new Portal(image = config.imgPortal()).aparecer(altura, "aparecerPortal")
		})
		
	}
	
}

object nivelPlataforma inherits Nivel (altura = config.alturaPlataforma(), entity = cube, siguienteNivel = nivelNave){
	
	override method iniciar() {
		
		//setear dato para que lo use el portal al switchear
		juego.currentGameMode(self)
		
		//player configs
		player.entity(self.entity())
		
		generador.generarPlataforma()
		generador.generarPinchos(altura, config.tiempoPlataforma()) //tal vez aparezcan muy rapido

		game.schedule(config.tiempoPlataforma(),{
			new Portal(image = config.imgPortal()).aparecer(altura, "aparecerPortal")
		})	
		
	}
	
}

object nivelNave inherits Nivel (altura = config.alturaNave(), entity = ship, siguienteNivel = nivelArania){
	
	override method iniciar() {
		
		//setear dato para que lo use el portal al switchear
		juego.currentGameMode(self)
		
		//player configs
		self.entity().movement_direction(-1) //comenzar moviendose hacia abajo
		player.entity(self.entity())
		player.entity().position(game.at(config.x(),altura))
		
		ship.moverse()
	
		generador.generarBloquesAleatorios()
		
		game.schedule(config.tiempoNave(),{
			new PortalRotado(image = config.imgPortalRotado()).aparecer(config.alturaPiso(), "aparecerPortal")
		})
		
	}
	
}

object nivelArania inherits Nivel (altura = config.alturaPiso(), entity = arania, siguienteNivel = nivelPiso){
	
	override method iniciar() {
		
		//setear dato para que lo use el portal al switchear
		juego.currentGameMode(self)
		
		//player configs
		player.entity(self.entity())
		player.entity().position(game.at(config.x(),altura))
	
		arania.moverse()
		
		generador.generarColumnas()
		
		game.schedule(config.tiempoArania(),{
			new Portal(image = config.imgPortal()).aparecer(altura, "aparecerPortal")
			new Obstaculo(image = config.imgColumna()).aparecer(config.columnaAlta(), "ultimaColumna")
			new Obstaculo(image = config.imgBloque()).aparecer(altura+config.techo(), "ultimoObstaculo")
		})
		
	}
	
}



