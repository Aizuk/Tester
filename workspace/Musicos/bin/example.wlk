 /** TP N1 */
class Musico {
	var grupo
	var habilidadBase
	var instrumentos
	
	constructor (_grupo,_habilidad,_instrumentos){
		grupo = _grupo
		habilidadBase = _habilidad
		instrumentos = _instrumentos
	}
	
	method grupo() = grupo
	method dejarGrupo() {grupo = null}
	/** method precioPorPresentacion()*/
}

object joaquin inherits Musico("pimpinela",20,null) {
	method habilidad() { 
		if (grupo!=null) return habilidadBase+5
		else return habilidadBase
	}
	method interpretaBien(cancion) = cancion.duracion() > 300
	method precioPorPresentacion(presentacion){
		if (presentacion.musicos().size()==1) return 100
		else return 50
	}
}

object lucia inherits Musico("Pimpinela",70,null) {
	method habilidad(){
		if (grupo!=null) return habilidadBase -= 20
		else return habilidadBase
	}
	method interpretaBien(cancion) = cancion.letra().contains("familia")
	method precioPorPresentacion(presentacion){
		if (presentacion.lugarConcurrido()) return 500
		else return 400
	}	
}

object luisAlberto inherits Musico(null,8,#{fender,gibson}){
	const fechaCambioPrecio = new Date(01,09,2017)
	method habilidad(instrumento) = (habilidadBase*(instrumento.valor())).min(100)
	method interpretaBien(cancion) = true
	method precioPorPresentacion(presentacion){
		if (presentacion.fecha() < fechaCambioPrecio) return 1000
		else return 1200
	}
}

class Cancion {
	var duracion
	var letra 
	constructor (_duracion,_letra){
		duracion = _duracion
		letra = _letra
	}
	
	method duracion() = duracion
	method letra() = letra

}

class Presentacion {
	var fecha
	var musicos = []
	var lugar

	constructor (_fecha,_musicos,_lugar)
	{
		fecha = _fecha
		musicos = _musicos
		lugar = _lugar
	}

	method fecha() = fecha
	method capacidad() = lugar.capacidad(fecha)
	method musicos() = musicos 
	method sacarMusico(musico) = musicos.remove(musico)
	method lugarConcurrido() = lugar.concurrido(fecha)
	method precio() = musicos.sum({musico => musico.precioPorPresentacion(self)})
}

class Escenario {
	var capacidad
	constructor(_capacidad){
		capacidad = _capacidad
	}
	method capacidad(_) = capacidad
	method concurrido(fecha) = self.capacidad(fecha) > 5000
}

object trastienda inherits Escenario(null) {
	const capacidadPlantaBaja = 400
	const capacidadPrimerPiso = 300
	
	method esSabado(fecha) = return fecha.dayOfWeek()==6
	override method capacidad(fecha) {
		if (self.esSabado(fecha)) return capacidadPlantaBaja+capacidadPrimerPiso
		else return capacidadPlantaBaja
	}
}

object fender {
	method valor() = 10
}

object gibson {
	var buenEstado = true
	method maltratada() {buenEstado=false}
	method valor() {
		if (buenEstado) return 15
		else return 5
	}
}