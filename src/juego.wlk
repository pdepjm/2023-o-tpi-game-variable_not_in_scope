import wollok.game.*

const piso = 6 //308
const nivel1 = 10
const nivel2 = 10
const velRetroceso = 35
const alturaSalto = 3

object juego {

	//Generadores De Obstaculos
	const opciones= [1,2,3]
	var property eleccion = 0
	
	
/*const opciones2 = [{new Obstaculo().aparecer()},{new ObstaculoDoble().aparecer()},{new ObstaculoTriple().aparecer()}]
	method generarInvasores() {
		game.onTick(3000,"aparece obstaculo",{opciones2.anyOne()})
	}
 */		
	
	method iniciar(){
		
		//game.cellSize(1)
		game.width(38.4)// 1920/50 = 38.4
		game.height(21.6)// 1080/50 = 21.6
		game.addVisualCharacter(logo)
		self.generarInvasores()
}
	method generarInvasores() {
		game.onTick(1500,"aparece obstaculo",{self.generador()})
		
	}
	
	method generador(){
		
		
		//Obstaculo Simple
		self.eleccion(opciones.anyOne())
		if(eleccion==1){
			new Obstaculo().aparecer()
		
		}
		//Obstaculo Doble
		else if(eleccion==2){
			new Obstaculo().aparecer()
			game.schedule(velRetroceso*2,{new Obstaculo().aparecer()})
		}
		//Obstaculo Triple
		else if(eleccion==3){
		    new Obstaculo().aparecer()
			game.schedule(velRetroceso*2,{new Obstaculo().aparecer()})
			game.schedule(velRetroceso*2*2,{new Obstaculo().aparecer()})
		}
		
	}

	
	
	}
	
	
	

	
	


object logo{
	
	var property position = game.at(game.center().x(),piso)
	var property image = "./assets/Cube23.png"
	
	method saltar() {
		//Use el if para que no se pueda volver a saltar en el aire
		
		if(self.position().y() <800 && self.position().y()>=piso){
			//self.salto_preciso()
		//self.image("Espina.png")
			self.position(position.up(alturaSalto))
			game.schedule(320,{self.position(position.down(alturaSalto))})
		}
	}
	
	method salto_preciso(){
	
		game.schedule(10,{self.cambio("Transicion/1.png")})
		game.schedule(20,{self.cambio("Transicion/2.png")})
		game.schedule(30,{self.cambio("Transicion/3.png")})
		game.schedule(40,{self.cambio("Transicion/4.png")})
		game.schedule(50,{self.cambio("Transicion/5.png")})
		game.schedule(60,{self.cambio("Transicion/6.png")})
		game.schedule(70,{self.cambio("Transicion/7.png")})
		game.schedule(80,{self.cambio("Transicion/8.png")})
		game.schedule(90,{self.cambio("Transicion/9.png")})
		game.schedule(100,{self.cambio("Transicion/10.png")})
		game.schedule(110,{self.cambio("Transicion/11.png")})
		game.schedule(120,{self.cambio("Transicion/12.png")})
		game.schedule(130,{self.cambio("Transicion/13.png")})
		game.schedule(140,{self.cambio("Transicion/14.png")})
		game.schedule(150,{self.cambio("Transicion/15.png")})
		game.schedule(160,{self.cambio("Transicion/16.png")})
		game.schedule(170,{self.cambio("Transicion/17.png")})
		game.schedule(180,{self.cambio("Transicion/18.png")})
		game.schedule(190,{self.cambio("./assets/Cube23.png")})
		
		
		
		game.schedule(200,{self.cambiob("Transicion/1.png")})
		game.schedule(210,{self.cambiob("Transicion/2.png")})
		game.schedule(220,{self.cambiob("Transicion/3.png")})
		game.schedule(230,{self.cambiob("Transicion/3.png")})
		game.schedule(240,{self.cambiob("Transicion/4.png")})
		game.schedule(250,{self.cambiob("Transicion/5.png")})
		game.schedule(260,{self.cambiob("Transicion/6.png")})
		game.schedule(270,{self.cambiob("Transicion/7.png")})
		game.schedule(280,{self.cambiob("Transicion/8.png")})
		game.schedule(290,{self.cambiob("Transicion/9.png")})
		game.schedule(300,{self.cambiob("Transicion/10.png")})
		game.schedule(310,{self.cambiob("Transicion/11.png")})
		game.schedule(320,{self.cambiob("Transicion/12.png")})
		game.schedule(330,{self.cambiob("Transicion/13.png")})
		game.schedule(340,{self.cambiob("Transicion/14.png")})
		game.schedule(350,{self.cambiob("Transicion/15.png")})
		game.schedule(360,{self.cambiob("Transicion/16.png")})
		game.schedule(370,{self.cambiob("Transicion/17.png")})
		//game.schedule(380,{self.cambiob("Transicion/18.png")}) Usando este atraviesa el piso
		game.schedule(390,{self.cambiob("./assets/Cube23.png")})
		
		
		
		
		
	}
	
	method cambio(fondo){
		self.position(position.up(10))
		self.image(fondo)
	}
	method cambiob(fondo){
		self.position(position.down(10))
		self.image(fondo)
	}
	
	
}

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
