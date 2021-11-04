Include Modelo.macros

/// Clase Empleado
Class Modelo.Empleado Extends (%Persistent, %Populate, %JSON.Adaptor, %XML.Adaptor)
{

Property EmpleadoID As %Integer(MINVAL = 0) [ Identity ];

Property Nombre As %String(MAXLEN = 30, POPORDER = 1, POPSPEC = "Name()");

/// Domicilio
Property Domicilio As Modelo.Direccion;

Property Genero As %String(VALUELIST = ",M,F,O");

Property FechaNacimiento As %Date;

Property Edad As %Integer [ Calculated, SqlComputeCode = { set {*} = (+$horolog - {FechaNacimiento})\365 }, SqlComputed ];

Property DatosTemporales As %String [ MultiDimensional ];

Property Superior As Modelo.Empleado;

Property Cargo As %String(VALUELIST = ",EMP,MGR");

Property InfoContacto As array Of %String(POPORDER = 9, POPSPEC = ".popContacto(""V""):3:.popContacto(""K"")");

Property FechaRegistro As %DateTime [ InitialExpression = {$zdatetime($h,3)} ];

/// Indice sobre Nombre
Index idxNombre On Nombre;

ClassMethod Test() As Modelo.Empleado
{
    #dim objRef as Modelo.Empleado
    #dim objMgr as Modelo.Empleado = ##class(Modelo.Empleado).%OpenId(1)

    set objRef = ..%New()
    if $IsObject(objRef)
    {
        set objRef.Nombre = "Juan"
        set objRef.Genero = "M"
        set objRef.FechaNacimiento = +$horolog - (365*40)

        //Direccion como objeto serial (embebido)
        set objRef.Domicilio.Tipo = "CL"
        set objRef.Domicilio.Descripcion = "Miguel Gila"
        set objRef.Domicilio.Numero = 10
        set objRef.Domicilio.Ciudad = "Albacete"
        set objRef.Domicilio.CodPostal = "02230"

        // Referencia a otros objetos persistentes
        set objRef.Superior = objMgr

        // Datos Temporales - sólo cuando el objeto esté en memoria
        set objRef.DatosTemporales("NodoXXX") = "lo que quiera"
        set objRef.DatosTemporales(1,"otronodo") = 201
        set objRef.DatosTemporales(1,2,"meloinvento") = 10.34

        
        write !,"Contenido de la propiedad DatosTemporales",!
        merge x = objRef.DatosTemporales 
        zwrite x

        set tSC = objRef.InfoContacto.SetAt("+34666000111","Movil")
        set tSC = objRef.InfoContacto.SetAt("+34961234567","Oficina")
        set tSC = objRef.InfoContacto.SetAt("pepe@mycompany.com","Email")

        set tSC = objRef.%Save()

        return objRef
    }

    return $$$NULLOREF
}

/// Generador de Info Contacto. Ha de ejecutarse siempre una vez tengamos un nombre
/// Formato esperado para el nombre: Ape, Nom
Method popContacto(pKorVal As %String) As %String
{
    set listaK = $LB("TfCasa","TfTrabajo","TfMovil","TfBusca","Email")
    // Genera clave
    if pKorVal = "K"
    {
        set %zValKey = $get(%zValKey,"Desconocido")
        return %zValKey
    }
    // Genera valor
    elseif pKorVal = "V"
    {
        // La utilidad Populate llamará primero a la lógica de generación de valor... aquí aprovechamos para 
        // generar ya la clave, es decir, el tipo de Info de Contacto... la dejamos en la %zValKey para que 
        // se mantenga disponible al proceso
        set %zValKey=$listget(listaK,$r($ll(listaK))+1)
        if $get(%zValKey) = "Email"
        {
            set ape = $piece(i%Nombre,",",1)
            set nom = $piece(i%Nombre,",",2)

            return $extract(nom,1)_"."_ape_$r(99)_"@mycompany.es"
        }
        else // numero teléfono
        {
            return "+34666"_$tr($j($r(999),3)," ",0)_$tr($j($r(999),3)," ",0)
        }
    }
}

Storage Default
{
<Data name="EmpleadoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EmpleadoID</Value>
</Value>
<Value name="3">
<Value>Nombre</Value>
</Value>
<Value name="4">
<Value>Generao</Value>
</Value>
<Value name="5">
<Value>FechaNacimiento</Value>
</Value>
<Value name="6">
<Value>Domicilio</Value>
</Value>
<Value name="7">
<Value>Superior</Value>
</Value>
<Value name="8">
<Value>Cargo</Value>
</Value>
<Value name="9">
<Value>FechaRegistro</Value>
</Value>
<Value name="10">
<Value>Genero</Value>
</Value>
</Data>
<Data name="InfoContacto">
<Attribute>InfoContacto</Attribute>
<Structure>subnode</Structure>
<Subscript>"InfoContacto"</Subscript>
</Data>
<DataLocation>^Modelo.EmpleadoD</DataLocation>
<DefaultData>EmpleadoDefaultData</DefaultData>
<IdLocation>^Modelo.EmpleadoD</IdLocation>
<IndexLocation>^Modelo.EmpleadoI</IndexLocation>
<StreamLocation>^Modelo.EmpleadoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
