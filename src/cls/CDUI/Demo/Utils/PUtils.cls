Class CDUI.Demo.Utils.PUtils Extends %PopulateUtils
{

ClassMethod RdFirstName()
{
}

ClassMethod RdLastName()
{
}

ClassMethod RdListElement(InputList As %List)
{
    set random = ..Random(InputList.Count())+1
    return InputList.GetAt(random)
}

ClassMethod RdTime()
{
    return $ztime(..Random(86399))
}

// return a random date for an episode

ClassMethod RdAdmDate()
{
    set RdAdmDateH = ..Date(65379, $piece($HOROLOG,",",1))
    set RdAdmDateD = $zdate(RdAdmDateH,4,,4)
    return RdAdmDateD
}

ClassMethod RdDOB()
{
    set currentDate = $piece($horolog, ",", 1)
    set minDate = currentDate - 36500
    set RdDOBH = ..Date(minDate, currentDate)
    set RdDOBD = $zdate((RdDOBH),4,,4)
    return RdDOBD
}

ClassMethod RdSEX()
{
    set sexList = $LISTBUILD("Male", "Female", "Indeterminate", "Unknown", "Other")
    set random = ..Random($LISTLENGTH(sexList))+1
    set RdSex = $LIST(sexList,random)
    return RdSex
}

ClassMethod RdAdmType()
{
    set admTypeList = $LISTBUILD("E","I") 
    set random = ..Random($LISTLENGTH(admTypeList))+1
    return $List(admTypeList,random)
}

}
