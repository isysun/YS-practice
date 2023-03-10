Class CDUI.Demo.Request.NewEpisode Extends (Ens.Request, %JSON.Adaptor)
{

Property PatientID As %String;

Property CTLOCDesc As %String;

Property PAADMType As %String;

Property PAADMAdmDate As %String;

Property PAADMAdmTime As %String;

Method SerialisedGet() As %RawString
{
	do ..%JSONExportToString(.json)
	return json
}

Storage Default
{
<Data name="NewEpisodeDefaultData">
<Subscript>"NewEpisode"</Subscript>
<Value name="1">
<Value>PatientID</Value>
</Value>
<Value name="2">
<Value>CTLOCDesc</Value>
</Value>
<Value name="3">
<Value>PAADMType</Value>
</Value>
<Value name="4">
<Value>PAADMAdmDate</Value>
</Value>
<Value name="5">
<Value>PAADMAdmTime</Value>
</Value>
</Data>
<DefaultData>NewEpisodeDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
