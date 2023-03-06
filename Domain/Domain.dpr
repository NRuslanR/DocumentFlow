program Domain;

{%TogetherDiagram 'ModelSupport_Domain\default.txaPackage'}

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Forms,
  IDocumentChargeSheetUnit in 'Documents\Common\Entities\Interfaces\IDocumentChargeSheetUnit.pas',
  IDocumentUnit in 'Documents\Common\Entities\Interfaces\IDocumentUnit.pas',
  Document in 'Documents\Common\Entities\Document.pas',
  DocumentApprovingCycle in 'Documents\Common\Entities\DocumentApprovingCycle.pas',
  DocumentApprovingCycleResult in 'Documents\Common\Entities\DocumentApprovingCycleResult.pas',
  DocumentApprovings in 'Documents\Common\Entities\DocumentApprovings.pas',
  DocumentCharges in 'Documents\Common\Entities\DocumentCharges.pas',
  DocumentChargeSheet in 'Documents\Common\Entities\DocumentChargeSheet.pas',
  DocumentFileUnit in 'Documents\Common\Entities\DocumentFileUnit.pas',
  DocumentRelationsUnit in 'Documents\Common\Entities\DocumentRelationsUnit.pas',
  DocumentSignings in 'Documents\Common\Entities\DocumentSignings.pas',
  DocumentWorkCycle in 'Documents\Common\Entities\DocumentWorkCycle.pas',
  IncomingDocument in 'Documents\Common\Entities\IncomingDocument.pas',
  StandardApprovingDocumentSendingRule in 'Documents\Common\Rules\Approving\StandardApprovingDocumentSendingRule.pas',
  StandardDocumentApproverListChangingRule in 'Documents\Common\Rules\Approving\StandardDocumentApproverListChangingRule.pas',
  StandardDocumentApprovingPassingMarkingRule in 'Documents\Common\Rules\Approving\StandardDocumentApprovingPassingMarkingRule.pas',
  StandardDocumentApprovingPerformingRule in 'Documents\Common\Rules\Approving\StandardDocumentApprovingPerformingRule.pas',
  StandardDocumentApprovingRejectingPerformingRule in 'Documents\Common\Rules\Approving\StandardDocumentApprovingRejectingPerformingRule.pas',
  DocumentApproverListChangingRule in 'Documents\Common\Rules\Approving\Interfaces\DocumentApproverListChangingRule.pas',
  DocumentApprovingPerformingRule in 'Documents\Common\Rules\Approving\Interfaces\DocumentApprovingPerformingRule.pas',
  DocumentApprovingRejectingPerformingRule in 'Documents\Common\Rules\Approving\Interfaces\DocumentApprovingRejectingPerformingRule.pas',
  DocumentChargeListChangingRule in 'Documents\Common\Rules\Charges\Interfaces\DocumentChargeListChangingRule.pas',
  StandardDocumentChargeListChangingRule in 'Documents\Common\Rules\Charges\StandardDocumentChargeListChangingRule.pas',
  EmployeeDocumentWorkingRule in 'Documents\Common\Rules\Common\Interfaces\EmployeeDocumentWorkingRule.pas',
  EmployeeDocumentWorkingRules in 'Documents\Common\Rules\Common\EmployeeDocumentWorkingRules.pas',
  StandardEmployeeDocumentWorkingRule in 'Documents\Common\Rules\Common\StandardEmployeeDocumentWorkingRule.pas',
  StandardPerformingDocumentSendingRule in 'Documents\Common\Rules\Performing\StandardPerformingDocumentSendingRule.pas',
  DocumentSignerListChangingRule in 'Documents\Common\Rules\Signing\Interfaces\DocumentSignerListChangingRule.pas',
  DocumentSigningPerformingRule in 'Documents\Common\Rules\Signing\Interfaces\DocumentSigningPerformingRule.pas',
  DocumentSigningRejectingPerformingRule in 'Documents\Common\Rules\Signing\Interfaces\DocumentSigningRejectingPerformingRule.pas',
  StandardDocumentSignerListChangingRule in 'Documents\Common\Rules\Signing\StandardDocumentSignerListChangingRule.pas',
  StandardEmployeeDocumentSigningPerformingRule in 'Documents\Common\Rules\Signing\StandardEmployeeDocumentSigningPerformingRule.pas',
  StandardEmployeeDocumentSigningRejectingPerformingRule in 'Documents\Common\Rules\Signing\StandardEmployeeDocumentSigningRejectingPerformingRule.pas',
  StandardSigningDocumentSendingRule in 'Documents\Common\Rules\Signing\StandardSigningDocumentSendingRule.pas',
  DocumentUsageEmployeeAccessRightsService in 'Documents\Common\Services\Access Rights\Interfaces\DocumentUsageEmployeeAccessRightsService.pas',
  StandardDocumentUsageEmployeeAccessRightsService in 'Documents\Common\Services\Access Rights\StandardDocumentUsageEmployeeAccessRightsService.pas',
  StandardIncomingDocumentUsageEmployeeAccessRightsService in 'Documents\Common\Services\Access Rights\StandardIncomingDocumentUsageEmployeeAccessRightsService.pas',
  DocumentApprovingCycleResultFinder in 'Documents\Common\Services\Approving\Interfaces\DocumentApprovingCycleResultFinder.pas',
  DocumentApprovingProcessControlService in 'Documents\Common\Services\Approving\Interfaces\DocumentApprovingProcessControlService.pas',
  StandardDocumentApprovingProcessControlService in 'Documents\Common\Services\Approving\StandardDocumentApprovingProcessControlService.pas',
  DocumentFullNameCompilationService in 'Documents\Common\Services\Formalization\Interfaces\DocumentFullNameCompilationService.pas',
  DocumentResponsibleFinder in 'Documents\Common\Services\Formalization\Interfaces\DocumentResponsibleFinder.pas',
  StandardDocumentFullNameCompilationService in 'Documents\Common\Services\Formalization\StandardDocumentFullNameCompilationService.pas',
  DocumentNumerator in 'Documents\Common\Services\Numerators\Interfaces\DocumentNumerator.pas',
  DocumentNumeratorRegistry in 'Documents\Common\Services\Numerators\Interfaces\DocumentNumeratorRegistry.pas',
  AbstractDocumentNumeratorRegistry in 'Documents\Common\Services\Numerators\AbstractDocumentNumeratorRegistry.pas',
  StandardDocumentNumerator in 'Documents\Common\Services\Numerators\StandardDocumentNumerator.pas',
  CreatingNecessaryDataForDocumentPerformingService in 'Documents\Common\Services\Performing\Interfaces\CreatingNecessaryDataForDocumentPerformingService.pas',
  StandardCreatingNecessaryDataForDocumentPerformingService in 'Documents\Common\Services\Performing\StandardCreatingNecessaryDataForDocumentPerformingService.pas',
  DocumentRegistrationService in 'Documents\Common\Services\Registration\Interfaces\DocumentRegistrationService.pas',
  IncomingServiceNote in 'Documents\Service Notes\Entities\IncomingServiceNote.pas',
  ServiceNote in 'Documents\Service Notes\Entities\ServiceNote.pas',
  StandardDocumentDraftingRule in 'Documents\Common\Rules\Drafting\StandardDocumentDraftingRule.pas',
  DocumentDraftingRule in 'Documents\Common\Rules\Drafting\Interfaces\DocumentDraftingRule.pas',
  DocumentApprovingListCreatingService in 'Documents\Common\Services\Approving\Interfaces\DocumentApprovingListCreatingService.pas',
  DocumentApprovingList in 'Documents\Common\Entities\DocumentApprovingList.pas',
  StandardDocumentApprovingListCreatingService in 'Documents\Common\Services\Approving\StandardDocumentApprovingListCreatingService.pas',
  StandardAsSelfRegisteredDocumentMarkingRule in 'Documents\Common\Rules\Drafting\StandardAsSelfRegisteredDocumentMarkingRule.pas',
  EmployeeDocumentKindAccessRightsService in 'Documents\Common\Services\Access Rights\Interfaces\EmployeeDocumentKindAccessRightsService.pas',
  StandardEmployeeDocumentKindAccessRightsService in 'Documents\Common\Services\Access Rights\StandardEmployeeDocumentKindAccessRightsService.pas',
  DocumentKind in 'Documents\Common\Entities\DocumentKind.pas',
  DocumentRelationsFinder in 'Documents\Common\Services\Relations\DocumentRelationsFinder.pas',
  TestFormUnit in 'TestFormUnit.pas' {Form6},
  StandardInternalDocumentChargeListChangingRule in 'Documents\Common\Rules\Charges\StandardInternalDocumentChargeListChangingRule.pas',
  StandardInternalDocumentSignerListChangingRule in 'Documents\Common\Rules\Signing\StandardInternalDocumentSignerListChangingRule.pas',
  AbstractDocumentDecorator in 'Documents\Common\Entities\AbstractDocumentDecorator.pas',
  InternalDocument in 'Documents\Common\Entities\InternalDocument.pas',
  InternalServiceNote in 'Documents\Service Notes\Entities\InternalServiceNote.pas',
  StandardInternalDocumentDraftingRule in 'Documents\Common\Rules\Drafting\StandardInternalDocumentDraftingRule.pas',
  IncomingInternalServiceNote in 'Documents\Service Notes\Entities\IncomingInternalServiceNote.pas',
  DocumentKindWorkCycleInfo in 'Documents\Common\Supporting Objects\DocumentKindWorkCycleInfo.pas',
  DocumentKindWorkCycleInfoService in 'Documents\Common\Services\References\Interfaces\DocumentKindWorkCycleInfoService.pas',
  StandardDocumentKindWorkCycleInfoService in 'Documents\Common\Services\References\Standard\StandardDocumentKindWorkCycleInfoService.pas',
  DocumentAccessRightsServiceRegistry in 'Documents\Common\Services\Access Rights\DocumentAccessRightsServiceRegistry.pas',
  DocumentFormalizationServiceRegistry in 'Documents\Common\Services\Formalization\DocumentFormalizationServiceRegistry.pas',
  DocumentRelationsServiceRegistry in 'Documents\Common\Services\Relations\DocumentRelationsServiceRegistry.pas',
  DocumentApprovingRuleRegistry in 'Documents\Common\Rules\Approving\DocumentApprovingRuleRegistry.pas',
  DocumentDraftingRuleRegistry in 'Documents\Common\Rules\Drafting\DocumentDraftingRuleRegistry.pas',
  DocumentChargeSheetRuleRegistry in 'Documents\Common\Rules\Charge Sheets\DocumentChargeSheetRuleRegistry.pas',
  DocumentChargeRuleRegistry in 'Documents\Common\Rules\Charges\DocumentChargeRuleRegistry.pas',
  StandardEmployeeDocumentEditingRule in 'Documents\Common\Rules\Access\Editing\StandardEmployeeDocumentEditingRule.pas',
  DocumentRemovingRule in 'Documents\Common\Rules\Access\Removing\Interfaces\DocumentRemovingRule.pas',
  StandardDocumentRemovingRule in 'Documents\Common\Rules\Access\Removing\StandardDocumentRemovingRule.pas',
  StandardEmployeeDocumentViewingRule in 'Documents\Common\Rules\Access\Viewing\StandardEmployeeDocumentViewingRule.pas',
  DocumentAccessRuleRegistry in 'Documents\Common\Rules\Access\DocumentAccessRuleRegistry.pas',
  DocumentPerformingRuleRegistry in 'Documents\Common\Rules\Performing\DocumentPerformingRuleRegistry.pas',
  DocumentSigningRuleRegistry in 'Documents\Common\Rules\Signing\DocumentSigningRuleRegistry.pas',
  DocumentRuleRegistry in 'Documents\Common\Rules\DocumentRuleRegistry.pas',
  DocumentApprovingServiceRegistry in 'Documents\Common\Services\Approving\DocumentApprovingServiceRegistry.pas',
  DocumentNumerationServiceRegistry in 'Documents\Common\Services\Numerators\DocumentNumerationServiceRegistry.pas',
  DocumentPerformingServiceRegistry in 'Documents\Common\Services\Performing\DocumentPerformingServiceRegistry.pas',
  DocumentKindReferenceServiceRegistry in 'Documents\Common\Services\References\DocumentKindReferenceServiceRegistry.pas',
  DocumentRegistrationServiceRegistry in 'Documents\Common\Services\Registration\DocumentRegistrationServiceRegistry.pas',
  DocumentServiceRegistry in 'Documents\Common\Services\DocumentServiceRegistry.pas',
  DocumentsDomainRegistries in 'Documents\DocumentsDomainRegistries.pas',
  DomainRegistries in 'DomainRegistries.pas',
  AbstractDocumentRegistrationService in 'Documents\Common\Services\Registration\AbstractDocumentRegistrationService.pas',
  StandardInDepartmentDocumentRegistrationService in 'Documents\Common\Services\Registration\StandardInDepartmentDocumentRegistrationService.pas',
  StandardInDepartmentIncomingDocumentRegistrationService in 'Documents\Common\Services\Registration\StandardInDepartmentIncomingDocumentRegistrationService.pas',
  StandardInDepartmentIncomingInternalDocumentRegistrationService in 'Documents\Common\Services\Registration\StandardInDepartmentIncomingInternalDocumentRegistrationService.pas',
  DocumentApprovingFinder in 'Documents\Common\Services\Approving\Interfaces\DocumentApprovingFinder.pas',
  DocumentFinder in 'Documents\Common\Services\Search\Interfaces\DocumentFinder.pas',
  DocumentSearchServiceRegistry in 'Documents\Common\Services\Search\DocumentSearchServiceRegistry.pas',
  DocumentDirectory in 'Documents\Common\Services\Storage\Interfaces\DocumentDirectory.pas',
  DocumentFileMetadataDirectory in 'Documents\Common\Services\Storage\Interfaces\DocumentFileMetadataDirectory.pas',
  DocumentRelationDirectory in 'Documents\Common\Services\Storage\Interfaces\DocumentRelationDirectory.pas',
  DocumentResponsibleDirectory in 'Documents\Common\Services\Storage\Interfaces\DocumentResponsibleDirectory.pas',
  AbstractDocumentDirectory in 'Documents\Common\Services\Storage\AbstractDocumentDirectory.pas',
  DocumentUsageEmployeeAccessRightsInfo in 'Documents\Common\Services\Access Rights\Interfaces\DocumentUsageEmployeeAccessRightsInfo.pas',
  DocumentFileStorageService in 'Documents\Common\Services\Storage\Interfaces\DocumentFileStorageService.pas',
  StandardDocumentFileStorageService in 'Documents\Common\Services\Storage\StandardDocumentFileStorageService.pas',
  RespondingDocumentCreatingService in 'Documents\Common\Services\Operations\Interfaces\RespondingDocumentCreatingService.pas',
  StandardRespondingDocumentCreatingService in 'Documents\Common\Services\Operations\StandardRespondingDocumentCreatingService.pas',
  DocumentOperationServiceRegistry in 'Documents\Common\Services\Operations\DocumentOperationServiceRegistry.pas',
  DocumentStorageServiceRegistry in 'Documents\Common\Services\Storage\DocumentStorageServiceRegistry.pas',
  FormalDocumentSignerFinder in 'Documents\Common\Services\Search\Interfaces\FormalDocumentSignerFinder.pas',
  StandardFormalDocumentSignerFinder in 'Documents\Common\Services\Search\StandardFormalDocumentSignerFinder.pas',
  DocumentApprovingCycleResultDirectory in 'Documents\Common\Services\Storage\Interfaces\DocumentApprovingCycleResultDirectory.pas',
  AbstractDocumentApprovingCycleResultDirectory in 'Documents\Common\Services\Storage\AbstractDocumentApprovingCycleResultDirectory.pas',
  IncomingDocumentDirectory in 'Documents\Common\Services\Storage\Interfaces\IncomingDocumentDirectory.pas',
  AbstractIncomingDocumentDirectory in 'Documents\Common\Services\Storage\AbstractIncomingDocumentDirectory.pas',
  AbstractDocumentFinder in 'Documents\Common\Services\Search\AbstractDocumentFinder.pas',
  SendingDocumentToPerformingService in 'Documents\Common\Services\Performing\Interfaces\SendingDocumentToPerformingService.pas',
  StandardSendingDocumentToPerformingService in 'Documents\Common\Services\Performing\StandardSendingDocumentToPerformingService.pas',
  IncomingInternalDocument in 'Documents\Common\Entities\IncomingInternalDocument.pas',
  DocumentChargeSheetDirectory in 'Documents\Common\Services\Storage\Interfaces\DocumentChargeSheetDirectory.pas',
  AbstractDocumentChargeSheetDirectory in 'Documents\Common\Services\Storage\AbstractDocumentChargeSheetDirectory.pas',
  CreatingNecessaryDataForCrossDepartmentDocumentPerformingService in 'Documents\Common\Services\Performing\Interfaces\CreatingNecessaryDataForCrossDepartmentDocumentPerformingService.pas',
  StandardCreatingNecessaryDataForCrossDepartmentDocumentPerformingService in 'Documents\Common\Services\Performing\StandardCreatingNecessaryDataForCrossDepartmentDocumentPerformingService.pas',
  StandardSendingCrossDepartmentDocumentToPerformingService in 'Documents\Common\Services\Performing\StandardSendingCrossDepartmentDocumentToPerformingService.pas',
  DocumentPerformingService in 'Documents\Common\Services\Performing\Interfaces\DocumentPerformingService.pas',
  StandardDocumentPerformingService in 'Documents\Common\Services\Performing\StandardDocumentPerformingService.pas',
  PersonnelOrder in 'Documents\Personnel Orders\Entities\PersonnelOrder.pas',
  DocumentSigningMarkingRule in 'Documents\Common\Rules\Signing\Interfaces\DocumentSigningMarkingRule.pas',
  PersonnelOrderControlGroup in 'Documents\Personnel Orders\Entities\PersonnelOrderControlGroup.pas',
  DocumentSigningService in 'Documents\Common\Services\Signing\Interfaces\DocumentSigningService.pas',
  StandardDocumentSigningService in 'Documents\Common\Services\Signing\StandardDocumentSigningService.pas',
  StandardDocumentSigningToPerformingService in 'Documents\Common\Services\Signing\StandardDocumentSigningToPerformingService.pas',
  DocumentSigningToPerformingService in 'Documents\Common\Services\Signing\Interfaces\DocumentSigningToPerformingService.pas',
  DocumentSigningServiceRegistry in 'Documents\Common\Services\Signing\DocumentSigningServiceRegistry.pas',
  PersonnelOrderAccessServiceRegistry in 'Documents\Personnel Orders\Services\Access\Registries\PersonnelOrderAccessServiceRegistry.pas',
  PersonnelOrderControlServiceRegistry in 'Documents\Personnel Orders\Services\Control\Registries\PersonnelOrderControlServiceRegistry.pas',
  DocumentApprovingsPicker in 'Documents\Common\Services\Approving\Interfaces\DocumentApprovingsPicker.pas',
  ToDocumentApprovingSheetApprovingsPicker in 'Documents\Common\Services\Approving\Approvings Pickers\ToDocumentApprovingSheetApprovingsPicker.pas',
  AbstractDocumentApprovingsPicker in 'Documents\Common\Services\Approving\Approvings Pickers\AbstractDocumentApprovingsPicker.pas',
  DocumentApprovingSheetDataCreatingService in 'Documents\Common\Services\Approving\Interfaces\DocumentApprovingSheetDataCreatingService.pas',
  DocumentApprovingSheetData in 'Documents\Common\Entities\DocumentApprovingSheetData.pas',
  StandardDocumentApprovingSheetDataCreatingService in 'Documents\Common\Services\Approving\StandardDocumentApprovingSheetDataCreatingService.pas',
  DocumentApprovingsCollector in 'Documents\Common\Services\Approving\Approving Collectors\Interfaces\DocumentApprovingsCollector.pas',
  StandardDocumentApprovingsCollector in 'Documents\Common\Services\Approving\Approving Collectors\StandardDocumentApprovingsCollector.pas',
  PersonnelOrderSignerListChangingRule in 'Documents\Personnel Orders\Rules\Signing\PersonnelOrderSignerListChangingRule.pas',
  DocumentCreatingService in 'Documents\Common\Services\Operations\Interfaces\DocumentCreatingService.pas',
  StandardDocumentCreatingService in 'Documents\Common\Services\Operations\StandardDocumentCreatingService.pas',
  DocumentWorkCycleFinder in 'Documents\Common\Services\Search\Interfaces\DocumentWorkCycleFinder.pas',
  DocumentKindFinder in 'Documents\Common\Services\Search\Interfaces\DocumentKindFinder.pas',
  AbstractDocumentKindFinder in 'Documents\Common\Services\Search\AbstractDocumentKindFinder.pas',
  PersonnelOrderSubKind in 'Documents\Personnel Orders\Entities\PersonnelOrderSubKind.pas',
  PersonnelOrderApproverList in 'Documents\Personnel Orders\Entities\PersonnelOrderApproverList.pas',
  PersonnelOrderEmployeeList in 'Documents\Personnel Orders\Entities\PersonnelOrderEmployeeList.pas',
  PersonnelOrderSignerList in 'Documents\Personnel Orders\Entities\PersonnelOrderSignerList.pas',
  PersonnelOrderSubKindEmployeeList in 'Documents\Personnel Orders\Entities\PersonnelOrderSubKindEmployeeList.pas',
  PersonnelOrderEmployeeGroup in 'Documents\Personnel Orders\Entities\PersonnelOrderEmployeeGroup.pas',
  PersonnelOrderSubKindEmployeeGroup in 'Documents\Personnel Orders\Entities\PersonnelOrderSubKindEmployeeGroup.pas',
  PersonnelOrderSignerListFinder in 'Documents\Personnel Orders\Services\Search\Interfaces\PersonnelOrderSignerListFinder.pas',
  PersonnelOrderCreatingAccessEmployeeList in 'Documents\Personnel Orders\Entities\PersonnelOrderCreatingAccessEmployeeList.pas',
  PersonnelOrderCreatingAccessEmployeeListFinder in 'Documents\Personnel Orders\Services\Search\Interfaces\PersonnelOrderCreatingAccessEmployeeListFinder.pas',
  PersonnelOrderSingleEmployeeListFinder in 'Documents\Personnel Orders\Services\Search\Interfaces\PersonnelOrderSingleEmployeeListFinder.pas',
  PersonnelOrderEmployeeListFinder in 'Documents\Personnel Orders\Services\Search\Interfaces\PersonnelOrderEmployeeListFinder.pas',
  PersonnelOrderEmployeeGroupFinder in 'Documents\Personnel Orders\Services\Search\Interfaces\PersonnelOrderEmployeeGroupFinder.pas',
  PersonnelOrderSubKindEmployeeGroupFinder in 'Documents\Personnel Orders\Services\Search\Interfaces\PersonnelOrderSubKindEmployeeGroupFinder.pas',
  PersonnelOrderControlGroupFinder in 'Documents\Personnel Orders\Services\Search\Interfaces\PersonnelOrderControlGroupFinder.pas',
  AbstractPersonnelOrderEmployeeListFinder in 'Documents\Personnel Orders\Services\Search\AbstractPersonnelOrderEmployeeListFinder.pas',
  AbstractPersonnelOrderSingleEmployeeListFinder in 'Documents\Personnel Orders\Services\Search\AbstractPersonnelOrderSingleEmployeeListFinder.pas',
  AbstractPersonnelOrderSignerListFinder in 'Documents\Personnel Orders\Services\Search\AbstractPersonnelOrderSignerListFinder.pas',
  AbstractPersonnelOrderCreatingAccessEmployeeListFinder in 'Documents\Personnel Orders\Services\Search\AbstractPersonnelOrderCreatingAccessEmployeeListFinder.pas',
  AbstractPersonnelOrderEmployeeGroupFinder in 'Documents\Personnel Orders\Services\Search\AbstractPersonnelOrderEmployeeGroupFinder.pas',
  AbstractPersonnelOrderSubKindEmployeeGroupFinder in 'Documents\Personnel Orders\Services\Search\AbstractPersonnelOrderSubKindEmployeeGroupFinder.pas',
  AbstractPersonnelOrderControlGroupFinder in 'Documents\Personnel Orders\Services\Search\AbstractPersonnelOrderControlGroupFinder.pas',
  PersonnelOrderControlService in 'Documents\Personnel Orders\Services\Control\Interfaces\PersonnelOrderControlService.pas',
  StandardPersonnelOrderControlService in 'Documents\Personnel Orders\Services\Control\StandardPersonnelOrderControlService.pas',
  PersonnelOrderSubKindEmployeeListFinder in 'Documents\Personnel Orders\Services\Search\Interfaces\PersonnelOrderSubKindEmployeeListFinder.pas',
  PersonnelOrderApproverListFinder in 'Documents\Personnel Orders\Services\Search\Interfaces\PersonnelOrderApproverListFinder.pas',
  AbstractPersonnelOrderSubKindEmployeeListFinder in 'Documents\Personnel Orders\Services\Search\AbstractPersonnelOrderSubKindEmployeeListFinder.pas',
  AbstractPersonnelOrderApproverListFinder in 'Documents\Personnel Orders\Services\Search\AbstractPersonnelOrderApproverListFinder.pas',
  PersonnelOrderSearchServiceRegistry in 'Documents\Personnel Orders\Services\Search\Registries\PersonnelOrderSearchServiceRegistry.pas',
  PersonnelOrderCreatingAccessService in 'Documents\Personnel Orders\Services\Access\Interfaces\PersonnelOrderCreatingAccessService.pas',
  StandardPersonnelOrderCreatingAccessService in 'Documents\Personnel Orders\Services\Access\StandardPersonnelOrderCreatingAccessService.pas',
  PersonnelOrderDomainRegistries in 'Documents\Personnel Orders\PersonnelOrderDomainRegistries.pas',
  PersonnelOrderServiceRegistries in 'Documents\Personnel Orders\Services\PersonnelOrderServiceRegistries.pas',
  PersonnelOrderSigningRejectingRule in 'Documents\Personnel Orders\Rules\Signing\PersonnelOrderSigningRejectingRule.pas',
  PersonnelOrderViewingRule in 'Documents\Personnel Orders\Rules\Access\PersonnelOrderViewingRule.pas',
  PersonnelOrderEditingRule in 'Documents\Personnel Orders\Rules\Access\PersonnelOrderEditingRule.pas',
  DocumentPerformingSheet in 'Documents\Common\Entities\DocumentPerformingSheet.pas',
  DocumentAcquaitanceSheet in 'Documents\Common\Entities\DocumentAcquaitanceSheet.pas',
  DocumentChargeWorkingRules in 'Documents\Common\Rules\Charges\DocumentChargeWorkingRules.pas',
  DocumentPerformingRule in 'Documents\Common\Rules\Performing\Interfaces\DocumentPerformingRule.pas',
  StandardDocumentPerformingRule in 'Documents\Common\Rules\Performing\StandardDocumentPerformingRule.pas',
  DocumentAcquaitance in 'Documents\Common\Entities\DocumentAcquaitance.pas',
  DocumentPerforming in 'Documents\Common\Entities\DocumentPerforming.pas',
  DocumentChargeChangingRule in 'Documents\Common\Rules\Charges\Interfaces\DocumentChargeChangingRule.pas',
  StandardDocumentChargeChangingRule in 'Documents\Common\Rules\Charges\StandardDocumentChargeChangingRule.pas',
  DocumentChargeInterface in 'Documents\Common\Entities\Interfaces\DocumentChargeInterface.pas',
  DocumentChargeCreatingService in 'Documents\Common\Services\Charges\Interfaces\DocumentChargeCreatingService.pas',
  StandardDocumentChargeCreatingService in 'Documents\Common\Services\Charges\StandardDocumentChargeCreatingService.pas',
  DocumentChargeKind in 'Documents\Common\Entities\DocumentChargeKind.pas',
  DocumentChargeKindsControlService in 'Documents\Common\Services\Charges\Interfaces\DocumentChargeKindsControlService.pas',
  AbstractDocumentChargeKindsControlService in 'Documents\Common\Services\Charges\AbstractDocumentChargeKindsControlService.pas',
  DocumentChargeServiceRegistry in 'Documents\Common\Services\Charges\DocumentChargeServiceRegistry.pas',
  DocumentChargeSheetControlService in 'Documents\Common\Services\Charge Sheets\DocumentChargeSheetControlService.pas',
  DocumentChargeSheetsServiceRegistry in 'Documents\Common\Services\Charge Sheets\DocumentChargeSheetsServiceRegistry.pas',
  StandardDocumentChargeSheetControlService in 'Documents\Common\Services\Charge Sheets\StandardDocumentChargeSheetControlService.pas',
  DocumentChargeSheetCreatingService in 'Documents\Common\Services\Charge Sheets\Creating\DocumentChargeSheetCreatingService.pas',
  StandardDocumentChargeSheetCreatingService in 'Documents\Common\Services\Charge Sheets\Creating\StandardDocumentChargeSheetCreatingService.pas',
  StandardDocumentPerformingSheetCreatingService in 'Documents\Common\Services\Charge Sheets\Creating\StandardDocumentPerformingSheetCreatingService.pas',
  DocumentChargeSheetOverlappingPerformingService in 'Documents\Common\Services\Charge Sheets\Performing\DocumentChargeSheetOverlappingPerformingService.pas',
  DocumentChargeSheetPerformingService in 'Documents\Common\Services\Charge Sheets\Performing\DocumentChargeSheetPerformingService.pas',
  StandardDocumentChargeSheetOverlappingPerformingService in 'Documents\Common\Services\Charge Sheets\Performing\StandardDocumentChargeSheetOverlappingPerformingService.pas',
  DocumentChargeSheetRemovingService in 'Documents\Common\Services\Charge Sheets\Removing\DocumentChargeSheetRemovingService.pas',
  AbstractDocumentChargeSheetFinder in 'Documents\Common\Services\Charge Sheets\Search\AbstractDocumentChargeSheetFinder.pas',
  DocumentChargeSheetFinder in 'Documents\Common\Services\Charge Sheets\Search\DocumentChargeSheetFinder.pas',
  DocumentChargeSheetPerformingResult in 'Documents\Common\Services\Charge Sheets\Performing\DocumentChargeSheetPerformingResult.pas',
  DocumentChargeSheetOrdinaryPerformingService in 'Documents\Common\Services\Charge Sheets\Performing\DocumentChargeSheetOrdinaryPerformingService.pas',
  StandardDocumentChargeSheetOrdinaryPerformingService in 'Documents\Common\Services\Charge Sheets\Performing\StandardDocumentChargeSheetOrdinaryPerformingService.pas',
  StandardDocumentChargeSheetControlPerformingService in 'Documents\Common\Services\Charge Sheets\Performing\StandardDocumentChargeSheetControlPerformingService.pas',
  DocumentChargeSheetControlPerformingService in 'Documents\Common\Services\Charge Sheets\Performing\DocumentChargeSheetControlPerformingService.pas',
  DocumentChargeSheetWorkingRule in 'Documents\Common\Rules\Charge Sheets\Interfaces\DocumentChargeSheetWorkingRule.pas',
  StandardDocumentChargeSheetWorkingRule in 'Documents\Common\Rules\Charge Sheets\StandardDocumentChargeSheetWorkingRule.pas',
  DocumentChargeSheetWorkingRules in 'Documents\Common\Rules\Charge Sheets\DocumentChargeSheetWorkingRules.pas',
  StandardDocumentChargeSheetChangingRule in 'Documents\Common\Rules\Charge Sheets\Changing\StandardDocumentChargeSheetChangingRule.pas',
  DocumentChargeSheetChangingRule in 'Documents\Common\Rules\Charge Sheets\Changing\Interfaces\DocumentChargeSheetChangingRule.pas',
  DocumentChargeSheetOverlappedPerformingRule in 'Documents\Common\Rules\Charge Sheets\Performing\Interfaces\DocumentChargeSheetOverlappedPerformingRule.pas',
  DocumentChargeSheetPerformingRule in 'Documents\Common\Rules\Charge Sheets\Performing\Interfaces\DocumentChargeSheetPerformingRule.pas',
  StandardDocumentChargeSheetOverlappedPerformingRule in 'Documents\Common\Rules\Charge Sheets\Performing\StandardDocumentChargeSheetOverlappedPerformingRule.pas',
  StandardDocumentChargeSheetPerformingRule in 'Documents\Common\Rules\Charge Sheets\Performing\StandardDocumentChargeSheetPerformingRule.pas',
  DocumentChargeSheetRemovingRule in 'Documents\Common\Rules\Charge Sheets\Removing\Interfaces\DocumentChargeSheetRemovingRule.pas',
  StandardDocumentChargeSheetRemovingRule in 'Documents\Common\Rules\Charge Sheets\Removing\StandardDocumentChargeSheetRemovingRule.pas',
  StandardDocumentChargeSheetViewingRule in 'Documents\Common\Rules\Charge Sheets\Viewing\StandardDocumentChargeSheetViewingRule.pas',
  DocumentChargeSheetViewingRule in 'Documents\Common\Rules\Charge Sheets\Viewing\Interfaces\DocumentChargeSheetViewingRule.pas',
  DocumentChargeSheetPerformingEnsurer in 'Documents\Common\Rules\Charge Sheets\Performing\DocumentChargeSheetPerformingEnsurer.pas',
  StandardDocumentChargeSheetRemovingService in 'Documents\Common\Services\Charge Sheets\Removing\StandardDocumentChargeSheetRemovingService.pas',
  DocumentChargeSheetChangingEnsurer in 'Documents\Common\Rules\Charge Sheets\Changing\DocumentChargeSheetChangingEnsurer.pas',
  DocumentChargeSheetAccessRightsService in 'Documents\Common\Services\Charge Sheets\Access Rights\DocumentChargeSheetAccessRightsService.pas',
  DocumentChargeSheetAccessRights in 'Documents\Common\Services\Charge Sheets\Access Rights\DocumentChargeSheetAccessRights.pas',
  StandardDocumentChargeSheetAccessRightsService in 'Documents\Common\Services\Charge Sheets\Access Rights\StandardDocumentChargeSheetAccessRightsService.pas',
  GeneralDocumentChargeSheetAccessRightsService in 'Documents\Common\Services\Access Rights\Interfaces\GeneralDocumentChargeSheetAccessRightsService.pas',
  GeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo in 'Documents\Common\Services\Access Rights\Interfaces\GeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo.pas',
  StandardGeneralDocumentChargeSheetAccessRightsService in 'Documents\Common\Services\Access Rights\StandardGeneralDocumentChargeSheetAccessRightsService.pas',
  StandardGeneralIncomingDocumentChargeSheetAccessRightsService in 'Documents\Common\Services\Access Rights\StandardGeneralIncomingDocumentChargeSheetAccessRightsService.pas',
  DocumentChargesSpecification in 'Documents\Common\Specifications\Charges\Interfaces\DocumentChargesSpecification.pas',
  StandardDocumentChargesSpecification in 'Documents\Common\Specifications\Charges\StandardDocumentChargesSpecification.pas',
  DocumentSpecificationRegistry in 'Documents\Common\Specifications\DocumentSpecificationRegistry.pas',
  DocumentSpecifications in 'Documents\Common\Specifications\DocumentSpecifications.pas',
  IncomingDocumentCreatingService in 'Documents\Common\Services\Operations\Interfaces\IncomingDocumentCreatingService.pas',
  StandardIncomingDocumentCreatingService in 'Documents\Common\Services\Operations\StandardIncomingDocumentCreatingService.pas',
  OriginalDocumentFinder in 'Documents\Common\Services\Search\OriginalDocumentFinder.pas',
  PersonnelOrderWorkCycle in 'Documents\Personnel Orders\Entities\PersonnelOrderWorkCycle.pas',
  DocumentPerformingSpecification in 'Documents\Common\Specifications\Performing\Interfaces\DocumentPerformingSpecification.pas',
  StandardDocumentPerformingSpecification in 'Documents\Common\Specifications\Performing\StandardDocumentPerformingSpecification.pas',
  DocumentSigningMarkingToPerformingService in 'Documents\Common\Services\Signing\Interfaces\DocumentSigningMarkingToPerformingService.pas',
  StandardDocumentSigningMarkingToPerformingService in 'Documents\Common\Services\Signing\StandardDocumentSigningMarkingToPerformingService.pas',
  DocumentPerformingEventHandlers in 'Documents\Common\Services\Performing\Events\DocumentPerformingEventHandlers.pas',
  DocumentToPerformingSendingResult in 'Documents\Common\Services\Performing\DocumentToPerformingSendingResult.pas',
  DocumentSigningSpecification in 'Documents\Common\Specifications\Signing\Interfaces\DocumentSigningSpecification.pas',
  StandardDocumentSigningSpecification in 'Documents\Common\Specifications\Signing\StandardDocumentSigningSpecification.pas',
  StandardPersonnelOrderSigningSpecification in 'Documents\Personnel Orders\Specifications\StandardPersonnelOrderSigningSpecification.pas',
  StandardDocumentSigningMarkingRule in 'Documents\Common\Rules\Signing\StandardDocumentSigningMarkingRule.pas',
  DocumentDraftingRuleOptionsBuilder in 'Documents\Common\Rules\Drafting\Interfaces\DocumentDraftingRuleOptionsBuilder.pas',
  DocumentDraftingRuleOptions in 'Documents\Common\Rules\Drafting\Interfaces\DocumentDraftingRuleOptions.pas',
  StandardDocumentDraftingRuleOptionsBuilder in 'Documents\Common\Rules\Drafting\StandardDocumentDraftingRuleOptionsBuilder.pas',
  StandardDocumentDraftingRuleOptions in 'Documents\Common\Rules\Drafting\StandardDocumentDraftingRuleOptions.pas',
  DocumentPersistingValidator in 'Documents\Common\Services\Storage\Interfaces\DocumentPersistingValidator.pas',
  StandardDocumentPersistingValidator in 'Documents\Common\Services\Storage\StandardDocumentPersistingValidator.pas',
  SuccessedDocumentPersistingValidator in 'Documents\Common\Services\Storage\SuccessedDocumentPersistingValidator.pas',
  EmployeeDocumentKindAccessRightsInfo in 'Documents\Common\Services\Access Rights\Interfaces\EmployeeDocumentKindAccessRightsInfo.pas';

{$R *.res}

begin

  ReportMemoryLeaksOnShutdown := True;
  
  Application.Initialize;
  Application.CreateForm(TForm6, Form6);
  Application.Run;
  
end.
