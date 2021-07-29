/// Jugando con macros en métodos
Class User.BasicMacro
{

/// Define macro
ClassMethod EjemploMacros(pMsg As %String = "Resultado", pX As %Integer = 10, pY As %Integer = 1) As %Status
{
    #Define Macro9A(%x) READ !,"Name: ",name  WRITE !,"%x ",name,!
    #define D(%msg,%x,%y) write !,%msg," : ",%x\%y 

    $$$D(pMsg,pX,pY)
    $$$Macro9A(Bienvenido)
    return 1
}

}
