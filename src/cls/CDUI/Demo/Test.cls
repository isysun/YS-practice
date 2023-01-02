Include %syPrompt

Class CDUI.Demo.Test
{

ClassMethod List(StartsWith As %String = "", PageSize As %Integer = "", ByRef Page As %Integer = "", ByRef Results) As %Status
{
	set request = ##class(CDUI.Demo.Request.Location).%New()
	set request.Description = StartsWith
	if Page'=""
	{
		set request.page = Page
	}
	if PageSize'=""
	{
		set request.count = PageSize
	}
	#; ,request.HospitalDesc = Desc
	set sc = ##class(Ens.Director).CreateBusinessService("CDUI.Demo.Service.Adaptorless",.svc)
	set sc = $$$ADDSC(sc,svc.ProcessInput(request,.response))

	if $$$ISOK(sc)
	{
		set json = {}.%FromJSON(response.StringValue)
		set iterator = json.results.%GetIterator()
		while iterator.%GetNext(.key,.value)
		{	
			set Results($increment(Results)) = $listbuild(value.CTLOCCode,value.CTLOCDesc)
		}
	}
	quit sc
}

ClassMethod ListLocations()
{
	set promptResult = ##class(%Prompt).GetString("Search for location starting with : ",.value)
	set sc = ..List(value,24,.page,.results)
	set i = ""
	for
	{
		set i = $order(results(i),1,location)
		quit:i=""
		set code = $listget(location),codelen = $length(code)
		write !,$listget(location,1)_$justify("",(15-codelen))_" : "_$listget(location,2)
	}
}

ClassMethod NewLocation()
{
	set CTLOCCode = "Z"_##class(%PopulateUtils).String(5)
	set CTLOCDesc = $zconvert($translate(##class(%PopulateUtils).Syllable(10)," "),"S")
	set request = ##class(CDUI.Demo.Request.NewLocation).%New()
	set request.CTLOCCode = CTLOCCode,request.CTLOCDesc = CTLOCDesc
	set sc = ##class(Ens.Director).CreateBusinessService("CDUI.Demo.Service.Adaptorless",.svc)
	set sc = $$$ADDSC(sc,svc.ProcessInput(request,.response))
	if $$$ISOK(sc)
	{
		set json = {}.%FromJSON(response.StringValue)
		write !,"Created CT_Loc RowID "_json.ID
	}
	quit sc
}

ClassMethod NewPatient() As %List
{
	set patientIDList = $LISTBUILD()
	for i = 1:1:3{
		set PAPERName = ##class(%PopulateUtils).FirstName() //ID: 11480
		set PAPERName2 = ##class(%PopulateUtils).LastName()
		set CTSEXDesc = "Female"
		set PAPERDob = "10/2/2000"
		set INSTDesc = "BUPA Australia"
		set AUXITDesc = "BUP Basic"

		set request = ##class(CDUI.Demo.Request.NewPatient).%New()
		set request.PAPERName = PAPERName
		set request.PAPERName2 = PAPERName2
		set request.CTSEXDesc = CTSEXDesc
		set request.PAPERDob = PAPERDob
		set request.INSTDesc = INSTDesc
		set request.AUXITDesc = AUXITDesc

		set sc = ##class(Ens.Director).CreateBusinessService("CDUI.Demo.Service.Adaptorless",.svc)
		set sc = $$$ADDSC(sc,svc.ProcessInput(request,.response))
		if $$$ISOK(sc)
		{
			set json = {}.%FromJSON(response.StringValue)
			set $list(patientIDList,*+1) = json.ID
			write !, patientIDList
			zwrite response
			write !,"Created ID "_json.ID
		}
	}		
	//quit sc
	return patientIDList
}

ClassMethod ListInsurance(ByRef resultList) As %Status
{
	set resultList = ##class(%ListOfObjects).%New()

	set request = ##class(CDUI.Demo.Request.ReqInsTables).%New()
	set sc = ##class(Ens.Director).CreateBusinessService("CDUI.Demo.Service.Adaptorless",.svc)
	set sc = $$$ADDSC(sc,svc.ProcessInput(request,.response))
	if $$$ISOK(sc)
	{
		set json = {}.%FromJSON(response.StringValue)
		set results = json.results
		set iterator = json.results.%GetIterator()
		while iterator.%GetNext(.key,.value)
		{	
			do resultList.Insert(value)		
		}
	}
	write !, resultList.GetAt(1).AUXITInsTypeDR
	write !, resultList.Count()
	quit sc
}

ClassMethod NewEpisode()
{
	set PatientID = "testid"
	set CTLOCDesc = "Admissions H1"
	set PAADMType = "E"
	set PAADMAdmDate = ##class(%PopulateUtils).Date()
	set PAADMAdmTime = "64800"

	set request = ##class(CDUI.Demo.Request.NewEpisode).%New()
	set request.PatientID = PatientID
	set request.CTLOCDesc = CTLOCDesc
	set request.PAADMType = PAADMType
	set request.PAADMAdmDate = PAADMAdmDate
	set request.PAADMAdmTime = PAADMAdmTime

	set sc = ##class(Ens.Director).CreateBusinessService("CDUI.Demo.Service.Adaptorless",.svc)
	set sc = $$$ADDSC(sc,svc.ProcessInput(request,.response))
	if $$$ISOK(sc)
	{
		set json = {}.%FromJSON(response.StringValue)
		zwrite response
		write !,"Created ID "_json.ID
	}
}

}
