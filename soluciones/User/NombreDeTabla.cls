/// Clase de Pruebas
Class User.NombreDeTabla Extends (%Persistent, %Populate) [ SqlTableName = nombre_de_tabla ]
{

Property nom As %String(MAXLEN = 30);

Property ape1 As %String [ SqlFieldName = ape_1 ];

Property edad As %Integer [ InitialExpression = 0 ];

ClassMethod testSQLBasico()
{
    &SQL(select count(*) into :filas from SQLUSer.nombre_de_tabla)

    if SQLCODE = 0 
    {
        write !,"Filas encontradas: "_filas
    }
    else
    {
        write !,"Algo ha podido ir mal. SQLCODE = "_SQLCODE
    }

    quit
}

Storage Default
{
<Data name="NombreDeTablaDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>nom</Value>
</Value>
<Value name="3">
<Value>ape1</Value>
</Value>
<Value name="4">
<Value>edad</Value>
</Value>
</Data>
<DataLocation>^User.NombreDeTablaD</DataLocation>
<DefaultData>NombreDeTablaDefaultData</DefaultData>
<IdLocation>^User.NombreDeTablaD</IdLocation>
<IndexLocation>^User.NombreDeTablaI</IndexLocation>
<StreamLocation>^User.NombreDeTablaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
