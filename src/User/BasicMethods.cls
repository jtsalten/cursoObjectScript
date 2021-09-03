/// Basic Methods
Class User.BasicMethods Extends %RegisteredObject
{

/// Propiedad 1
Property codigo As %Integer;

/// Propiedad 2
Property descripcion As %String;

/// Description
ClassMethod MetodoClaseAAA() As %Integer
{
        set x = $random(999)
        Return x
}

/// Metodo de clase
ClassMethod MetodoClaseBBB() As %Status
{
        Set sc = $$$OK

        //Llama a otro de clase con operador ..
        write !,"Resultado llamada a MetodoClaseAAA: "_..MetodoClaseAAA()

        Return sc
}

/// Metodo de Instancia
Method MetodoInstanciaAAA() As %String
{
    Return "["_..MetodoClaseAAA()_"] "_..codigo_" -- "_..descripcion
}

/// PasoArgumentos
ClassMethod PasoArgumentos(ByRef pEntrada As %String, Output pSalida As %String, pValor As %String) As %Status
{
        set pSalida = "Generado en el método"
        set pEntrada = "CAMBIADO en el méotodo ** ORIG: "_pEntrada

        set pValor = pValor_" CAMBIADO EN EL METODO... para uso local"

        write !,"Arg ByRef: "_pEntrada
        write !,"Arg Output: "_pSalida
        write !,"Arg por valor: "_pValor

        return 1
}

/// Argumentos Multidimensionales
ClassMethod ArgumentoMultidimensional(pEntrada...) As %Status
{
        do $increment(^zloop)

        quit:$get(^zloop)>3
        
        write !,"Llamada numero: "_$get(^zloop)
        write !
        
        zw pEntrada

        do ..ArgumentoMultidimensional(.pEntrada)
        return 1
}

}
