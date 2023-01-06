Class CDUI.Demo.Request.OrderItems Extends (Ens.Request, %JSON.Adaptor)
{

Property count As %Integer(%JSONFIELDNAME = "_count");

Property page As %Integer(%JSONFIELDNAME = "page");

Property Serialised As %RawString(%JSONINCLUDE = "NONE") [ Transient ];

Method SerialisedGet() As %RawString
{
	do ..%JSONExportToString(.json)
	return json
}

Storage Default
{
<Data name="OrderItemsDefaultData">
<Subscript>"OrderItems"</Subscript>
<Value name="1">
<Value>count</Value>
</Value>
<Value name="2">
<Value>page</Value>
</Value>
</Data>
<DefaultData>OrderItemsDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
