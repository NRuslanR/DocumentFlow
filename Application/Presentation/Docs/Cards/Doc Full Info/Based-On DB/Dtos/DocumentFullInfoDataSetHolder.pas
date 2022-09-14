unit DocumentFullInfoDataSetHolder;

interface

uses

  DB,
  DocumentInfoHolder,
  DocumentApprovingsInfoHolder,
  AbstractDataSetHolder,
  DocumentChargesInfoHolder,
  DocumentChargeSheetsInfoHolder,
  DocumentRelationsInfoHolder,
  DocumentFilesInfoHolder,
  Disposable,
  SysUtils,
  Classes;

type

  TDocumentFullInfoDataSetFieldNames = class (TAbstractDataSetFieldDefs)

    protected

      FDocumentInfoFieldNames: TDocumentInfoFieldNames;
      FDocumentApprovingsInfoFieldNames: TDocumentApprovingsInfoFieldNames;
      FDocumentChargesInfoFieldNames: TDocumentChargesInfoFieldNames;
      FDocumentChargeSheetsInfoFieldNames: TDocumentChargeSheetsInfoFieldNames;
      FDocumentRelationsInfoFieldNames: TDocumentRelationsInfoFieldNames;
      FDocumentFilesInfoFieldNames: TDocumentFilesInfoFieldNames;

      function GetDocumentIdFieldName: String;
      function GetBaseDocumentIdFieldName: String;
      function GetDocumentNumberFieldName: String;
      function GetDocumentNameFieldName: String;
      function GetDocumentContentFieldName: String;
      function GetDocumentNoteFieldName: String;
      function GetDocumentProductCodeFieldName: String;
      function GetDocumentIsSelfRegisteredFieldName: String;
      function GetDocumentCreationDateFieldName: String;
      function GetDocumentDateFieldName: String;
      function GetDocumentKindFieldName: String;
      function GetDocumentKindIdFieldName: String;
      function GetDocumentCurrentWorkCycleStageNameFieldName: String;
      function GetDocumentCurrentWorkCycleStageNumberFieldName: String;

      function GetDocumentAuthorIdFieldName: String;
      function GetDocumentAuthorLeaderIdFieldName: String;
      function GetDocumentAuthorNameFieldName: String;
      function GetDocumentAuthorSpecialityFieldName: String;
      function GetDocumentAuthorDepartmentIdFieldName: String;
      function GetDocumentAuthorDepartmentCodeFieldName: String;
      function GetDocumentAuthorDepartmentNameFieldName: String;

      function GetDocumentResponsibleIdFieldName: String;
      function GetDocumentResponsibleNameFieldName: String;
      function GetDocumentResponsibleTelephoneNumberFieldName: String;
      function GetDocumentResponsibleDepartmentIdFieldName: String;
      function GetDocumentResponsibleDepartmentCodeFieldName: String;
      function GetDocumentResponsibleDepartmentNameFieldName: String;

      function GetDocumentSigningIdFieldName: String;
      function GetDocumentSigningDateFieldName: String;
      function GetDocumentSignerIdFieldName: String;
      function GetDocumentSignerLeaderIdFieldName: String;
      function GetDocumentSignerNameFieldName: String;
      function GetDocumentSignerSpecialityFieldName: String;
      function GetDocumentSignerDepartmentIdFieldName: String;
      function GetDocumentSignerDepartmentCodeFieldName: String;
      function GetDocumentSignerDepartmentNameFieldName: String;

      function GetDocumentActualSignerIdFieldName: String;
      function GetDocumentActualSignerLeaderIdFieldName: String;
      function GetDocumentActualSignerNameFieldName: String;
      function GetDocumentActualSignerSpecialityFieldName: String;
      function GetDocumentActualSignerDepartmentIdFieldName: String;
      function GetDocumentActualSignerDepartmentCodeFieldName: String;
      function GetDocumentActualSignerDepartmentNameFieldName: String;

      function GetDocumentChargeIdFieldName: String;
      function GetDocumentChargeTextFieldName: String;
      function GetDocumentChargeIsForAcquaitanceFieldName: String;
      function GetDocumentChargeResponseFieldName: String;
      function GetDocumentChargePeriodStartFieldName: String;
      function GetDocumentChargePeriodEndFieldName: String;
      function GetDocumentChargePerformingDateTimeFieldName: String;
      function GetDocumentChargePerformerIdFieldName: String;
      function GetDocumentChargePerformerLeaderIdFieldName: String;
      function GetDocumentChargePerformerIsForeignFieldName: String;
      function GetDocumentChargePerformerNameFieldName: String;
      function GetDocumentChargePerformerSpecialityFieldName: String;
      function GetDocumentChargePerformerDepartmentIdFieldName: String;
      function GetDocumentChargePerformerDepartmentCodeFieldName: String;
      function GetDocumentChargePerformerDepartmentNameFieldName: String;

      function GetDocumentChargeActualPerformerIdFieldName: String;
      function GetDocumentChargeActualPerformerLeaderIdFieldName: String;
      function GetDocumentChargeActualPerformerIsForeignFieldName: String;
      function GetDocumentChargeActualPerformerNameFieldName: String;
      function GetDocumentChargeActualPerformerSpecialityFieldName: String;
      function GetDocumentChargeActualPerformerDepartmentIdFieldName: String;
      function GetDocumentChargeActualPerformerDepartmentCodeFieldName: String;
      function GetDocumentChargeActualPerformerDepartmentNameFieldName: String;

      function GetDocumentFileIdFieldName: String;
      function GetDocumentFileNameFieldName: String;
      function GetDocumentFilePathFieldName: String;

      function GetDocumentRelationIdFieldName: String;
      function GetRelatedDocumentIdFieldName: String;
      function GetRelatedDocumentKindIdFieldName: String;
      function GetRelatedDocumentKindNameFieldName: String;
      function GetRelatedDocumentNumberFieldName: String;
      function GetRelatedDocumentNameFieldName: String;
      function GetRelatedDocumentDateFieldName: String;

      function GetDocumentChargeSheetIdFieldName: String;
      function GetChargeSheetDocumentIdFieldName: String;
      function GetTopLevelDocumentChargeSheetIdFieldName: String;
      function GetDocumentChargeSheetTextFieldName: String;
      function GetDocumentChargeSheetIsForAcquaitanceFieldName: String;
      function GetDocumentChargeSheetResponseFieldName: String;
      function GetDocumentChargeSheetPeriodStartFieldName: String;
      function GetDocumentChargeSheetPeriodEndFieldName: String;
      function GetDocumentChargeSheetPerformingDateTimeFieldName: String;
      function GetDocumentChargeSheetViewingDateByPerformerFieldName: String;

      function GetDocumentChargeSheetPerformerIdFieldName: String;
      function GetDocumentChargeSheetPerformerRoleIdFieldName: String; { refactor }
      function GetDocumentChargeSheetPerformerLeaderIdFieldName: String;
      function GetDocumentChargeSheetPerformerIsForeignFieldName: String;
      function GetDocumentChargeSheetPerformerNameFieldName: String;
      function GetDocumentChargeSheetPerformerSpecialityFieldName: String;
      function GetDocumentChargeSheetPerformerDepartmentIdFieldName: String;
      function GetDocumentChargeSheetPerformerDepartmentCodeFieldName: String;
      function GetDocumentChargeSheetPerformerDepartmentNameFieldName: String;

      function GetDocumentChargeSheetActualPerformerIdFieldName: String;
      function GetDocumentChargeSheetActualPerformerLeaderIdFieldName: String;
      function GetDocumentChargeSheetActualPerformerIsForeignFieldName: String;
      function GetDocumentChargeSheetActualPerformerNameFieldName: String;
      function GetDocumentChargeSheetActualPerformerSpecialityFieldName: String;
      function GetDocumentChargeSheetActualPerformerDepartmentIdFieldName: String;
      function GetDocumentChargeSheetActualPerformerDepartmentCodeFieldName: String;
      function GetDocumentChargeSheetActualPerformerDepartmentNameFieldName: String;

      function GetDocumentChargeSheetSenderIdFieldName: String;
      function GetDocumentChargeSheetSenderLeaderIdFieldName: String;
      function GetDocumentChargeSheetSenderIsForeignFieldName: String;
      function GetDocumentChargeSheetSenderNameFieldName: String;
      function GetDocumentChargeSheetSenderSpecialityFieldName: String;
      function GetDocumentChargeSheetSenderDepartmentIdFieldName: String;
      function GetDocumentChargeSheetSenderDepartmentCodeFieldName: String;
      function GetDocumentChargeSheetSenderDepartmentNameFieldName: String;

      function GetDocumentApprovingIdFieldName: String;
      function GetDocumentApprovingIsAccessibleFieldName: String;
      function GetDocumentChargeSheetIssuingDateTimeFieldName: String;
      function GetDocumentApprovingPerformingDateTimeFieldName: String;
      function GetDocumentApprovingPerformingResultIdFieldName: String;
      function GetDocumentApprovingPerformingResultFieldName: String;
      function GetDocumentApprovingNoteFieldName: String;
      function GetDocumentApprovingCycleNumberFieldName: String;
      function GetDocumentApprovingCycleIdFieldName: String;
      function GetDocumentApprovingIsCompletedFieldName: String;
      function GetDocumentApprovingIsLookedByApproverFieldName: String;

      function GetDocumentApproverIdFieldName: String;
      function GetDocumentApproverLeaderIdFieldName: String;
      function GetDocumentApproverIsForeignFieldName: String;
      function GetDocumentApproverNameFieldName: String;
      function GetDocumentApproverSpecialityFieldName: String;
      function GetDocumentApproverDepartmentIdFieldName: String;
      function GetDocumentApproverDepartmentCodeFieldName: String;
      function GetDocumentApproverDepartmentNameFieldName: String;

      function GetDocumentActualApproverIdFieldName: String;
      function GetDocumentActualApproverLeaderIdFieldName: String;
      function GetDocumentActualApproverIsForeignFieldName: String;
      function GetDocumentActualApproverNameFieldName: String;
      function GetDocumentActualApproverSpecialityFieldName: String;
      function GetDocumentActualApproverDepartmentIdFieldName: String;
      function GetDocumentActualApproverDepartmentCodeFieldName: String;
      function GetDocumentActualApproverDepartmentNameFieldName: String;

      procedure SetDocumentFilesInfoFieldNames(const Value: TDocumentFilesInfoFieldNames);
      procedure SetDocumentInfoFieldNames(const Value: TDocumentInfoFieldNames);
      procedure SetDocumentRelationsInfoFieldNames(const Value: TDocumentRelationsInfoFieldNames);

    protected

      procedure SetDocumentIdFieldName(const Value: String);
      procedure SetBaseDocumentIdFieldName(const Value: String);
      procedure SetDocumentNumberFieldName(const Value: String);
      procedure SetDocumentNameFieldName(const Value: String);
      procedure SetDocumentContentFieldName(const Value: String);
      procedure SetDocumentNoteFieldName(const Value: String);
      procedure SetDocumentProductCodeFieldName(const Value: String);
      procedure SetDocumentIsSelfRegisteredFieldName(const Value: String);
      procedure SetDocumentCreationDateFieldName(const Value: String);
      procedure SetDocumentDateFieldName(const Value: String);
      procedure SetDocumentKindFieldName(const Value: String);
      procedure SetDocumentKindIdFieldName(const Value: String);
      procedure SetDocumentCurrentWorkCycleStageNameFieldName(const Value: String);
      procedure SetDocumentCurrentWorkCycleStageNumberFieldName(const Value: String);

      procedure SetDocumentAuthorIdFieldName(const Value: String);
      procedure SetDocumentAuthorLeaderIdFieldName(const Value: String);
      procedure SetDocumentAuthorNameFieldName(const Value: String);
      procedure SetDocumentAuthorSpecialityFieldName(const Value: String);
      procedure SetDocumentAuthorDepartmentIdFieldName(const Value: String);
      procedure SetDocumentAuthorDepartmentCodeFieldName(const Value: String);
      procedure SetDocumentAuthorDepartmentNameFieldName(const Value: String);

      procedure SetDocumentResponsibleIdFieldName(const Value: String);
      procedure SetDocumentResponsibleNameFieldName(const Value: String);
      procedure SetDocumentResponsibleTelephoneNumberFieldName(const Value: String);
      procedure SetDocumentResponsibleDepartmentIdFieldName(const Value: String);
      procedure SetDocumentResponsibleDepartmentCodeFieldName(const Value: String);
      procedure SetDocumentResponsibleDepartmentNameFieldName(const Value: String);

      procedure SetDocumentSigningIdFieldName(const Value: String);
      procedure SetDocumentSigningDateFieldName(const Value: String);
      procedure SetDocumentSignerIdFieldName(const Value: String);
      procedure SetDocumentSignerLeaderIdFieldName(const Value: String);
      procedure SetDocumentSignerNameFieldName(const Value: String);
      procedure SetDocumentSignerSpecialityFieldName(const Value: String);
      procedure SetDocumentSignerDepartmentIdFieldName(const Value: String);
      procedure SetDocumentSignerDepartmentCodeFieldName(const Value: String);
      procedure SetDocumentSignerDepartmentNameFieldName(const Value: String);

      procedure SetDocumentActualSignerIdFieldName(const Value: String);
      procedure SetDocumentActualSignerLeaderIdFieldName(const Value: String);
      procedure SetDocumentActualSignerNameFieldName(const Value: String);
      procedure SetDocumentActualSignerSpecialityFieldName(const Value: String);
      procedure SetDocumentActualSignerDepartmentIdFieldName(const Value: String);
      procedure SetDocumentActualSignerDepartmentCodeFieldName(const Value: String);
      procedure SetDocumentActualSignerDepartmentNameFieldName(const Value: String);

      procedure SetDocumentChargeIdFieldName(const Value: String);
      procedure SetDocumentChargeTextFieldName(const Value: String);
      procedure SetDocumentChargeIsForAcquaitanceFieldName(const Value: String);
      procedure SetDocumentChargeResponseFieldName(const Value: String);
      procedure SetDocumentChargePeriodStartFieldName(const Value: String);
      procedure SetDocumentChargePeriodEndFieldName(const Value: String);
      procedure SetDocumentChargePerformingDateTimeFieldName(const Value: String);
      procedure SetDocumentChargePerformerIdFieldName(const Value: String);
      procedure SetDocumentChargePerformerLeaderIdFieldName(const Value: String);
      procedure SetDocumentChargePerformerIsForeignFieldName(const Value: String);
      procedure SetDocumentChargePerformerNameFieldName(const Value: String);
      procedure SetDocumentChargePerformerSpecialityFieldName(const Value: String);
      procedure SetDocumentChargePerformerDepartmentIdFieldName(const Value: String);
      procedure SetDocumentChargePerformerDepartmentCodeFieldName(const Value: String);
      procedure SetDocumentChargePerformerDepartmentNameFieldName(const Value: String);

      procedure SetDocumentChargeActualPerformerIdFieldName(const Value: String);
      procedure SetDocumentChargeActualPerformerLeaderIdFieldName(const Value: String);
      procedure SetDocumentChargeActualPerformerIsForeignFieldName(const Value: String);
      procedure SetDocumentChargeActualPerformerNameFieldName(const Value: String);
      procedure SetDocumentChargeActualPerformerSpecialityFieldName(const Value: String);
      procedure SetDocumentChargeActualPerformerDepartmentIdFieldName(const Value: String);
      procedure SetDocumentChargeActualPerformerDepartmentCodeFieldName(const Value: String);
      procedure SetDocumentChargeActualPerformerDepartmentNameFieldName(const Value: String);

      procedure SetDocumentFileIdFieldName(const Value: String);
      procedure SetDocumentFileNameFieldName(const Value: String);
      procedure SetDocumentFilePathFieldName(const Value: String);

      procedure SetDocumentRelationIdFieldName(const Value: String);
      procedure SetRelatedDocumentIdFieldName(const Value: String);
      procedure SetRelatedDocumentKindIdFieldName(const Value: String);
      procedure SetRelatedDocumentKindNameFieldName(const Value: String);
      procedure SetRelatedDocumentNumberFieldName(const Value: String);
      procedure SetRelatedDocumentNameFieldName(const Value: String);
      procedure SetRelatedDocumentDateFieldName(const Value: String);

      procedure SetDocumentChargeSheetIdFieldName(const Value: String);
      procedure SetChargeSheetDocumentIdFieldName(const Value: String);
      procedure SetTopLevelDocumentChargeSheetIdFieldName(const Value: String);
      procedure SetDocumentChargeSheetTextFieldName(const Value: String);
      procedure SetDocumentChargeSheetIsForAcquaitanceFieldName(const Value: String);
      procedure SetDocumentChargeSheetResponseFieldName(const Value: String);
      procedure SetDocumentChargeSheetPeriodStartFieldName(const Value: String);
      procedure SetDocumentChargeSheetPeriodEndFieldName(const Value: String);
      procedure SetDocumentChargeSheetPerformingDateTimeFieldName(const Value: String);
      procedure SetDocumentChargeSheetViewingDateByPerformerFieldName(const Value: String);

      procedure SetDocumentChargeSheetPerformerIdFieldName(const Value: String);
      procedure SetDocumentChargeSheetPerformerRoleIdFieldName(const Value: String); { refactor }
      procedure SetDocumentChargeSheetPerformerLeaderIdFieldName(const Value: String);
      procedure SetDocumentChargeSheetPerformerIsForeignFieldName(const Value: String);
      procedure SetDocumentChargeSheetPerformerNameFieldName(const Value: String);
      procedure SetDocumentChargeSheetPerformerSpecialityFieldName(const Value: String);
      procedure SetDocumentChargeSheetPerformerDepartmentIdFieldName(const Value: String);
      procedure SetDocumentChargeSheetPerformerDepartmentCodeFieldName(const Value: String);
      procedure SetDocumentChargeSheetPerformerDepartmentNameFieldName(const Value: String);

      procedure SetDocumentChargeSheetActualPerformerIdFieldName(const Value: String);
      procedure SetDocumentChargeSheetActualPerformerLeaderIdFieldName(const Value: String);
      procedure SetDocumentChargeSheetActualPerformerIsForeignFieldName(const Value: String);
      procedure SetDocumentChargeSheetActualPerformerNameFieldName(const Value: String);
      procedure SetDocumentChargeSheetActualPerformerSpecialityFieldName(const Value: String);
      procedure SetDocumentChargeSheetActualPerformerDepartmentIdFieldName(const Value: String);
      procedure SetDocumentChargeSheetActualPerformerDepartmentCodeFieldName(const Value: String);
      procedure SetDocumentChargeSheetActualPerformerDepartmentNameFieldName(const Value: String);

      procedure SetDocumentChargeSheetSenderIdFieldName(const Value: String);
      procedure SetDocumentChargeSheetSenderLeaderIdFieldName(const Value: String);
      procedure SetDocumentChargeSheetSenderIsForeignFieldName(const Value: String);
      procedure SetDocumentChargeSheetSenderNameFieldName(const Value: String);
      procedure SetDocumentChargeSheetSenderSpecialityFieldName(const Value: String);
      procedure SetDocumentChargeSheetSenderDepartmentIdFieldName(const Value: String);
      procedure SetDocumentChargeSheetSenderDepartmentCodeFieldName(const Value: String);
      procedure SetDocumentChargeSheetSenderDepartmentNameFieldName(const Value: String);

      procedure SetDocumentApprovingIdFieldName(const Value: String);
      procedure SetDocumentApprovingIsAccessibleFieldName(const Value: String);
      procedure SetDocumentChargeSheetIssuingDateTimeFieldName(const Value: String);
      procedure SetDocumentApprovingPerformingDateTimeFieldName(const Value: String);
      procedure SetDocumentApprovingPerformingResultIdFieldName(const Value: String);
      procedure SetDocumentApprovingPerformingResultFieldName(const Value: String);
      procedure SetDocumentApprovingNoteFieldName(const Value: String);
      procedure SetDocumentApprovingCycleNumberFieldName(const Value: String);
      procedure SetDocumentApprovingCycleIdFieldName(const Value: String);
      procedure SetDocumentApprovingIsCompletedFieldName(const Value: String);
      procedure SetDocumentApprovingIsLookedByApproverFieldName(const Value: String);

      procedure SetDocumentApproverIdFieldName(const Value: String);
      procedure SetDocumentApproverLeaderIdFieldName(const Value: String);
      procedure SetDocumentApproverIsForeignFieldName(const Value: String);
      procedure SetDocumentApproverNameFieldName(const Value: String);
      procedure SetDocumentApproverSpecialityFieldName(const Value: String);
      procedure SetDocumentApproverDepartmentIdFieldName(const Value: String);
      procedure SetDocumentApproverDepartmentCodeFieldName(const Value: String);
      procedure SetDocumentApproverDepartmentNameFieldName(const Value: String);

      procedure SetDocumentActualApproverIdFieldName(const Value: String);
      procedure SetDocumentActualApproverLeaderIdFieldName(const Value: String);
      procedure SetDocumentActualApproverIsForeignFieldName(const Value: String);
      procedure SetDocumentActualApproverNameFieldName(const Value: String);
      procedure SetDocumentActualApproverSpecialityFieldName(const Value: String);
      procedure SetDocumentActualApproverDepartmentIdFieldName(const Value: String);
      procedure SetDocumentActualApproverDepartmentCodeFieldName(const Value: String);
      procedure SetDocumentActualApproverDepartmentNameFieldName(const Value: String);

    public

      property DocumentIdFieldName: String
      read GetDocumentIdFieldName write SetDocumentIdFieldName;

      property BaseDocumentIdFieldName: String
      read GetBaseDocumentIdFieldName write SetBaseDocumentIdFieldName;
      
      property DocumentNumberFieldName: String
      read GetDocumentNumberFieldName write SetDocumentNumberFieldName;
      
      property DocumentNameFieldName: String
      read GetDocumentNameFieldName write SetDocumentNameFieldName;

      property DocumentContentFieldName: String
      read GetDocumentContentFieldName write SetDocumentContentFieldName;

      property DocumentNoteFieldName: String
      read GetDocumentNoteFieldName write SetDocumentNoteFieldName;
      
      property DocumentProductCodeFieldName: String
      read GetDocumentProductCodeFieldName write SetDocumentProductCodeFieldName;

      property DocumentIsSelfRegisteredFieldName: String
      read GetDocumentIsSelfRegisteredFieldName write SetDocumentIsSelfRegisteredFieldName;
      
      property DocumentCreationDateFieldName: String
      read GetDocumentCreationDateFieldName write SetDocumentCreationDateFieldName;
      
      property DocumentDateFieldName: String
      read GetDocumentDateFieldName write SetDocumentDateFieldName;
      
      property DocumentKindFieldName: String
      read GetDocumentKindFieldName write SetDocumentKindFieldName;

      property DocumentKindIdFieldName: String
      read GetDocumentKindIdFieldName write SetDocumentKindIdFieldName;
      
      property DocumentCurrentWorkCycleStageNameFieldName: String
      read GetDocumentCurrentWorkCycleStageNameFieldName
      write SetDocumentCurrentWorkCycleStageNameFieldName;
      
      property DocumentCurrentWorkCycleStageNumberFieldName: String
      read GetDocumentCurrentWorkCycleStageNumberFieldName
      write SetDocumentCurrentWorkCycleStageNumberFieldName;

      property DocumentAuthorIdFieldName: String
      read GetDocumentAuthorIdFieldName write SetDocumentAuthorIdFieldName;
      
      property DocumentAuthorLeaderIdFieldName: String
      read GetDocumentAuthorLeaderIdFieldName write SetDocumentAuthorLeaderIdFieldName;
      
      property DocumentAuthorNameFieldName: String
      read GetDocumentAuthorNameFieldName write SetDocumentAuthorNameFieldName;
      
      property DocumentAuthorSpecialityFieldName: String
      read GetDocumentAuthorSpecialityFieldName
      write SetDocumentAuthorSpecialityFieldName;

      property DocumentAuthorDepartmentIdFieldName: String
      read GetDocumentAuthorDepartmentIdFieldName
      write SetDocumentAuthorDepartmentIdFieldName;

      property DocumentAuthorDepartmentCodeFieldName: String
      read GetDocumentAuthorDepartmentCodeFieldName
      write SetDocumentAuthorDepartmentCodeFieldName;
      
      property DocumentAuthorDepartmentNameFieldName: String
      read GetDocumentAuthorDepartmentNameFieldName
      write SetDocumentAuthorDepartmentNameFieldName;

      property DocumentResponsibleIdFieldName: String
      read GetDocumentResponsibleIdFieldName
      write SetDocumentResponsibleIdFieldName;
      
      property DocumentResponsibleNameFieldName: String
      read GetDocumentResponsibleNameFieldName
      write SetDocumentResponsibleNameFieldName;

      property DocumentResponsibleTelephoneNumberFieldName: String
      read GetDocumentResponsibleTelephoneNumberFieldName
      write SetDocumentResponsibleTelephoneNumberFieldName;
      
      property DocumentResponsibleDepartmentIdFieldName: String
      read GetDocumentResponsibleDepartmentIdFieldName
      write SetDocumentResponsibleDepartmentIdFieldName;

      property DocumentResponsibleDepartmentCodeFieldName: String
      read GetDocumentResponsibleDepartmentCodeFieldName
      write SetDocumentResponsibleDepartmentCodeFieldName;
      
      property DocumentResponsibleDepartmentNameFieldName: String
      read GetDocumentResponsibleDepartmentNameFieldName
      write SetDocumentResponsibleDepartmentNameFieldName;

      property DocumentSigningIdFieldName: String
      read GetDocumentSigningIdFieldName
      write SetDocumentSigningIdFieldName;

      property DocumentSigningDateFieldName: String
      read GetDocumentSigningDateFieldName
      write SetDocumentSigningDateFieldName;

      property DocumentSignerIdFieldName: String
      read GetDocumentSignerIdFieldName write SetDocumentSignerIdFieldName;

      property DocumentSignerLeaderIdFieldName: String
      read GetDocumentSignerLeaderIdFieldName write SetDocumentSignerLeaderIdFieldName;
      
      property DocumentSignerNameFieldName: String
      read GetDocumentSignerNameFieldName write SetDocumentSignerNameFieldName;
      
      property DocumentSignerSpecialityFieldName: String
      read GetDocumentSignerSpecialityFieldName write SetDocumentSignerSpecialityFieldName;

      property DocumentSignerDepartmentIdFieldName: String
      read GetDocumentSignerDepartmentIdFieldName write SetDocumentSignerDepartmentIdFieldName;

      property DocumentSignerDepartmentCodeFieldName: String
      read GetDocumentSignerDepartmentCodeFieldName write SetDocumentSignerDepartmentCodeFieldName;
      
      property DocumentSignerDepartmentNameFieldName: String
      read GetDocumentSignerDepartmentNameFieldName write SetDocumentSignerDepartmentNameFieldName;

      property DocumentActualSignerIdFieldName: String
      read GetDocumentActualSignerIdFieldName write SetDocumentActualSignerIdFieldName;

      property DocumentActualSignerLeaderIdFieldName: String
      read GetDocumentActualSignerLeaderIdFieldName write SetDocumentActualSignerLeaderIdFieldName;

      property DocumentActualSignerNameFieldName: String
      read GetDocumentActualSignerNameFieldName write SetDocumentActualSignerNameFieldName;

      property DocumentActualSignerSpecialityFieldName: String
      read GetDocumentActualSignerSpecialityFieldName write SetDocumentActualSignerSpecialityFieldName;

      property DocumentActualSignerDepartmentIdFieldName: String
      read GetDocumentActualSignerDepartmentIdFieldName write SetDocumentActualSignerDepartmentIdFieldName;
      
      property DocumentActualSignerDepartmentCodeFieldName: String
      read GetDocumentActualSignerDepartmentCodeFieldName
      write SetDocumentActualSignerDepartmentCodeFieldName;
      
      property DocumentActualSignerDepartmentNameFieldName: String
      read GetDocumentActualSignerDepartmentNameFieldName
      write SetDocumentActualSignerDepartmentNameFieldName;

      property DocumentChargeIdFieldName: String
      read GetDocumentChargeIdFieldName write SetDocumentChargeIdFieldName;

      property DocumentChargeTextFieldName: String
      read GetDocumentChargeTextFieldName write SetDocumentChargeTextFieldName;

      property DocumentChargeIsForAcquaitanceFieldName: String
      read GetDocumentChargeIsForAcquaitanceFieldName write SetDocumentChargeIsForAcquaitanceFieldName;
      
      property DocumentChargeResponseFieldName: String
      read GetDocumentChargeResponseFieldName write SetDocumentChargeResponseFieldName;

      property DocumentChargePeriodStartFieldName: String
      read GetDocumentChargePeriodStartFieldName write SetDocumentChargePeriodStartFieldName;

      property DocumentChargePeriodEndFieldName: String
      read GetDocumentChargePeriodEndFieldName write SetDocumentChargePeriodEndFieldName;

      property DocumentChargePerformingDateTimeFieldName: String
      read GetDocumentChargePerformingDateTimeFieldName write SetDocumentChargePerformingDateTimeFieldName;
      
      property DocumentChargePerformerIdFieldName: String
      read GetDocumentChargePerformerIdFieldName write SetDocumentChargePerformerIdFieldName;

      property DocumentChargePerformerLeaderIdFieldName: String
      read GetDocumentChargePerformerLeaderIdFieldName write SetDocumentChargePerformerLeaderIdFieldName;

      property DocumentChargePerformerIsForeignFieldName: String
      read GetDocumentChargePerformerIsForeignFieldName write SetDocumentChargePerformerIsForeignFieldName;
      
      property DocumentChargePerformerNameFieldName: String
      read GetDocumentChargePerformerNameFieldName write SetDocumentChargePerformerNameFieldName;
      
      property DocumentChargePerformerSpecialityFieldName: String
      read GetDocumentChargePerformerSpecialityFieldName write SetDocumentChargePerformerSpecialityFieldName;

      property DocumentChargePerformerDepartmentIdFieldName: String
      read GetDocumentChargePerformerDepartmentIdFieldName write SetDocumentChargePerformerDepartmentIdFieldName;

      property DocumentChargePerformerDepartmentCodeFieldName: String
      read GetDocumentChargePerformerDepartmentCodeFieldName
      write SetDocumentChargePerformerDepartmentCodeFieldName;

      property DocumentChargePerformerDepartmentNameFieldName: String
      read GetDocumentChargePerformerDepartmentNameFieldName
      write SetDocumentChargePerformerDepartmentNameFieldName;

      property DocumentChargeActualPerformerIdFieldName: String
      read GetDocumentChargeActualPerformerIdFieldName
      write SetDocumentChargeActualPerformerIdFieldName;

      property DocumentChargeActualPerformerLeaderIdFieldName: String
      read GetDocumentChargeActualPerformerLeaderIdFieldName
      write SetDocumentChargeActualPerformerLeaderIdFieldName;

      property DocumentChargeActualPerformerIsForeignFieldName: String
      read GetDocumentChargeActualPerformerIsForeignFieldName
      write SetDocumentChargeActualPerformerIsForeignFieldName;

      property DocumentChargeActualPerformerNameFieldName: String
      read GetDocumentChargeActualPerformerNameFieldName
      write SetDocumentChargeActualPerformerNameFieldName;
      
      property DocumentChargeActualPerformerSpecialityFieldName: String
      read GetDocumentChargeActualPerformerSpecialityFieldName
      write SetDocumentChargeActualPerformerSpecialityFieldName;

      property DocumentChargeActualPerformerDepartmentIdFieldName: String
      read GetDocumentChargeActualPerformerDepartmentIdFieldName
      write SetDocumentChargeActualPerformerDepartmentIdFieldName;
      
      property DocumentChargeActualPerformerDepartmentCodeFieldName: String
      read GetDocumentChargeActualPerformerDepartmentCodeFieldName
      write SetDocumentChargeActualPerformerDepartmentCodeFieldName;

      property DocumentChargeActualPerformerDepartmentNameFieldName: String
      read GetDocumentChargeActualPerformerDepartmentNameFieldName
      write SetDocumentChargeActualPerformerDepartmentNameFieldName;

      property DocumentFileIdFieldName: String
      read GetDocumentFileIdFieldName write SetDocumentFileIdFieldName;
      
      property DocumentFileNameFieldName: String
      read GetDocumentFileNameFieldName write SetDocumentFileNameFieldName;
      
      property DocumentFilePathFieldName: String
      read GetDocumentFilePathFieldName write SetDocumentFilePathFieldName;

      property DocumentRelationIdFieldName: String
      read GetDocumentRelationIdFieldName write SetDocumentRelationIdFieldName;

      property RelatedDocumentIdFieldName: String
      read GetRelatedDocumentIdFieldName write SetRelatedDocumentIdFieldName;

      property RelatedDocumentKindIdFieldName: String
      read GetRelatedDocumentKindIdFieldName write SetRelatedDocumentKindIdFieldName;

      property RelatedDocumentKindNameFieldName: String
      read GetRelatedDocumentKindNameFieldName write SetRelatedDocumentKindNameFieldName;
      
      property RelatedDocumentNumberFieldName: String
      read GetRelatedDocumentNumberFieldName write SetRelatedDocumentNumberFieldName;
      
      property RelatedDocumentNameFieldName: String
      read GetRelatedDocumentNameFieldName write SetRelatedDocumentNameFieldName;
      
      property RelatedDocumentDateFieldName: String
      read GetRelatedDocumentDateFieldName write SetRelatedDocumentDateFieldName;

      property DocumentChargeSheetIdFieldName: String
      read GetDocumentChargeSheetIdFieldName write SetDocumentChargeSheetIdFieldName;

      property ChargeSheetDocumentIdFieldName: String
      read GetChargeSheetDocumentIdFieldName write SetChargeSheetDocumentIdFieldName;

      property TopLevelDocumentChargeSheetIdFieldName: String
      read GetTopLevelDocumentChargeSheetIdFieldName
      write SetTopLevelDocumentChargeSheetIdFieldName;

      property DocumentChargeSheetTextFieldName: String
      read GetDocumentChargeSheetTextFieldName write SetDocumentChargeSheetTextFieldName;

      property DocumentChargeSheetIsForAcquaitanceFieldName: String
      read GetDocumentChargeSheetIsForAcquaitanceFieldName write SetDocumentChargeSheetIsForAcquaitanceFieldName;

      property DocumentChargeSheetResponseFieldName: String
      read GetDocumentChargeSheetResponseFieldName write SetDocumentChargeSheetResponseFieldName;
      
      property DocumentChargeSheetPeriodStartFieldName: String
      read GetDocumentChargeSheetPeriodStartFieldName write SetDocumentChargeSheetPeriodStartFieldName;

      property DocumentChargeSheetPeriodEndFieldName: String
      read GetDocumentChargeSheetPeriodEndFieldName write SetDocumentChargeSheetPeriodEndFieldName;

      property DocumentChargeSheetPerformingDateTimeFieldName: String
      read GetDocumentChargeSheetPerformingDateTimeFieldName
      write SetDocumentChargeSheetPerformingDateTimeFieldName;
      
      property DocumentChargeSheetViewingDateByPerformerFieldName: String
      read GetDocumentChargeSheetViewingDateByPerformerFieldName
      write SetDocumentChargeSheetViewingDateByPerformerFieldName;

      property DocumentChargeSheetPerformerIdFieldName: String
      read GetDocumentChargeSheetPerformerIdFieldName
      write SetDocumentChargeSheetPerformerIdFieldName;

      property DocumentChargeSheetPerformerRoleIdFieldName: String
      read GetDocumentChargeSheetPerformerRoleIdFieldName
      write SetDocumentChargeSheetPerformerRoleIdFieldName; { refactor }

      property DocumentChargeSheetPerformerLeaderIdFieldName: String
      read GetDocumentChargeSheetPerformerLeaderIdFieldName
      write SetDocumentChargeSheetPerformerLeaderIdFieldName;
      
      property DocumentChargeSheetPerformerIsForeignFieldName: String
      read GetDocumentChargeSheetPerformerIsForeignFieldName
      write SetDocumentChargeSheetPerformerIsForeignFieldName;

      property DocumentChargeSheetPerformerNameFieldName: String
      read GetDocumentChargeSheetPerformerNameFieldName
      write SetDocumentChargeSheetPerformerNameFieldName;

      property DocumentChargeSheetPerformerSpecialityFieldName: String
      read GetDocumentChargeSheetPerformerSpecialityFieldName
      write SetDocumentChargeSheetPerformerSpecialityFieldName;

      property DocumentChargeSheetPerformerDepartmentIdFieldName: String
      read GetDocumentChargeSheetPerformerDepartmentIdFieldName
      write SetDocumentChargeSheetPerformerDepartmentIdFieldName;

      property DocumentChargeSheetPerformerDepartmentCodeFieldName: String
      read GetDocumentChargeSheetPerformerDepartmentCodeFieldName
      write SetDocumentChargeSheetPerformerDepartmentCodeFieldName;
      
      property DocumentChargeSheetPerformerDepartmentNameFieldName: String
      read GetDocumentChargeSheetPerformerDepartmentNameFieldName
      write SetDocumentChargeSheetPerformerDepartmentNameFieldName;

      property DocumentChargeSheetActualPerformerIdFieldName: String
      read GetDocumentChargeSheetActualPerformerIdFieldName
      write SetDocumentChargeSheetActualPerformerIdFieldName;
      
      property DocumentChargeSheetActualPerformerLeaderIdFieldName: String
      read GetDocumentChargeSheetActualPerformerLeaderIdFieldName
      write SetDocumentChargeSheetActualPerformerLeaderIdFieldName;
      
      property DocumentChargeSheetActualPerformerIsForeignFieldName: String
      read GetDocumentChargeSheetActualPerformerIsForeignFieldName
      write SetDocumentChargeSheetActualPerformerIsForeignFieldName;

      property DocumentChargeSheetActualPerformerNameFieldName: String
      read GetDocumentChargeSheetActualPerformerNameFieldName
      write SetDocumentChargeSheetActualPerformerNameFieldName;
      
      property DocumentChargeSheetActualPerformerSpecialityFieldName: String
      read GetDocumentChargeSheetActualPerformerSpecialityFieldName
      write SetDocumentChargeSheetActualPerformerSpecialityFieldName;
      
      property DocumentChargeSheetActualPerformerDepartmentIdFieldName: String
      read GetDocumentChargeSheetActualPerformerDepartmentIdFieldName
      write SetDocumentChargeSheetActualPerformerDepartmentIdFieldName;
      
      property DocumentChargeSheetActualPerformerDepartmentCodeFieldName: String
      read GetDocumentChargeSheetActualPerformerDepartmentCodeFieldName
      write SetDocumentChargeSheetActualPerformerDepartmentCodeFieldName;
      
      property DocumentChargeSheetActualPerformerDepartmentNameFieldName: String
      read GetDocumentChargeSheetActualPerformerDepartmentNameFieldName
      write SetDocumentChargeSheetActualPerformerDepartmentNameFieldName;

      property DocumentChargeSheetSenderIdFieldName: String
      read GetDocumentChargeSheetSenderIdFieldName
      write SetDocumentChargeSheetSenderIdFieldName;

      property DocumentChargeSheetSenderLeaderIdFieldName: String
      read GetDocumentChargeSheetSenderLeaderIdFieldName
      write SetDocumentChargeSheetSenderLeaderIdFieldName;

      property DocumentChargeSheetSenderIsForeignFieldName: String
      read GetDocumentChargeSheetSenderIsForeignFieldName
      write SetDocumentChargeSheetSenderIsForeignFieldName;
      
      property DocumentChargeSheetSenderNameFieldName: String
      read GetDocumentChargeSheetSenderNameFieldName
      write SetDocumentChargeSheetSenderNameFieldName;

      property DocumentChargeSheetSenderSpecialityFieldName: String
      read GetDocumentChargeSheetSenderSpecialityFieldName
      write SetDocumentChargeSheetSenderSpecialityFieldName;
      
      property DocumentChargeSheetSenderDepartmentIdFieldName: String
      read GetDocumentChargeSheetSenderDepartmentIdFieldName
      write SetDocumentChargeSheetSenderDepartmentIdFieldName;
      
      property DocumentChargeSheetSenderDepartmentCodeFieldName: String
      read GetDocumentChargeSheetSenderDepartmentCodeFieldName
      write SetDocumentChargeSheetSenderDepartmentCodeFieldName;

      property DocumentChargeSheetSenderDepartmentNameFieldName: String
      read GetDocumentChargeSheetSenderDepartmentNameFieldName
      write SetDocumentChargeSheetSenderDepartmentNameFieldName;

      property DocumentApprovingIdFieldName: String
      read GetDocumentApprovingIdFieldName write SetDocumentApprovingIdFieldName;

      property DocumentApprovingIsAccessibleFieldName: String
      read GetDocumentApprovingIsAccessibleFieldName
      write SetDocumentApprovingIsAccessibleFieldName;

      property DocumentChargeSheetIssuingDateTimeFieldName: String
      read GetDocumentChargeSheetIssuingDateTimeFieldName
      write SetDocumentChargeSheetIssuingDateTimeFieldName;

      property DocumentApprovingPerformingDateTimeFieldName: String
      read GetDocumentApprovingPerformingDateTimeFieldName
      write SetDocumentApprovingPerformingDateTimeFieldName;

      property DocumentApprovingPerformingResultIdFieldName: String
      read GetDocumentApprovingPerformingResultIdFieldName
      write SetDocumentApprovingPerformingResultIdFieldName;

      property DocumentApprovingPerformingResultFieldName: String
      read GetDocumentApprovingPerformingResultFieldName
      write SetDocumentApprovingPerformingResultFieldName;
      
      property DocumentApprovingNoteFieldName: String
      read GetDocumentApprovingNoteFieldName write SetDocumentApprovingNoteFieldName;

      property DocumentApprovingCycleNumberFieldName: String
      read GetDocumentApprovingCycleNumberFieldName
      write SetDocumentApprovingCycleNumberFieldName;

      property DocumentApprovingCycleIdFieldName: String
      read GetDocumentApprovingCycleIdFieldName
      write SetDocumentApprovingCycleIdFieldName;

      property DocumentApprovingIsCompletedFieldName: String
      read GetDocumentApprovingIsCompletedFieldName
      write SetDocumentApprovingIsCompletedFieldName;
      
      property DocumentApprovingIsLookedByApproverFieldName: String
      read GetDocumentApprovingIsLookedByApproverFieldName
      write SetDocumentApprovingIsLookedByApproverFieldName;

      property DocumentApproverIdFieldName: String
      read GetDocumentApproverIdFieldName write SetDocumentApproverIdFieldName;
      
      property DocumentApproverLeaderIdFieldName: String
      read GetDocumentApproverLeaderIdFieldName write SetDocumentApproverLeaderIdFieldName;

      property DocumentApproverIsForeignFieldName: String
      read GetDocumentApproverIsForeignFieldName
      write SetDocumentApproverIsForeignFieldName;
      
      property DocumentApproverNameFieldName: String
      read GetDocumentApproverNameFieldName write SetDocumentApproverNameFieldName;
      
      property DocumentApproverSpecialityFieldName: String
      read GetDocumentApproverSpecialityFieldName
      write SetDocumentApproverSpecialityFieldName;
      
      property DocumentApproverDepartmentIdFieldName: String
      read GetDocumentApproverDepartmentIdFieldName
      write SetDocumentApproverDepartmentIdFieldName;
      
      property DocumentApproverDepartmentCodeFieldName: String
      read GetDocumentApproverDepartmentCodeFieldName
      write SetDocumentApproverDepartmentCodeFieldName;

      property DocumentApproverDepartmentNameFieldName: String
      read GetDocumentApproverDepartmentNameFieldName
      write SetDocumentApproverDepartmentNameFieldName;

      property DocumentActualApproverIdFieldName: String
      read GetDocumentActualApproverIdFieldName
      write SetDocumentActualApproverIdFieldName;

      property DocumentActualApproverLeaderIdFieldName: String
      read GetDocumentActualApproverLeaderIdFieldName
      write SetDocumentActualApproverLeaderIdFieldName;

      property DocumentActualApproverIsForeignFieldName: String
      read GetDocumentActualApproverIsForeignFieldName
      write SetDocumentActualApproverIsForeignFieldName;
      
      property DocumentActualApproverNameFieldName: String
      read GetDocumentActualApproverNameFieldName
      write SetDocumentActualApproverNameFieldName;
      
      property DocumentActualApproverSpecialityFieldName: String
      read GetDocumentActualApproverSpecialityFieldName
      write SetDocumentActualApproverSpecialityFieldName;
      
      property DocumentActualApproverDepartmentIdFieldName: String
      read GetDocumentActualApproverDepartmentIdFieldName
      write SetDocumentActualApproverDepartmentIdFieldName;
      
      property DocumentActualApproverDepartmentCodeFieldName: String
      read GetDocumentActualApproverDepartmentCodeFieldName
      write SetDocumentActualApproverDepartmentCodeFieldName;
      
      property DocumentActualApproverDepartmentNameFieldName: String
      read GetDocumentActualApproverDepartmentNameFieldName
      write SetDocumentActualApproverDepartmentNameFieldName;

    public

      property DocumentInfoFieldNames: TDocumentInfoFieldNames
      read FDocumentInfoFieldNames write SetDocumentInfoFieldNames;

      property DocumentApprovingsInfoFieldNames: TDocumentApprovingsInfoFieldNames
      read FDocumentApprovingsInfoFieldNames write FDocumentApprovingsInfoFieldNames;
      
      property DocumentChargesInfoFieldNames: TDocumentChargesInfoFieldNames
      read FDocumentChargesInfoFieldNames write FDocumentChargesInfoFieldNames;

      property DocumentChargeSheetsInfoFieldNames: TDocumentChargeSheetsInfoFieldNames
      read FDocumentChargeSheetsInfoFieldNames write FDocumentChargeSheetsInfoFieldNames;

      property DocumentRelationsInfoFieldNames: TDocumentRelationsInfoFieldNames
      read FDocumentRelationsInfoFieldNames write SetDocumentRelationsInfoFieldNames;
      
      property DocumentFilesInfoFieldNames: TDocumentFilesInfoFieldNames
      read FDocumentFilesInfoFieldNames write SetDocumentFilesInfoFieldNames;
      
  end;

  TDocumentFullInfoDataSetHolder = class (TAbstractDataSetHolder)

    private

      function GetFieldNames: TDocumentFullInfoDataSetFieldNames;

    protected

      procedure SetDocumentApprovingsInfoHolder(const Value: TDocumentApprovingsInfoHolder); virtual;

      procedure SetDocumentChargesInfoHolder(const Value: TDocumentChargesInfoHolder); virtual;

      procedure SetDocumentChargeSheetsInfoHolder(const Value: TDocumentChargeSheetsInfoHolder); virtual;

      procedure SetDocumentFilesInfoHolder(const Value: TDocumentFilesInfoHolder); virtual;
      procedure SetDocumentInfoHolder(const Value: TDocumentInfoHolder); virtual;

      procedure SetDocumentRelationsInfoHolder(const Value: TDocumentRelationsInfoHolder); virtual;

      procedure SetFieldNames(const Value: TDocumentFullInfoDataSetFieldNames); virtual;

    protected

      FDocumentInfoHolder: TDocumentInfoHolder;
      FFreeDocumentInfoHolder: IDisposable;

      FDocumentApprovingsInfoHolder: TDocumentApprovingsInfoHolder;
      FFreeDocumentApprovingsInfoHolder: IDisposable;
      
      FDocumentChargesInfoHolder: TDocumentChargesInfoHolder;
      FFreeDocumentChargesInfoHolder: IDisposable;
      
      FDocumentChargeSheetsInfoHolder: TDocumentChargeSheetsInfoHolder;
      FFreeDocumentChargeSheetsInfoHolder: IDisposable;
      
      FDocumentRelationsInfoHolder: TDocumentRelationsInfoHolder;
      FFreeDocumentRelationsInfoHolder: IDisposable;
      
      FDocumentFilesInfoHolder: TDocumentFilesInfoHolder;
      FFreeDocumentFilesInfoHolder: IDisposable;

      procedure Initialize; override;

      function CreateDocumentInfoHolderInstance: TDocumentInfoHolder; virtual;
      function CreateDocumentApprovingsInfoHolderInstance: TDocumentApprovingsInfoHolder; virtual;
      function CreateDocumentChargesInfoHolderInstance: TDocumentChargesInfoHolder; virtual;
      function CreateDocumentChargeSheetsInfoHolderInstance: TDocumentChargeSheetsInfoHolder; virtual;
      function CreateDocumentRelationsInfoHolderInstance: TDocumentRelationsInfoHolder; virtual;
      function CreateDocumentFilesInfoHolderInstance: TDocumentFilesInfoHolder; virtual;

      function CreateDocumentInfoHolder: TDocumentInfoHolder; virtual;
      function CreateDocumentApprovingsInfoHolder: TDocumentApprovingsInfoHolder; virtual;
      function CreateDocumentChargesInfoHolder: TDocumentChargesInfoHolder; virtual;
      function CreateDocumentChargeSheetsInfoHolder: TDocumentChargeSheetsInfoHolder; virtual;
      function CreateDocumentRelationsInfoHolder: TDocumentRelationsInfoHolder; virtual;
      function CreateDocumentFilesInfoHolder: TDocumentFilesInfoHolder; virtual;
      
      procedure UpdateDataSet(Holder: TAbstractDataSetHolder);

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;

      function GetDocumentAuthorDepartmentCodeFieldValue: String;
      function GetDocumentAuthorDepartmentIdFieldValue: Variant;
      function GetDocumentAuthorDepartmentNameFieldValue: String;
      function GetDocumentAuthorIdFieldValue: Variant;
      function GetDocumentChargeIsForAcquaitanceFieldValue: Boolean;
      function GetDocumentProductCodeFieldValue: String;
      function GetDocumentChargeSheetIsForAcquaitanceFieldValue: Boolean;
      function GetDocumentAuthorNameFieldValue: String;
      function GetDocumentChargeActualPerformerDepartmentCodeFieldValue: String;
      function GetDocumentChargeActualPerformerDepartmentIdFieldValue: Variant;
      function GetDocumentChargeActualPerformerDepartmentNameFieldValue: String;
      function GetDocumentChargeActualPerformerIdFieldValue: Variant;
      function GetDocumentChargeActualPerformerNameFieldValue: String;
      function GetDocumentChargeActualPerformerSpecialityFieldValue: String;
      function GetDocumentChargeIdFieldValue: Variant;
      function GetDocumentChargePerformerDepartmentCodeFieldValue: String;
      function GetDocumentChargePerformerDepartmentIdFieldValue: Variant;
      function GetDocumentChargePerformerDepartmentNameFieldValue: String;
      function GetDocumentChargePerformerIdFieldValue: Variant;
      function GetDocumentChargePerformerNameFieldValue: String;
      function GetDocumentChargePerformerSpecialityFieldValue: String;
      function GetDocumentChargePerformingDateTimeFieldValue: Variant;
      function GetDocumentChargePeriodEndFieldValue: Variant;
      function GetDocumentChargePeriodStartFieldValue: Variant;
      function GetDocumentChargeResponseFieldValue: String;
      function GetDocumentChargeTextFieldValue: String;
      function GetDocumentContentFieldName: String;
      function GetDocumentNoteFieldValue: String;
      function GetDocumentIsSelfRegisteredFieldValue: Variant;
      function GetDocumentCreationDateFieldValue: TDateTime;
      function GetDocumentDateFieldValue: Variant;
      function GetDocumentCurrentWorkCycleStageNameFieldValue: String;
      function GetDocumentCurrentWorkCycleStageNumberFieldValue: Integer;
      function GetDocumentFileIdFieldValue: Variant;
      function GetDocumentFileNameFieldValue: String;
      function GetDocumentFilePathFieldValue: String;
      function GetDocumentIdFieldValue: Variant;
      function GetBaseDocumentIdFieldValue: Variant;
      function GetDocumentKindFieldValue: String;
      function GetDocumentNameFieldValue: String;
      function GetDocumentNumberFieldValue: String;
      function GetDocumentResponsibleDepartmentCodeFieldValue: String;
      function GetDocumentResponsibleDepartmentIdFieldValue: Variant;
      function GetDocumentResponsibleDepartmentNameFieldValue: String;
      function GetDocumentResponsibleIdFieldValue: Variant;
      function GetDocumentResponsibleNameFieldValue: String;
      function GetDocumentResponsibleTelephoneNumberFieldValue: String;
      function GetDocumentSignerDepartmentCodeFieldValue: String;
      function GetDocumentSignerDepartmentIdFieldValue: Variant;
      function GetDocumentSignerDepartmentNameFieldValue: String;
      function GetDocumentSignerIdFieldValue: Variant;
      function GetDocumentSignerNameFieldValue: String;
      function GetDocumentSignerSpecialityFieldValue: String;
      function GetDocumentSigningDateFieldValue: Variant;
      function GetDocumentSigningIdFieldValue: Variant;
      function GetRelatedDocumentDateFieldValue: TDateTime;
      function GetDocumentRelationIdFieldValue: Variant;
      function GetRelatedDocumentIdFieldValue: Variant;
      function GetRelatedDocumentKindIdFieldValue: Variant;
      function GetRelatedDocumentKindNameFieldValue: String;
      function GetRelatedDocumentNameFieldValue: String;
      function GetRelatedDocumentNumberFieldValue: String;
      function GetDocumentActualSignerDepartmentCodeFieldValue: String;
      function GetDocumentActualSignerDepartmentIdFieldValue: Variant;
      function GetDocumentActualSignerDepartmentNameFieldValue: String;
      function GetDocumentActualSignerIdFieldValue: Variant;
      function GetDocumentActualSignerNameFieldValue: String;
      function GetDocumentActualSignerSpecialityFieldValue: String;
      function GetDocumentChargeSheetActualPerformerDepartmentCodeFieldValue: String;
      function GetDocumentChargeSheetActualPerformerDepartmentIdFieldValue: Variant;
      function GetDocumentChargeSheetActualPerformerDepartmentNameFieldValue: String;
      function GetDocumentChargeSheetActualPerformerIdFieldValue: Variant;
      function GetDocumentChargeSheetActualPerformerNameFieldValue: String;
      function GetDocumentChargeSheetActualPerformerSpecialityFieldValue: String;
      function GetDocumentChargeSheetIdFieldValue: Variant;
      function GetDocumentChargeSheetPerformerDepartmentCodeFieldValue: String;
      function GetDocumentChargeSheetPerformerDepartmentIdFieldValue: Variant;
      function GetDocumentChargeSheetPerformerDepartmentNameFieldValue: String;
      function GetDocumentChargeSheetPerformerIdFieldValue: Variant;
      function GetDocumentChargeSheetPerformerNameFieldValue: String;
      function GetDocumentChargeSheetPerformerSpecialityFieldValue: String;
      function GetDocumentChargeSheetIssuingDateTimeFieldValue: Variant;
      function GetDocumentChargeSheetPerformingDateTimeFieldValue: Variant;
      function GetDocumentChargeSheetPeriodEndFieldValue: Variant;
      function GetDocumentChargeSheetPeriodStartFieldValue: Variant;
      function GetDocumentChargeSheetResponseFieldValue: String;
      function GetDocumentChargeSheetSenderDepartmentCodeFieldValue: String;
      function GetDocumentChargeSheetSenderDepartmentIdFieldValue: Variant;
      function GetDocumentChargeSheetSenderDepartmentNameFieldValue: String;
      function GetDocumentChargeSheetSenderIdFieldValue: Variant;
      function GetDocumentChargeSheetSenderNameFieldValue: String;
      function GetDocumentChargeSheetSenderSpecialityFieldValue: String;
      function GetDocumentChargeSheetTextFieldValue: String;
      function GetTopLevelChargeSheetIdFieldValue: Variant;
      function GetDocumentActualSignerLeaderIdFieldValue: Variant;
      function GetDocumentAuthorLeaderIdFieldValue: Variant;
      function GetDocumentChargeActualPerformerIsForeignFieldValue: Boolean;
      function GetDocumentChargeActualPerformerLeaderIdFieldValue: Variant;
      function GetDocumentChargePerformerIsForeignFieldValue: Boolean;
      function GetDocumentChargePerformerLeaderIdFieldValue: Variant;
      function GetDocumentChargeSheetActualPerformerIsForeignFieldValue: Boolean;
      function GetDocumentChargeSheetActualPerformerLeaderIdFieldValue: Variant;
      function GetDocumentChargeSheetPerformerIsForeignFieldValue: Boolean;
      function GetDocumentChargeSheetPerformerLeaderIdFieldValue: Variant;
      function GetDocumentChargeSheetSenderIsForeignFieldValue: Boolean;
      function GetDocumentChargeSheetSenderLeaderIdFieldValue: Variant;
      function GetDocumentSignerLeaderIdFieldValue: Variant;
      function GetDocumentKindIdFieldValue: Variant;
      function GetDocumentAuthorSpecialityFieldValue: String;
      function GetDocumentActualApproverDepartmentCodeFieldValue: String;
      function GetDocumentActualApproverDepartmentIdFieldValue: Variant;
      function GetDocumentActualApproverDepartmentNameFieldValue: String;
      function GetDocumentActualApproverIdFieldValue: Variant;
      function GetDocumentActualApproverIsForeignFieldValue: Boolean;
      function GetDocumentActualApproverLeaderIdFieldValue: Variant;
      function GetDocumentActualApproverNameFieldValue: String;
      function GetDocumentActualApproverSpecialityFieldValue: String;
      function GetDocumentApproverDepartmentCodeFieldValue: String;
      function GetDocumentApproverDepartmentIdFieldValue: Variant;
      function GetDocumentApproverDepartmentNameFieldValue: String;
      function GetDocumentApproverIdFieldValue: Variant;
      function GetDocumentApproverIsForeignFieldValue: Boolean;
      function GetDocumentApproverLeaderIdFieldValue: Variant;
      function GetDocumentApprovingIsAccessibleFieldValue: Boolean;
      function GetDocumentApproverNameFieldValue: String;
      function GetDocumentApproverSpecialityFieldValue: String;
      function GetDocumentApprovingCycleIdFieldValue: Variant;
      function GetDocumentApprovingCycleNumberFieldValue: Variant;
      function GetDocumentApprovingIdFieldValue: Variant;
      function GetDocumentApprovingIsCompletedFieldValue: Boolean;
      function GetDocumentApprovingNoteFieldValue: String;
      function GetDocumentApprovingPerformingDateTimeFieldValue: Variant;
      function GetDocumentApprovingPerformingResultFieldValue: String;
      function GetDocumentApprovingPerformingResultIdFieldValue: Variant;
      function GetDocumentApprovingIsLookedByApproverFieldValue: Boolean;
      function GetDocumentChargeSheetViewingDateByPerformerFieldValue: Variant;
      function GetDocumentChargeSheetPerformerRoleIdFieldValue: Variant; { временно, из-за неадаптированной предыдущей версии программы }
      function GetChargeSheetDocumentIdFieldValue: Variant;

    protected

      procedure SetDataSet(const Value: TDataSet); override;

    published

      property DocumentInfoHolder: TDocumentInfoHolder
      read FDocumentInfoHolder write SetDocumentInfoHolder;
      
      property DocumentApprovingsInfoHolder: TDocumentApprovingsInfoHolder
      read FDocumentApprovingsInfoHolder write SetDocumentApprovingsInfoHolder;

      property DocumentChargesInfoHolder: TDocumentChargesInfoHolder
      read FDocumentChargesInfoHolder write SetDocumentChargesInfoHolder;

      property DocumentChargeSheetsInfoHolder: TDocumentChargeSheetsInfoHolder
      read FDocumentChargeSheetsInfoHolder write SetDocumentChargeSheetsInfoHolder;

      property DocumentRelationsInfoHolder: TDocumentRelationsInfoHolder
      read FDocumentRelationsInfoHolder write SetDocumentRelationsInfoHolder;

      property DocumentFilesInfoHolder: TDocumentFilesInfoHolder
      read FDocumentFilesInfoHolder write SetDocumentFilesInfoHolder;

      property FieldNames: TDocumentFullInfoDataSetFieldNames
      read GetFieldNames write SetFieldNames;
      
      property DocumentIdFieldValue: Variant
      read GetDocumentIdFieldValue;

      property BaseDocumentIdFieldValue: Variant
      read GetBaseDocumentIdFieldValue;

      property DocumentNumberFieldValue: String
      read GetDocumentNumberFieldValue;

      property DocumentNameFieldValue: String
      read GetDocumentNameFieldValue;

      property DocumentContentFieldValue: String
      read GetDocumentContentFieldName;

      property DocumentNoteFieldValue: String
      read GetDocumentNoteFieldValue;

      property DocumentProductCodeFieldValue: String
      read GetDocumentProductCodeFieldValue;
      
      property DocumentCreationDateFieldValue: TDateTime
      read GetDocumentCreationDateFieldValue;

      property DocumentDateFieldValue: Variant
      read GetDocumentDateFieldValue;
      
      property DocumentKindFieldValue: String
      read GetDocumentKindFieldValue;

      property DocumentKindIdFieldValue: Variant
      read GetDocumentKindIdFieldValue;

      property DocumentCurrentWorkCycleStageNameFieldValue: String
      read GetDocumentCurrentWorkCycleStageNameFieldValue;

      property DocumentCurrentWorkCycleStageNumberFieldValue: Integer
      read GetDocumentCurrentWorkCycleStageNumberFieldValue;

      property DocumentAuthorIdFieldValue: Variant
      read GetDocumentAuthorIdFieldValue;

      property DocumentAuthorLeaderIdFieldValue: Variant
      read GetDocumentAuthorLeaderIdFieldValue;

      property DocumentAuthorNameFieldValue: String
      read GetDocumentAuthorNameFieldValue;

      property DocumentAuthorSpecialityFieldValue: String
      read GetDocumentAuthorSpecialityFieldValue;
      
      property DocumentAuthorDepartmentIdFieldValue: Variant
      read GetDocumentAuthorDepartmentIdFieldValue;
      
      property DocumentAuthorDepartmentCodeFieldValue: String
      read GetDocumentAuthorDepartmentCodeFieldValue;

      property DocumentAuthorDepartmentNameFieldValue: String
      read GetDocumentAuthorDepartmentNameFieldValue;
      
      property DocumentResponsibleIdFieldValue: Variant
      read GetDocumentResponsibleIdFieldValue;

      property DocumentResponsibleNameFieldValue: String
      read GetDocumentResponsibleNameFieldValue;

      property DocumentResponsibleTelephoneNumberFieldValue: String
      read GetDocumentResponsibleTelephoneNumberFieldValue;
      
      property DocumentResponsibleDepartmentIdFieldValue: Variant
      read GetDocumentResponsibleDepartmentIdFieldValue;
      
      property DocumentResponsibleDepartmentCodeFieldValue: String
      read GetDocumentResponsibleDepartmentCodeFieldValue;

      property DocumentResponsibleDepartmentNameFieldValue: String
      read GetDocumentResponsibleDepartmentNameFieldValue;
      
      property DocumentSigningIdFieldValue: Variant
      read GetDocumentSigningIdFieldValue;

      property DocumentSigningDateFieldValue: Variant
      read GetDocumentSigningDateFieldValue;
      
      property DocumentSignerIdFieldValue: Variant
      read GetDocumentSignerIdFieldValue;

      property DocumentSignerLeaderIdFieldValue: Variant
      read GetDocumentSignerLeaderIdFieldValue;

      property DocumentSignerNameFieldValue: String
      read GetDocumentSignerNameFieldValue;

      property DocumentSignerSpecialityFieldValue: String
      read GetDocumentSignerSpecialityFieldValue;
      
      property DocumentSignerDepartmentIdFieldValue: Variant
      read GetDocumentSignerDepartmentIdFieldValue;
      
      property DocumentSignerDepartmentCodeFieldValue: String
      read GetDocumentSignerDepartmentCodeFieldValue;
      
      property DocumentSignerDepartmentNameFieldValue: String
      read GetDocumentSignerDepartmentNameFieldValue;

      property DocumentActualSignerIdFieldValue: Variant
      read GetDocumentActualSignerIdFieldValue;

      property DocumentActualSignerLeaderIdFieldValue: Variant
      read GetDocumentActualSignerLeaderIdFieldValue;

      property DocumentActualSignerNameFieldValue: String
      read GetDocumentActualSignerNameFieldValue;

      property DocumentActualSignerSpecialityFieldValue: String
      read GetDocumentActualSignerSpecialityFieldValue;
      
      property DocumentActualSignerDepartmentIdFieldValue: Variant
      read GetDocumentActualSignerDepartmentIdFieldValue;
      
      property DocumentActualSignerDepartmentCodeFieldValue: String
      read GetDocumentActualSignerDepartmentCodeFieldValue;
      
      property DocumentActualSignerDepartmentNameFieldValue: String
      read GetDocumentActualSignerDepartmentNameFieldValue;
      
      property DocumentChargeIdFieldValue: Variant
      read GetDocumentChargeIdFieldValue;
      
      property DocumentChargeTextFieldValue: String
      read GetDocumentChargeTextFieldValue;

      property DocumentChargeIsForAcquaitanceFieldValue: Boolean
      read GetDocumentChargeIsForAcquaitanceFieldValue;
      
      property DocumentChargeResponseFieldValue: String
      read GetDocumentChargeResponseFieldValue;
      
      property DocumentChargePeriodStartFieldValue: Variant
      read GetDocumentChargePeriodStartFieldValue;

      property DocumentChargePeriodEndFieldValue: Variant
      read GetDocumentChargePeriodEndFieldValue;

      property DocumentChargePerformingDateTimeFieldValue: Variant
      read GetDocumentChargePerformingDateTimeFieldValue;
      
      property DocumentChargePerformerIdFieldValue: Variant
      read GetDocumentChargePerformerIdFieldValue;

      property DocumentChargePerformerLeaderIdFieldValue: Variant
      read GetDocumentChargePerformerLeaderIdFieldValue;

      property DocumentChargePerformerIsForeignFieldValue: Boolean
      read GetDocumentChargePerformerIsForeignFieldValue;
      
      property DocumentChargePerformerNameFieldValue: String
      read GetDocumentChargePerformerNameFieldValue;
      
      property DocumentChargePerformerSpecialityFieldValue: String
      read GetDocumentChargePerformerSpecialityFieldValue;
      
      property DocumentChargePerformerDepartmentIdFieldValue: Variant
      read GetDocumentChargePerformerDepartmentIdFieldValue;
      
      property DocumentChargePerformerDepartmentCodeFieldValue: String
      read GetDocumentChargePerformerDepartmentCodeFieldValue;
      
      property DocumentChargePerformerDepartmentNameFieldValue: String
      read GetDocumentChargePerformerDepartmentNameFieldValue;
      
      property DocumentChargeActualPerformerIdFieldValue: Variant
      read GetDocumentChargeActualPerformerIdFieldValue;

      property DocumentChargeActualPerformerLeaderIdFieldValue: Variant
      read GetDocumentChargeActualPerformerLeaderIdFieldValue;

      property DocumentChargeActualPerformerIsForeignFieldValue: Boolean
      read GetDocumentChargeActualPerformerIsForeignFieldValue;

      property DocumentChargeActualPerformerNameFieldValue: String
      read GetDocumentChargeActualPerformerNameFieldValue;
      
      property DocumentChargeActualPerformerSpecialityFieldValue: String
      read GetDocumentChargeActualPerformerSpecialityFieldValue;
      
      property DocumentChargeActualPerformerDepartmentIdFieldValue: Variant
      read GetDocumentChargeActualPerformerDepartmentIdFieldValue;
      
      property DocumentChargeActualPerformerDepartmentCodeFieldValue: String
      read GetDocumentChargeActualPerformerDepartmentCodeFieldValue;
      
      property DocumentChargeActualPerformerDepartmentNameFieldValue: String
      read GetDocumentChargeActualPerformerDepartmentNameFieldValue;
      
      property DocumentFileIdFieldValue: Variant
      read GetDocumentFileIdFieldValue;

      property DocumentFileNameFieldValue: String
      read GetDocumentFileNameFieldValue;

      property DocumentFilePathFieldValue: String
      read GetDocumentFilePathFieldValue;

      property DocumentRelationIdFieldValue: Variant
      read GetDocumentRelationIdFieldValue;
      
      property RelatedDocumentIdFieldValue: Variant
      read GetRelatedDocumentIdFieldValue;
      
      property RelatedDocumentKindIdFieldValue: Variant
      read GetRelatedDocumentKindIdFieldValue;
      
      property RelatedDocumentKindNameFieldValue: String
      read GetRelatedDocumentKindNameFieldValue;
      
      property RelatedDocumentNumberFieldValue: String
      read GetRelatedDocumentNumberFieldValue;

      property RelatedDocumentNameFieldValue: String
      read GetRelatedDocumentNameFieldValue;

      property RelatedDocumentDateFieldValue: TDateTime
      read GetRelatedDocumentDateFieldValue;

      property ChargeSheetDocumentIdFieldValue: Variant
      read GetChargeSheetDocumentIdFieldValue;
      
      property DocumentChargeSheetIdFieldValue: Variant
      read GetDocumentChargeSheetIdFieldValue;

      property TopLevelChargeSheetIdFieldValue: Variant
      read GetTopLevelChargeSheetIdFieldValue;

      property DocumentChargeSheetTextFieldValue: String
      read GetDocumentChargeSheetTextFieldValue;

      property DocumentIsSelfRegisteredFieldValue: Variant
      read GetDocumentIsSelfRegisteredFieldValue;
      
      property DocumentChargeSheetResponseFieldValue: String
      read GetDocumentChargeSheetResponseFieldValue;

      property DocumentChargeSheetIsForAcquaitanceFieldValue: Boolean
      read GetDocumentChargeSheetIsForAcquaitanceFieldValue;
      
      property DocumentChargeSheetPeriodStartFieldValue: Variant
      read GetDocumentChargeSheetPeriodStartFieldValue;

      property DocumentChargeSheetPeriodEndFieldValue: Variant
      read GetDocumentChargeSheetPeriodEndFieldValue;

      property DocumentChargeSheetPerformingDateTimeFieldValue: Variant
      read GetDocumentChargeSheetPerformingDateTimeFieldValue;
      
      property DocumentChargeSheetPerformerIdFieldValue: Variant
      read GetDocumentChargeSheetPerformerIdFieldValue;

      { временно, из-за неадаптированной предыдущей версии программы }
      property DocumentChargeSheetPerformerRoleIdFieldValue: Variant
      read GetDocumentChargeSheetPerformerRoleIdFieldValue;

      property DocumentChargeSheetPerformerLeaderIdFieldValue: Variant
      read GetDocumentChargeSheetPerformerLeaderIdFieldValue;

      property DocumentChargeSheetPerformerIsForeignFieldValue: Boolean
      read GetDocumentChargeSheetPerformerIsForeignFieldValue;

      property DocumentChargeSheetPerformerNameFieldValue: String
      read GetDocumentChargeSheetPerformerNameFieldValue;
      
      property DocumentChargeSheetPerformerSpecialityFieldValue: String
      read GetDocumentChargeSheetPerformerSpecialityFieldValue;
      
      property DocumentChargeSheetPerformerDepartmentIdFieldValue: Variant
      read GetDocumentChargeSheetPerformerDepartmentIdFieldValue;
      
      property DocumentChargeSheetPerformerDepartmentCodeFieldValue: String
      read GetDocumentChargeSheetPerformerDepartmentCodeFieldValue;
      
      property DocumentChargeSheetPerformerDepartmentNameFieldValue: String
      read GetDocumentChargeSheetPerformerDepartmentNameFieldValue;
      
      property DocumentChargeSheetActualPerformerIdFieldValue: Variant
      read GetDocumentChargeSheetActualPerformerIdFieldValue;

      property DocumentChargeSheetActualPerformerLeaderIdFieldValue: Variant
      read GetDocumentChargeSheetActualPerformerLeaderIdFieldValue;

      property DocumentChargeSheetActualPerformerIsForeignFieldValue: Boolean
      read GetDocumentChargeSheetActualPerformerIsForeignFieldValue;
      
      property DocumentChargeSheetActualPerformerNameFieldValue: String
      read GetDocumentChargeSheetActualPerformerNameFieldValue;
      
      property DocumentChargeSheetActualPerformerSpecialityFieldValue: String
      read GetDocumentChargeSheetActualPerformerSpecialityFieldValue;
      
      property DocumentChargeSheetActualPerformerDepartmentIdFieldValue: Variant
      read GetDocumentChargeSheetActualPerformerDepartmentIdFieldValue;
      
      property DocumentChargeSheetActualPerformerDepartmentCodeFieldValue: String
      read GetDocumentChargeSheetActualPerformerDepartmentCodeFieldValue;
      
      property DocumentChargeSheetActualPerformerDepartmentNameFieldValue: String
      read GetDocumentChargeSheetActualPerformerDepartmentNameFieldValue;

      property DocumentChargeSheetSenderIdFieldValue: Variant
      read GetDocumentChargeSheetSenderIdFieldValue;

      property DocumentChargeSheetSenderLeaderIdFieldValue: Variant
      read GetDocumentChargeSheetSenderLeaderIdFieldValue;

      property DocumentChargeSheetSenderIsForeignFieldValue: Boolean
      read GetDocumentChargeSheetSenderIsForeignFieldValue;

      property DocumentChargeSheetSenderNameFieldValue: String
      read GetDocumentChargeSheetSenderNameFieldValue;
      
      property DocumentChargeSheetSenderSpecialityFieldValue: String
      read GetDocumentChargeSheetSenderSpecialityFieldValue;
      
      property DocumentChargeSheetSenderDepartmentIdFieldValue: Variant
      read GetDocumentChargeSheetSenderDepartmentIdFieldValue;
      
      property DocumentChargeSheetSenderDepartmentCodeFieldValue: String
      read GetDocumentChargeSheetSenderDepartmentCodeFieldValue;
      
      property DocumentChargeSheetSenderDepartmentNameFieldValue: String
      read GetDocumentChargeSheetSenderDepartmentNameFieldValue;

      property DocumentApprovingIdFieldValue: Variant
      read GetDocumentApprovingIdFieldValue;

      property DocumentApprovingPerformingDateTimeFieldValue: Variant
      read GetDocumentApprovingPerformingDateTimeFieldValue;
      
      property DocumentApprovingPerformingResultIdFieldValue: Variant
      read GetDocumentApprovingPerformingResultIdFieldValue;
      
      property DocumentApprovingPerformingResultFieldValue: String
      read GetDocumentApprovingPerformingResultFieldValue;
      
      property DocumentApprovingNoteFieldValue: String
      read GetDocumentApprovingNoteFieldValue;

      property DocumentApprovingCycleIdFieldValue: Variant
      read GetDocumentApprovingCycleIdFieldValue;
      
      property DocumentApprovingCycleNumberFieldValue: Variant
      read GetDocumentApprovingCycleNumberFieldValue;

      property DocumentApprovingIsCompletedFieldValue: Boolean
      read GetDocumentApprovingIsCompletedFieldValue;

      property DocumentApproverIdFieldValue: Variant
      read GetDocumentApproverIdFieldValue;
      
      property DocumentApproverLeaderIdFieldValue: Variant
      read GetDocumentApproverLeaderIdFieldValue;
      
      property DocumentApproverIsForeignFieldValue: Boolean
      read GetDocumentApproverIsForeignFieldValue;

      property DocumentApproverNameFieldValue: String
      read GetDocumentApproverNameFieldValue;
      
      property DocumentApproverSpecialityFieldValue: String
      read GetDocumentApproverSpecialityFieldValue;

      property DocumentApprovingIsAccessibleFieldValue: Boolean
      read GetDocumentApprovingIsAccessibleFieldValue;
      
      property DocumentApproverDepartmentIdFieldValue: Variant
      read GetDocumentApproverDepartmentIdFieldValue;
      
      property DocumentApproverDepartmentCodeFieldValue: String
      read GetDocumentApproverDepartmentCodeFieldValue;
      
      property DocumentApproverDepartmentNameFieldValue: String
      read GetDocumentApproverDepartmentNameFieldValue;

      property DocumentActualApproverIdFieldValue: Variant
      read GetDocumentActualApproverIdFieldValue;

      property DocumentActualApproverLeaderIdFieldValue: Variant
      read GetDocumentActualApproverLeaderIdFieldValue;
      
      property DocumentActualApproverIsForeignFieldValue: Boolean
      read GetDocumentActualApproverIsForeignFieldValue;
      
      property DocumentActualApproverNameFieldValue: String
      read GetDocumentActualApproverNameFieldValue;
      
      property DocumentActualApproverSpecialityFieldValue: String
      read GetDocumentActualApproverSpecialityFieldValue;
      
      property DocumentActualApproverDepartmentIdFieldValue: Variant
      read GetDocumentActualApproverDepartmentIdFieldValue;
      
      property DocumentActualApproverDepartmentCodeFieldValue: String
      read GetDocumentActualApproverDepartmentCodeFieldValue;
      
      property DocumentActualApproverDepartmentNameFieldValue: String
      read GetDocumentActualApproverDepartmentNameFieldValue;

      property DocumentApprovingIsLookedByApproverFieldValue: Boolean
      read GetDocumentApprovingIsLookedByApproverFieldValue;

      property DocumentChargeSheetViewingDateByPerformerFieldValue: Variant
      read GetDocumentChargeSheetViewingDateByPerformerFieldValue;

      property DocumentChargeSheetIssuingDateTimeFieldValue: Variant
      read GetDocumentChargeSheetIssuingDateTimeFieldValue;

  end;

implementation

uses

  Variants,
  AuxDebugFunctionsUnit;
  
{ TDocumentFullInfoDataSetHolder }


function TDocumentFullInfoDataSetHolder.CreateDocumentApprovingsInfoHolder: TDocumentApprovingsInfoHolder;
begin

  Result := CreateDocumentApprovingsInfoHolderInstance;

  FieldNames.DocumentApprovingsInfoFieldNames := Result.FieldNames;

end;

function TDocumentFullInfoDataSetHolder.CreateDocumentApprovingsInfoHolderInstance: TDocumentApprovingsInfoHolder;
begin

  Result := TDocumentApprovingsInfoHolder.Create;
  
end;

function TDocumentFullInfoDataSetHolder.CreateDocumentChargeSheetsInfoHolder: TDocumentChargeSheetsInfoHolder;
begin

  Result := CreateDocumentChargeSheetsInfoHolderInstance;

  FieldNames.DocumentChargeSheetsInfoFieldNames := Result.FieldNames;
  
end;

function TDocumentFullInfoDataSetHolder.CreateDocumentChargeSheetsInfoHolderInstance: TDocumentChargeSheetsInfoHolder;
begin

  Result := TDocumentChargeSheetsInfoHolder.Create;
  
end;

function TDocumentFullInfoDataSetHolder.CreateDocumentChargesInfoHolder: TDocumentChargesInfoHolder;
begin

  Result := CreateDocumentChargesInfoHolderInstance;

  FieldNames.DocumentChargesInfoFieldNames := Result.FieldNames;
  
end;

function TDocumentFullInfoDataSetHolder.CreateDocumentChargesInfoHolderInstance: TDocumentChargesInfoHolder;
begin

  Result := TDocumentChargesInfoHolder.Create;
  
end;

function TDocumentFullInfoDataSetHolder.CreateDocumentFilesInfoHolder: TDocumentFilesInfoHolder;
begin

  Result := CreateDocumentFilesInfoHolderInstance;

  FieldNames.DocumentFilesInfoFieldNames := Result.FieldNames;
  
end;

function TDocumentFullInfoDataSetHolder.CreateDocumentFilesInfoHolderInstance: TDocumentFilesInfoHolder;
begin

  Result := TDocumentFilesInfoHolder.Create;
  
end;

function TDocumentFullInfoDataSetHolder.CreateDocumentInfoHolder: TDocumentInfoHolder;
begin

  Result := CreateDocumentInfoHolderInstance;

  FieldNames.DocumentInfoFieldNames := Result.FieldNames;

end;

function TDocumentFullInfoDataSetHolder.CreateDocumentInfoHolderInstance: TDocumentInfoHolder;
begin

  Result := TDocumentInfoHolder.Create;

end;

function TDocumentFullInfoDataSetHolder.CreateDocumentRelationsInfoHolder: TDocumentRelationsInfoHolder;
begin

  Result := CreateDocumentRelationsInfoHolderInstance;

  FieldNames.DocumentRelationsInfoFieldNames := Result.FieldNames;
  
end;

function TDocumentFullInfoDataSetHolder.CreateDocumentRelationsInfoHolderInstance: TDocumentRelationsInfoHolder;
begin

  Result := TDocumentRelationsInfoHolder.Create;

end;

function TDocumentFullInfoDataSetHolder.GetBaseDocumentIdFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.BaseIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetChargeSheetDocumentIdFieldValue: Variant;
begin

  Result := FDocumentChargeSheetsInfoHolder.ChargeSheetDocumentIdFieldValue;
            
end;

class function TDocumentFullInfoDataSetHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TDocumentFullInfoDataSetFieldNames;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentActualApproverDepartmentCodeFieldValue: String;
begin

  Result := FDocumentApprovingsInfoHolder.DocumentActualApproverDepartmentCodeFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetDocumentActualApproverDepartmentIdFieldValue: Variant;
begin

  Result := FDocumentApprovingsInfoHolder.DocumentActualApproverDepartmentIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentActualApproverDepartmentNameFieldValue: String;
begin

  Result := FDocumentApprovingsInfoHolder.DocumentActualApproverDepartmentNameFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentActualApproverIdFieldValue: Variant;
begin

  Result := FDocumentApprovingsInfoHolder.DocumentActualApproverIdFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetDocumentActualApproverIsForeignFieldValue: Boolean;
begin

  Result := FDocumentApprovingsInfoHolder.DocumentActualApproverIsForeignFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetDocumentActualApproverLeaderIdFieldValue: Variant;
begin

  Result := FDocumentApprovingsInfoHolder.DocumentActualApproverLeaderIdFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetDocumentActualApproverNameFieldValue: String;
begin

  Result := FDocumentApprovingsInfoHolder.DocumentActualApproverNameFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentActualApproverSpecialityFieldValue: String;
begin

  Result := FDocumentApprovingsInfoHolder.DocumentActualApproverSpecialityFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetDocumentActualSignerDepartmentCodeFieldValue: String;
begin

  Result := FDocumentInfoHolder.ActualSignerDepartmentCodeFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentActualSignerDepartmentIdFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.ActualSignerDepartmentIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentActualSignerDepartmentNameFieldValue: String;
begin

  Result := FDocumentInfoHolder.ActualSignerDepartmentNameFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentActualSignerIdFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.ActualSignerIdFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentActualSignerLeaderIdFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.ActualSignerLeaderIdFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentActualSignerNameFieldValue: String;
begin

  Result := FDocumentInfoHolder.ActualSignerNameFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.
  GetDocumentActualSignerSpecialityFieldValue: String;
begin

  Result := FDocumentInfoHolder.ActualSignerSpecialityFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetDocumentApproverDepartmentCodeFieldValue: String;
begin

  Result := FDocumentApprovingsInfoHolder.DocumentApproverDepartmentCodeFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetDocumentApproverDepartmentIdFieldValue: Variant;
begin

  Result := FDocumentApprovingsInfoHolder.DocumentApproverDepartmentIdFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetDocumentApproverDepartmentNameFieldValue: String;
begin

  Result := FDocumentApprovingsInfoHolder.DocumentApproverDepartmentNameFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetDocumentApproverIdFieldValue: Variant;
begin

  Result := FDocumentApprovingsInfoHolder.DocumentApproverIdFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetDocumentApproverIsForeignFieldValue: Boolean;
begin

  Result := FDocumentApprovingsInfoHolder.DocumentApproverIsForeignFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetDocumentApproverLeaderIdFieldValue: Variant;
begin

  Result := FDocumentApprovingsInfoHolder.DocumentApproverLeaderIdFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetDocumentApproverNameFieldValue: String;
begin

  Result := FDocumentApprovingsInfoHolder.DocumentApproverNameFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetDocumentApproverSpecialityFieldValue: String;
begin

  Result := FDocumentApprovingsInfoHolder.DocumentApproverSpecialityFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetDocumentApprovingIsAccessibleFieldValue: Boolean;
begin

  Result := FDocumentApprovingsInfoHolder.DocumentApprovingIsAccessibleFieldValue;
    
end;

function TDocumentFullInfoDataSetHolder.GetDocumentApprovingCycleIdFieldValue: Variant;
begin

  Result := FDocumentApprovingsInfoHolder.DocumentApprovingCycleIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentApprovingCycleNumberFieldValue: Variant;
begin

  Result := FDocumentApprovingsInfoHolder.DocumentApprovingCycleNumberFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetDocumentApprovingIdFieldValue: Variant;
begin

  Result := FDocumentApprovingsInfoHolder.DocumentApprovingIdFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetDocumentApprovingIsCompletedFieldValue: Boolean;
begin

  Result := FDocumentApprovingsInfoHolder.DocumentApprovingIsCompletedFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetDocumentApprovingIsLookedByApproverFieldValue: Boolean;
begin

  Result := FDocumentApprovingsInfoHolder.DocumentApprovingIsLookedByApproverFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetDocumentApprovingNoteFieldValue: String;
begin

  Result := FDocumentApprovingsInfoHolder.DocumentApprovingNoteFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetDocumentApprovingPerformingDateTimeFieldValue: Variant;
begin

  Result := FDocumentApprovingsInfoHolder.DocumentApprovingPerformingDateTimeFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetDocumentApprovingPerformingResultFieldValue: String;
begin

  Result := FDocumentApprovingsInfoHolder.DocumentApprovingPerformingResultFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentApprovingPerformingResultIdFieldValue: Variant;
begin

  Result := FDocumentApprovingsInfoHolder.DocumentApprovingPerformingResultIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentAuthorDepartmentCodeFieldValue: String;
begin

  Result := FDocumentInfoHolder.AuthorDepartmentCodeFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentAuthorDepartmentIdFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.AuthorDepartmentIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentAuthorDepartmentNameFieldValue: String;
begin

  Result := FDocumentInfoHolder.AuthorDepartmentNameFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentAuthorIdFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.AuthorIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentAuthorLeaderIdFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.AuthorLeaderIdFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetDocumentAuthorNameFieldValue: String;
begin

  Result := FDocumentInfoHolder.AuthorNameFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentAuthorSpecialityFieldValue: String;
begin

  Result := FDocumentInfoHolder.AuthorSpecialityFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetDocumentChargeActualPerformerDepartmentCodeFieldValue: String;
begin

  Result := FDocumentChargesInfoHolder.DocumentChargeActualPerformerDepartmentCodeFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentChargeActualPerformerDepartmentIdFieldValue: Variant;
begin

  Result := FDocumentChargesInfoHolder.DocumentChargeActualPerformerDepartmentIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentChargeActualPerformerDepartmentNameFieldValue: String;
begin

  Result := FDocumentChargesInfoHolder.DocumentChargeActualPerformerDepartmentNameFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentChargeActualPerformerIdFieldValue: Variant;
begin

  Result := FDocumentChargesInfoHolder.DocumentChargeActualPerformerIdFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentChargeActualPerformerIsForeignFieldValue: Boolean;
begin

  Result := FDocumentChargesInfoHolder.DocumentChargeActualPerformerIsForeignFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetDocumentChargeActualPerformerLeaderIdFieldValue: Variant;
begin

  Result := FDocumentChargesInfoHolder.DocumentChargeActualPerformerLeaderIdFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetDocumentChargeActualPerformerNameFieldValue: String;
begin

  Result := FDocumentChargesInfoHolder.DocumentChargeActualPerformerNameFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentChargeActualPerformerSpecialityFieldValue: String;
begin

  Result := FDocumentChargesInfoHolder.DocumentChargeActualPerformerSpecialityFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentChargeIdFieldValue: Variant;
begin

  Result := FDocumentChargesInfoHolder.DocumentChargeIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentChargeIsForAcquaitanceFieldValue: Boolean;
begin

  Result := FDocumentChargesInfoHolder.DocumentChargeIsForAcquaitanceFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentChargePerformerDepartmentCodeFieldValue: String;
begin

  Result := FDocumentChargesInfoHolder.DocumentChargePerformerDepartmentCodeFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentChargePerformerDepartmentIdFieldValue: Variant;
begin

  Result := FDocumentChargesInfoHolder.DocumentChargePerformerDepartmentIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentChargePerformerDepartmentNameFieldValue: String;
begin

  Result := FDocumentChargesInfoHolder.DocumentChargePerformerDepartmentNameFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentChargePerformerIdFieldValue: Variant;
begin

  Result := FDocumentChargesInfoHolder.DocumentChargePerformerIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentChargePerformerIsForeignFieldValue: Boolean;
begin

  Result := FDocumentChargesInfoHolder.DocumentChargePerformerIsForeignFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetDocumentChargePerformerLeaderIdFieldValue: Variant;
begin

  Result := FDocumentChargesInfoHolder.DocumentChargePerformerLeaderIdFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetDocumentChargePerformerNameFieldValue: String;
begin

  Result := FDocumentChargesInfoHolder.DocumentChargePerformerNameFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentChargePerformerSpecialityFieldValue: String;
begin

  Result := FDocumentChargesInfoHolder.DocumentChargePerformerSpecialityFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentChargePerformingDateTimeFieldValue: Variant;
begin

  Result := FDocumentChargesInfoHolder.DocumentChargePerformingDateTimeFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentChargePeriodEndFieldValue: Variant;
begin

  Result := FDocumentChargesInfoHolder.DocumentChargePeriodEndFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentChargePeriodStartFieldValue: Variant;
begin

  Result := FDocumentChargesInfoHolder.DocumentChargePeriodStartFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentChargeResponseFieldValue: String;
begin

  Result := FDocumentChargesInfoHolder.DocumentChargeResponseFieldValue;

end;

function TDocumentFullInfoDataSetHolder.
  GetDocumentChargeSheetActualPerformerDepartmentCodeFieldValue: String;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetActualPerformerDepartmentCodeFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.
  GetDocumentChargeSheetActualPerformerDepartmentIdFieldValue: Variant;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetActualPerformerDepartmentIdFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.
  GetDocumentChargeSheetActualPerformerDepartmentNameFieldValue: String;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetActualPerformerDepartmentNameFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.
  GetDocumentChargeSheetActualPerformerIdFieldValue: Variant;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetActualPerformerIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentChargeSheetActualPerformerIsForeignFieldValue: Boolean;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetActualPerformerIsForeignFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentChargeSheetActualPerformerLeaderIdFieldValue: Variant;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetActualPerformerLeaderIdFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.
  GetDocumentChargeSheetActualPerformerNameFieldValue: String;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetActualPerformerNameFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.
  GetDocumentChargeSheetActualPerformerSpecialityFieldValue: String;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetActualPerformerSpecialityFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetDocumentChargeSheetIdFieldValue: Variant;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetIdFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentChargeSheetIsForAcquaitanceFieldValue: Boolean;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetIsForAcquaitanceFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentChargeSheetViewingDateByPerformerFieldValue: Variant;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetViewingDateByPerformerFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.
  GetDocumentChargeSheetIssuingDateTimeFieldValue: Variant;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetIssuingDateTimeFieldValue;
    
end;

function TDocumentFullInfoDataSetHolder.
  GetDocumentChargeSheetPerformerDepartmentCodeFieldValue: String;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetPerformerDepartmentCodeFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.
  GetDocumentChargeSheetPerformerDepartmentIdFieldValue: Variant;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetPerformerDepartmentIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.
  GetDocumentChargeSheetPerformerDepartmentNameFieldValue: String;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetPerformerDepartmentNameFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.
  GetDocumentChargeSheetPerformerIdFieldValue: Variant;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetPerformerIdFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetDocumentChargeSheetPerformerIsForeignFieldValue: Boolean;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetPerformerIsForeignFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetDocumentChargeSheetPerformerLeaderIdFieldValue: Variant;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetPerformerLeaderIdFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.
  GetDocumentChargeSheetPerformerNameFieldValue: String;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetPerformerNameFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentChargeSheetPerformerRoleIdFieldValue: Variant;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetPerformerRoleIdFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.
  GetDocumentChargeSheetPerformerSpecialityFieldValue: String;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetPerformerSpecialityFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.
  GetDocumentChargeSheetPerformingDateTimeFieldValue: Variant;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetPerformingDateTimeFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.
  GetDocumentChargeSheetPeriodEndFieldValue: Variant;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetPeriodEndFieldValue;

end;

function TDocumentFullInfoDataSetHolder.
  GetDocumentChargeSheetPeriodStartFieldValue: Variant;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetPeriodStartFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.
  GetDocumentChargeSheetResponseFieldValue: String;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetResponseFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.
  GetDocumentChargeSheetSenderDepartmentCodeFieldValue: String;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetSenderDepartmentCodeFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.
  GetDocumentChargeSheetSenderDepartmentIdFieldValue: Variant;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetSenderDepartmentIdFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.
  GetDocumentChargeSheetSenderDepartmentNameFieldValue: String;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetSenderDepartmentNameFieldValue;

end;

function TDocumentFullInfoDataSetHolder.
  GetDocumentChargeSheetSenderIdFieldValue: Variant;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetSenderIdFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetDocumentChargeSheetSenderIsForeignFieldValue: Boolean;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetSenderIsForeignFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentChargeSheetSenderLeaderIdFieldValue: Variant;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetSenderLeaderIdFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.
  GetDocumentChargeSheetSenderNameFieldValue: String;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetSenderNameFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.
  GetDocumentChargeSheetSenderSpecialityFieldValue: String;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetSenderSpecialityFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.
  GetDocumentChargeSheetTextFieldValue: String;
begin

  Result := FDocumentChargeSheetsInfoHolder.DocumentChargeSheetTextFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetDocumentChargeTextFieldValue: String;
begin

  Result := FDocumentChargesInfoHolder.DocumentChargeTextFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentContentFieldName: String;
begin

  Result := FDocumentInfoHolder.ContentFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentCreationDateFieldValue: TDateTime;
begin

  Result := FDocumentInfoHolder.CreationDateFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentCurrentWorkCycleStageNameFieldValue: String;
begin

  Result := FDocumentInfoHolder.CurrentWorkCycleStageNameFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentCurrentWorkCycleStageNumberFieldValue: Integer;
begin

  Result := FDocumentInfoHolder.CurrentWorkCycleStageNumberFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentDateFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.DateFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentFileIdFieldValue: Variant;
begin

  Result := FDocumentFilesInfoHolder.DocumentFileIdFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentFileNameFieldValue: String;
begin

  Result := FDocumentFilesInfoHolder.DocumentFileNameFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentFilePathFieldValue: String;
begin

  Result := FDocumentFilesInfoHolder.DocumentFilePathFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentIdFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.IdFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentIsSelfRegisteredFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.IsSelfRegisteredFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentKindFieldValue: String;
begin

  Result := FDocumentInfoHolder.KindFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentKindIdFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.KindIdFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetDocumentNameFieldValue: String;
begin

  Result := FDocumentInfoHolder.NameFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentNoteFieldValue: String;
begin

  Result := FDocumentInfoHolder.NoteFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentNumberFieldValue: String;
begin

  Result := FDocumentInfoHolder.NumberFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentProductCodeFieldValue: String;
begin

  Result := FDocumentInfoHolder.ProductCodeFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentRelationIdFieldValue: Variant;
begin

  Result := FDocumentRelationsInfoHolder.DocumentRelationIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentResponsibleDepartmentCodeFieldValue: String;
begin

  Result := FDocumentInfoHolder.ResponsibleDepartmentCodeFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentResponsibleDepartmentIdFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.ResponsibleDepartmentIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentResponsibleDepartmentNameFieldValue: String;
begin

  Result := FDocumentInfoHolder.ResponsibleDepartmentNameFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentResponsibleIdFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.ResponsibleIdFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentResponsibleNameFieldValue: String;
begin

  Result := FDocumentInfoHolder.ResponsibleNameFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentResponsibleTelephoneNumberFieldValue: String;
begin

  Result := FDocumentInfoHolder.ResponsibleTelephoneNumberFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentSignerDepartmentCodeFieldValue: String;
begin

  Result := FDocumentInfoHolder.SignerDepartmentCodeFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentSignerDepartmentIdFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.SignerDepartmentIdFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentSignerDepartmentNameFieldValue: String;
begin

  Result := FDocumentInfoHolder.SignerDepartmentNameFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentSignerIdFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.SignerIdFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentSignerLeaderIdFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.SignerLeaderIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentSignerNameFieldValue: String;
begin

  Result := FDocumentInfoHolder.SignerNameFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentSignerSpecialityFieldValue: String;
begin

  Result := FDocumentInfoHolder.SignerSpecialityFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDocumentSigningDateFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.SigningDateFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetDocumentSigningIdFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.SigningIdFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetFieldNames: TDocumentFullInfoDataSetFieldNames;
begin

  Result := TDocumentFullInfoDataSetFieldNames(inherited FieldDefs);
  
end;

function TDocumentFullInfoDataSetHolder.GetRelatedDocumentDateFieldValue: TDateTime;
begin

  Result := FDocumentRelationsInfoHolder.RelatedDocumentDateFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetRelatedDocumentIdFieldValue: Variant;
begin

  Result := FDocumentRelationsInfoHolder.RelatedDocumentIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetRelatedDocumentKindIdFieldValue: Variant;
begin

  Result := FDocumentRelationsInfoHolder.RelatedDocumentKindIdFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetRelatedDocumentKindNameFieldValue: String;
begin

  Result := FDocumentRelationsInfoHolder.RelatedDocumentKindNameFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetRelatedDocumentNameFieldValue: String;
begin

  Result := FDocumentRelationsInfoHolder.RelatedDocumentNameFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetRelatedDocumentNumberFieldValue: String;
begin

  Result := FDocumentRelationsInfoHolder.RelatedDocumentNumberFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetTopLevelChargeSheetIdFieldValue: Variant;
begin

  Result := FDocumentChargeSheetsInfoHolder.TopLevelChargeSheetIdFieldValue;

end;

procedure TDocumentFullInfoDataSetHolder.Initialize;
begin

  inherited Initialize;

  FDocumentInfoHolder := CreateDocumentInfoHolder;
  FDocumentApprovingsInfoHolder := CreateDocumentApprovingsInfoHolder;
  FDocumentChargesInfoHolder := CreateDocumentChargesInfoHolder;
  FDocumentChargeSheetsInfoHolder := CreateDocumentChargeSheetsInfoHolder;
  FDocumentRelationsInfoHolder := CreateDocumentRelationsInfoHolder;
  FDocumentFilesInfoHolder := CreateDocumentFilesInfoHolder;
  
end;

procedure TDocumentFullInfoDataSetHolder.SetDataSet(const Value: TDataSet);
begin

  inherited;

  if Assigned(FDocumentInfoHolder) then
    FDocumentInfoHolder.DataSet := Value;

  if Assigned(FDocumentApprovingsInfoHolder) then
    FDocumentApprovingsInfoHolder.DataSet := Value;

  if Assigned(FDocumentChargesInfoHolder) then
    FDocumentChargesInfoHolder.DataSet := Value;

  if Assigned(FDocumentChargeSheetsInfoHolder) then
    FDocumentChargeSheetsInfoHolder.DataSet := Value;

  if Assigned(FDocumentRelationsInfoHolder) then
    FDocumentRelationsInfoHolder.DataSet := Value;

  if Assigned(FDocumentFilesInfoHolder) then
    FDocumentFilesInfoHolder.DataSet := Value;
    
end;

procedure TDocumentFullInfoDataSetHolder.SetDocumentApprovingsInfoHolder(
  const Value: TDocumentApprovingsInfoHolder);
begin

  FDocumentApprovingsInfoHolder := Value;
  FFreeDocumentApprovingsInfoHolder := Value;

  UpdateDataSet(Value);
  
end;

procedure TDocumentFullInfoDataSetHolder.SetDocumentChargeSheetsInfoHolder(
  const Value: TDocumentChargeSheetsInfoHolder);
begin

  FDocumentChargeSheetsInfoHolder := Value;
  FFreeDocumentChargeSheetsInfoHolder := Value;

  UpdateDataSet(Value);

end;

procedure TDocumentFullInfoDataSetHolder.SetDocumentChargesInfoHolder(
  const Value: TDocumentChargesInfoHolder);
begin

  FDocumentChargesInfoHolder := Value;
  FFreeDocumentChargesInfoHolder := Value;

  UpdateDataSet(Value);
  
end;

procedure TDocumentFullInfoDataSetHolder.SetDocumentFilesInfoHolder(
  const Value: TDocumentFilesInfoHolder);
begin

  FDocumentFilesInfoHolder := Value;
  FFreeDocumentFilesInfoHolder := Value;

  UpdateDataSet(Value);

end;

procedure TDocumentFullInfoDataSetHolder.SetDocumentInfoHolder(
  const Value: TDocumentInfoHolder);
begin

  FDocumentInfoHolder := Value;
  FFreeDocumentInfoHolder := Value;

  UpdateDataSet(Value);
  
end;

procedure TDocumentFullInfoDataSetHolder.SetDocumentRelationsInfoHolder(
  const Value: TDocumentRelationsInfoHolder);
begin

  FDocumentRelationsInfoHolder := Value;
  FFreeDocumentRelationsInfoHolder := FDocumentRelationsInfoHolder;

  UpdateDataSet(Value);

end;

procedure TDocumentFullInfoDataSetHolder.SetFieldNames(
  const Value: TDocumentFullInfoDataSetFieldNames);
begin

  inherited FieldDefs := Value;
  
end;

procedure TDocumentFullInfoDataSetHolder.UpdateDataSet(
  Holder: TAbstractDataSetHolder);
begin

  if DataSet = Holder.DataSet then Exit;

  if not Assigned(DataSet) then
    DataSet := Holder.DataSet

  else Holder.DataSet := DataSet;
  
end;

{ TDocumentFullInfoDataSetFieldNames }

function TDocumentFullInfoDataSetFieldNames.GetBaseDocumentIdFieldName: String;
begin

  Result := FDocumentInfoFieldNames.BaseIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetChargeSheetDocumentIdFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.ChargeSheetDocumentIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentActualApproverDepartmentCodeFieldName: String;
begin

  Result := FDocumentApprovingsInfoFieldNames.DocumentActualApproverDepartmentCodeFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentActualApproverDepartmentIdFieldName: String;
begin

  Result := FDocumentApprovingsInfoFieldNames.DocumentActualApproverDepartmentIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentActualApproverDepartmentNameFieldName: String;
begin

  Result := FDocumentApprovingsInfoFieldNames.DocumentActualApproverDepartmentNameFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentActualApproverIdFieldName: String;
begin

  Result := FDocumentApprovingsInfoFieldNames.DocumentActualApproverIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentActualApproverIsForeignFieldName: String;
begin

  Result := FDocumentApprovingsInfoFieldNames.DocumentActualApproverIsForeignFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentActualApproverLeaderIdFieldName: String;
begin

  Result := FDocumentApprovingsInfoFieldNames.DocumentActualApproverLeaderIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentActualApproverNameFieldName: String;
begin

  Result := FDocumentApprovingsInfoFieldNames.DocumentActualApproverNameFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentActualApproverSpecialityFieldName: String;
begin

  Result := FDocumentApprovingsInfoFieldNames.DocumentActualApproverSpecialityFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentActualSignerDepartmentCodeFieldName: String;
begin

  Result := FDocumentInfoFieldNames.ActualSignerDepartmentCodeFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentActualSignerDepartmentIdFieldName: String;
begin

  Result := FDocumentInfoFieldNames.ActualSignerDepartmentIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentActualSignerDepartmentNameFieldName: String;
begin

  Result := FDocumentInfoFieldNames.ActualSignerDepartmentNameFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentActualSignerIdFieldName: String;
begin

  Result := FDocumentInfoFieldNames.ActualSignerIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentActualSignerLeaderIdFieldName: String;
begin

  Result := FDocumentInfoFieldNames.ActualSignerLeaderIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentActualSignerNameFieldName: String;
begin

  Result := FDocumentInfoFieldNames.ActualSignerNameFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentActualSignerSpecialityFieldName: String;
begin

  Result := FDocumentInfoFieldNames.ActualSignerSpecialityFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentApproverDepartmentCodeFieldName: String;
begin

  Result := FDocumentApprovingsInfoFieldNames.DocumentApproverDepartmentCodeFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentApproverDepartmentIdFieldName: String;
begin

  Result := FDocumentApprovingsInfoFieldNames.DocumentApproverDepartmentIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentApproverDepartmentNameFieldName: String;
begin

  Result := FDocumentApprovingsInfoFieldNames.DocumentApproverDepartmentNameFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentApproverIdFieldName: String;
begin

  Result := FDocumentApprovingsInfoFieldNames.DocumentApproverIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentApproverIsForeignFieldName: String;
begin

  Result := FDocumentApprovingsInfoFieldNames.DocumentApproverIsForeignFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentApproverLeaderIdFieldName: String;
begin

  Result := FDocumentApprovingsInfoFieldNames.DocumentApproverLeaderIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentApproverNameFieldName: String;
begin

  Result := FDocumentApprovingsInfoFieldNames.DocumentApproverNameFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentApproverSpecialityFieldName: String;
begin

  Result := FDocumentApprovingsInfoFieldNames.DocumentApproverSpecialityFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentApprovingCycleIdFieldName: String;
begin

  Result := FDocumentApprovingsInfoFieldNames.DocumentApprovingCycleIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentApprovingCycleNumberFieldName: String;
begin

  Result := FDocumentApprovingsInfoFieldNames.DocumentApprovingCycleNumberFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentApprovingIdFieldName: String;
begin

  Result := FDocumentApprovingsInfoFieldNames.DocumentApprovingIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentApprovingIsAccessibleFieldName: String;
begin

  Result := FDocumentApprovingsInfoFieldNames.DocumentApprovingIsAccessibleFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentApprovingIsCompletedFieldName: String;
begin

  Result := FDocumentApprovingsInfoFieldNames.DocumentApprovingIsCompletedFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentApprovingIsLookedByApproverFieldName: String;
begin

  Result := FDocumentApprovingsInfoFieldNames.DocumentApprovingIsLookedByApproverFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentApprovingNoteFieldName: String;
begin

  Result := FDocumentApprovingsInfoFieldNames.DocumentApprovingNoteFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentApprovingPerformingDateTimeFieldName: String;
begin

  Result := FDocumentApprovingsInfoFieldNames.DocumentApprovingPerformingDateTimeFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentApprovingPerformingResultFieldName: String;
begin

  Result := FDocumentApprovingsInfoFieldNames.DocumentApprovingPerformingResultFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentApprovingPerformingResultIdFieldName: String;
begin

  Result := FDocumentApprovingsInfoFieldNames.DocumentApprovingPerformingResultIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentAuthorDepartmentCodeFieldName: String;
begin

  Result := FDocumentInfoFieldNames.AuthorDepartmentCodeFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentAuthorDepartmentIdFieldName: String;
begin

  Result := FDocumentInfoFieldNames.AuthorDepartmentIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentAuthorDepartmentNameFieldName: String;
begin

  Result := FDocumentInfoFieldNames.AuthorDepartmentNameFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentAuthorIdFieldName: String;
begin

  Result := FDocumentInfoFieldNames.AuthorIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentAuthorLeaderIdFieldName: String;
begin

  Result := FDocumentInfoFieldNames.AuthorLeaderIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentAuthorNameFieldName: String;
begin

  Result := FDocumentInfoFieldNames.AuthorNameFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentAuthorSpecialityFieldName: String;
begin

  Result := FDocumentInfoFieldNames.AuthorSpecialityFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeActualPerformerDepartmentCodeFieldName: String;
begin

  Result := FDocumentChargesInfoFieldNames.DocumentChargeActualPerformerDepartmentCodeFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeActualPerformerDepartmentIdFieldName: String;
begin

  Result := FDocumentChargesInfoFieldNames.DocumentChargeActualPerformerDepartmentIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeActualPerformerDepartmentNameFieldName: String;
begin

  Result := FDocumentChargesInfoFieldNames.DocumentChargeActualPerformerDepartmentNameFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeActualPerformerIdFieldName: String;
begin

  Result := FDocumentChargesInfoFieldNames.DocumentChargeActualPerformerIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeActualPerformerIsForeignFieldName: String;
begin

  Result := FDocumentChargesInfoFieldNames.DocumentChargeActualPerformerIsForeignFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeActualPerformerLeaderIdFieldName: String;
begin

  Result := FDocumentChargesInfoFieldNames.DocumentChargeActualPerformerLeaderIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeActualPerformerNameFieldName: String;
begin

  Result := FDocumentChargesInfoFieldNames.DocumentChargeActualPerformerNameFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeActualPerformerSpecialityFieldName: String;
begin

  Result := FDocumentChargesInfoFieldNames.DocumentChargeActualPerformerSpecialityFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeIdFieldName: String;
begin

  Result := FDocumentChargesInfoFieldNames.DocumentChargeIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeIsForAcquaitanceFieldName: String;
begin

  Result := FDocumentChargesInfoFieldNames.DocumentChargeIsForAcquaitanceFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargePerformerDepartmentCodeFieldName: String;
begin

  Result := FDocumentChargesInfoFieldNames.DocumentChargePerformerDepartmentCodeFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargePerformerDepartmentIdFieldName: String;
begin

  Result := FDocumentChargesInfoFieldNames.DocumentChargePerformerDepartmentIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargePerformerDepartmentNameFieldName: String;
begin

  Result := FDocumentChargesInfoFieldNames.DocumentChargePerformerDepartmentNameFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargePerformerIdFieldName: String;
begin

  Result := FDocumentChargesInfoFieldNames.DocumentChargePerformerIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargePerformerIsForeignFieldName: String;
begin

  Result := FDocumentChargesInfoFieldNames.DocumentChargePerformerIsForeignFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargePerformerLeaderIdFieldName: String;
begin

  Result := FDocumentChargesInfoFieldNames.DocumentChargePerformerLeaderIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargePerformerNameFieldName: String;
begin

  Result := FDocumentChargesInfoFieldNames.DocumentChargePerformerNameFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargePerformerSpecialityFieldName: String;
begin

  Result := FDocumentChargesInfoFieldNames.DocumentChargePerformerSpecialityFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargePerformingDateTimeFieldName: String;
begin

  Result := FDocumentChargesInfoFieldNames.DocumentChargePerformingDateTimeFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargePeriodEndFieldName: String;
begin

  Result := FDocumentChargesInfoFieldNames.DocumentChargePeriodEndFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargePeriodStartFieldName: String;
begin

  Result := FDocumentChargesInfoFieldNames.DocumentChargePeriodStartFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeResponseFieldName: String;
begin

  Result := FDocumentChargesInfoFieldNames.DocumentChargeResponseFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetActualPerformerDepartmentCodeFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetActualPerformerDepartmentCodeFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetActualPerformerDepartmentIdFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetActualPerformerDepartmentIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetActualPerformerDepartmentNameFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetActualPerformerDepartmentNameFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetActualPerformerIdFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetActualPerformerIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetActualPerformerIsForeignFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetActualPerformerIsForeignFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetActualPerformerLeaderIdFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetActualPerformerLeaderIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetActualPerformerNameFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetActualPerformerNameFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetActualPerformerSpecialityFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetActualPerformerSpecialityFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetIdFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetIsForAcquaitanceFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetIsForAcquaitanceFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetIssuingDateTimeFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetIssuingDateTimeFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetPerformerDepartmentCodeFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetPerformerDepartmentCodeFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetPerformerDepartmentIdFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetPerformerDepartmentIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetPerformerDepartmentNameFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetPerformerDepartmentNameFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetPerformerIdFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetPerformerIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetPerformerIsForeignFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetPerformerIsForeignFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetPerformerLeaderIdFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetPerformerLeaderIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetPerformerNameFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetPerformerNameFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetPerformerRoleIdFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetPerformerRoleIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetPerformerSpecialityFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetPerformerSpecialityFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetPerformingDateTimeFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetPerformingDateTimeFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetPeriodEndFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetPeriodEndFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetPeriodStartFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetPeriodStartFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetResponseFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetResponseFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetSenderDepartmentCodeFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetSenderDepartmentCodeFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetSenderDepartmentIdFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetSenderDepartmentIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetSenderDepartmentNameFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetSenderDepartmentNameFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetSenderIdFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetSenderIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetSenderIsForeignFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetSenderIsForeignFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetSenderLeaderIdFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetSenderLeaderIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetSenderNameFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetSenderNameFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetSenderSpecialityFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetSenderSpecialityFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetTextFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetTextFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeSheetViewingDateByPerformerFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetViewingDateByPerformerFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentChargeTextFieldName: String;
begin

  Result := FDocumentChargesInfoFieldNames.DocumentChargeTextFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentContentFieldName: String;
begin

  Result := FDocumentInfoFieldNames.ContentFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentCreationDateFieldName: String;
begin

  Result := FDocumentInfoFieldNames.CreationDateFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentCurrentWorkCycleStageNameFieldName: String;
begin

  Result := FDocumentInfoFieldNames.CurrentWorkCycleStageNameFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentCurrentWorkCycleStageNumberFieldName: String;
begin

  Result := FDocumentInfoFieldNames.CurrentWorkCycleStageNumberFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentDateFieldName: String;
begin

  Result := FDocumentInfoFieldNames.DateFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentFileIdFieldName: String;
begin

  Result := FDocumentFilesInfoFieldNames.DocumentFileIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentFileNameFieldName: String;
begin

  Result := FDocumentFilesInfoFieldNames.DocumentFileNameFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentFilePathFieldName: String;
begin

  Result := FDocumentFilesInfoFieldNames.DocumentFilePathFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentIdFieldName: String;
begin

  Result := FDocumentInfoFieldNames.IdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentIsSelfRegisteredFieldName: String;
begin

  Result := FDocumentInfoFieldNames.IsSelfRegisteredFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentKindFieldName: String;
begin

  Result := FDocumentInfoFieldNames.KindFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentKindIdFieldName: String;
begin

  Result := FDocumentInfoFieldNames.KindIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentNameFieldName: String;
begin

  Result := FDocumentInfoFieldNames.NameFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentNoteFieldName: String;
begin

  Result := FDocumentInfoFieldNames.NoteFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentNumberFieldName: String;
begin

  Result := FDocumentInfoFieldNames.NumberFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentProductCodeFieldName: String;
begin

  Result := FDocumentInfoFieldNames.ProductCodeFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentRelationIdFieldName: String;
begin

  Result := FDocumentRelationsInfoFieldNames.DocumentRelationIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentResponsibleDepartmentCodeFieldName: String;
begin

  Result := FDocumentInfoFieldNames.ResponsibleDepartmentCodeFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentResponsibleDepartmentIdFieldName: String;
begin

  Result := FDocumentInfoFieldNames.ResponsibleDepartmentIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentResponsibleDepartmentNameFieldName: String;
begin

  Result := FDocumentInfoFieldNames.ResponsibleDepartmentNameFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentResponsibleIdFieldName: String;
begin

  Result := FDocumentInfoFieldNames.ResponsibleIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentResponsibleNameFieldName: String;
begin

  Result := FDocumentInfoFieldNames.ResponsibleNameFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentResponsibleTelephoneNumberFieldName: String;
begin

  Result := FDocumentInfoFieldNames.ResponsibleTelephoneNumberFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentSignerDepartmentCodeFieldName: String;
begin

  Result := FDocumentInfoFieldNames.SignerDepartmentCodeFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentSignerDepartmentIdFieldName: String;
begin

  Result := FDocumentInfoFieldNames.SignerDepartmentIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentSignerDepartmentNameFieldName: String;
begin

  Result := FDocumentInfoFieldNames.SignerDepartmentNameFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentSignerIdFieldName: String;
begin

  Result := FDocumentInfoFieldNames.SignerIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentSignerLeaderIdFieldName: String;
begin

  Result := FDocumentInfoFieldNames.SignerLeaderIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentSignerNameFieldName: String;
begin

  Result := FDocumentInfoFieldNames.SignerNameFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentSignerSpecialityFieldName: String;
begin

  Result := FDocumentInfoFieldNames.SignerSpecialityFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentSigningDateFieldName: String;
begin

  Result := FDocumentInfoFieldNames.SigningDateFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDocumentSigningIdFieldName: String;
begin

  Result := FDocumentInfoFieldNames.SigningIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetRelatedDocumentDateFieldName: String;
begin

  Result := FDocumentRelationsInfoFieldNames.RelatedDocumentDateFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetRelatedDocumentIdFieldName: String;
begin

  Result := FDocumentRelationsInfoFieldNames.RelatedDocumentIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetRelatedDocumentKindIdFieldName: String;
begin

  Result := FDocumentRelationsInfoFieldNames.RelatedDocumentKindIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetRelatedDocumentKindNameFieldName: String;
begin

  Result := FDocumentRelationsInfoFieldNames.RelatedDocumentKindNameFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetRelatedDocumentNameFieldName: String;
begin

  Result := FDocumentRelationsInfoFieldNames.RelatedDocumentNameFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetRelatedDocumentNumberFieldName: String;
begin

  Result := FDocumentRelationsInfoFieldNames.RelatedDocumentNumberFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetTopLevelDocumentChargeSheetIdFieldName: String;
begin

  Result := FDocumentChargeSheetsInfoFieldNames.TopLevelDocumentChargeSheetIdFieldName;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetBaseDocumentIdFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.BaseIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeSheetDocumentIdFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.ChargeSheetDocumentIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentActualApproverDepartmentCodeFieldName(
  const Value: String);
begin

  FDocumentApprovingsInfoFieldNames.DocumentActualApproverDepartmentCodeFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentActualApproverDepartmentIdFieldName(
  const Value: String);
begin

  FDocumentApprovingsInfoFieldNames.DocumentActualApproverDepartmentIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentActualApproverDepartmentNameFieldName(
  const Value: String);
begin

  FDocumentApprovingsInfoFieldNames.DocumentActualApproverDepartmentNameFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentActualApproverIdFieldName(
  const Value: String);
begin

  FDocumentApprovingsInfoFieldNames.DocumentActualApproverIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentActualApproverIsForeignFieldName(
  const Value: String);
begin

  FDocumentApprovingsInfoFieldNames.DocumentActualApproverIsForeignFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentActualApproverLeaderIdFieldName(
  const Value: String);
begin

  FDocumentApprovingsInfoFieldNames.DocumentActualApproverLeaderIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentActualApproverNameFieldName(
  const Value: String);
begin

  FDocumentApprovingsInfoFieldNames.DocumentActualApproverNameFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentActualApproverSpecialityFieldName(
  const Value: String);
begin

  FDocumentApprovingsInfoFieldNames.DocumentActualApproverSpecialityFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentActualSignerDepartmentCodeFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.ActualSignerDepartmentCodeFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentActualSignerDepartmentIdFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.ActualSignerDepartmentIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentActualSignerDepartmentNameFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.ActualSignerDepartmentNameFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentActualSignerIdFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.ActualSignerIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentActualSignerLeaderIdFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.ActualSignerLeaderIdFieldName := Value;
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentActualSignerNameFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.ActualSignerNameFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentActualSignerSpecialityFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.ActualSignerSpecialityFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentApproverDepartmentCodeFieldName(
  const Value: String);
begin

  FDocumentApprovingsInfoFieldNames.DocumentApproverDepartmentCodeFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentApproverDepartmentIdFieldName(
  const Value: String);
begin

  FDocumentApprovingsInfoFieldNames.DocumentApproverDepartmentIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentApproverDepartmentNameFieldName(
  const Value: String);
begin

  FDocumentApprovingsInfoFieldNames.DocumentApproverDepartmentNameFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentApproverIdFieldName(
  const Value: String);
begin

  FDocumentApprovingsInfoFieldNames.DocumentApproverIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentApproverIsForeignFieldName(
  const Value: String);
begin

  FDocumentApprovingsInfoFieldNames.DocumentApproverIsForeignFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentApproverLeaderIdFieldName(
  const Value: String);
begin

  FDocumentApprovingsInfoFieldNames.DocumentApproverLeaderIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentApproverNameFieldName(
  const Value: String);
begin

  FDocumentApprovingsInfoFieldNames.DocumentApproverNameFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentApproverSpecialityFieldName(
  const Value: String);
begin

  FDocumentApprovingsInfoFieldNames.DocumentApproverSpecialityFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentApprovingCycleIdFieldName(
  const Value: String);
begin

  FDocumentApprovingsInfoFieldNames.DocumentApprovingCycleIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentApprovingCycleNumberFieldName(
  const Value: String);
begin

  FDocumentApprovingsInfoFieldNames.DocumentApprovingCycleNumberFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentApprovingIdFieldName(
  const Value: String);
begin

  FDocumentApprovingsInfoFieldNames.DocumentApprovingIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentApprovingIsAccessibleFieldName(
  const Value: String);
begin

  FDocumentApprovingsInfoFieldNames.DocumentApprovingIsAccessibleFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentApprovingIsCompletedFieldName(
  const Value: String);
begin

  FDocumentApprovingsInfoFieldNames.DocumentApprovingIsCompletedFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentApprovingIsLookedByApproverFieldName(
  const Value: String);
begin

  FDocumentApprovingsInfoFieldNames.DocumentApprovingIsLookedByApproverFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentApprovingNoteFieldName(
  const Value: String);
begin

  FDocumentApprovingsInfoFieldNames.DocumentApprovingNoteFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentApprovingPerformingDateTimeFieldName(
  const Value: String);
begin

  FDocumentApprovingsInfoFieldNames.DocumentApprovingPerformingDateTimeFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentApprovingPerformingResultFieldName(
  const Value: String);
begin

  FDocumentApprovingsInfoFieldNames.DocumentApprovingPerformingResultFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentApprovingPerformingResultIdFieldName(
  const Value: String);
begin

  FDocumentApprovingsInfoFieldNames.DocumentApprovingPerformingResultIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentAuthorDepartmentCodeFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.AuthorDepartmentCodeFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentAuthorDepartmentIdFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.AuthorDepartmentIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentAuthorDepartmentNameFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.AuthorDepartmentNameFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentAuthorIdFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.AuthorIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentAuthorLeaderIdFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.AuthorLeaderIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentAuthorNameFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.AuthorNameFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentAuthorSpecialityFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.AuthorSpecialityFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeActualPerformerDepartmentCodeFieldName(
  const Value: String);
begin

  FDocumentChargesInfoFieldNames.DocumentChargeActualPerformerDepartmentCodeFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeActualPerformerDepartmentIdFieldName(
  const Value: String);
begin

  FDocumentChargesInfoFieldNames.DocumentChargeActualPerformerDepartmentIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeActualPerformerDepartmentNameFieldName(
  const Value: String);
begin

  FDocumentChargesInfoFieldNames.DocumentChargeActualPerformerDepartmentNameFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeActualPerformerIdFieldName(
  const Value: String);
begin

  FDocumentChargesInfoFieldNames.DocumentChargeActualPerformerIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeActualPerformerIsForeignFieldName(
  const Value: String);
begin

  FDocumentChargesInfoFieldNames.DocumentChargeActualPerformerIsForeignFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeActualPerformerLeaderIdFieldName(
  const Value: String);
begin

  FDocumentChargesInfoFieldNames.DocumentChargeActualPerformerLeaderIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeActualPerformerNameFieldName(
  const Value: String);
begin

  FDocumentChargesInfoFieldNames.DocumentChargeActualPerformerNameFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeActualPerformerSpecialityFieldName(
  const Value: String);
begin

  FDocumentChargesInfoFieldNames.DocumentChargeActualPerformerSpecialityFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeIdFieldName(
  const Value: String);
begin

  FDocumentChargesInfoFieldNames.DocumentChargeIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeIsForAcquaitanceFieldName(
  const Value: String);
begin

  FDocumentChargesInfoFieldNames.DocumentChargeIsForAcquaitanceFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargePerformerDepartmentCodeFieldName(
  const Value: String);
begin

  FDocumentChargesInfoFieldNames.DocumentChargePerformerDepartmentCodeFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargePerformerDepartmentIdFieldName(
  const Value: String);
begin

  FDocumentChargesInfoFieldNames.DocumentChargePerformerDepartmentIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargePerformerDepartmentNameFieldName(
  const Value: String);
begin

  FDocumentChargesInfoFieldNames.DocumentChargePerformerDepartmentNameFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargePerformerIdFieldName(
  const Value: String);
begin

  FDocumentChargesInfoFieldNames.DocumentChargePerformerIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargePerformerIsForeignFieldName(
  const Value: String);
begin

  FDocumentChargesInfoFieldNames.DocumentChargePerformerIsForeignFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargePerformerLeaderIdFieldName(
  const Value: String);
begin

  FDocumentChargesInfoFieldNames.DocumentChargePerformerLeaderIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargePerformerNameFieldName(
  const Value: String);
begin

  FDocumentChargesInfoFieldNames.DocumentChargePerformerNameFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargePerformerSpecialityFieldName(
  const Value: String);
begin

  FDocumentChargesInfoFieldNames.DocumentChargePerformerSpecialityFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargePerformingDateTimeFieldName(
  const Value: String);
begin

  FDocumentChargesInfoFieldNames.DocumentChargePerformingDateTimeFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargePeriodEndFieldName(
  const Value: String);
begin

  FDocumentChargesInfoFieldNames.DocumentChargePeriodEndFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargePeriodStartFieldName(
  const Value: String);
begin

  FDocumentChargesInfoFieldNames.DocumentChargePeriodStartFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeResponseFieldName(
  const Value: String);
begin

  FDocumentChargesInfoFieldNames.DocumentChargeResponseFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetActualPerformerDepartmentCodeFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetActualPerformerDepartmentCodeFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetActualPerformerDepartmentIdFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetActualPerformerDepartmentIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetActualPerformerDepartmentNameFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetActualPerformerDepartmentNameFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetActualPerformerIdFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetActualPerformerIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetActualPerformerIsForeignFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetActualPerformerIsForeignFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetActualPerformerLeaderIdFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetActualPerformerLeaderIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetActualPerformerNameFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetActualPerformerNameFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetActualPerformerSpecialityFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetActualPerformerSpecialityFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetIdFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetIsForAcquaitanceFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetIsForAcquaitanceFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetIssuingDateTimeFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetIssuingDateTimeFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetPerformerDepartmentCodeFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetPerformerDepartmentCodeFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetPerformerDepartmentIdFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetPerformerDepartmentIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetPerformerDepartmentNameFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetPerformerDepartmentNameFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetPerformerIdFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetPerformerIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetPerformerIsForeignFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetPerformerIsForeignFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetPerformerLeaderIdFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetPerformerLeaderIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetPerformerNameFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetPerformerNameFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetPerformerRoleIdFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetPerformerRoleIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetPerformerSpecialityFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetPerformerSpecialityFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetPerformingDateTimeFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetPerformingDateTimeFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetPeriodEndFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetPeriodEndFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetPeriodStartFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetPeriodStartFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetResponseFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetResponseFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetSenderDepartmentCodeFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetSenderDepartmentCodeFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetSenderDepartmentIdFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetSenderDepartmentIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetSenderDepartmentNameFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetSenderDepartmentNameFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetSenderIdFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetSenderIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetSenderIsForeignFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetSenderIsForeignFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetSenderLeaderIdFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetSenderLeaderIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetSenderNameFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetSenderNameFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetSenderSpecialityFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetSenderSpecialityFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetTextFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetTextFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeSheetViewingDateByPerformerFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.DocumentChargeSheetViewingDateByPerformerFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentChargeTextFieldName(
  const Value: String);
begin

  FDocumentChargesInfoFieldNames.DocumentChargeTextFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentContentFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.ContentFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentCreationDateFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.CreationDateFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentCurrentWorkCycleStageNameFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.CurrentWorkCycleStageNameFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentCurrentWorkCycleStageNumberFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.CurrentWorkCycleStageNumberFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentDateFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.DateFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentFileIdFieldName(
  const Value: String);
begin

  FDocumentFilesInfoFieldNames.DocumentFileIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentFileNameFieldName(
  const Value: String);
begin

  FDocumentFilesInfoFieldNames.DocumentFileNameFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentFilePathFieldName(
  const Value: String);
begin

  FDocumentFilesInfoFieldNames.DocumentFilePathFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentFilesInfoFieldNames(
  const Value: TDocumentFilesInfoFieldNames);
begin

  FDocumentFilesInfoFieldNames := Value;
  FDocumentFilesInfoFieldNames.DocumentIdFieldName := DocumentIdFieldName;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentIdFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.IdFieldName := Value;
  FDocumentRelationsInfoFieldNames.TargetDocumentIdFieldName := Value;
  FDocumentFilesInfoFieldNames.DocumentFileIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentInfoFieldNames(
  const Value: TDocumentInfoFieldNames);
begin

  FDocumentInfoFieldNames := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentIsSelfRegisteredFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.IsSelfRegisteredFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentKindFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.KindFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentKindIdFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.KindIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentNameFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.NameFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentNoteFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.NoteFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentNumberFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.NumberFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentProductCodeFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.ProductCodeFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentRelationIdFieldName(
  const Value: String);
begin

  FDocumentRelationsInfoFieldNames.DocumentRelationIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentRelationsInfoFieldNames(
  const Value: TDocumentRelationsInfoFieldNames);
begin
  FDocumentRelationsInfoFieldNames := Value;
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentResponsibleDepartmentCodeFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.ResponsibleDepartmentCodeFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentResponsibleDepartmentIdFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.ResponsibleDepartmentIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentResponsibleDepartmentNameFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.ResponsibleDepartmentNameFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentResponsibleIdFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.ResponsibleIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentResponsibleNameFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.ResponsibleNameFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentResponsibleTelephoneNumberFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.ResponsibleTelephoneNumberFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentSignerDepartmentCodeFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.SignerDepartmentCodeFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentSignerDepartmentIdFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.SignerDepartmentIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentSignerDepartmentNameFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.SignerDepartmentNameFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentSignerIdFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.SignerIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentSignerLeaderIdFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.SignerLeaderIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentSignerNameFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.SignerNameFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentSignerSpecialityFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.SignerSpecialityFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentSigningDateFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.SigningDateFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetDocumentSigningIdFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.SigningIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetRelatedDocumentDateFieldName(
  const Value: String);
begin

  FDocumentRelationsInfoFieldNames.RelatedDocumentDateFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetRelatedDocumentIdFieldName(
  const Value: String);
begin

  FDocumentRelationsInfoFieldNames.RelatedDocumentIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetRelatedDocumentKindIdFieldName(
  const Value: String);
begin

  FDocumentRelationsInfoFieldNames.RelatedDocumentKindIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetRelatedDocumentKindNameFieldName(
  const Value: String);
begin

  FDocumentRelationsInfoFieldNames.RelatedDocumentKindNameFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetRelatedDocumentNameFieldName(
  const Value: String);
begin

  FDocumentRelationsInfoFieldNames.RelatedDocumentNameFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetRelatedDocumentNumberFieldName(
  const Value: String);
begin

  FDocumentRelationsInfoFieldNames.RelatedDocumentNumberFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetTopLevelDocumentChargeSheetIdFieldName(
  const Value: String);
begin

  FDocumentChargeSheetsInfoFieldNames.TopLevelDocumentChargeSheetIdFieldName := Value;
  
end;

end.
