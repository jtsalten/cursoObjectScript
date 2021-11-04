/// Direccion
Class Modelo.Direccion Extends (%SerialObject, %Populate)
{

/// Tipo
Property Tipo As %String(VALUELIST = ",CL,AV,Ctra,Paseo");

/// Descripcion
Property Descripcion As %String;

/// Numero
Property Numero As %Integer(MAXVAL = 300, MINVAL = 1);

/// CodPostal
Property CodPostal As %String(POPORDER = 5, POPSPEC = ".popCP()");

/// Ciudad
Property Ciudad As %String(POPSPEC = "City()");

/// Provincia
Property Provincia As %String(POPORDER = 1, VALUELIST = ",Albacete,Barcelona,Madrid");

Method popCP() As %String
{
    return $case(i%Provincia,"Albacete":"02","Barcelona":"08","Madrud":"28",:"50")_$translate($justify($random(400),3)," ",0)
}

/// Provincia
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
<Description>
<![CDATA[Provincia]]></Description>
<State>DireccionState</State>
<StreamLocation>^Modelo.DireccionS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
