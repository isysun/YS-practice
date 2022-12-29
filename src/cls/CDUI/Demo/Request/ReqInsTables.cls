Class CDUI.Demo.Request.ReqInsTables Extends (Ens.Request, %JSON.Adaptor)
{

Property INSTDesc As %String;

Property AUXITDesc As %String;

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
</Data>
<DefaultData>ReqInsTablesDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
