/// Description
Class User.test Extends %Persistent
{

/// Description
Property nombre As %String;

/// Description
ClassMethod holaMundo() As %Status
{
        Return "Hola Mundo!!"
}

Storage Default
{
<Data name="testDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>nombre</Value>
</Value>
</Data>
<DataLocation>^User.testD</DataLocation>
<DefaultData>testDefaultData</DefaultData>
<IdLocation>^User.testD</IdLocation>
<IndexLocation>^User.testI</IndexLocation>
<StreamLocation>^User.testS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
