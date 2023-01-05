Class CDUI.Demo.test2
{

ClassMethod GetRandomTime()
{
        w $ZTIME(##class(%PopulateUtils).Random(86399))
}

ClassMethod convertDateToH(date)
{
    set Hformat = $ZDATEH(date,4,,4)
    w !,Hformat
    set Dformat = $zdate(Hformat,4,,4)
    w !,Dformat
}

ClassMethod random()
{
    set random = ##class(%PopulateUtils).Random(2)
    w random
}

}
