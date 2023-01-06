/// 
Class CDUI.Demo.Process.MsgRouter.RESTRoutingRule Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "EnsLib.MsgRouter.RuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="EnsLib.MsgRouter.RoutingEngine" production="CDUI.Demo.Production">
<ruleSet name="REST" effectiveBegin="" effectiveEnd="">
<rule name="NewPatient">
<constraint name="source" value="CDUI.Demo.Service.Adaptorless"></constraint>
<constraint name="msgClass" value="CDUI.Demo.Request.NewPatient"></constraint>
<when condition="1">
<send transform="" target="CDUI.Demo.Operation.REST.Patient"></send>
<return></return>
</when>
</rule>
<rule name="Location">
<constraint name="source" value="CDUI.Demo.Service.Adaptorless"></constraint>
<constraint name="msgClass" value="CDUI.Demo.Request.Location"></constraint>
<when condition="1">
<send transform="" target="CDUI.Demo.Operation.REST.Location"></send>
<return></return>
</when>
</rule>
<rule name="NewLocation">
<constraint name="source" value="CDUI.Demo.Service.Adaptorless"></constraint>
<constraint name="msgClass" value="CDUI.Demo.Request.NewLocation"></constraint>
<when condition="1">
<send transform="" target="CDUI.Demo.Operation.REST.Location"></send>
<return></return>
</when>
</rule>
<rule name="ListInsurance">
<constraint name="source" value="CDUI.Demo.Service.Adaptorless"></constraint>
<constraint name="msgClass" value="CDUI.Demo.Request.ReqInsTables"></constraint>
<when condition="1">
<send transform="" target="CDUI.Demo.Operation.REST.ReqInsTables"></send>
<return></return>
</when>
</rule>
<rule name="NewEpisode">
<constraint name="source" value="CDUI.Demo.Service.Adaptorless"></constraint>
<constraint name="msgClass" value="CDUI.Demo.Request.NewEpisode"></constraint>
<when condition="1">
<send transform="" target="CDUI.Demo.Operation.REST.Episode"></send>
<return></return>
</when>
</rule>
<rule name="GetItems">
<constraint name="source" value="CDUI.Demo.Service.Adaptorless"></constraint>
<constraint name="msgClass" value="CDUI.Demo.Request.OrderItems"></constraint>
<when condition="1">
<send transform="" target="CDUI.Demo.Operation.REST.OrderItems"></send>
<return></return>
</when>
</rule>
</ruleSet>
</ruleDefinition>
}

}
