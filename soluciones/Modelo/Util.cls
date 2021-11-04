/// Utilidades del paquete Modelo
Class Modelo.Util Extends %RegisteredObject
{

/// Borra y Regenera los datos del modelo
ClassMethod ResetData() As %Status
{
    do ##class(Modelo.Cliente).%KillExtent()
    do ##class(Modelo.Empleado).%KillExtent()

    do ##class(Modelo.Empleado).Populate(20,1)
    do ##class(Modelo.Cliente).Populate(100,1)

    quit
}

}
