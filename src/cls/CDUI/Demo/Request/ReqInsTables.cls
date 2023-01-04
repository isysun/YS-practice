Class CDUI.Demo.Request.ReqInsTables Extends (Ens.Request, %JSON.Adaptor)
{

Property count As %Integer(%JSONFIELDNAME = "_count");

Property page As %Integer(%JSONFIELDNAME = "page");

Property Active As %String(%JSONFIELDNAME = "Active", DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N");

Property Serialised As %RawString(%JSONINCLUDE = "NONE") [ Transient ];

Method SerialisedGet() As %RawString
{
	do ..%JSONExportToString(.json)
	return json
}

Storage Default
{
<Data name="ReqInsTablesDefaultData">
<Subscript>"ReqInsTables"</Subscript>
<Value name="1">
<Value>INSTDesc</Value>
</Value>
<Value name="2">
<Value>AUXITDesc</Value>
</Value>
<Value name="3">
<Value>count</Value>
</Value>
<Value name="4">
<Value>page</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
</Data>
<DefaultData>ReqInsTablesDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
