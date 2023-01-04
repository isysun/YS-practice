Include %syPrompt

Class CDUI.Demo.Test
{

ClassMethod GetLocation(StartsWith As %String = "", LocationTypeID As %String = "", Active As %String = "", PageSize As %Integer = "", ByRef Page As %Integer = "", ByRef ResultsList) As %Status
{
	set request = ##class(CDUI.Demo.Request.Location).%New()
	if StartsWith '=""
	{
		set request.Description = StartsWith
	}	
	if Page'=""
	{
		set request.page = Page
	}
	if PageSize'=""
	{
		set request.count = PageSize
	}
	if LocationTypeID '=""
	{
		set request.LocationTypeID = LocationTypeID
	}
	if Active '=""
	{
		set request.Active = Active
	}
	#; ,request.HospitalDesc = Desc
	set ResultsList = ##class(%ListOfObjects).%New() 

	set sc = ##class(Ens.Director).CreateBusinessService("CDUI.Demo.Service.Adaptorless",.svc)
	set sc = $$$ADDSC(sc,svc.ProcessInput(request,.response))

	if $$$ISOK(sc)
	{
		set json = {}.%FromJSON(response.StringValue)
		set iterator = json.results.%GetIterator()
		while iterator.%GetNext(.key,.value)
		{	
			do ResultsList.Insert(value)
		}
		#; write ResultsList.Count()
		#; write !, ResultsList.GetAt(1).CTLOCCode
	}
	quit sc
}

// ClassMethod ListLocations()

// {

// 	set promptResult = ##class(%Prompt).GetString("Search for location starting with : ",.value)

// 	set sc = ..List(value,24,.page,.results)

// 	set i = ""

// 	for

// 	{

// 		set i = $order(results(i),1,location)

// 		quit:i=""

// 		set code = $listget(location),codelen = $length(code)

// 		write !,$listget(location,1)_$justify("",(15-codelen))_" : "_$listget(location,2)

// 	}

// }

ClassMethod NewLocation() As %Status
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

ClassMethod NewPatient(Count As %Integer = 1, ByRef PatientIDList) As %Status
{
	set PatientIDList = $LISTBUILD()
	set sc = ..ListInsurance("Y",,,.insuranceList)
	for i = 1:1:Count{
		set PAPERName = ##class(%PopulateUtils).FirstName() 
		set PAPERName2 = ##class(%PopulateUtils).LastName()
		//TODO:generate CTSEXDesc randomly
		set CTSEXDesc = "Female"
		//TODO:generate PatientDOB randomly, PatientDOB cannot pass current date
		set PAPERDob = "10/2/2000"
		set insuranceRecord = insuranceList.GetAt(##class(%PopulateUtils).Random(insuranceList.Count()-1) + 1)

		set request = ##class(CDUI.Demo.Request.NewPatient).%New()
		set request.PAPERName = PAPERName
		set request.PAPERName2 = PAPERName2
		set request.CTSEXDesc = CTSEXDesc
		set request.PAPERDob = PAPERDob
		set request.INSTDesc = insuranceRecord.AUXITInsTypeDR
		set request.AUXITDesc = insuranceRecord.AUXITDesc

		set sc = ##class(Ens.Director).CreateBusinessService("CDUI.Demo.Service.Adaptorless",.svc)
		set sc = $$$ADDSC(sc,svc.ProcessInput(request,.response))
		if $$$ISOK(sc)
		{
			set json = {}.%FromJSON(response.StringValue)
			// append each new patient ID to the end of the patientIDList
			set $list(PatientIDList,*+1) = json.ID
			write !, PatientIDList, !
			zwrite response
			write !,"Created Patient Row ID "_json.ID
		}
	}		
	quit sc
}

ClassMethod ListInsurance(Active As %String = "", PageSize As %Integer = "", ByRef Page As %Integer = "", ByRef ResultsList) As %Status
{
	set request = ##class(CDUI.Demo.Request.ReqInsTables).%New()
	if Active '= ""
	{
		set request.Active = Active
	}
	if PageSize '= ""
	{
		set request.PageSize = PageSize
	}
	if Page '=""
	{
		set request.Page = Page
	}
	set ResultsList = ##class(%ListOfObjects).%New()
	set sc = ##class(Ens.Director).CreateBusinessService("CDUI.Demo.Service.Adaptorless",.svc)
	set sc = $$$ADDSC(sc,svc.ProcessInput(request,.response))
	if $$$ISOK(sc)
	{
		set json = {}.%FromJSON(response.StringValue)
		set results = json.results
		set iterator = json.results.%GetIterator()
		while iterator.%GetNext(.key,.value)
		{	
			do ResultsList.Insert(value)		
		}
		#; write ResultsList.Count()
		#; write !, ResultsList.GetAt(1).AUXITRowId
	}
	quit sc
}

ClassMethod NewEpisode(Count As %Integer = 1, ByRef EpisodeIDList) As %Status
{
	set sc1 = ..GetLocation(,"E","A",,,.locationList)
	set sc2 = ..NewPatient(3,.patientList)
	set EpisodeIDList = ##class(%ListOfDataTypes).%New()
	set currentDate = $PIECE($HOROLOG,",",1)
	set currentTime = $PIECE($HOROLOG,",",2)
	
	set PatientID = patientList.GetAt(##class(%PopulateUtils).Random(patientList.Count()-1) + 1)
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
