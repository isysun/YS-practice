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
  return InputList.GetAt(##class(%PopulateUtils).Random(InputList.Count()-1) + 1)
}

}
