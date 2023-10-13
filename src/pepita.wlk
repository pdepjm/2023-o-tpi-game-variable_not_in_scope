import wollok.game.*

object juego {

	method iniciar(){
		
	
		  
  		game.cellSize(1)
		game.width(1920)
		game.height(1080)
		game.addVisualCharacter(logo)
		self.generarInvasores()
}
	method generarInvasores() {
		game.onTick(3000,"aparece obstaculo",{new Obstaculo().aparecer()})
	}
	}
	

	
	


object logo{
	
	var property position = game.at(game.center().x(),100)
	method image() = "Cube23.png"
	
	method saltar() {
		//Use el if para que no se pueda volver a saltar en el aire
		
		if(self.position().y() <200){
		self.position(position.up(100))
		game.schedule(200,{self.position(position.down(100))})
		}
	}

	
}

class Obstaculo {
	
	var property position = game.at(game.width(),100)
	method image() = "Espina.png"
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
			game.removeVisual(self)
		}else{
			game.onTick(0.5,"espina",{self.position(position.left(60))})
		}
	}
}