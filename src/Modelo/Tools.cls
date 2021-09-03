Include Modelo.macros

/// Description
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
ClassMethod MacroExterna(pX As %Integer = 0, pY As %Integer = 0) As %Status
{
  return $$$MULT(pX,pY)
}

ClassMethod MacroInterna(pX As %Integer = 0, pY As %Integer = 0, numDig As %SmallInt = 10) As %Float
{
    #define JUSTIFICA(%num,%digitos) $translate($justify(%num,%digitos)," ","0")
    #define DIVIDE(%x,%y) %x\%y 
    #define LEE(%x) READ !,"Nombre: ",nombre write !,"%x ",nombre,!

    set resul = $$$DIVIDE(pX, pY)
    write !,"Resultado: "_resul
    write !,"Justificado a "_numDig_" digitos: "_$$$JUSTIFICA(resul,numDig)
    write !
    
    $$$LEE(Bienvenid@)

    return resul
}

/// Jugando con JSON Nativo
ClassMethod TestJSON() As %DynamicObject
{
    #dim json, json2 as %DynamicObject
    #dim arrM, arrS as %DynamicArray
    #dim itS as %Iterator.Array
    #dim it as %Iterator.Object


    // Define un array: arrM; con info sobre el estado de motores -- propiedades: motor / activo 
    set arrM = [{"motor":"A02","activo":true},{"motor":"B386","activo":false}]
    
    // Define un array: arrS; con info sobre el valor de señales -- propiedades señal / valor
    set arrS = [{"señal":8007,"valor":23},{"señal":1007,"valor":1.34}]

    // Número de señales en el array
    write !,"arrS contiene "_arrS.%Size()_" señales",!

    // Objeto iterator sobre el array (itS)
    set itS = arrS.%GetIterator()

    // Nos movemos al primer elemento del array JSON   -- variables keyS / valueS
    do itS.%GetNext(.keyS,.valueS)
        
    // Muestra info     
    write !,"Primer elemento del array arrS: "_keyS," *** ",valueS," *** ",valueS.%ToJSON()
    write !

    // Iterator sobre un objeto JSON  (it)
    set it = valueS.%GetIterator()

    // Recuperamos la primera propiedad, valor y descripción, del objeto JSON -- variables key / value
    do it.%GetNext(.key,.value)

    // Muestra info
    write !,"Primera propiedad del objeto JSON: "_key," ** ",value,!

    //Crea 2 objetos JSON: json y json2; de prueba y los introduce en un array: arrS
    set json = {"señal":1,"valor":0.15}
    set json2 = {"señal":123,"valor":921}

    do arrS.%Push(json), arrS.%Push(json2)
    do arrS.%ToJSON()
    write !

    // Saca el último elemento del array: arrS; lo retorna (elem) y lo quita del array
    set elem = arrS.%Pop()
    do elem.%ToJSON()
    write !
    do arrS.%ToJSON()

    // Saca el elemento del array: arrS; que esté en la posición indicada. Lo retorna (elem) y lo quita del array
    set elem = arrS.%Remove(2)
    do elem.%ToJSON()
    do arrS.%ToJSON()
    write !

    //Introduce valores en un JSON. Creamos un bundle con los 2 arrays: arrM y arrS, en las propiedades motores y signals
    Set bundle = {}.%Set("motores",arrM)
    set bundle.signals = arrS

    //Retorna el documento JSON: bundle;  con toda la información
    return bundle
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

ClassMethod TestTryCatch() As %Status
{
    #dim tSC as %Status = $$$OK
    #dim ex as %Exception.General
    #dim emp as Modelo.Empleado = ##class(Modelo.Empleado).%OpenId(1,0)

    try
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
    catch ex
    {
        set tSC = ex.AsStatus()
        write !,"Estoy en el catch... retornará tSC = "_tSC
        trollback
    }

    return tSC
}

}
