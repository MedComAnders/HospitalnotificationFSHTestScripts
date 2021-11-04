Instance: ffb-1-encounter
InstanceOf: TestScript
* insert Metadata
* id = "ffb-1-encounter"
* name = "First documentation phase"
* title = "First documentation phase"
* description = "Testing correct use of First documentation phase"
* insert createFfbReportTest( 1, /FHIRSandbox/MedCom/401-ffb-reporting/send/Userstory/_reference/resources/firstEncounter.xml)


RuleSet: createFfbReportTest(number, fixture)
* origin.index = 1
* origin.profile.system = "http://terminology.hl7.org/CodeSystem/testscript-profile-origin-types"
* origin.profile.code = #FHIR-Client

* destination.index = 1
* destination.profile.system = "http://terminology.hl7.org/CodeSystem/testscript-profile-destination-types"
* destination.profile.code = #FHIR-Server

* fixture[+].id = "bundle-create-{number}"
* fixture[=].autocreate = false
* fixture[=].autodelete = false
* fixture[=].resource.reference = "{fixture}"

* profile.id = "kl-ffb-reporting-profile"
* profile.reference = "http://ffb/reporting/kl.dk/1.0/StructureDefinition/kl-reporting-ffb-deliveryReport" 

//There will only be one and only one MunicipalityCaseNumber for each test.
* variable[+].name = "MunicipalityCaseNumber"
* variable[=].expression = "Bundle.entry.resource.ofType('ServiceRequest').extension.where(url= 'http://ffb/reporting/kl.dk/1.0/StructureDefinition/kl-reporting-ffb-municipalityCaseNumber').extension.where(url= 'municipalitySpecific').value.value"
* variable[=].sourceId = "bundle-create-{number}"
/*
* variable[+].name = "headerResourceReference{type}{number}"
* variable[=].expression = "Bundle.entry[0].fullUrl"
* variable[=].sourceId = "bundle-create-{number}"

* variable[+].name = "firstEpisodeOfCareIdentifier{type}{number}"
* variable[=].expression = "Bundle.entry.resource.ofType(Encounter).episodeOfCare.identifier.value"
* variable[=].sourceId = "bundle-create-{number}"
*/

* test[+].id = "HN-{type}-{number}" 
* test[=].name = "{number} Post ffb-report" 
* test[=].description = "Post ffb-report" 
* test[=].action[+].operation.type.system = "http://terminology.hl7.org/CodeSystem/testscript-operation-codes"
* test[=].action[=].operation.type.code = #create
* test[=].action[=].operation.resource = #Bundle
* test[=].action[=].operation.description = "Post a ffb-report"
* test[=].action[=].operation.destination = 1
* test[=].action[=].operation.encodeRequestUrl = true
* test[=].action[=].operation.origin = 1
* test[=].action[=].operation.sourceId = "bundle-create-{number}" 

* test[=].action[+].assert.description = "Confirm that the client request payload contains a Bundle resource type."
* test[=].action[=].assert.direction = #request
* test[=].action[=].assert.resource = #Bundle
* test[=].action[=].assert.warningOnly = false

* test[=].action[+].assert.description = "Confirm that the Bundle is of type collection"
* test[=].action[=].assert.direction = #request
* test[=].action[=].assert.expression = "Bundle.type"
* test[=].action[=].assert.operator = #equals
* test[=].action[=].assert.value = #collection
* test[=].action[=].assert.warningOnly = false

* test[=].action[+].assert.description = "Confirm that the Bundle contains an Identifier"
* test[=].action[=].assert.direction = #request
* test[=].action[=].assert.expression = "Bundle.entry.resource.ofType(Patient).identifier.exists()"
* test[=].action[=].assert.warningOnly = false

* test[=].action[+].assert.description = "Confirm that the Bundle contains a ServiceRequest MunicipalityCaseNumber"
* test[=].action[=].assert.direction = #request
* test[=].action[=].assert.expression = "Bundle.entry.resource.ofType('ServiceRequest').extension.where(url= 'http://ffb/reporting/kl.dk/1.0/StructureDefinition/kl-reporting-ffb-municipalityCaseNumber').extension.where(url= 'municipalitySpecific').value.value"
* test[=].action[=].assert.warningOnly = false

* test[=].action[+].assert.description = "Confirm that the Bundle contains a ServiceRequest MunicipalityCaseNumber"
* test[=].action[=].assert.direction = #request
* test[=].action[=].assert.expression = "Bundle.entry.resource.ofType('ClinicalImpression').extension.where(url= 'http://kl.dk/fhir/common/caresocial/StructureDefinition/BasedOnServiceRequest').value"
* test[=].action[=].assert.operator = #equals
* test[=].action[=].assert.value = "${MunicipalityCaseNumber}"
* test[=].action[=].assert.warningOnly = false


