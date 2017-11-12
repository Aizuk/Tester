 /** TP N1 */
class Musico {
	var grupo=null
	var habilidadBase
	var albumes = []
	
	constructor (_grupo,_habilidad,_albumes){
		grupo = _grupo
		habilidadBase = _habilidad
		albumes = _albumes
	}
	
	method solista() = grupo==null
	method habilidad() = habilidadBase
	method dejarGrupo() {grupo = null}
	/*method albumesPublicados() = albumes.size()*/
	method laPego() = albumes.all({album=>album.buenaVenta()})
	method minimalista() = albumes.all({album=>album.cancionesCortas()})
	method duracionObra() = albumes.sum({album=>album.duracion()})
	method palabraEnCadaCancion(palabra) = albumes.all({album=>album.cancionesContienen(palabra)})
}

class DeGrupo inherits Musico{
	var bonus
	constructor(_grupo,_habilidad,_albumes,_bonus) = super(_grupo,_habilidad,_albumes){
		bonus = _bonus
	}
	override method habilidad() = habilidadBase+bonus
}

class VocalistaPopular inherits Musico{
	var  palabraClave
	constructor(_grupo,_habilidad,_albumes,_palabraClave) = super(_grupo,_habilidad,_albumes){
		palabraClave = _palabraClave
	}
	method interpretaBien(cancion) = cancion.letra().contains(palabraClave)
}

object joaquin inherits DeGrupo("pimpinela",20,null,5) {
	method interpretaBien(cancion) = cancion.duracion() > 300
	method precioPorPresentacion(presentacion){
		if (presentacion.musicos().size()==1) return 100
		else return 50
	}
}

object lucia inherits VocalistaPopular("Pimpinela",70,null,"familia") {
	override method habilidad(){
		if (grupo!=null) return habilidadBase - 20
		else return habilidadBase
	}
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

class Album{
	var canciones = []
	var titulo
	var fecha
	var copiasHechas
	var copiasVendidas
	constructor (_canciones,_titulo,_fecha,_copiasHechas,_copiasVendidas){
		canciones = _canciones
		titulo = _titulo
		fecha = _fecha
		copiasHechas = _copiasHechas
		copiasVendidas = _copiasVendidas
	}
	method titulo() = titulo
	method cancionMasLarga() = canciones.forEach({cancion=>cancion.duracion()}).max()
	method cancionesCortas () = canciones.all({cancion=>cancion.esCorta()})
	method buenaVenta() = copiasVendidas>copiasHechas*0.75
}

class Cancion {
	var duracion
	var letra 
	constructor (_duracion,_letra){
		duracion = _duracion
		letra = _letra
	}
	
	method esCorta()=duracion<180
	/**method duracion() = duracion
	method letra() = letra**/

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