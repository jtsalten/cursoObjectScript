/// Clase Cliente
Class Modelo.Cliente Extends (%Persistent, %Populate, %JSON.Adaptor, %XML.Adaptor) [ ClassType = persistent, DdlAllowed ]
{

Property ClienteID As %Integer [ Identity ];

Property Nombre As %String(MAXLEN = 50, POPSPEC = "Company()");

Property Supervisor As Modelo.Empleado;

Property FechaAlta As %Library.Date [ SqlColumnNumber = 2, SqlFieldName = Fecha_Alta ];

/// Indice único sobre Nombre de empresa
Index idxNombre On Nombre [ Unique ];

/// Indice por fecha alta
Index idxFecAlta On FechaAlta;

Storage Default
{
<Data name="ClienteDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ClienteID</Value>
</Value>
<Value name="3">
<Value>Nombre</Value>
</Value>
<Value name="4">
<Value>Supervisor</Value>
</Value>
<Value name="5">
<Value>FechaAlta</Value>
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
