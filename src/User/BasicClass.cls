/// Basic Class
Class User.BasicClass Extends %RegisteredObject
{

Property codigo As %Integer;

Property descripcion As %String;

/// Metodo de Instancia
Method MetodoInstancia() As %Status
{
        Set sc = $$$OK
        write !,"Propiedades: "_..codigo_" ** "_..descripcion
        Return sc
}

}
