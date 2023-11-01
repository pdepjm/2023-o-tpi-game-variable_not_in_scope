import wollok.game.*
import logo.*
import Obstaculo.*
import niveles.*
import config.*

class ContextException inherits wollok.lang.Exception {}

object juego {

	var property cantidadPinchos = 0
	var property alturaAleatoria = 0
	var modoJuego=2 //usar solo para niveles secuenciales

	//se utiliza para guardar la altura de un bloque generado en el modo de juego 3
	var altura_anterior=game.height()/2

	
	method iniciar(){
		//game.cellSize(1)
		game.width(38.4)// 1920/50 = 38.4
		game.height(21.6)// 1080/50 = 21.6
		game.addVisualCharacter(logo)
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
			 self.timepoEnArania()
			 game.schedule(config.tiempoArania()+10,{self.tiempoEnElPiso()})
			 
		})
		
	}

	//ELegir Modo De Juego

	method seleccionar(){
		/*randomized
		modoJuego = new Range(start = 1, end = 3).anyOne()
		 */
		 
		
		if(modoJuego==1){
			self.tiempoEnElPiso()
			modoJuego++
			return config.piso()
		}else if(modoJuego==2){
			modoJuego++
			self.tiempoEnPlataforma()
			return config.nivel2()
		}else if(modoJuego==3){
			modoJuego=1
			self.tiempoEnNave()
			return config.nivel3()
		}
		else{
			throw new ContextException(message = "Invalid gamemode")
		}
		
	}
	
	//Generadores 
	method generarPinchos(altura) {
		game.onTick(config.frecuenciaPinchos(),"aparece obstaculo",{self.generadorPinchos(altura)})
		
	}
	
	
	
	method generadorPinchos(altura){
		cantidadPinchos = new Range(start = 1, end = 3).anyOne()
		cantidadPinchos.times({ n=>game.schedule(config.velRetroceso()*n,{ new Pincho().aparecer(altura) }) })
	}
	
	method generarBloques(){
		game.onTick(config.frecuenciaBloques(), "aparece obstaculo", {self.generadorBloques()})
	}
	
	// Sirve para garantizar dispersion entre los bloques obstaculo
	method randomEntre(piso, techo, rand_anterior){
		var rand = piso.randomUpTo(techo).truncate(0)
		if((rand-rand_anterior).abs()<config.blockDistance()){
			rand = self.randomEntre(piso, techo, rand_anterior)
		}
		return rand
	}
	
	method generadorBloques(){
		//const altura = 1.randomUpTo(game.height()-1).truncate(0)
		const altura = self.randomEntre(config.piso(), game.height()-1, altura_anterior)
		new Bloque().aparecer(altura)
		altura_anterior=altura
	}
	
			method generarColumna(){
		game.onTick(config.frecuenciaColumna(), "columna", {self.generadorColumna()})
	}

		method generadorColumna(){
		
		const numeros = [2, 1]
		self.alturaAleatoria(numeros.anyOne())
		
		if(self.alturaAleatoria()==1){
			new Columna().aparecer(config.piso())
		}else if (self.alturaAleatoria()==2){
			new Columna().aparecer(config.columnaAlta())
			new Bloque().aparecer(config.piso()+config.techo())
		}
}
	

//Modos De Juego
	
	method tiempoEnElPiso(){
		
		game.schedule(0,{self.generarPinchos(config.piso())})
		game.schedule(config.tiempoPiso()-config.frecuenciaPinchos(),{game.removeTickEvent("aparece obstaculo") })
		
		var next_gamemode_height //altura a la que deba aparecer el portal
		
		game.schedule(config.tiempoPiso(), {
			next_gamemode_height = self.seleccionar()
			portal.nextHeight(next_gamemode_height)
		})
		
		game.schedule(config.tiempoPiso(),{portal.aparecer(config.piso())})
		
	}
	
	
	
	
	method tiempoEnPlataforma(){
		
		game.onTick(config.velRetroceso(),"crear piso",{
			const cuadrado = new Plataforma(position=game.at(game.width(),config.nivel2()-1))
			cuadrado.aparecer()
		})

		game.schedule(config.frecuenciaPinchos(),{self.generarPinchos(config.nivel2())})
		game.schedule(config.tiempoArriba()-config.frecuenciaPinchos(),{game.removeTickEvent("aparece obstaculo") })
		game.schedule(config.tiempoArriba(),{game.removeTickEvent("crear piso") })
	
	
		var next_gamemode_height
	
		game.schedule(config.tiempoArriba(), {
			next_gamemode_height = self.seleccionar()
			portal.nextHeight(next_gamemode_height)
		})
		
		game.schedule(config.tiempoArriba(),{portal.aparecer(config.nivel2())})
	
	}
	
	
	method timepoEnArania(){
		logo.entity(arania)
		arania.moverse()
		game.schedule(0,{self.generarColumna()})
		game.schedule(config.tiempoArania()-config.frecuenciaColumna(),{game.removeTickEvent("columna") })
		game.schedule(config.tiempoArania(),{self.estructuraFinal() })
		
}
	method estructuraFinal(){
		portal.aparecer(config.piso())
		new Columna().aparecer(config.columnaAlta())
		new Bloque().aparecer(config.piso()+config.techo())
	}
	
	
	
	
	
	method tiempoEnNave(){
		
		game.schedule(config.frecuenciaBloques(),{self.generarBloques()})
		game.schedule(config.tiempoNave()-config.frecuenciaBloques(),{game.removeTickEvent("aparece obstaculo") })
		
		var next_gamemode_height
		
		game.schedule(config.tiempoNave(), {
			next_gamemode_height = self.seleccionar()
			portalRotado.nextHeight(next_gamemode_height)
		})
		
		game.schedule(config.tiempoNave(),{portalRotado.aparecer(config.piso())})
	
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

object perder{
	
	
	var property position = game.origin()
	var property image = "./assets/roto.png"
	
}

object destello{
		var property image = "./assets/brillos/brillo1.png"
		var property position = game.origin()
		method brillar(){
		game.addVisual(self)
		game.schedule(0.2,{self.image("./assets/brillos/brillo1.png")})
		game.schedule(0.5,{self.image("./assets/brillos/brillo2.png")})
		game.schedule(0.8,{self.image("./assets/brillos/brillo3.png")})
		game.schedule(1,{self.image("./assets/brillos/brillo4.png")})
		game.schedule(1.4,{self.image("./assets/brillos/brillo3.png")})
		game.schedule(1.9,{self.image("./assets/brillos/brillo2.png")})
		game.schedule(2.4,{self.image("./assets/brillos/brillo1.png")})
		game.removeVisual(self)
	}	
	}


//Generador Antiguo
/*method generador(){
		
		
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
*/
	


/*
object eliminador{
	var property position = game.at(0,piso)
	var property image = "./assets/eliminador.png"
}
 */
 
 
 

