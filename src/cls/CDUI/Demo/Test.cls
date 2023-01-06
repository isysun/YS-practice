Import (CDUI.Demo.Common, CDUI.Demo.Utils)

Include %syPrompt

Class CDUI.Demo.Test Extends Ens.Util.IOLogger
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
	//set PatientIDList = $LISTBUILD()
	set PatientIDList = ##class(%ListOfDataTypes).%New()
	set sc = ..ListInsurance("Y",,,.insuranceList)
	for i = 1:1:Count{ 
		//TODO:generate CTSEXDesc randomly
		set CTSEXDesc = ##class(PUtils).RdSEX()
		//TODO:generate PatientDOB randomly, PatientDOB cannot pass current date
		set PAPERDob = ##class(PUtils).RdDOB()
		set insuranceRecord = ##class(PUtils).RdListElement(insuranceList)
		//write !,insuranceRecord.AUXITDesc
		set request = ##class(CDUI.Demo.Request.NewPatient).%New()
		set request.PAPERName = ##class(%PopulateUtils).FirstName()
		set request.PAPERName2 = ##class(%PopulateUtils).LastName()
		set request.CTSEXDesc = CTSEXDesc
		set request.PAPERDob = PAPERDob
		set request.INSTDesc = insuranceRecord.AUXITInsTypeDR
		set request.AUXITDesc = insuranceRecord.AUXITDesc

		set sc = ##class(Ens.Director).CreateBusinessService("CDUI.Demo.Service.Adaptorless",.svc)
		set sc = $$$ADDSC(sc,svc.ProcessInput(request,.response))
		set json = {}.%FromJSON(response.StringValue)
		if $$$ISOK(sc)
		{
			if json.ERROR = ""{
				do PatientIDList.Insert(json.ID)
				#; zwrite response
				#; w !, request.PAPERName
				#; w !, request.PAPERName2
				#; w !, request.PAPERDob
			}
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
	//generate locationList and patientList
	set sc1 = ..GetLocation(,"E","Y",,,.locationList)
	set sc2 = ..NewPatient(3,.patientList)
	//generate empty list to store episode id
	set EpisodeIDList = ##class(%ListOfDataTypes).%New()
	
	for i = 1:1:Count{
		set PAADMType = ##class(PUtils).RdAdmType()
		set CTLOCDesc = ##class(PUtils).RdListElement(locationList).CTLOCDesc

		set request = ##class(CDUI.Demo.Request.NewEpisode).%New()
		set request.PatientID = ##class(PUtils).RdListElement(patientList)
		set request.CTLOCDesc = CTLOCDesc
		set request.PAADMType = PAADMType
		set request.PAADMAdmDate = ##class(PUtils).RdAdmDate()
		set request.PAADMAdmTime = ##class(PUtils).RdTime()

		set sc = ##class(Ens.Director).CreateBusinessService("CDUI.Demo.Service.Adaptorless",.svc)
		set sc = $$$ADDSC(sc,svc.ProcessInput(request,.response))
		if $$$ISOK(sc)
		{
			set json = {}.%FromJSON(response.StringValue)
			if json.ERROR = ""{
				do EpisodeIDList.Insert(json.ID)
				zwrite response
				write !,"Created ID "_json.ID
				write !, EpisodeIDList.GetAt(1)
			}
			else{
				write "An error occurs!"_json.ERROR
			}
		}
	}
	quit sc
}

ClassMethod GetItems(PageSize As %Integer = "", ByRef Page As %Integer = "", Output ResultsList)
{
	set request = ##class(CDUI.Demo.Request.OrderItems).%New()
	set ResultsList = ##class(%ListOfObjects).%New()
	if PageSize '= ""{
		set request.count = PageSize
	}
	if Page '= ""{
		set request.page = Page
	}

	//start service call
	$$$LOGINFO("[GetItems] BS is initiated")
	Try 
	{
		set sc = ##class(Ens.Director).CreateBusinessService("CDUI.Demo.Service.Adaptorless",.svc)
		set sc = $$$ADDSC(sc,svc.ProcessInput(request,.response))
		if $$$ISOK(sc)
		{
			set json = {}.%FromJSON(response.StringValue)
			set iterator = json.results.%GetIterator()
			while iterator.%GetNext(.key,.value){
				do ResultsList.Insert(value)
			}
		}
		else{
			$$$LOGERROR("[GetItems] Failed to retrive items. Error(sc):"_$System.Status.DisplayError(sc))
		}
		$$$LOGINFO("[GetItems] Successfully retrive items. Sample item:"_ResultsList.GetAt(1).ARCIMDesc)
	}
	catch ex
	{
		$$$LOGERROR("[GetItems] Failed to retrive items. Error(Ex):"_ex.DisplayString())
	}
	quit sc
}

ClassMethod NewOrder(Count As %Integer, Output OrderIDList) As %Status
{
	//generate new episodes for the order
	set sc1 = ..NewEpisode(1,)
}

}
