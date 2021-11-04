/// Pruebas de uso SQL Embebido y Dinámico
Class Modelo.App Extends %RegisteredObject
{

/// SQL Embebido
ClassMethod ClientesAsignados(pEmpID As %Integer = 0, pSelect As %String = "", pOrderBY As %String = "") As %Status
{
        #dim e as %Exception.SystemException
        #dim tSC as %Status = $$$OK
        #dim tEmp as Modelo.Empleado

        try
        {
            //Instancia el empleado cuyo ID nos hayan indicado. 
            //Si no es válido o no existe, sale con: return $system.Status.Error("5000","No existe un empleado con el ID indicado")
            set tEmp = ##class(Modelo.Empleado).%OpenId(pEmpID)
            if $isobject(tEmp)
            {
                //Muestra info básica del empleado: 
                //1a linea: Nombre   - 2ª línea: Email y Movil   3ª linea: Provincia en que se encuentra
                write #
                write !,"==============================================================================="
                write !,"Información de clientes solicitada para el empleado ["_pEmpID_"] - "_tEmp.Nombre
                write !,"Email: "_tEmp.InfoContacto.GetAt("Email")_"   /   Movil: "_tEmp.InfoContacto.GetAt("Movil")
                write !,"Provincia: "_tEmp.Domicilio.Provincia
                write !,"==============================================================================",!
            
                if pSelect = ""
                {
                    //Llama al metodo ListaClientesGral() para mostrar la relación de clientes
                    set tSC = ..ListaClientesGral(pEmpID)
                }
                else
                {
                    //Llama al método ListaClientesDinamica() para mostrar la relación de clientes, con la info y ordenación especificada
                    set tSC = ..ListaClientesDinamica(pEmpID,pSelect,pOrderBY)
                }
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
            #SQLCompile Select = ODBC

            // Definimos el cursor listaC para obtener los datos de clientes asignados al empleado
            &SQL(declare listaC cursor for 
                  select ClienteID, Nombre, Fecha_Alta into :cliID, :nomCli, :fechaAlta from Modelo.Cliente 
                    where Supervisor = :pEmpID
                )
            
            // Abrimos el cursor
            &SQL(open listaC)

            // Si ha habido algún error (SQLCODE < 0) lanzamos una excepción
            throw:SQLCODE ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)

            //Si no hay error, recorremos y mostramos la lista de clientes
            //Cabecera de la lista
            write !,"CLIENTES ASIGNADOS"
            write !,"******************"
            write !,"ID",?13,"Fecha de Alta",?30,"Cliente",!
        
            //Hacemos un primer fetch
            &SQL(fetch listaC)

            //Si hemos obtenido alguna fila (SQLCODE = 0), iniciamos el bucle. Iteramos mientras SQLCODE = 0
            while (SQLCODE = 0)
            {
                // Mostramos los datos por pantalla
                write !,$justify(cliID,8),?13,$justify(fechaAlta,12),?30,nomCli

                // Fetch
                &SQL(fetch listaC)
                
                //Comprobamos si ha habido error SQLCODE < 0... SQLCODE = 100 no es error, es ejecución sin resultados
                throw:(SQLCODE<0) ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)
            }
        }
        catch e
        {
            // Convertimos la información de excepción en un objeto tipo %Status
            set tSC = e.AsStatus()
        }   

        //Cerramos el cursor antes de salir
        &SQL(close listaC)

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
    set selectTxt = "", sep = ""
    for i = 1:1:$length(showCol)
    {
        set selectTxt = selectTxt_sep_$case($extract(showCol,i),"1":"ClienteID",2:"Nombre",3:"Fecha_Alta",:"ID")
        set sep = ","
    }

    // Construye claúsula order by - sólo permitimos ordenación por 1 campo
    set orderBY = $case($extract(ordCol,1),1:"order by ClienteID",2:"order by Nombre",3:"order by Fecha_Alta",:"")

    // Llama al método principal ClientesAsignados() con la información de entrada
    set tSC = ..ClientesAsignados(pEmpID,selectTxt,orderBY)
    
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
    set tSelectUpper = $zcvt($zstrip(pSelect,"<=>W"),"u")
    set tOrderBYupper = $zcvt($zstrip(pOrderBY,"<=>W"),"u")

    // Si pSelect es "" salimos
    return:pSelect="" $system.Status.Error("5000","No se han seleccionado campos para mostrar")
    // Si pOrderBY no empieza por "ORDER BY" salimos con $system.Status.Error("5000","Clausula de ordenación incorrecta"). 
    // No queremos nada que no sea un Order By en este parámetro
     return:($extract(tOrderBYupper,1,8)'="ORDER BY") $system.Status.Error("5000","Clausula de ordenación incorrecta")

    Try 
    {
        // Construimos la query sobre MODELO.CLIENTE
        set tQuery = "SELECT "_$ZCVT(pSelect,"u")_" FROM MODELO.CLIENTE WHERE SUPERVISOR = ? "_pOrderBY

        // Datos de la select en formato ODBC
        set tSQLStat.%SelectMode = 1

        // Ejecutamos la select y lanzamos una excepción en caso de error
        set tRS = ##class(%SQL.Statement).%ExecDirect(.tSQLStat,.tQuery,pEmpID)

        throw:tRS.%SQLCODE'=0 ##class(%Exception.SQL).CreateFromSQLCODE(tRS.%SQLCODE,tRS.%Message)

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
        while tRS.%Next()
        {
            write !
            for i=1:1:$length(pSelect,",")
            {
                write ?(25*(i-1)),tRS.%GetData(i)
            }
        }
        write !
    }
    Catch e
    {
        Set tSC=e.AsStatus()
    }

    Return tSC
}

}
