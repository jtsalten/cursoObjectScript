/// Clase Empleado
Class Modelo.Empleado Extends (%Persistent, %Populate, %JSON.Adaptor, %XML.Adaptor)
{

Property EmpleadoID As %Integer(MINVAL = 0) [ Identity ];

Property Nombre As %String(MAXLEN = 30);

/// Domicilio
Property Domicilio As Modelo.Direccion;

Property Generao As %String(VALUELIST = ",M,F,O");

Property FechaNacimiento As %Date;

Property Edad As %Integer [ Calculated, SqlComputeCode = { set {*} = (+$horolog - {FechaNacimiento})\365 }, SqlComputed ];

Property DatosTemporales [ MultiDimensional ];

Property Superior As Modelo.Empleado;

Property Cargo As %String(VALUELIST = ",EMP,MGR");

Property InfoContacto As array Of %String;

Property FechaRegistro As %DateTime [ InitialExpression = {$h} ];

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
