 /** TP N3 */

class Musico {
	var grupo=null
	var habilidadBase
	var albumes = []
	const habilidadMinima = 60
	
	constructor (_grupo,_habilidad,_albumes){
		grupo = _grupo
		habilidadBase = _habilidad
		albumes = _albumes
	}
	
	method solista() = grupo==null
	method editarAlbum(album) = albumes.add(album)
	method habilidad() = habilidadBase
	method dejarGrupo() {grupo = null}
	method albumesPublicados() = albumes.size()
	method laPego() = albumes.all({album=>album.buenaVenta()})
	method minimalista() = albumes.all({album=>album.cancionesCortas()})
	method duracionObra() = albumes.sum({album=>album.duracion()})
	method cancionesQueContienen(palabra) = albumes.flatMap({album=>album.cancionesQueContienen(palabra)})
	method compusoCancion(cancion) = albumes.any({album=>album.tieneCancion(cancion)})
	method cambiarHabilidadBase(habilidad) {habilidadBase = habilidad}
	method interpretaBien(cancion) = self.compusoCancion(cancion) || self.habilidad()>=habilidadMinima
		
}

class DeGrupo inherits Musico{
	var bonus
	const duracionMinima = 300
	constructor(_grupo,_habilidad,_albumes,_bonus) = super(_grupo,_habilidad,_albumes){
		bonus = _bonus
	}
	override method habilidad() = habilidadBase+bonus
	override method interpretaBien(cancion) = super(cancion) || cancion.duracion()>=duracionMinima
}

class VocalistaPopular inherits Musico{
	var  palabraClave
	constructor(_grupo,_habilidad,_albumes,_palabraClave) = super(_grupo,_habilidad,_albumes){
		palabraClave = _palabraClave
	}
	override method interpretaBien(cancion) = super(cancion) || cancion.tienePalabra(palabraClave)
}

object joaquin inherits DeGrupo("pimpinela",20,[],5) {
	method precioPorPresentacion(presentacion){
		if (presentacion.musicos().size()==1) return 100
		else return 50
	}
}

object lucia inherits VocalistaPopular("Pimpinela",70,[],"familia") {
	override method habilidad(){
		if (grupo!=null) return habilidadBase - 20
		else return habilidadBase
	}
	method precioPorPresentacion(presentacion){
		if (presentacion.lugarConcurrido()) return 500
		else return 400
	}	
}

object luisAlberto inherits Musico([],8,[]){
	var instrumentos = #{fender,gibson}
	const fechaCambioPrecio = new Date(01,09,2017)
	method habilidad(instrumento) = (habilidadBase*(instrumento.valor())).min(100)
	override method habilidad() = self.habilidad(instrumentos.anyOne())
	override method interpretaBien(cancion) = true
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
	method cancionMasLarga(criterio) = canciones.fold(canciones.head(), {masLarga, cancion => if(masLarga==criterio.comparar(masLarga,cancion)) masLarga else cancion })
	method cancionesCortas () = canciones.all({cancion=>cancion.esCorta()})
	method buenaVenta() = copiasVendidas>copiasHechas*0.75
	method cancionesQueContienen(palabra) = canciones.filter({cancion=>cancion.tienePalabra(palabra)})
	method duracion() = canciones.sum({cancion=>cancion.duracion()})
	method tieneCancion(cancion) = canciones.contains(cancion)
}

class Cancion {
	var duracion
	var letra 
	constructor (_duracion,_letra){
		duracion = _duracion
		letra = _letra
	}
	
	method esCorta()=duracion<180
	method duracion() = duracion
	method tienePalabra(palabra) = letra.toUpperCase().contains(palabra.toUpperCase())
	method longitud() = letra.size()
	method letra() = letra
	
}

class Remix {
	var original
	constructor(_original){
		original = _original
	}
	method titulo() = original.titulo()
	method letra()  = "mueve tu cuelpo baby " + original.letra() + " yeah oh yeah"
	method duracion() = original.duracion()*3
}
class Mashup {
	var cancion1
	var cancion2
	constructor(_cancion1,_cancion2){
		cancion1 = _cancion1
		cancion2 = _cancion2
	}
	method titulo() = cancion1.titulo()+cancion2.titulo()
	method duracion() = self.laMasLarga().duracion()
	method laMasLarga() = criterioDuracion.comparar(cancion1,cancion2)
	method letra() = cancion1.letra() + " " + cancion2.letra()
}

object criterioDuracion{
	method comparar(cancion1,cancion2) = [cancion1,cancion2].max({cancion=>cancion.duracion()})
}

object criterioTamanioLetra{
	method comparar(cancion1,cancion2) = [cancion1,cancion2].max({cancion=>cancion.longitud()})
}

object criterioTitulo{
	method comparar(cancion1,cancion2) = [cancion1,cancion2].max({cancion=>cancion.titulo()})
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

object pdpalooza inherits Presentacion(new Date(15,12,2017),[],lunaPark){
	var condicionesAdmision = [condicionHabilidad,condicionCancion,condicionCancionAlicia]
	method agregarMusico(musico) = if(self.cumpleCondiciones(musico)) musicos.add(musico)
	
	method cumpleCondiciones(musico) = condicionesAdmision.all({cond=>cond.cumple(musico)})
	method agregarOQuitarCondicion(condicion){
		if (condicionesAdmision.contains(condicion)) condicionesAdmision.remove(condicion)
		else condicionesAdmision.add(condicion)
	}
}

object condicionHabilidad{
	method cumple(musico) = if(musico.habilidad()<70) throw new UserException ("Habilidad insuficiente") else return true
}

object condicionCancion{
	method cumple(musico) = if(musico.albumesPublicados()<=0) throw new UserException ("No compuso") else return true
}

object condicionCancionAlicia{
	method cumple(musico) = musico.interpretaBien(cancionAlicia)
}

object cancionAlicia inherits Cancion(510,"Quién sabe Alicia, este país no estuvo hecho porque sí. Te vas a ir, vas a salir pero te quedas, ¿dónde más vas a ir? Y es que aquí, sabes el trabalenguas, trabalenguas, el asesino te asesina, y es mucho para ti. Se acabó ese juego que te hacía feliz."){}

object lunaPark {
	const capacidad = 9290
	method capacidad(_) = capacidad
	method concurrido(fecha) = self.capacidad(fecha) > 5000
}

object trastienda{
	const capacidadPlantaBaja = 400
	const capacidadPrimerPiso = 300
	
	method esSabado(fecha) = return fecha.dayOfWeek()==6
	method capacidad(fecha) {
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
class UserException inherits Exception{}