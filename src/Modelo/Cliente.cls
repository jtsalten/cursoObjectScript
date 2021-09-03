/// Cliente
Class Modelo.Cliente Extends (%Persistent, %Populate, %JSON.Adaptor, %XML.Adaptor)
{

Property ClienteID As %Integer [ Identity ];

Property Nombre As %String(MAXLEN = 50);

Property Supervisor As Modelo.Empleado;

Storage Default
{
<Data name="ClienteDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Nombre</Value>
</Value>
<Value name="3">
<Value>Supervisor</Value>
</Value>
</Data>
<DataLocation>^Modelo.ClienteD</DataLocation>
<DefaultData>ClienteDefaultData</DefaultData>
<IdLocation>^Modelo.ClienteD</IdLocation>
<IndexLocation>^Modelo.ClienteI</IndexLocation>
<StreamLocation>^Modelo.ClienteS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
