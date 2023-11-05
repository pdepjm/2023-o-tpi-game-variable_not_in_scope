import wollok.game.*
import player.*
import Obstaculo.*
import niveles.*
import config.*

class ContextException inherits wollok.lang.Exception {}

object juego {

	var property currentGameMode = nivelPiso

	
	method iniciar(){
		//game.cellSize(1)
		game.width(38.4)// 1920/50 = 38.4
		game.height(21.6)// 1080/50 = 21.6
		game.addVisualCharacter(player)
		game.addVisualCharacter(portal)
		game.addVisualCharacter(portalRotado)
		game.addVisualCharacter(inicio)
		game.addVisualCharacter(pressEnter)
		portal.offBoard()
		portalRotado.offBoard()
		
		
		//esperando a que se presione enter
		keyboard.enter().onPressDo({
			
			game.removeVisual(pressEnter)
			game.removeVisual(inicio)
			const cancion = game.sound("./assets/cancion.mp3")
			cancion.shouldLoop(true)
			cancion.play()
			self.currentGameMode().iniciar()
			 
		})
		
	}
	
	method perder(){
		game.schedule(config.loseDelay(),{game.stop()})
		game.addVisual(perder_logo)	
		game.say(player, "auch!")
	}
	
}



object pressEnter{
	var property position = game.at(game.center().x()-3, game.center().y())
	var property image = "./assets/press_enter.png"
}

object inicio{
	var property position = game.origin()
	var property image = "./assets/inicio.jpg"
}

object perder_logo{
	
	
	var property position = game.origin()
	var property image = "./assets/roto.png"
	
}


