/// Direccion
Class Modelo.Direccion Extends %SerialObject
{

/// Description
Property Tipo As %String;

/// Description
Property Descripcion As %String;

Property Numero As %String;

Property CodPostal As %String;

Property Ciudad As %String;

Property Provincia As %String;

Storage Default
{
<Data name="DireccionState">
<Value name="1">
<Value>Tipo</Value>
</Value>
<Value name="2">
<Value>Descripcion</Value>
</Value>
<Value name="3">
<Value>Numero</Value>
</Value>
<Value name="4">
<Value>CodPostal</Value>
</Value>
<Value name="5">
<Value>Ciudad</Value>
</Value>
<Value name="6">
<Value>Provincia</Value>
</Value>
</Data>
<State>DireccionState</State>
<StreamLocation>^Modelo.DireccionS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
