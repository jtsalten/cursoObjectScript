Include Modelo.macros

/// Utilidades varias
Class Modelo.Tools
{

/// Indireccion en objetos
ClassMethod IndireccionOO() As %Status
{
    set sc = $$$OK
    
    set x = $classmethod("Modelo.Empleado","%OpenId",1)
    set nomProp = "Edad"
    write !, $property(x,nomProp)
    write !

    return sc
}

/// Macro Externa
ClassMethod MacroExterna(x As %Integer = 0, y As %Integer = 0)
{
    return $$$MULT(x,y)
}

/// Macro interna
ClassMethod MacroInterna(x As %Integer = 0, y As %Integer = 1, numDig As %SmallInt = 10) As %Float
{
    #define DIVIDE(%x,%y) %x\%y
    #define JUSTIFICA(%num,%digitos) $translate($justify(%num,%digitos)," ",0)
    #Define LEE(%x) READ !,"Nombre: ",nombre  WRITE !,"%x ",nombre,!

    set resul = $$$DIVIDE(x,y)
    
    write !,"Resultado: "_resul
    write !,"Justificado a "_numDig_" dígitos: "_$$$JUSTIFICA(resul,numDig)
    write !
    $$$LEE(Bienvenid@)

    return resul
}

/// Jugando con JSON nativo
ClassMethod TestJSON() As %DynamicObject
{
    // Define un array con info sobre el estado de motores -- propiedades: motor / activo 
    Set arrM = [{"motor":"A02","activo":true},{"motor":"B836","activo":false}]

    // Define un array con info sobre el valor de señales -- propiedades señal / valor
    set arrS = [{"señal":8007,"valor":23}, {"señal":1007,"valor":1.34}]
    
    // Número de señales en el array
    write !, "arrS contiene "_arrS.%Size()_" señales",!

    // Objeto iterator sobre el array (itS)
    set itS = arrS.%GetIterator()

    // Nos movemos al primer elemento del array JSON   -- variables keyS / valueS
    do itS.%GetNext(.keyS,.valueS)

    // Muestra info
    write !,"Primer elemento del array arrS: "_keyS," *** ",valueS," *** ",valueS.%ToJSON()
    write !

    // Iterator sobre un objeto JSON (it)
    set it = valueS.%GetIterator()

    // Recuperamos la primera propiedad, valor y descripción, del objeto JSON -- variables key / value
    do it.%GetNext(.key,.value)
 
    // Muestra info
    write !,"Primera propiedad del objeto JSON: "_key," ** ",value,!
    write !

    //Crea 2 objetos JSON: json y json2; de prueba y los introduce en un array: arrS
    Set json = {"señal":1,"valor":0.15}
    Set json2 = {"señal":123,"valor":921}

    Do arrS.%Push(json), arrS.%Push(json2)
    Do arrS.%ToJSON()

    // Saca el último elemento del array: arrS; lo retorna (elem) y lo quita del array
    Set elem = arrS.%Pop()
    Do elem.%ToJSON()
    Do arrS.%ToJSON()

    // Saca el elemento del array: arrS; que esté en la posición indicada. Lo retorna (elem) y lo quita del array
    Set elem = arrS.%Remove(2)
    Do elem.%ToJSON()
    Do arrS.%ToJSON()

    //Introduce valores en un JSON. Creamos un bundle con los 2 arrays: arrM y arrS, en las propiedades motores y signals
    Set bundle = {}.%Set("motores",arrM)
    Set bundle.signals = arrS

    //Retorna el documento JSON: bundle; con toda la información
    return bundle
}

ClassMethod TestTryCatch() As %Status
{
    #dim tSC as %Status = $$$OK
    #dim ex as %Exception.General
    #dim emp as Modelo.Empleado = ##class(Modelo.Empleado).%OpenId(1,0)
    Try 
    {
        tstart

        set emp.Nombre = "TESTTEST"
        write !,"Guardando: "_emp.%Save()
        write !
        read "Verifica en otro terminal que se ha cambiado....luego pulsa una tecla para generar error",k
        
        write !
        write 1/0  

        // Aquí no vamos a llegar...
        tcommit
    }
    Catch ex {
        Set tSC=ex.AsStatus()
        write !,"Estoy en el catch... retornará tSC = "_tSC
        trollback
    }

    return tSC
}

ClassMethod TestZTRAP()
{
    #dim tSC as %Status = $$$OK
    #dim ex as %Exception.General
    #dim emp as Modelo.Empleado = ##class(Modelo.Empleado).%OpenId(1,0)

    set $ZTRAP = "Error"

    tstart

    set emp.Nombre = "TESTTEST"
    write !,"Guardando: "_emp.%Save()
    write !
    read "Verifica en otro terminal que se ha cambiado....luego pulsa una tecla para generar error",k
    
    write !
    write 1/0  

    // Aquí no vamos a llegar...
    tcommit

    quit tSC

Error
    set error = $ZERROR, $ZERROR = ""
    write !,"Estoy en la subrutina Error... retornará tSC = "_error

    trollback
    quit error
}

}
