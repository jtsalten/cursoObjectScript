/// Cliente
Class Modelo.Cliente Extends (%Persistent, %Populate, %JSON.Adaptor, %XML.Adaptor) [ ClassType = persistent, DdlAllowed ]
{

Property ClienteID As %Integer [ Identity ];

Property Nombre As %String(MAXLEN = 50);

Property Supervisor As Modelo.Empleado;

Property FechaAlta As %Library.Date [ SqlColumnNumber = 2, SqlFieldName = Fecha_Alta ];

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
<Value name="4">
<Value>FECHAALTA</Value>
</Value>
<Value name="5">
<Value>FechaAlta</Value>
</Value>
</Data>
<DataLocation>^Modelo.ClienteD</DataLocation>
<DefaultData>ClienteDefaultData</DefaultData>
<ExtentSize>11</ExtentSize>
<IdLocation>^Modelo.ClienteD</IdLocation>
<IndexLocation>^Modelo.ClienteI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="ClienteID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="FechaAlta">
<AverageFieldSize>3.82</AverageFieldSize>
<Selectivity>9.0909%</Selectivity>
</Property>
<Property name="Nombre">
<AverageFieldSize>7.64</AverageFieldSize>
<Selectivity>9.0909%</Selectivity>
</Property>
<Property name="Supervisor">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>33.3333%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^Modelo.ClienteS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
