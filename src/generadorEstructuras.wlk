import wollok.game.*
import config.*
import Obstaculo.*
import player.*

object onTickIdHandler{
	var id = 0
	method newID(){
		id++
		if(id==1024){
			id=0
		}
		return "desplazable"+id.toString()
	} 
}

object generador {

	//se utiliza para guardar la altura de un bloque generado en el modo de juego 3
	var altura_anterior=game.height()/2
	
	method generarPinchos(altura, deltaT) {
		
		//aparecer sucesivamente pinchos en <altura>
		game.onTick(config.frecuenciaPinchos(),"aparece pincho",{
			
			const cantidadPinchos = new Range(start = 1, end = 3).anyOne()
			cantidadPinchos.times({
				n=>game.schedule(config.velRetroceso()*n,{
					const ontickID = onTickIdHandler.newID()
					new Obstaculo(image = config.imgEspina()).aparecer(altura, ontickID)
				})
			})
			
		})
		
		game.schedule(deltaT-config.frecuenciaPinchos(),{
			game.removeTickEvent("aparece pincho")
		})
		
	}

	
	method generarBloquesAleatorios(){
		
		//aparecer sucesivamente bloques en posiciones aleatorias
		game.onTick(config.frecuenciaBloques(), "aparece bloque", {
			const ontickID = onTickIdHandler.newID()
			const altura = self.randomEntre(config.alturaPiso(), game.height()-1, altura_anterior)
			new Obstaculo(image = config.imgBloque()).aparecer(altura, ontickID)
			altura_anterior=altura
			
		})
		
		game.schedule(config.tiempoNave()-config.frecuenciaBloques(),{game.removeTickEvent("aparece bloque") })
		
	}
	
	// Sirve para garantizar dispersion entre los bloques obstaculo de generarBloques
	method randomEntre(piso, techo, rand_anterior){
		var rand = piso.randomUpTo(techo).truncate(0)
		if((rand-rand_anterior).abs()<config.blockDistance()){
			rand = self.randomEntre(piso, techo, rand_anterior)
		}
		return rand
	}
	
	method generarPlataforma(){
		
		//aparecer sucesivamente bloques que hagan de plataforma
		game.onTick(config.velRetroceso(),"aparecer piso",{
			const baldosa = new Plataforma(image=config.imgBloque())
			const ontickID = onTickIdHandler.newID()
			baldosa.aparecer(
				config.alturaPlataforma()-1,
				ontickID
			)
		})
		
		//quiero que el personaje suba a la plataforma cuando aparece
		game.schedule(config.velRetroceso()*(game.width()-(config.x()-7)), {
			player.entity().position(game.at(config.x(),config.alturaPlataforma()))
		})
		
		game.schedule(config.tiempoPlataforma(),{
			game.removeTickEvent("aparecer piso")
		})
		
	}
	
	method generarColumnas(){
		
		const numeros = [2, 1]
		var alturaAleatoria = 0
		
		//aparecer sucesivamente columnas
		game.onTick(config.frecuenciaColumna(), "generar columna", {
			
			alturaAleatoria = numeros.anyOne()
			const ontickID = onTickIdHandler.newID()
			if(alturaAleatoria==1){
				new Obstaculo(image = config.imgColumna()).aparecer(config.alturaPiso(), ontickID)
			}else if (alturaAleatoria==2){
				const anotherOnTickID = onTickIdHandler.newID()
				new Obstaculo(image = config.imgColumna()).aparecer(config.columnaAlta(), ontickID)
				new Obstaculo(image = config.imgBloque()).aparecer(config.alturaPiso()+config.techo(), anotherOnTickID)
			}
			
		})
		
		game.schedule(config.tiempoArania()-config.frecuenciaColumna(),{
			game.removeTickEvent("generar columna")
		})
		
	}
	
	//Fin del objeto generador
}
