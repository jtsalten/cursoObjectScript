/// Pruebas de uso SQL Embebido y Dinámico
Class Modelo.App Extends %RegisteredObject
{

/// SQL Embebido
ClassMethod ClientesAsignados(pEmpID As %Integer = 0) As %Status
{
        #dim e as %Exception.SystemException
        #dim tSC as %Status = $$$OK
        #dim tEmp as Modelo.Empleado

        try
        {
            //Instancia el empleado cuyo ID nos hayan indicado. 
            //set tEmp = << tu código aquí>>

            //Si no es válido o no existe, sale con: return $system.Status.Error("5000","No existe un empleado con el ID indicado")
            if $isobject(tEmp)
            {
                //Muestra info básica del empleado: 
                //1a linea: Nombre   - 2ª línea: Email y Movil   3ª linea: Provincia en que se encuentra
                write !,"Información de clientes solicitada para el empleado ["_pEmpID_"] - "_" << tu codigo aquí >>"
                write !,"Email: "_" <<tucodigo aquí>> "_"   /   Movil: "_" <<tu codigo aquí>>"
                write !,"Provincia: "_"  <<tu codigo aquí>>  "
                write !,"==============================================================================",!
            
                //Llama al metodo ListaClientesGral() para mostrar la relación de clientes
                //set tSC = << llama al metodo ListaClientesGral()
            }
            else
            {
                set tSC = $system.Status.Error("5000","No existe un empleado con el ID indicado")
            }
        }
        catch e
        {
            set tSC = e.AsStatus()
        }
    
        Return tSC
}

/// Lista General de clientes asignados a un empleado utilizando SQL Embebido
ClassMethod ListaClientesGral(pEmpID As %Integer = 0) As %Status
{
        #dim tSC as %Status = $$$OK
        #dim e as %Exception.SQL

        try
        {
            // Establecemos el formato de datos de salida = ODBC (por defecto Logical que es el formato interno)

            // Definimos el cursor listaC para obtener los datos de clientes asignados al empleado
            
            //&SQL(  <<declaración del cursor listaC para recuperar ClienteID, Nombre y Fecha_Alta en las variables host: cliID, nomCli y fechaAlta>> )
            
            // Abrimos el cursor
            // << tu codigo aquí >>

            // Si ha habido algún error (SQLCODE < 0) lanzamos una excepción

            //Si no hay error, recorremos y mostramos la lista de clientes
            //Cabecera de la lista
            write !,"CLIENTES ASIGNADOS"
            write !,"******************"
            write !,"ID",?13,"Fecha de Alta",?30,"Cliente",!   //?num nos permite mover el cursor en horizontal...
        
            //Hacemos un primer fetch
            //<< tu codigo aquí>>

            //Si hemos obtenido alguna fila (SQLCODE = 0), iniciamos el bucle. Iteramos mientras SQLCODE = 0
            while (SQLCODE = 0)
            {
                // Mostramos los datos por pantalla
                

                // Fetch
                
                
                //Comprobamos si ha habido error SQLCODE < 0... SQLCODE = 100 no es error, es ejecución sin resultados
                // <<tu codigo aquí>>  //mira el throw de arriba... ojo que si SQLCODE = 100 no hay que lanzar la excepción
            }
        }
        catch e
        {
            // Convertimos la información de excepción en un objeto tipo %Status
            set tSC = e.AsStatus()
        }   

        //Cerramos el cursor antes de salir
        // <<tu codigo aquí>>

        // Retornamos con %Status
        Return tSC
}

/// SQL Dinámico - Toma de Datos
ClassMethod ListadoCustom(pEmpID As %Integer = 0) As %Status
{
    #dim tSC as %Status = $$$OK
    
    //Entrada de columnas a mostrar
    write !,"Indique las columnas a mostrar en el orden que desee y según su código numérico (1 - ClienteID, 2 - Nombre - 3 Fecha de Alta)"
    write !,"Ejemplo: 12, para mostrar ClienteID Nombre, 31 para mostrar Fecha de Alta ClienteID"
    read !,"   ---> Columnas: ",showCol

    //Ordenación
    write !
    write !,"Indique la columna por la que quiere ordenar la salida (0 - Sin ordenación, 1 - ClienteID, 2 - Nombre o 3 - Fecha de Alta):"
    read !,"   ---> Ordenar por:",ordCol

    // Construye columnas select

    // Construye claúsula order by - sólo permitimos ordenación por 1 campo

    // Llama al método principal ClientesAsignados() con la información de entrada
    

    return tSC
}

/// Relación de clientes asignados el empleado, mostrando los datos de cliente indicados y ordenados o no según parámetro
/// Recibe como parámetros el ID del supervisor o empleado asignado a los clientes, pSelect = "campo1,campo2,campo3" y orderBY = "ORDER BY campo"
ClassMethod ListaClientesDinamica(pEmpID As %Integer, pSelect As %String = "", pOrderBY As %String = "") As %Status
{
    #dim tSC as %Status = $$$OK
    #dim e as %Exception.SQL
    #dim tSQLStat as %SQL.Statement = ##class(%SQL.Statement).%New()
    #dim tRS as %SQL.StatementResult

    // Quitamos espacios en blanco sobrantes y pasamos los campos de la select y el order by a mayúsculas. 

    // Si pSelect es "" salimos con $system.Status.Error("5000","No se han seleccionado campos para mostrar")

    // Si pOrderBY no empieza por "ORDER BY" salimos con $system.Status.Error("5000","Clausula de ordenación incorrecta"). 
    // No queremos nada que no sea un Order By en este parámetro
 
    Try 
    {
        // Construimos la query sobre MODELO.CLIENTE

        // Datos de la select en formato ODBC

        // Ejecutamos la select 
        
        // Lanzamos una excepción en caso de error
 
        //Si no hay error, recorremos y mostramos la lista de clientes
        //Cabecera de la lista
        write !,"CLIENTES ASIGNADOS"
        write !,"******************"
        write !

        // A priori no sabemos las columnas que nos habrán pedido... la cabecera tambien es dinámica
        set tLine = ""
        for i=1:1:$length(pSelect,",")
        {
            write ?(25*(i-1)),$piece(pSelect,",",i)
            set tLine = tLine_"--------------------"
        }
        write !,tLine,!

        // Iteramos mientras haya resultados. Escribimos los valores en el orden de columnas marcado (al igual que la cabecera)
 
     }
    Catch e
    {
        Set tSC=e.AsStatus()
    }

    Return tSC
}

}
