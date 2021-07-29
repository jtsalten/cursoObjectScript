/// Basic Class
Class User.BasicClass Extends %RegisteredObject
{

Property codigo As %Integer;

Property descripcion As %String;

/// Método de Instancia
Method MetodoInstancia() As %Status
{
        write !,"Propiedades: "_..codigo_" ** "_..descripcion
        return 1
}

}
