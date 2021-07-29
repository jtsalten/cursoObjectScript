/// Ejemplo básico métodos
Class User.BasicMetodos Extends %RegisteredObject
{

Property codigo As %Integer;

Property descripcion As %String;

/// Metodo de clase
ClassMethod MetodoClaseAAA() As %Integer
{
        set x = $random(999)        
        Return x
}

/// Metodo de clase
ClassMethod MetodoClaseBBB() As %Status
{
        Set sc = $$$OK
        
        //Llama a otro método de clase con operador ..
        write !,"Resultado llamada a MetodoClaseAAA: "_..MetodoClaseAAA()

        Return sc
}

/// Metodo de instancia
Method MetodoInstanciaAAA() As %String
{
        Return "["_..MetodoClaseAAA()_"] "_..codigo_" -- "_..descripcion
}

/// Paso por valor o por referencia
/// Sólo importa cómo llamemos al método en la práctiva, ByRef y Output son sólo declarativos
/// Ej: do ..PasoArgumentos(x,y,.z) sólo pasará por referencia la variable z... x e y serán pasadas por valor y mantendrán 
/// su valor original una vez termine de ejecutarse el método.
ClassMethod PasoArgumentos(ByRef pEntrada As %String, Output pSalida As %String, pValor As %String) As %Status
{
    set pSalida = "Generado en el método"

    set pEntrada = "CAMBIADO en el método ** ORIG: "_pEntrada

    set pValor = pValor_" CAMBIADO en el método... para uso local"

    write !,"Arg ByRef: "_pEntrada
    write !,"Arg Output: "_pSalida
    write !,"Arg por valor: "_pValor

    return 1
}

/// Argumentos multidimensionales
ClassMethod ArgumentoMultidimensional(pEntrada...) As %Status
{
    quit:$get(^zloop)=3

    do $Increment(^zloop)
    
    write !,"Llamada numero: "_$get(^zloop)
    write !
    zw pEntrada
    
    //do ..ArgumentoMultidimensional("Nivel "_$get(^zloop),.pEntrada)

    Return 1
}

}
