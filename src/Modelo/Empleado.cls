/// Empleado
Class Modelo.Empleado Extends (%Persistent, %Populate, %JSON.Adaptor, %XML.Adaptor) [ ClassType = persistent ]
{

/// Description
Property EmpleadoID As %Integer(MINVAL = 0) [ Identity ];

Property Nombre As %String(MAXLEN = 30);

Property Domicilio As Modelo.Direccion;

Property Genero As %String(VALUELIST = ",M,F,O");

Property FechaNacimiento As %Date;

Property Edad As %Integer [ Calculated, SqlComputeCode = { set {*} = (+$horolog - {FechaNacimiento})\365}, SqlComputed ];

Property DatosTemporales As %String [ MultiDimensional ];

Property Superior As Modelo.Empleado;

Property Cargo As %String(VALUELIST = ",EMP,MGR");

Property InfoContacto As array Of %String;

Property FechaRegistro As %DateTime [ InitialExpression = {$zdatetime($h,3)} ];

/// Test
ClassMethod Test() As Modelo.Empleado
{
    Set sc = $$$OK
    
    #dim objRef as Modelo.Empleado
    #dim objMgr as Modelo.Empleado = ##class(Modelo.Empleado).%OpenId(2)

    set objRef = ..%New()

    if $isobject(objRef)
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

        //Referencia a otros Objetos Persistentes
        set objRef.Superior = objMgr

        // Datos Temporales -Solo cuando el objeto esté en memoria
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
<Value>Domicilio</Value>
</Value>
<Value name="5">
<Value>Genero</Value>
</Value>
<Value name="6">
<Value>FechaNacimiento</Value>
</Value>
<Value name="7">
<Value>Edad</Value>
</Value>
<Value name="8">
<Value>DatosTemporales</Value>
</Value>
<Value name="9">
<Value>Superior</Value>
</Value>
<Value name="10">
<Value>Cargo</Value>
</Value>
<Value name="11">
<Value>FechaRegistro</Value>
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
