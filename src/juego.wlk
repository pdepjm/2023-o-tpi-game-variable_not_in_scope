import wollok.game.*
import logo.*
import Obstaculo.*

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
