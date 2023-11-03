import wollok.game.*
import player.*
import Obstaculo.*
import juego.*
import config.*

object generador{
	
	//se utiliza para guardar la altura de un bloque generado en el modo de juego 3
	var altura_anterior=game.height()/2
	
	method generarPinchos(altura, deltaT) {
		
		//aparecer sucesivamente pinchos en <altura>
		game.onTick(config.frecuenciaPinchos(),"aparece pincho",{
			
			const cantidadPinchos = new Range(start = 1, end = 3).anyOne()
			cantidadPinchos.times({
				n=>game.schedule(config.velRetroceso()*n,{
					new Obstaculo(image = config.imgEspina()).aparecer(altura)
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
			
			const altura = self.randomEntre(config.alturaPiso(), game.height()-1, altura_anterior)
			new Obstaculo(image = config.imgBloque()).aparecer(altura)
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
			const baldosa = new Plataforma(
				position=game.at(game.width(),config.alturaPlataforma()-1),
				image=config.imgBloque()
			)
			baldosa.aparecer()
		})
		
		game.schedule(config.tiempoPlataforma()-config.frecuenciaPinchos(),{
			game.removeTickEvent("aparecer piso")
		})
		
	}
	
	method generarColumnas(){
		
		const numeros = [2, 1]
		var alturaAleatoria = 0
		
		//aparecer sucesivamente columnas
		game.onTick(config.frecuenciaColumna(), "generar columna", {
			
			alturaAleatoria = numeros.anyOne()
			
			if(alturaAleatoria==1){
				new Obstaculo(image = config.imgColumna()).aparecer(config.alturaPiso())
			}else if (alturaAleatoria==2){
				new Obstaculo(image = config.imgColumna()).aparecer(config.columnaAlta())
				new Obstaculo(image = config.imgBloque()).aparecer(config.alturaPiso()+config.techo())
			}
			
		})
		
		game.schedule(config.tiempoArania()-config.frecuenciaColumna(),{
			game.removeTickEvent("generar columna")
		})
		
	}
	
	//Fin del objeto generador
}


object nivelPiso{
		
	const altura = config.alturaPiso()
	
	method entity() = cube
	
	method altura() = altura
	
	method iniciar(){
		
		generador.generarPinchos(altura, config.tiempoPiso())
		
		game.schedule(config.tiempoPiso(), {
			portal.nextHeight(config.alturaPlataforma())
		})
		
		game.schedule(config.tiempoPiso(),{portal.aparecer(altura)})
		
	}
	
	method siguienteNivel() = nivelPlataforma
	
}

object nivelPlataforma{
	
	const altura = config.alturaPlataforma()
	
	method entity() = cube
	
	method altura() = altura
	
	method iniciar(){
		generador.generarPlataforma()
	
		//game.schedule(config.frecuenciaPinchos(),{generador.generarPinchos(config.alturaPlataforma())})
		generador.generarPinchos(altura, config.tiempoPlataforma()) //tal vez aparezcan muy rapido
	
		game.schedule(config.tiempoPlataforma(), {
			portal.nextHeight(config.alturaNave())
		})
		
		game.schedule(config.tiempoPlataforma(),{portal.aparecer(altura)})	
	}
	
	method siguienteNivel() = nivelArania

}

object nivelArania{
		
	const altura = config.alturaPiso()
	
	method entity() = arania
	
	method altura() = altura
	
	method iniciar(){
	
		arania.moverse()
		
		generador.generarColumnas()
		
		game.schedule(config.tiempoArania(),{
			portal.aparecer(altura)
			new Obstaculo(image = config.imgColumna()).aparecer(config.columnaAlta())
			new Obstaculo(image = config.imgBloque()).aparecer(altura+config.techo())
		})

	}
	
	method siguienteNivel() = nivelNave
	
}

object nivelNave{
		
	const altura = config.alturaNave()
	
	method entity() = ship
	
	method altura() = altura

	method iniciar(){
	
		ship.moverse()
	
		generador.generarBloquesAleatorios()
		
		game.schedule(config.tiempoNave(), {
			portalRotado.nextHeight(config.alturaPiso())
		})
		
		game.schedule(config.tiempoNave(),{portalRotado.aparecer(config.alturaPiso())})

	}
}



