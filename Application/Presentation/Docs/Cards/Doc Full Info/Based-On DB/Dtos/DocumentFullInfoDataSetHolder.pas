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
      FApprovingsInfoFieldNames: TDocumentApprovingsInfoFieldNames;
      FChargesInfoFieldNames: TDocumentChargesInfoFieldNames;
      FChargeSheetsInfoFieldNames: TDocumentChargeSheetsInfoFieldNames;
      FRelationsInfoFieldNames: TDocumentRelationsInfoFieldNames;
      FFilesInfoFieldNames: TDocumentFilesInfoFieldNames;

      function GetIdFieldName: String;
      function GetBaseIdFieldName: String;
      function GetNumberFieldName: String;
      function GetNameFieldName: String;
      function GetContentFieldName: String;
      function GetNoteFieldName: String;
      function GetProductCodeFieldName: String;
      function GetIsSelfRegisteredFieldName: String;
      function GetCreationDateFieldName: String;
      function GetDateFieldName: String;
      function GetKindFieldName: String;
      function GetKindIdFieldName: String;
      function GetCurrentWorkCycleStageNameFieldName: String;
      function GetCurrentWorkCycleStageNumberFieldName: String;

      function GetAuthorIdFieldName: String;
      function GetAuthorLeaderIdFieldName: String;
      function GetAuthorNameFieldName: String;
      function GetAuthorSpecialityFieldName: String;
      function GetAuthorDepartmentIdFieldName: String;
      function GetAuthorDepartmentCodeFieldName: String;
      function GetAuthorDepartmentNameFieldName: String;

      function GetResponsibleIdFieldName: String;
      function GetResponsibleNameFieldName: String;
      function GetResponsibleTelephoneNumberFieldName: String;
      function GetResponsibleDepartmentIdFieldName: String;
      function GetResponsibleDepartmentCodeFieldName: String;
      function GetResponsibleDepartmentNameFieldName: String;

      function GetSigningIdFieldName: String;
      function GetSigningDateFieldName: String;
      function GetSignerIdFieldName: String;
      function GetSignerLeaderIdFieldName: String;
      function GetSignerNameFieldName: String;
      function GetSignerSpecialityFieldName: String;
      function GetSignerDepartmentIdFieldName: String;
      function GetSignerDepartmentCodeFieldName: String;
      function GetSignerDepartmentNameFieldName: String;

      function GetActualSignerIdFieldName: String;
      function GetActualSignerLeaderIdFieldName: String;
      function GetActualSignerNameFieldName: String;
      function GetActualSignerSpecialityFieldName: String;
      function GetActualSignerDepartmentIdFieldName: String;
      function GetActualSignerDepartmentCodeFieldName: String;
      function GetActualSignerDepartmentNameFieldName: String;

      function GetChargeIdFieldName: String;
      function GetChargeChargeTextFieldName: String;
      function GetChargeIsForAcquaitanceFieldName: String;
      function GetChargeResponseFieldName: String;
      function GetChargeTimeFrameStartFieldName: String;
      function GetChargeTimeFrameDeadlineFieldName: String;
      function GetChargePerformingDateTimeFieldName: String;
      function GetChargePerformerIdFieldName: String;
      function GetChargePerformerIsForeignFieldName: String;
      function GetChargePerformerNameFieldName: String;
      function GetChargePerformerSpecialityFieldName: String;
      function GetChargePerformerDepartmentIdFieldName: String;
      function GetChargePerformerDepartmentCodeFieldName: String;
      function GetChargePerformerDepartmentNameFieldName: String;

      function GetChargeActualPerformerIdFieldName: String;
      function GetChargeActualPerformerNameFieldName: String;
      function GetChargeActualPerformerSpecialityFieldName: String;
      function GetChargeActualPerformerDepartmentIdFieldName: String;
      function GetChargeActualPerformerDepartmentCodeFieldName: String;
      function GetChargeActualPerformerDepartmentNameFieldName: String;

      function GetFileIdFieldName: String;
      function GetFileNameFieldName: String;
      function GetFilePathFieldName: String;

      function GetRelationIdFieldName: String;
      function GetRelatedDocumentIdFieldName: String;
      function GetRelatedDocumentKindIdFieldName: String;
      function GetRelatedDocumentKindNameFieldName: String;
      function GetRelatedDocumentNumberFieldName: String;
      function GetRelatedDocumentNameFieldName: String;
      function GetRelatedDocumentDateFieldName: String;

      function GetChargeSheetIdFieldName: String;
      function GetChargeSheetChargeIdFieldName: String;
      function GetChargeSheetDocumentIdFieldName: String;
      function GetChargeSheetDocumentKindIdFieldName: String;
      function GetTopLevelChargeSheetIdFieldName: String;
      function GetChargeSheetChargeTextFieldName: String;
      function GetChargeSheetIsForAcquaitanceFieldName: String;
      function GetChargeSheetResponseFieldName: String;
      function GetChargeSheetTimeFrameStartFieldName: String;
      function GetChargeSheetTimeFrameDeadlineFieldName: String;
      function GetChargeSheetPerformingDateTimeFieldName: String;
      function GetChargeSheetViewDateByPerformerFieldName: String;

      function GetChargeSheetPerformerIdFieldName: String;
      function GetChargeSheetPerformerIsForeignFieldName: String;
      function GetChargeSheetPerformerNameFieldName: String;
      function GetChargeSheetPerformerSpecialityFieldName: String;
      function GetChargeSheetPerformerDepartmentIdFieldName: String;
      function GetChargeSheetPerformerDepartmentCodeFieldName: String;
      function GetChargeSheetPerformerDepartmentNameFieldName: String;

      function GetChargeSheetActualPerformerIdFieldName: String;
      function GetChargeSheetActualPerformerNameFieldName: String;
      function GetChargeSheetActualPerformerSpecialityFieldName: String;
      function GetChargeSheetActualPerformerDepartmentIdFieldName: String;
      function GetChargeSheetActualPerformerDepartmentCodeFieldName: String;
      function GetChargeSheetActualPerformerDepartmentNameFieldName: String;

      function GetChargeSheetIssuerIdFieldName: String;
      function GetChargeSheetIssuerIsForeignFieldName: String;
      function GetChargeSheetIssuerNameFieldName: String;
      function GetChargeSheetIssuerSpecialityFieldName: String;
      function GetChargeSheetIssuerDepartmentIdFieldName: String;
      function GetChargeSheetIssuerDepartmentCodeFieldName: String;
      function GetChargeSheetIssuerDepartmentNameFieldName: String;

      function GetApprovingIdFieldName: String;
      function GetApprovingIsAccessibleFieldName: String;
      function GetChargeSheetIssuingDateTimeFieldName: String;
      function GetApprovingPerformingDateTimeFieldName: String;
      function GetApprovingPerformingResultIdFieldName: String;
      function GetApprovingPerformingResultFieldName: String;
      function GetApprovingNoteFieldName: String;
      function GetApprovingCycleNumberFieldName: String;
      function GetApprovingCycleIdFieldName: String;
      function GetApprovingIsCompletedFieldName: String;
      function GetApprovingIsLookedByApproverFieldName: String;

      function GetApproverIdFieldName: String;
      function GetApproverLeaderIdFieldName: String;
      function GetApproverIsForeignFieldName: String;
      function GetApproverNameFieldName: String;
      function GetApproverSpecialityFieldName: String;
      function GetApproverDepartmentIdFieldName: String;
      function GetApproverDepartmentCodeFieldName: String;
      function GetApproverDepartmentNameFieldName: String;

      function GetActualApproverIdFieldName: String;
      function GetActualApproverLeaderIdFieldName: String;
      function GetActualApproverIsForeignFieldName: String;
      function GetActualApproverNameFieldName: String;
      function GetActualApproverSpecialityFieldName: String;
      function GetActualApproverDepartmentIdFieldName: String;
      function GetActualApproverDepartmentCodeFieldName: String;
      function GetActualApproverDepartmentNameFieldName: String;

      procedure SetFilesInfoFieldNames(const Value: TDocumentFilesInfoFieldNames);
      procedure SetInfoFieldNames(const Value: TDocumentInfoFieldNames);
      procedure SetRelationsInfoFieldNames(const Value: TDocumentRelationsInfoFieldNames);

    protected

      procedure SetIdFieldName(const Value: String);
      procedure SetBaseIdFieldName(const Value: String);
      procedure SetNumberFieldName(const Value: String);
      procedure SetNameFieldName(const Value: String);
      procedure SetContentFieldName(const Value: String);
      procedure SetNoteFieldName(const Value: String);
      procedure SetProductCodeFieldName(const Value: String);
      procedure SetIsSelfRegisteredFieldName(const Value: String);
      procedure SetCreationDateFieldName(const Value: String);
      procedure SetDateFieldName(const Value: String);
      procedure SetKindFieldName(const Value: String);
      procedure SetKindIdFieldName(const Value: String);
      procedure SetCurrentWorkCycleStageNameFieldName(const Value: String);
      procedure SetCurrentWorkCycleStageNumberFieldName(const Value: String);

      procedure SetAuthorIdFieldName(const Value: String);
      procedure SetAuthorLeaderIdFieldName(const Value: String);
      procedure SetAuthorNameFieldName(const Value: String);
      procedure SetAuthorSpecialityFieldName(const Value: String);
      procedure SetAuthorDepartmentIdFieldName(const Value: String);
      procedure SetAuthorDepartmentCodeFieldName(const Value: String);
      procedure SetAuthorDepartmentNameFieldName(const Value: String);

      procedure SetResponsibleIdFieldName(const Value: String);
      procedure SetResponsibleNameFieldName(const Value: String);
      procedure SetResponsibleTelephoneNumberFieldName(const Value: String);
      procedure SetResponsibleDepartmentIdFieldName(const Value: String);
      procedure SetResponsibleDepartmentCodeFieldName(const Value: String);
      procedure SetResponsibleDepartmentNameFieldName(const Value: String);

      procedure SetSigningIdFieldName(const Value: String);
      procedure SetSigningDateFieldName(const Value: String);
      procedure SetSignerIdFieldName(const Value: String);
      procedure SetSignerLeaderIdFieldName(const Value: String);
      procedure SetSignerNameFieldName(const Value: String);
      procedure SetSignerSpecialityFieldName(const Value: String);
      procedure SetSignerDepartmentIdFieldName(const Value: String);
      procedure SetSignerDepartmentCodeFieldName(const Value: String);
      procedure SetSignerDepartmentNameFieldName(const Value: String);

      procedure SetActualSignerIdFieldName(const Value: String);
      procedure SetActualSignerLeaderIdFieldName(const Value: String);
      procedure SetActualSignerNameFieldName(const Value: String);
      procedure SetActualSignerSpecialityFieldName(const Value: String);
      procedure SetActualSignerDepartmentIdFieldName(const Value: String);
      procedure SetActualSignerDepartmentCodeFieldName(const Value: String);
      procedure SetActualSignerDepartmentNameFieldName(const Value: String);

      procedure SetChargeIdFieldName(const Value: String);
      procedure SetChargeChargeTextFieldName(const Value: String);
      procedure SetChargeIsForAcquaitanceFieldName(const Value: String);
      procedure SetChargeResponseFieldName(const Value: String);
      procedure SetChargeTimeFrameStartFieldName(const Value: String);
      procedure SetChargeTimeFrameDeadlineFieldName(const Value: String);
      procedure SetChargePerformingDateTimeFieldName(const Value: String);
      procedure SetChargePerformerIdFieldName(const Value: String);
      procedure SetChargePerformerIsForeignFieldName(const Value: String);
      procedure SetChargePerformerNameFieldName(const Value: String);
      procedure SetChargePerformerSpecialityFieldName(const Value: String);
      procedure SetChargePerformerDepartmentIdFieldName(const Value: String);
      procedure SetChargePerformerDepartmentCodeFieldName(const Value: String);
      procedure SetChargePerformerDepartmentNameFieldName(const Value: String);

      procedure SetChargeActualPerformerIdFieldName(const Value: String);
      procedure SetChargeActualPerformerNameFieldName(const Value: String);
      procedure SetChargeActualPerformerSpecialityFieldName(const Value: String);
      procedure SetChargeActualPerformerDepartmentIdFieldName(const Value: String);
      procedure SetChargeActualPerformerDepartmentCodeFieldName(const Value: String);
      procedure SetChargeActualPerformerDepartmentNameFieldName(const Value: String);

      procedure SetFileIdFieldName(const Value: String);
      procedure SetFileNameFieldName(const Value: String);
      procedure SetFilePathFieldName(const Value: String);

      procedure SetRelationIdFieldName(const Value: String);
      procedure SetRelatedDocumentIdFieldName(const Value: String);
      procedure SetRelatedDocumentKindIdFieldName(const Value: String);
      procedure SetRelatedDocumentKindNameFieldName(const Value: String);
      procedure SetRelatedDocumentNumberFieldName(const Value: String);
      procedure SetRelatedDocumentNameFieldName(const Value: String);
      procedure SetRelatedDocumentDateFieldName(const Value: String);

      procedure SetChargeSheetIdFieldName(const Value: String);
      procedure SetChargeSheetDocumentIdFieldName(const Value: String);
      procedure SetChargeSheetDocumentKindIdFieldName(const Value: String);
      procedure SetChargeSheetChargeIdFieldName(const Value: String);
      procedure SetTopLevelChargeSheetIdFieldName(const Value: String);
      procedure SetChargeSheetChargeTextFieldName(const Value: String);
      procedure SetChargeSheetIsForAcquaitanceFieldName(const Value: String);
      procedure SetChargeSheetResponseFieldName(const Value: String);
      procedure SetChargeSheetTimeFrameStartFieldName(const Value: String);
      procedure SetChargeSheetTimeFrameDeadlineFieldName(const Value: String);
      procedure SetChargeSheetPerformingDateTimeFieldName(const Value: String);
      procedure SetChargeSheetViewDateByPerformerFieldName(const Value: String);

      procedure SetChargeSheetPerformerIdFieldName(const Value: String);
      procedure SetChargeSheetPerformerIsForeignFieldName(const Value: String);
      procedure SetChargeSheetPerformerNameFieldName(const Value: String);
      procedure SetChargeSheetPerformerSpecialityFieldName(const Value: String);
      procedure SetChargeSheetPerformerDepartmentIdFieldName(const Value: String);
      procedure SetChargeSheetPerformerDepartmentCodeFieldName(const Value: String);
      procedure SetChargeSheetPerformerDepartmentNameFieldName(const Value: String);

      procedure SetChargeSheetActualPerformerIdFieldName(const Value: String);
      procedure SetChargeSheetActualPerformerNameFieldName(const Value: String);
      procedure SetChargeSheetActualPerformerSpecialityFieldName(const Value: String);
      procedure SetChargeSheetActualPerformerDepartmentIdFieldName(const Value: String);
      procedure SetChargeSheetActualPerformerDepartmentCodeFieldName(const Value: String);
      procedure SetChargeSheetActualPerformerDepartmentNameFieldName(const Value: String);

      procedure SetChargeSheetIssuerIdFieldName(const Value: String);
      procedure SetChargeSheetIssuerIsForeignFieldName(const Value: String);
      procedure SetChargeSheetIssuerNameFieldName(const Value: String);
      procedure SetChargeSheetIssuerSpecialityFieldName(const Value: String);
      procedure SetChargeSheetIssuerDepartmentIdFieldName(const Value: String);
      procedure SetChargeSheetIssuerDepartmentCodeFieldName(const Value: String);
      procedure SetChargeSheetIssuerDepartmentNameFieldName(const Value: String);

      procedure SetApprovingIdFieldName(const Value: String);
      procedure SetApprovingIsAccessibleFieldName(const Value: String);
      procedure SetChargeSheetIssuingDateTimeFieldName(const Value: String);
      procedure SetApprovingPerformingDateTimeFieldName(const Value: String);
      procedure SetApprovingPerformingResultIdFieldName(const Value: String);
      procedure SetApprovingPerformingResultFieldName(const Value: String);
      procedure SetApprovingNoteFieldName(const Value: String);
      procedure SetApprovingCycleNumberFieldName(const Value: String);
      procedure SetApprovingCycleIdFieldName(const Value: String);
      procedure SetApprovingIsCompletedFieldName(const Value: String);
      procedure SetApprovingIsLookedByApproverFieldName(const Value: String);

      procedure SetApproverIdFieldName(const Value: String);
      procedure SetApproverLeaderIdFieldName(const Value: String);
      procedure SetApproverIsForeignFieldName(const Value: String);
      procedure SetApproverNameFieldName(const Value: String);
      procedure SetApproverSpecialityFieldName(const Value: String);
      procedure SetApproverDepartmentIdFieldName(const Value: String);
      procedure SetApproverDepartmentCodeFieldName(const Value: String);
      procedure SetApproverDepartmentNameFieldName(const Value: String);

      procedure SetActualApproverIdFieldName(const Value: String);
      procedure SetActualApproverLeaderIdFieldName(const Value: String);
      procedure SetActualApproverIsForeignFieldName(const Value: String);
      procedure SetActualApproverNameFieldName(const Value: String);
      procedure SetActualApproverSpecialityFieldName(const Value: String);
      procedure SetActualApproverDepartmentIdFieldName(const Value: String);
      procedure SetActualApproverDepartmentCodeFieldName(const Value: String);
      procedure SetActualApproverDepartmentNameFieldName(const Value: String);

    public

      property IdFieldName: String
      read GetIdFieldName write SetIdFieldName;

      property BaseIdFieldName: String
      read GetBaseIdFieldName write SetBaseIdFieldName;
      
      property NumberFieldName: String
      read GetNumberFieldName write SetNumberFieldName;
      
      property NameFieldName: String
      read GetNameFieldName write SetNameFieldName;

      property ContentFieldName: String
      read GetContentFieldName write SetContentFieldName;

      property NoteFieldName: String
      read GetNoteFieldName write SetNoteFieldName;
      
      property ProductCodeFieldName: String
      read GetProductCodeFieldName write SetProductCodeFieldName;

      property IsSelfRegisteredFieldName: String
      read GetIsSelfRegisteredFieldName write SetIsSelfRegisteredFieldName;
      
      property CreationDateFieldName: String
      read GetCreationDateFieldName write SetCreationDateFieldName;
      
      property DateFieldName: String
      read GetDateFieldName write SetDateFieldName;
      
      property KindFieldName: String
      read GetKindFieldName write SetKindFieldName;

      property KindIdFieldName: String
      read GetKindIdFieldName write SetKindIdFieldName;
      
      property CurrentWorkCycleStageNameFieldName: String
      read GetCurrentWorkCycleStageNameFieldName
      write SetCurrentWorkCycleStageNameFieldName;
      
      property CurrentWorkCycleStageNumberFieldName: String
      read GetCurrentWorkCycleStageNumberFieldName
      write SetCurrentWorkCycleStageNumberFieldName;

      property AuthorIdFieldName: String
      read GetAuthorIdFieldName write SetAuthorIdFieldName;
      
      property AuthorLeaderIdFieldName: String
      read GetAuthorLeaderIdFieldName write SetAuthorLeaderIdFieldName;
      
      property AuthorNameFieldName: String
      read GetAuthorNameFieldName write SetAuthorNameFieldName;
      
      property AuthorSpecialityFieldName: String
      read GetAuthorSpecialityFieldName
      write SetAuthorSpecialityFieldName;

      property AuthorDepartmentIdFieldName: String
      read GetAuthorDepartmentIdFieldName
      write SetAuthorDepartmentIdFieldName;

      property AuthorDepartmentCodeFieldName: String
      read GetAuthorDepartmentCodeFieldName
      write SetAuthorDepartmentCodeFieldName;
      
      property AuthorDepartmentNameFieldName: String
      read GetAuthorDepartmentNameFieldName
      write SetAuthorDepartmentNameFieldName;

      property ResponsibleIdFieldName: String
      read GetResponsibleIdFieldName
      write SetResponsibleIdFieldName;
      
      property ResponsibleNameFieldName: String
      read GetResponsibleNameFieldName
      write SetResponsibleNameFieldName;

      property ResponsibleTelephoneNumberFieldName: String
      read GetResponsibleTelephoneNumberFieldName
      write SetResponsibleTelephoneNumberFieldName;
      
      property ResponsibleDepartmentIdFieldName: String
      read GetResponsibleDepartmentIdFieldName
      write SetResponsibleDepartmentIdFieldName;

      property ResponsibleDepartmentCodeFieldName: String
      read GetResponsibleDepartmentCodeFieldName
      write SetResponsibleDepartmentCodeFieldName;
      
      property ResponsibleDepartmentNameFieldName: String
      read GetResponsibleDepartmentNameFieldName
      write SetResponsibleDepartmentNameFieldName;

      property SigningIdFieldName: String
      read GetSigningIdFieldName
      write SetSigningIdFieldName;

      property SigningDateFieldName: String
      read GetSigningDateFieldName
      write SetSigningDateFieldName;

      property SignerIdFieldName: String
      read GetSignerIdFieldName write SetSignerIdFieldName;

      property SignerLeaderIdFieldName: String
      read GetSignerLeaderIdFieldName write SetSignerLeaderIdFieldName;
      
      property SignerNameFieldName: String
      read GetSignerNameFieldName write SetSignerNameFieldName;
      
      property SignerSpecialityFieldName: String
      read GetSignerSpecialityFieldName write SetSignerSpecialityFieldName;

      property SignerDepartmentIdFieldName: String
      read GetSignerDepartmentIdFieldName write SetSignerDepartmentIdFieldName;

      property SignerDepartmentCodeFieldName: String
      read GetSignerDepartmentCodeFieldName write SetSignerDepartmentCodeFieldName;
      
      property SignerDepartmentNameFieldName: String
      read GetSignerDepartmentNameFieldName write SetSignerDepartmentNameFieldName;

      property ActualSignerIdFieldName: String
      read GetActualSignerIdFieldName write SetActualSignerIdFieldName;

      property ActualSignerLeaderIdFieldName: String
      read GetActualSignerLeaderIdFieldName write SetActualSignerLeaderIdFieldName;

      property ActualSignerNameFieldName: String
      read GetActualSignerNameFieldName write SetActualSignerNameFieldName;

      property ActualSignerSpecialityFieldName: String
      read GetActualSignerSpecialityFieldName write SetActualSignerSpecialityFieldName;

      property ActualSignerDepartmentIdFieldName: String
      read GetActualSignerDepartmentIdFieldName write SetActualSignerDepartmentIdFieldName;
      
      property ActualSignerDepartmentCodeFieldName: String
      read GetActualSignerDepartmentCodeFieldName
      write SetActualSignerDepartmentCodeFieldName;
      
      property ActualSignerDepartmentNameFieldName: String
      read GetActualSignerDepartmentNameFieldName
      write SetActualSignerDepartmentNameFieldName;

      property ChargeIdFieldName: String
      read GetChargeIdFieldName write SetChargeIdFieldName;

      property ChargeChargeTextFieldName: String
      read GetChargeChargeTextFieldName write SetChargeChargeTextFieldName;

      property ChargeIsForAcquaitanceFieldName: String
      read GetChargeIsForAcquaitanceFieldName write SetChargeIsForAcquaitanceFieldName;
      
      property ChargeResponseFieldName: String
      read GetChargeResponseFieldName write SetChargeResponseFieldName;

      property ChargeTimeFrameStartFieldName: String
      read GetChargeTimeFrameStartFieldName write SetChargeTimeFrameStartFieldName;

      property ChargeTimeFrameDeadlineFieldName: String
      read GetChargeTimeFrameDeadlineFieldName write SetChargeTimeFrameDeadlineFieldName;

      property ChargePerformingDateTimeFieldName: String
      read GetChargePerformingDateTimeFieldName write SetChargePerformingDateTimeFieldName;
      
      property ChargePerformerIdFieldName: String
      read GetChargePerformerIdFieldName write SetChargePerformerIdFieldName;

      property ChargePerformerIsForeignFieldName: String
      read GetChargePerformerIsForeignFieldName write SetChargePerformerIsForeignFieldName;
      
      property ChargePerformerNameFieldName: String
      read GetChargePerformerNameFieldName write SetChargePerformerNameFieldName;
      
      property ChargePerformerSpecialityFieldName: String
      read GetChargePerformerSpecialityFieldName write SetChargePerformerSpecialityFieldName;

      property ChargePerformerDepartmentIdFieldName: String
      read GetChargePerformerDepartmentIdFieldName write SetChargePerformerDepartmentIdFieldName;

      property ChargePerformerDepartmentCodeFieldName: String
      read GetChargePerformerDepartmentCodeFieldName
      write SetChargePerformerDepartmentCodeFieldName;

      property ChargePerformerDepartmentNameFieldName: String
      read GetChargePerformerDepartmentNameFieldName
      write SetChargePerformerDepartmentNameFieldName;

      property ChargeActualPerformerIdFieldName: String
      read GetChargeActualPerformerIdFieldName
      write SetChargeActualPerformerIdFieldName;

      property ChargeActualPerformerNameFieldName: String
      read GetChargeActualPerformerNameFieldName
      write SetChargeActualPerformerNameFieldName;
      
      property ChargeActualPerformerSpecialityFieldName: String
      read GetChargeActualPerformerSpecialityFieldName
      write SetChargeActualPerformerSpecialityFieldName;

      property ChargeActualPerformerDepartmentIdFieldName: String
      read GetChargeActualPerformerDepartmentIdFieldName
      write SetChargeActualPerformerDepartmentIdFieldName;
      
      property ChargeActualPerformerDepartmentCodeFieldName: String
      read GetChargeActualPerformerDepartmentCodeFieldName
      write SetChargeActualPerformerDepartmentCodeFieldName;

      property ChargeActualPerformerDepartmentNameFieldName: String
      read GetChargeActualPerformerDepartmentNameFieldName
      write SetChargeActualPerformerDepartmentNameFieldName;

      property FileIdFieldName: String
      read GetFileIdFieldName write SetFileIdFieldName;
      
      property FileNameFieldName: String
      read GetFileNameFieldName write SetFileNameFieldName;
      
      property FilePathFieldName: String
      read GetFilePathFieldName write SetFilePathFieldName;

      property RelationIdFieldName: String
      read GetRelationIdFieldName write SetRelationIdFieldName;

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

      property ChargeSheetIdFieldName: String
      read GetChargeSheetIdFieldName write SetChargeSheetIdFieldName;

      property ChargeSheetDocumentIdFieldName: String
      read GetChargeSheetDocumentIdFieldName write SetChargeSheetDocumentIdFieldName;

      property ChargeSheetDocumentKindIdFieldName: String
      read GetChargeSheetDocumentKindIdFieldName write SetChargeSheetDocumentKindIdFieldName;

      property ChargeSheetChargeIdFieldName: String
      read GetChargeSheetChargeIdFieldName write SetChargeSheetChargeIdFieldName;

      property TopLevelChargeSheetIdFieldName: String
      read GetTopLevelChargeSheetIdFieldName
      write SetTopLevelChargeSheetIdFieldName;

      property ChargeSheetChargeTextFieldName: String
      read GetChargeSheetChargeTextFieldName write SetChargeSheetChargeTextFieldName;

      property ChargeSheetIsForAcquaitanceFieldName: String
      read GetChargeSheetIsForAcquaitanceFieldName write SetChargeSheetIsForAcquaitanceFieldName;

      property ChargeSheetResponseFieldName: String
      read GetChargeSheetResponseFieldName write SetChargeSheetResponseFieldName;
      
      property ChargeSheetTimeFrameStartFieldName: String
      read GetChargeSheetTimeFrameStartFieldName write SetChargeSheetTimeFrameStartFieldName;

      property ChargeSheetTimeFrameDeadlineFieldName: String
      read GetChargeSheetTimeFrameDeadlineFieldName write SetChargeSheetTimeFrameDeadlineFieldName;

      property ChargeSheetPerformingDateTimeFieldName: String
      read GetChargeSheetPerformingDateTimeFieldName
      write SetChargeSheetPerformingDateTimeFieldName;
      
      property ChargeSheetViewDateByPerformerFieldName: String
      read GetChargeSheetViewDateByPerformerFieldName
      write SetChargeSheetViewDateByPerformerFieldName;

      property ChargeSheetPerformerIdFieldName: String
      read GetChargeSheetPerformerIdFieldName
      write SetChargeSheetPerformerIdFieldName;
      
      property ChargeSheetPerformerIsForeignFieldName: String
      read GetChargeSheetPerformerIsForeignFieldName
      write SetChargeSheetPerformerIsForeignFieldName;

      property ChargeSheetPerformerNameFieldName: String
      read GetChargeSheetPerformerNameFieldName
      write SetChargeSheetPerformerNameFieldName;

      property ChargeSheetPerformerSpecialityFieldName: String
      read GetChargeSheetPerformerSpecialityFieldName
      write SetChargeSheetPerformerSpecialityFieldName;

      property ChargeSheetPerformerDepartmentIdFieldName: String
      read GetChargeSheetPerformerDepartmentIdFieldName
      write SetChargeSheetPerformerDepartmentIdFieldName;

      property ChargeSheetPerformerDepartmentCodeFieldName: String
      read GetChargeSheetPerformerDepartmentCodeFieldName
      write SetChargeSheetPerformerDepartmentCodeFieldName;
      
      property ChargeSheetPerformerDepartmentNameFieldName: String
      read GetChargeSheetPerformerDepartmentNameFieldName
      write SetChargeSheetPerformerDepartmentNameFieldName;

      property ChargeSheetActualPerformerIdFieldName: String
      read GetChargeSheetActualPerformerIdFieldName
      write SetChargeSheetActualPerformerIdFieldName;

      property ChargeSheetActualPerformerNameFieldName: String
      read GetChargeSheetActualPerformerNameFieldName
      write SetChargeSheetActualPerformerNameFieldName;
      
      property ChargeSheetActualPerformerSpecialityFieldName: String
      read GetChargeSheetActualPerformerSpecialityFieldName
      write SetChargeSheetActualPerformerSpecialityFieldName;
      
      property ChargeSheetActualPerformerDepartmentIdFieldName: String
      read GetChargeSheetActualPerformerDepartmentIdFieldName
      write SetChargeSheetActualPerformerDepartmentIdFieldName;
      
      property ChargeSheetActualPerformerDepartmentCodeFieldName: String
      read GetChargeSheetActualPerformerDepartmentCodeFieldName
      write SetChargeSheetActualPerformerDepartmentCodeFieldName;
      
      property ChargeSheetActualPerformerDepartmentNameFieldName: String
      read GetChargeSheetActualPerformerDepartmentNameFieldName
      write SetChargeSheetActualPerformerDepartmentNameFieldName;

      property ChargeSheetIssuerIdFieldName: String
      read GetChargeSheetIssuerIdFieldName
      write SetChargeSheetIssuerIdFieldName;

      property ChargeSheetIssuerIsForeignFieldName: String
      read GetChargeSheetIssuerIsForeignFieldName
      write SetChargeSheetIssuerIsForeignFieldName;
      
      property ChargeSheetIssuerNameFieldName: String
      read GetChargeSheetIssuerNameFieldName
      write SetChargeSheetIssuerNameFieldName;

      property ChargeSheetIssuerSpecialityFieldName: String
      read GetChargeSheetIssuerSpecialityFieldName
      write SetChargeSheetIssuerSpecialityFieldName;
      
      property ChargeSheetIssuerDepartmentIdFieldName: String
      read GetChargeSheetIssuerDepartmentIdFieldName
      write SetChargeSheetIssuerDepartmentIdFieldName;
      
      property ChargeSheetIssuerDepartmentCodeFieldName: String
      read GetChargeSheetIssuerDepartmentCodeFieldName
      write SetChargeSheetIssuerDepartmentCodeFieldName;

      property ChargeSheetIssuerDepartmentNameFieldName: String
      read GetChargeSheetIssuerDepartmentNameFieldName
      write SetChargeSheetIssuerDepartmentNameFieldName;

      property ApprovingIdFieldName: String
      read GetApprovingIdFieldName write SetApprovingIdFieldName;

      property ApprovingIsAccessibleFieldName: String
      read GetApprovingIsAccessibleFieldName
      write SetApprovingIsAccessibleFieldName;

      property ChargeSheetIssuingDateTimeFieldName: String
      read GetChargeSheetIssuingDateTimeFieldName
      write SetChargeSheetIssuingDateTimeFieldName;

      property ApprovingPerformingDateTimeFieldName: String
      read GetApprovingPerformingDateTimeFieldName
      write SetApprovingPerformingDateTimeFieldName;

      property ApprovingPerformingResultIdFieldName: String
      read GetApprovingPerformingResultIdFieldName
      write SetApprovingPerformingResultIdFieldName;

      property ApprovingPerformingResultFieldName: String
      read GetApprovingPerformingResultFieldName
      write SetApprovingPerformingResultFieldName;
      
      property ApprovingNoteFieldName: String
      read GetApprovingNoteFieldName write SetApprovingNoteFieldName;

      property ApprovingCycleNumberFieldName: String
      read GetApprovingCycleNumberFieldName
      write SetApprovingCycleNumberFieldName;

      property ApprovingCycleIdFieldName: String
      read GetApprovingCycleIdFieldName
      write SetApprovingCycleIdFieldName;

      property ApprovingIsCompletedFieldName: String
      read GetApprovingIsCompletedFieldName
      write SetApprovingIsCompletedFieldName;
      
      property ApprovingIsLookedByApproverFieldName: String
      read GetApprovingIsLookedByApproverFieldName
      write SetApprovingIsLookedByApproverFieldName;

      property ApproverIdFieldName: String
      read GetApproverIdFieldName write SetApproverIdFieldName;
      
      property ApproverLeaderIdFieldName: String
      read GetApproverLeaderIdFieldName write SetApproverLeaderIdFieldName;

      property ApproverIsForeignFieldName: String
      read GetApproverIsForeignFieldName
      write SetApproverIsForeignFieldName;
      
      property ApproverNameFieldName: String
      read GetApproverNameFieldName write SetApproverNameFieldName;
      
      property ApproverSpecialityFieldName: String
      read GetApproverSpecialityFieldName
      write SetApproverSpecialityFieldName;
      
      property ApproverDepartmentIdFieldName: String
      read GetApproverDepartmentIdFieldName
      write SetApproverDepartmentIdFieldName;
      
      property ApproverDepartmentCodeFieldName: String
      read GetApproverDepartmentCodeFieldName
      write SetApproverDepartmentCodeFieldName;

      property ApproverDepartmentNameFieldName: String
      read GetApproverDepartmentNameFieldName
      write SetApproverDepartmentNameFieldName;

      property ActualApproverIdFieldName: String
      read GetActualApproverIdFieldName
      write SetActualApproverIdFieldName;

      property ActualApproverLeaderIdFieldName: String
      read GetActualApproverLeaderIdFieldName
      write SetActualApproverLeaderIdFieldName;

      property ActualApproverIsForeignFieldName: String
      read GetActualApproverIsForeignFieldName
      write SetActualApproverIsForeignFieldName;
      
      property ActualApproverNameFieldName: String
      read GetActualApproverNameFieldName
      write SetActualApproverNameFieldName;
      
      property ActualApproverSpecialityFieldName: String
      read GetActualApproverSpecialityFieldName
      write SetActualApproverSpecialityFieldName;
      
      property ActualApproverDepartmentIdFieldName: String
      read GetActualApproverDepartmentIdFieldName
      write SetActualApproverDepartmentIdFieldName;
      
      property ActualApproverDepartmentCodeFieldName: String
      read GetActualApproverDepartmentCodeFieldName
      write SetActualApproverDepartmentCodeFieldName;
      
      property ActualApproverDepartmentNameFieldName: String
      read GetActualApproverDepartmentNameFieldName
      write SetActualApproverDepartmentNameFieldName;

    public

      property DocumentInfoFieldNames: TDocumentInfoFieldNames
      read FDocumentInfoFieldNames write SetInfoFieldNames;

      property ApprovingsInfoFieldNames: TDocumentApprovingsInfoFieldNames
      read FApprovingsInfoFieldNames write FApprovingsInfoFieldNames;
      
      property ChargesInfoFieldNames: TDocumentChargesInfoFieldNames
      read FChargesInfoFieldNames write FChargesInfoFieldNames;

      property ChargeSheetsInfoFieldNames: TDocumentChargeSheetsInfoFieldNames
      read FChargeSheetsInfoFieldNames write FChargeSheetsInfoFieldNames;

      property RelationsInfoFieldNames: TDocumentRelationsInfoFieldNames
      read FRelationsInfoFieldNames write SetRelationsInfoFieldNames;
      
      property FilesInfoFieldNames: TDocumentFilesInfoFieldNames
      read FFilesInfoFieldNames write SetFilesInfoFieldNames;
      
  end;

  TDocumentFullInfoDataSetHolder = class (TAbstractDataSetHolder)

    private

      function GetFieldNames: TDocumentFullInfoDataSetFieldNames;

    protected

      procedure SetApprovingsInfoHolder(const Value: TDocumentApprovingsInfoHolder); virtual;

      procedure SetChargesInfoHolder(const Value: TDocumentChargesInfoHolder); virtual;

      procedure SetChargeSheetsInfoHolder(const Value: TDocumentChargeSheetsInfoHolder); virtual;

      procedure SetFilesInfoHolder(const Value: TDocumentFilesInfoHolder); virtual;
      procedure SetDocumentInfoHolder(const Value: TDocumentInfoHolder); virtual;

      procedure SetRelationsInfoHolder(const Value: TDocumentRelationsInfoHolder); virtual;

      procedure SetFieldNames(const Value: TDocumentFullInfoDataSetFieldNames); virtual;

    protected

      FDocumentInfoHolder: TDocumentInfoHolder;
      FFreeDocumentInfoHolder: IDisposable;

      FApprovingsInfoHolder: TDocumentApprovingsInfoHolder;
      FFreeApprovingsInfoHolder: IDisposable;
      
      FChargesInfoHolder: TDocumentChargesInfoHolder;
      FFreeChargesInfoHolder: IDisposable;
      
      FChargeSheetsInfoHolder: TDocumentChargeSheetsInfoHolder;
      FFreeChargeSheetsInfoHolder: IDisposable;
      
      FRelationsInfoHolder: TDocumentRelationsInfoHolder;
      FFreeRelationsInfoHolder: IDisposable;
      
      FFilesInfoHolder: TDocumentFilesInfoHolder;
      FFreeFilesInfoHolder: IDisposable;

      procedure Initialize; override;

      function CreateDocumentInfoHolderInstance: TDocumentInfoHolder; virtual;
      function CreateApprovingsInfoHolderInstance: TDocumentApprovingsInfoHolder; virtual;
      function CreateChargesInfoHolderInstance: TDocumentChargesInfoHolder; virtual;
      function CreateChargeSheetsInfoHolderInstance: TDocumentChargeSheetsInfoHolder; virtual;
      function CreateRelationsInfoHolderInstance: TDocumentRelationsInfoHolder; virtual;
      function CreateFilesInfoHolderInstance: TDocumentFilesInfoHolder; virtual;

      function CreateDocumentInfoHolder: TDocumentInfoHolder; virtual;
      function CreateApprovingsInfoHolder: TDocumentApprovingsInfoHolder; virtual;
      function CreateChargesInfoHolder: TDocumentChargesInfoHolder; virtual;
      function CreateChargeSheetsInfoHolder: TDocumentChargeSheetsInfoHolder; virtual;
      function CreateRelationsInfoHolder: TDocumentRelationsInfoHolder; virtual;
      function CreateFilesInfoHolder: TDocumentFilesInfoHolder; virtual;
      
      procedure UpdateDataSet(Holder: TAbstractDataSetHolder);

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;

      function GetAuthorDepartmentCodeFieldValue: String;
      function GetAuthorDepartmentIdFieldValue: Variant;
      function GetAuthorDepartmentNameFieldValue: String;
      function GetAuthorIdFieldValue: Variant;
      function GetChargeIsForAcquaitanceFieldValue: Boolean;
      function GetProductCodeFieldValue: String;
      function GetChargeSheetIsForAcquaitanceFieldValue: Boolean;
      function GetAuthorNameFieldValue: String;
      function GetChargeActualPerformerDepartmentCodeFieldValue: String;
      function GetChargeActualPerformerDepartmentIdFieldValue: Variant;
      function GetChargeActualPerformerDepartmentNameFieldValue: String;
      function GetChargeActualPerformerIdFieldValue: Variant;
      function GetChargeActualPerformerNameFieldValue: String;
      function GetChargeActualPerformerSpecialityFieldValue: String;
      function GetChargeIdFieldValue: Variant;
      function GetChargePerformerDepartmentCodeFieldValue: String;
      function GetChargePerformerDepartmentIdFieldValue: Variant;
      function GetChargePerformerDepartmentNameFieldValue: String;
      function GetChargePerformerIdFieldValue: Variant;
      function GetChargePerformerNameFieldValue: String;
      function GetChargePerformerSpecialityFieldValue: String;
      function GetChargePerformingDateTimeFieldValue: Variant;
      function GetChargeTimeFrameDeadlineFieldValue: Variant;
      function GetChargeTimeFrameStartFieldValue: Variant;
      function GetChargeResponseFieldValue: String;
      function GetChargeTextFieldValue: String;
      function GetContentFieldName: String;
      function GetNoteFieldValue: String;
      function GetIsSelfRegisteredFieldValue: Variant;
      function GetCreationDateFieldValue: TDateTime;
      function GetDateFieldValue: Variant;
      function GetCurrentWorkCycleStageNameFieldValue: String;
      function GetCurrentWorkCycleStageNumberFieldValue: Integer;
      function GetFileIdFieldValue: Variant;
      function GetFileNameFieldValue: String;
      function GetFilePathFieldValue: String;
      function GetIdFieldValue: Variant;
      function GetBaseIdFieldValue: Variant;
      function GetKindFieldValue: String;
      function GetNameFieldValue: String;
      function GetNumberFieldValue: String;
      function GetResponsibleDepartmentCodeFieldValue: String;
      function GetResponsibleDepartmentIdFieldValue: Variant;
      function GetResponsibleDepartmentNameFieldValue: String;
      function GetResponsibleIdFieldValue: Variant;
      function GetResponsibleNameFieldValue: String;
      function GetResponsibleTelephoneNumberFieldValue: String;
      function GetSignerDepartmentCodeFieldValue: String;
      function GetSignerDepartmentIdFieldValue: Variant;
      function GetSignerDepartmentNameFieldValue: String;
      function GetSignerIdFieldValue: Variant;
      function GetSignerNameFieldValue: String;
      function GetSignerSpecialityFieldValue: String;
      function GetSigningDateFieldValue: Variant;
      function GetSigningIdFieldValue: Variant;
      function GetRelatedDocumentDateFieldValue: TDateTime;
      function GetRelationIdFieldValue: Variant;
      function GetRelatedDocumentIdFieldValue: Variant;
      function GetRelatedDocumentKindIdFieldValue: Variant;
      function GetRelatedDocumentKindNameFieldValue: String;
      function GetRelatedDocumentNameFieldValue: String;
      function GetRelatedDocumentNumberFieldValue: String;
      function GetActualSignerDepartmentCodeFieldValue: String;
      function GetActualSignerDepartmentIdFieldValue: Variant;
      function GetActualSignerDepartmentNameFieldValue: String;
      function GetActualSignerIdFieldValue: Variant;
      function GetActualSignerNameFieldValue: String;
      function GetActualSignerSpecialityFieldValue: String;
      function GetChargeSheetActualPerformerDepartmentCodeFieldValue: String;
      function GetChargeSheetActualPerformerDepartmentIdFieldValue: Variant;
      function GetChargeSheetActualPerformerDepartmentNameFieldValue: String;
      function GetChargeSheetActualPerformerIdFieldValue: Variant;
      function GetChargeSheetActualPerformerNameFieldValue: String;
      function GetChargeSheetActualPerformerSpecialityFieldValue: String;
      function GetChargeSheetIdFieldValue: Variant;
      function GetChargeSheetChargeIdFieldValue: Variant;
      function GetChargeSheetPerformerDepartmentCodeFieldValue: String;
      function GetChargeSheetPerformerDepartmentIdFieldValue: Variant;
      function GetChargeSheetPerformerDepartmentNameFieldValue: String;
      function GetChargeSheetPerformerIdFieldValue: Variant;
      function GetChargeSheetPerformerNameFieldValue: String;
      function GetChargeSheetPerformerSpecialityFieldValue: String;
      function GetChargeSheetIssuingDateTimeFieldValue: Variant;
      function GetChargeSheetPerformingDateTimeFieldValue: Variant;
      function GetChargeSheetTimeFrameDeadlineFieldValue: Variant;
      function GetChargeSheetTimeFrameStartFieldValue: Variant;
      function GetChargeSheetResponseFieldValue: String;
      function GetChargeSheetIssuerDepartmentCodeFieldValue: String;
      function GetChargeSheetIssuerDepartmentIdFieldValue: Variant;
      function GetChargeSheetIssuerDepartmentNameFieldValue: String;
      function GetChargeSheetIssuerIdFieldValue: Variant;
      function GetChargeSheetIssuerNameFieldValue: String;
      function GetChargeSheetIssuerSpecialityFieldValue: String;
      function GetChargeSheetChargeTextFieldValue: String;
      function GetTopLevelChargeSheetIdFieldValue: Variant;
      function GetActualSignerLeaderIdFieldValue: Variant;
      function GetAuthorLeaderIdFieldValue: Variant;
      function GetChargePerformerIsForeignFieldValue: Boolean;
      function GetChargeSheetPerformerIsForeignFieldValue: Boolean;
      function GetChargeSheetIssuerIsForeignFieldValue: Boolean;
      function GetSignerLeaderIdFieldValue: Variant;
      function GetKindIdFieldValue: Variant;
      function GetAuthorSpecialityFieldValue: String;
      function GetActualApproverDepartmentCodeFieldValue: String;
      function GetActualApproverDepartmentIdFieldValue: Variant;
      function GetActualApproverDepartmentNameFieldValue: String;
      function GetActualApproverIdFieldValue: Variant;
      function GetActualApproverIsForeignFieldValue: Boolean;
      function GetActualApproverLeaderIdFieldValue: Variant;
      function GetActualApproverNameFieldValue: String;
      function GetActualApproverSpecialityFieldValue: String;
      function GetApproverDepartmentCodeFieldValue: String;
      function GetApproverDepartmentIdFieldValue: Variant;
      function GetApproverDepartmentNameFieldValue: String;
      function GetApproverIdFieldValue: Variant;
      function GetApproverIsForeignFieldValue: Boolean;
      function GetApproverLeaderIdFieldValue: Variant;
      function GetApprovingIsAccessibleFieldValue: Boolean;
      function GetApproverNameFieldValue: String;
      function GetApproverSpecialityFieldValue: String;
      function GetApprovingCycleIdFieldValue: Variant;
      function GetApprovingCycleNumberFieldValue: Variant;
      function GetApprovingIdFieldValue: Variant;
      function GetApprovingIsCompletedFieldValue: Boolean;
      function GetApprovingNoteFieldValue: String;
      function GetApprovingPerformingDateTimeFieldValue: Variant;
      function GetApprovingPerformingResultFieldValue: String;
      function GetApprovingPerformingResultIdFieldValue: Variant;
      function GetApprovingIsLookedByApproverFieldValue: Boolean;
      function GetChargeSheetViewDateByPerformerFieldValue: Variant;
      function GetChargeSheetDocumentIdFieldValue: Variant;
      function GetChargeSheetDocumentKindIdFieldValue: Variant;

    protected

      procedure SetDataSet(const Value: TDataSet); override;

    published

      property DocumentInfoHolder: TDocumentInfoHolder
      read FDocumentInfoHolder write SetDocumentInfoHolder;
      
      property ApprovingsInfoHolder: TDocumentApprovingsInfoHolder
      read FApprovingsInfoHolder write SetApprovingsInfoHolder;

      property ChargesInfoHolder: TDocumentChargesInfoHolder
      read FChargesInfoHolder write SetChargesInfoHolder;

      property ChargeSheetsInfoHolder: TDocumentChargeSheetsInfoHolder
      read FChargeSheetsInfoHolder write SetChargeSheetsInfoHolder;

      property RelationsInfoHolder: TDocumentRelationsInfoHolder
      read FRelationsInfoHolder write SetRelationsInfoHolder;

      property FilesInfoHolder: TDocumentFilesInfoHolder
      read FFilesInfoHolder write SetFilesInfoHolder;

      property FieldNames: TDocumentFullInfoDataSetFieldNames
      read GetFieldNames write SetFieldNames;
      
      property IdFieldValue: Variant
      read GetIdFieldValue;

      property BaseIdFieldValue: Variant
      read GetBaseIdFieldValue;

      property NumberFieldValue: String
      read GetNumberFieldValue;

      property NameFieldValue: String
      read GetNameFieldValue;

      property ContentFieldValue: String
      read GetContentFieldName;

      property NoteFieldValue: String
      read GetNoteFieldValue;

      property ProductCodeFieldValue: String
      read GetProductCodeFieldValue;
      
      property CreationDateFieldValue: TDateTime
      read GetCreationDateFieldValue;

      property DateFieldValue: Variant
      read GetDateFieldValue;
      
      property KindFieldValue: String
      read GetKindFieldValue;

      property KindIdFieldValue: Variant
      read GetKindIdFieldValue;

      property CurrentWorkCycleStageNameFieldValue: String
      read GetCurrentWorkCycleStageNameFieldValue;

      property CurrentWorkCycleStageNumberFieldValue: Integer
      read GetCurrentWorkCycleStageNumberFieldValue;

      property AuthorIdFieldValue: Variant
      read GetAuthorIdFieldValue;

      property AuthorLeaderIdFieldValue: Variant
      read GetAuthorLeaderIdFieldValue;

      property AuthorNameFieldValue: String
      read GetAuthorNameFieldValue;

      property AuthorSpecialityFieldValue: String
      read GetAuthorSpecialityFieldValue;
      
      property AuthorDepartmentIdFieldValue: Variant
      read GetAuthorDepartmentIdFieldValue;
      
      property AuthorDepartmentCodeFieldValue: String
      read GetAuthorDepartmentCodeFieldValue;

      property AuthorDepartmentNameFieldValue: String
      read GetAuthorDepartmentNameFieldValue;
      
      property ResponsibleIdFieldValue: Variant
      read GetResponsibleIdFieldValue;

      property ResponsibleNameFieldValue: String
      read GetResponsibleNameFieldValue;

      property ResponsibleTelephoneNumberFieldValue: String
      read GetResponsibleTelephoneNumberFieldValue;
      
      property ResponsibleDepartmentIdFieldValue: Variant
      read GetResponsibleDepartmentIdFieldValue;
      
      property ResponsibleDepartmentCodeFieldValue: String
      read GetResponsibleDepartmentCodeFieldValue;

      property ResponsibleDepartmentNameFieldValue: String
      read GetResponsibleDepartmentNameFieldValue;
      
      property SigningIdFieldValue: Variant
      read GetSigningIdFieldValue;

      property SigningDateFieldValue: Variant
      read GetSigningDateFieldValue;
      
      property SignerIdFieldValue: Variant
      read GetSignerIdFieldValue;

      property SignerLeaderIdFieldValue: Variant
      read GetSignerLeaderIdFieldValue;

      property SignerNameFieldValue: String
      read GetSignerNameFieldValue;

      property SignerSpecialityFieldValue: String
      read GetSignerSpecialityFieldValue;
      
      property SignerDepartmentIdFieldValue: Variant
      read GetSignerDepartmentIdFieldValue;
      
      property SignerDepartmentCodeFieldValue: String
      read GetSignerDepartmentCodeFieldValue;
      
      property SignerDepartmentNameFieldValue: String
      read GetSignerDepartmentNameFieldValue;

      property ActualSignerIdFieldValue: Variant
      read GetActualSignerIdFieldValue;

      property ActualSignerLeaderIdFieldValue: Variant
      read GetActualSignerLeaderIdFieldValue;

      property ActualSignerNameFieldValue: String
      read GetActualSignerNameFieldValue;

      property ActualSignerSpecialityFieldValue: String
      read GetActualSignerSpecialityFieldValue;
      
      property ActualSignerDepartmentIdFieldValue: Variant
      read GetActualSignerDepartmentIdFieldValue;
      
      property ActualSignerDepartmentCodeFieldValue: String
      read GetActualSignerDepartmentCodeFieldValue;
      
      property ActualSignerDepartmentNameFieldValue: String
      read GetActualSignerDepartmentNameFieldValue;
      
      property ChargeIdFieldValue: Variant
      read GetChargeIdFieldValue;
      
      property ChargeTextFieldValue: String
      read GetChargeTextFieldValue;

      property ChargeIsForAcquaitanceFieldValue: Boolean
      read GetChargeIsForAcquaitanceFieldValue;
      
      property ChargeResponseFieldValue: String
      read GetChargeResponseFieldValue;
      
      property ChargeTimeFrameStartFieldValue: Variant
      read GetChargeTimeFrameStartFieldValue;

      property ChargeTimeFrameDeadlineFieldValue: Variant
      read GetChargeTimeFrameDeadlineFieldValue;

      property ChargePerformingDateTimeFieldValue: Variant
      read GetChargePerformingDateTimeFieldValue;
      
      property ChargePerformerIdFieldValue: Variant
      read GetChargePerformerIdFieldValue;

      property ChargePerformerIsForeignFieldValue: Boolean
      read GetChargePerformerIsForeignFieldValue;
      
      property ChargePerformerNameFieldValue: String
      read GetChargePerformerNameFieldValue;
      
      property ChargePerformerSpecialityFieldValue: String
      read GetChargePerformerSpecialityFieldValue;
      
      property ChargePerformerDepartmentIdFieldValue: Variant
      read GetChargePerformerDepartmentIdFieldValue;
      
      property ChargePerformerDepartmentCodeFieldValue: String
      read GetChargePerformerDepartmentCodeFieldValue;
      
      property ChargePerformerDepartmentNameFieldValue: String
      read GetChargePerformerDepartmentNameFieldValue;

      property ChargeActualPerformerIdFieldValue: Variant
      read GetChargeActualPerformerIdFieldValue;

      property ChargeActualPerformerNameFieldValue: String
      read GetChargeActualPerformerNameFieldValue;
      
      property ChargeActualPerformerSpecialityFieldValue: String
      read GetChargeActualPerformerSpecialityFieldValue;
      
      property ChargeActualPerformerDepartmentIdFieldValue: Variant
      read GetChargeActualPerformerDepartmentIdFieldValue;
      
      property ChargeActualPerformerDepartmentCodeFieldValue: String
      read GetChargeActualPerformerDepartmentCodeFieldValue;
      
      property ChargeActualPerformerDepartmentNameFieldValue: String
      read GetChargeActualPerformerDepartmentNameFieldValue;
      
      property FileIdFieldValue: Variant
      read GetFileIdFieldValue;

      property FileNameFieldValue: String
      read GetFileNameFieldValue;

      property FilePathFieldValue: String
      read GetFilePathFieldValue;

      property RelationIdFieldValue: Variant
      read GetRelationIdFieldValue;
      
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
      
      property ChargeSheetIdFieldValue: Variant
      read GetChargeSheetIdFieldValue;

      property ChargeSheetDocumentIdFieldValue: Variant
      read GetChargeSheetDocumentIdFieldValue;

      property ChargeSheetDocumentKindIdFieldValue: Variant
      read GetChargeSheetDocumentKindIdFieldValue;

      property ChargeSheetChargeIdFieldValue: Variant
      read GetChargeSheetChargeIdFieldValue;
      
      property TopLevelChargeSheetIdFieldValue: Variant
      read GetTopLevelChargeSheetIdFieldValue;

      property ChargeSheetChargeTextFieldValue: String
      read GetChargeSheetChargeTextFieldValue;

      property IsSelfRegisteredFieldValue: Variant
      read GetIsSelfRegisteredFieldValue;
      
      property ChargeSheetResponseFieldValue: String
      read GetChargeSheetResponseFieldValue;

      property ChargeSheetIsForAcquaitanceFieldValue: Boolean
      read GetChargeSheetIsForAcquaitanceFieldValue;
      
      property ChargeSheetTimeFrameStartFieldValue: Variant
      read GetChargeSheetTimeFrameStartFieldValue;

      property ChargeSheetTimeFrameDeadlineFieldValue: Variant
      read GetChargeSheetTimeFrameDeadlineFieldValue;

      property ChargeSheetPerformingDateTimeFieldValue: Variant
      read GetChargeSheetPerformingDateTimeFieldValue;
      
      property ChargeSheetPerformerIdFieldValue: Variant
      read GetChargeSheetPerformerIdFieldValue;

      property ChargeSheetPerformerIsForeignFieldValue: Boolean
      read GetChargeSheetPerformerIsForeignFieldValue;

      property ChargeSheetPerformerNameFieldValue: String
      read GetChargeSheetPerformerNameFieldValue;
      
      property ChargeSheetPerformerSpecialityFieldValue: String
      read GetChargeSheetPerformerSpecialityFieldValue;
      
      property ChargeSheetPerformerDepartmentIdFieldValue: Variant
      read GetChargeSheetPerformerDepartmentIdFieldValue;
      
      property ChargeSheetPerformerDepartmentCodeFieldValue: String
      read GetChargeSheetPerformerDepartmentCodeFieldValue;
      
      property ChargeSheetPerformerDepartmentNameFieldValue: String
      read GetChargeSheetPerformerDepartmentNameFieldValue;

      property ChargeSheetActualPerformerIdFieldValue: Variant
      read GetChargeSheetActualPerformerIdFieldValue;

      property ChargeSheetActualPerformerNameFieldValue: String
      read GetChargeSheetActualPerformerNameFieldValue;
      
      property ChargeSheetActualPerformerSpecialityFieldValue: String
      read GetChargeSheetActualPerformerSpecialityFieldValue;
      
      property ChargeSheetActualPerformerDepartmentIdFieldValue: Variant
      read GetChargeSheetActualPerformerDepartmentIdFieldValue;
      
      property ChargeSheetActualPerformerDepartmentCodeFieldValue: String
      read GetChargeSheetActualPerformerDepartmentCodeFieldValue;
      
      property ChargeSheetActualPerformerDepartmentNameFieldValue: String
      read GetChargeSheetActualPerformerDepartmentNameFieldValue;

      property ChargeSheetIssuerIdFieldValue: Variant
      read GetChargeSheetIssuerIdFieldValue;
      
      property ChargeSheetIssuerIsForeignFieldValue: Boolean
      read GetChargeSheetIssuerIsForeignFieldValue;

      property ChargeSheetIssuerNameFieldValue: String
      read GetChargeSheetIssuerNameFieldValue;
      
      property ChargeSheetIssuerSpecialityFieldValue: String
      read GetChargeSheetIssuerSpecialityFieldValue;
      
      property ChargeSheetIssuerDepartmentIdFieldValue: Variant
      read GetChargeSheetIssuerDepartmentIdFieldValue;
      
      property ChargeSheetIssuerDepartmentCodeFieldValue: String
      read GetChargeSheetIssuerDepartmentCodeFieldValue;
      
      property ChargeSheetIssuerDepartmentNameFieldValue: String
      read GetChargeSheetIssuerDepartmentNameFieldValue;

      property ApprovingIdFieldValue: Variant
      read GetApprovingIdFieldValue;

      property ApprovingPerformingDateTimeFieldValue: Variant
      read GetApprovingPerformingDateTimeFieldValue;
      
      property ApprovingPerformingResultIdFieldValue: Variant
      read GetApprovingPerformingResultIdFieldValue;
      
      property ApprovingPerformingResultFieldValue: String
      read GetApprovingPerformingResultFieldValue;
      
      property ApprovingNoteFieldValue: String
      read GetApprovingNoteFieldValue;

      property ApprovingCycleIdFieldValue: Variant
      read GetApprovingCycleIdFieldValue;
      
      property ApprovingCycleNumberFieldValue: Variant
      read GetApprovingCycleNumberFieldValue;

      property ApprovingIsCompletedFieldValue: Boolean
      read GetApprovingIsCompletedFieldValue;

      property ApproverIdFieldValue: Variant
      read GetApproverIdFieldValue;
      
      property ApproverLeaderIdFieldValue: Variant
      read GetApproverLeaderIdFieldValue;
      
      property ApproverIsForeignFieldValue: Boolean
      read GetApproverIsForeignFieldValue;

      property ApproverNameFieldValue: String
      read GetApproverNameFieldValue;
      
      property ApproverSpecialityFieldValue: String
      read GetApproverSpecialityFieldValue;

      property ApprovingIsAccessibleFieldValue: Boolean
      read GetApprovingIsAccessibleFieldValue;
      
      property ApproverDepartmentIdFieldValue: Variant
      read GetApproverDepartmentIdFieldValue;
      
      property ApproverDepartmentCodeFieldValue: String
      read GetApproverDepartmentCodeFieldValue;
      
      property ApproverDepartmentNameFieldValue: String
      read GetApproverDepartmentNameFieldValue;

      property ActualApproverIdFieldValue: Variant
      read GetActualApproverIdFieldValue;

      property ActualApproverLeaderIdFieldValue: Variant
      read GetActualApproverLeaderIdFieldValue;
      
      property ActualApproverIsForeignFieldValue: Boolean
      read GetActualApproverIsForeignFieldValue;
      
      property ActualApproverNameFieldValue: String
      read GetActualApproverNameFieldValue;
      
      property ActualApproverSpecialityFieldValue: String
      read GetActualApproverSpecialityFieldValue;
      
      property ActualApproverDepartmentIdFieldValue: Variant
      read GetActualApproverDepartmentIdFieldValue;
      
      property ActualApproverDepartmentCodeFieldValue: String
      read GetActualApproverDepartmentCodeFieldValue;
      
      property ActualApproverDepartmentNameFieldValue: String
      read GetActualApproverDepartmentNameFieldValue;

      property ApprovingIsLookedByApproverFieldValue: Boolean
      read GetApprovingIsLookedByApproverFieldValue;

      property ChargeSheetViewDateByPerformerFieldValue: Variant
      read GetChargeSheetViewDateByPerformerFieldValue;

      property ChargeSheetIssuingDateTimeFieldValue: Variant
      read GetChargeSheetIssuingDateTimeFieldValue;

  end;

implementation

uses

  Variants,
  AuxDebugFunctionsUnit;
  
{ TDocumentFullInfoDataSetHolder }


function TDocumentFullInfoDataSetHolder.CreateApprovingsInfoHolder: TDocumentApprovingsInfoHolder;
begin

  Result := CreateApprovingsInfoHolderInstance;

  FieldNames.ApprovingsInfoFieldNames := Result.FieldNames;

end;

function TDocumentFullInfoDataSetHolder.CreateApprovingsInfoHolderInstance: TDocumentApprovingsInfoHolder;
begin

  Result := TDocumentApprovingsInfoHolder.Create;
  
end;

function TDocumentFullInfoDataSetHolder.CreateChargeSheetsInfoHolder: TDocumentChargeSheetsInfoHolder;
begin

  Result := CreateChargeSheetsInfoHolderInstance;

  FieldNames.ChargeSheetsInfoFieldNames := Result.FieldNames;
  
end;

function TDocumentFullInfoDataSetHolder.CreateChargeSheetsInfoHolderInstance: TDocumentChargeSheetsInfoHolder;
begin

  Result := TDocumentChargeSheetsInfoHolder.Create;
  
end;

function TDocumentFullInfoDataSetHolder.CreateChargesInfoHolder: TDocumentChargesInfoHolder;
begin

  Result := CreateChargesInfoHolderInstance;

  FieldNames.ChargesInfoFieldNames := Result.FieldNames;
  
end;

function TDocumentFullInfoDataSetHolder.CreateChargesInfoHolderInstance: TDocumentChargesInfoHolder;
begin

  Result := TDocumentChargesInfoHolder.Create;
  
end;

function TDocumentFullInfoDataSetHolder.CreateFilesInfoHolder: TDocumentFilesInfoHolder;
begin

  Result := CreateFilesInfoHolderInstance;

  FieldNames.FilesInfoFieldNames := Result.FieldNames;
  
end;

function TDocumentFullInfoDataSetHolder.CreateFilesInfoHolderInstance: TDocumentFilesInfoHolder;
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

function TDocumentFullInfoDataSetHolder.CreateRelationsInfoHolder: TDocumentRelationsInfoHolder;
begin

  Result := CreateRelationsInfoHolderInstance;

  FieldNames.RelationsInfoFieldNames := Result.FieldNames;
  
end;

function TDocumentFullInfoDataSetHolder.CreateRelationsInfoHolderInstance: TDocumentRelationsInfoHolder;
begin

  Result := TDocumentRelationsInfoHolder.Create;

end;

function TDocumentFullInfoDataSetHolder.GetBaseIdFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.BaseIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetChargeSheetIdFieldValue: Variant;
begin

  Result := FChargeSheetsInfoHolder.IdFieldValue;
            
end;

class function TDocumentFullInfoDataSetHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TDocumentFullInfoDataSetFieldNames;

end;

function TDocumentFullInfoDataSetHolder.GetActualApproverDepartmentCodeFieldValue: String;
begin

  Result := FApprovingsInfoHolder.ActualApproverDepartmentCodeFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetActualApproverDepartmentIdFieldValue: Variant;
begin

  Result := FApprovingsInfoHolder.ActualApproverDepartmentIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetActualApproverDepartmentNameFieldValue: String;
begin

  Result := FApprovingsInfoHolder.ActualApproverDepartmentNameFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetActualApproverIdFieldValue: Variant;
begin

  Result := FApprovingsInfoHolder.ActualApproverIdFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetActualApproverIsForeignFieldValue: Boolean;
begin

  Result := FApprovingsInfoHolder.ActualApproverIsForeignFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetActualApproverLeaderIdFieldValue: Variant;
begin

  Result := FApprovingsInfoHolder.ActualApproverLeaderIdFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetActualApproverNameFieldValue: String;
begin

  Result := FApprovingsInfoHolder.ActualApproverNameFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetActualApproverSpecialityFieldValue: String;
begin

  Result := FApprovingsInfoHolder.ActualApproverSpecialityFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetActualSignerDepartmentCodeFieldValue: String;
begin

  Result := FDocumentInfoHolder.ActualSignerDepartmentCodeFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetActualSignerDepartmentIdFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.ActualSignerDepartmentIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetActualSignerDepartmentNameFieldValue: String;
begin

  Result := FDocumentInfoHolder.ActualSignerDepartmentNameFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetActualSignerIdFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.ActualSignerIdFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetActualSignerLeaderIdFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.ActualSignerLeaderIdFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetActualSignerNameFieldValue: String;
begin

  Result := FDocumentInfoHolder.ActualSignerNameFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.
  GetActualSignerSpecialityFieldValue: String;
begin

  Result := FDocumentInfoHolder.ActualSignerSpecialityFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetApproverDepartmentCodeFieldValue: String;
begin

  Result := FApprovingsInfoHolder.ApproverDepartmentCodeFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetApproverDepartmentIdFieldValue: Variant;
begin

  Result := FApprovingsInfoHolder.ApproverDepartmentIdFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetApproverDepartmentNameFieldValue: String;
begin

  Result := FApprovingsInfoHolder.ApproverDepartmentNameFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetApproverIdFieldValue: Variant;
begin

  Result := FApprovingsInfoHolder.ApproverIdFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetApproverIsForeignFieldValue: Boolean;
begin

  Result := FApprovingsInfoHolder.ApproverIsForeignFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetApproverLeaderIdFieldValue: Variant;
begin

  Result := FApprovingsInfoHolder.ApproverLeaderIdFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetApproverNameFieldValue: String;
begin

  Result := FApprovingsInfoHolder.ApproverNameFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetApproverSpecialityFieldValue: String;
begin

  Result := FApprovingsInfoHolder.ApproverSpecialityFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetApprovingIsAccessibleFieldValue: Boolean;
begin

  Result := FApprovingsInfoHolder.IsAccessibleFieldValue;
    
end;

function TDocumentFullInfoDataSetHolder.GetApprovingCycleIdFieldValue: Variant;
begin

  Result := FApprovingsInfoHolder.CycleIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetApprovingCycleNumberFieldValue: Variant;
begin

  Result := FApprovingsInfoHolder.CycleNumberFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetApprovingIdFieldValue: Variant;
begin

  Result := FApprovingsInfoHolder.IdFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetApprovingIsCompletedFieldValue: Boolean;
begin

  Result := FApprovingsInfoHolder.IsCompletedFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetApprovingIsLookedByApproverFieldValue: Boolean;
begin

  Result := FApprovingsInfoHolder.IsLookedByApproverFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetApprovingNoteFieldValue: String;
begin

  Result := FApprovingsInfoHolder.NoteFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetApprovingPerformingDateTimeFieldValue: Variant;
begin

  Result := FApprovingsInfoHolder.PerformingDateTimeFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetApprovingPerformingResultFieldValue: String;
begin

  Result := FApprovingsInfoHolder.PerformingResultFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetApprovingPerformingResultIdFieldValue: Variant;
begin

  Result := FApprovingsInfoHolder.PerformingResultIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetAuthorDepartmentCodeFieldValue: String;
begin

  Result := FDocumentInfoHolder.AuthorDepartmentCodeFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetAuthorDepartmentIdFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.AuthorDepartmentIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetAuthorDepartmentNameFieldValue: String;
begin

  Result := FDocumentInfoHolder.AuthorDepartmentNameFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetAuthorIdFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.AuthorIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetAuthorLeaderIdFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.AuthorLeaderIdFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetAuthorNameFieldValue: String;
begin

  Result := FDocumentInfoHolder.AuthorNameFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetAuthorSpecialityFieldValue: String;
begin

  Result := FDocumentInfoHolder.AuthorSpecialityFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetChargeActualPerformerDepartmentCodeFieldValue: String;
begin

  Result := FChargesInfoHolder.ActualPerformerDepartmentCodeFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetChargeActualPerformerDepartmentIdFieldValue: Variant;
begin

  Result := FChargesInfoHolder.ActualPerformerDepartmentIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetChargeActualPerformerDepartmentNameFieldValue: String;
begin

  Result := FChargesInfoHolder.ActualPerformerDepartmentNameFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetChargeActualPerformerIdFieldValue: Variant;
begin

  Result := FChargesInfoHolder.ActualPerformerIdFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetChargeActualPerformerNameFieldValue: String;
begin

  Result := FChargesInfoHolder.ActualPerformerNameFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetChargeActualPerformerSpecialityFieldValue: String;
begin

  Result := FChargesInfoHolder.ActualPerformerSpecialityFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetChargeIdFieldValue: Variant;
begin

  Result := FChargesInfoHolder.IdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetChargeIsForAcquaitanceFieldValue: Boolean;
begin

  Result := FChargesInfoHolder.IsForAcquaitanceFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetChargePerformerDepartmentCodeFieldValue: String;
begin

  Result := FChargesInfoHolder.PerformerDepartmentCodeFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetChargePerformerDepartmentIdFieldValue: Variant;
begin

  Result := FChargesInfoHolder.PerformerDepartmentIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetChargePerformerDepartmentNameFieldValue: String;
begin

  Result := FChargesInfoHolder.PerformerDepartmentNameFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetChargePerformerIdFieldValue: Variant;
begin

  Result := FChargesInfoHolder.PerformerIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetChargePerformerIsForeignFieldValue: Boolean;
begin

  Result := FChargesInfoHolder.PerformerIsForeignFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetChargePerformerNameFieldValue: String;
begin

  Result := FChargesInfoHolder.PerformerNameFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetChargePerformerSpecialityFieldValue: String;
begin

  Result := FChargesInfoHolder.PerformerSpecialityFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetChargePerformingDateTimeFieldValue: Variant;
begin

  Result := FChargesInfoHolder.PerformingDateTimeFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetChargeTimeFrameDeadlineFieldValue: Variant;
begin

  Result := FChargesInfoHolder.TimeFrameDeadlineFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetChargeTimeFrameStartFieldValue: Variant;
begin

  Result := FChargesInfoHolder.TimeFrameStartFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetChargeResponseFieldValue: String;
begin

  Result := FChargesInfoHolder.ResponseFieldValue;

end;

function TDocumentFullInfoDataSetHolder.
  GetChargeSheetActualPerformerDepartmentCodeFieldValue: String;
begin

  Result := FChargeSheetsInfoHolder.ActualPerformerDepartmentCodeFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.
  GetChargeSheetActualPerformerDepartmentIdFieldValue: Variant;
begin

  Result := FChargeSheetsInfoHolder.ActualPerformerDepartmentIdFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.
  GetChargeSheetActualPerformerDepartmentNameFieldValue: String;
begin

  Result := FChargeSheetsInfoHolder.ActualPerformerDepartmentNameFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.
  GetChargeSheetActualPerformerIdFieldValue: Variant;
begin

  Result := FChargeSheetsInfoHolder.ActualPerformerIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.
  GetChargeSheetActualPerformerNameFieldValue: String;
begin

  Result := FChargeSheetsInfoHolder.ActualPerformerNameFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.
  GetChargeSheetActualPerformerSpecialityFieldValue: String;
begin

  Result := FChargeSheetsInfoHolder.ActualPerformerSpecialityFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetChargeSheetChargeIdFieldValue: Variant;
begin

  Result := FChargeSheetsInfoHolder.ChargeIdFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetChargeSheetIsForAcquaitanceFieldValue: Boolean;
begin

  Result := FChargeSheetsInfoHolder.IsForAcquaitanceFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetChargeSheetViewDateByPerformerFieldValue: Variant;
begin

  Result := FChargeSheetsInfoHolder.ViewDateByPerformerFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.
  GetChargeSheetIssuingDateTimeFieldValue: Variant;
begin

  Result := FChargeSheetsInfoHolder.IssuingDateTimeFieldValue;
    
end;

function TDocumentFullInfoDataSetHolder.
  GetChargeSheetPerformerDepartmentCodeFieldValue: String;
begin

  Result := FChargeSheetsInfoHolder.PerformerDepartmentCodeFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.
  GetChargeSheetPerformerDepartmentIdFieldValue: Variant;
begin

  Result := FChargeSheetsInfoHolder.PerformerDepartmentIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.
  GetChargeSheetPerformerDepartmentNameFieldValue: String;
begin

  Result := FChargeSheetsInfoHolder.PerformerDepartmentNameFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.
  GetChargeSheetPerformerIdFieldValue: Variant;
begin

  Result := FChargeSheetsInfoHolder.PerformerIdFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetChargeSheetPerformerIsForeignFieldValue: Boolean;
begin

  Result := FChargeSheetsInfoHolder.PerformerIsForeignFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.
  GetChargeSheetPerformerNameFieldValue: String;
begin

  Result := FChargeSheetsInfoHolder.PerformerNameFieldValue;

end;

function TDocumentFullInfoDataSetHolder.
  GetChargeSheetPerformerSpecialityFieldValue: String;
begin

  Result := FChargeSheetsInfoHolder.PerformerSpecialityFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.
  GetChargeSheetPerformingDateTimeFieldValue: Variant;
begin

  Result := FChargeSheetsInfoHolder.PerformingDateTimeFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.
  GetChargeSheetTimeFrameDeadlineFieldValue: Variant;
begin

  Result := FChargeSheetsInfoHolder.TimeFrameDeadlineFieldValue;

end;

function TDocumentFullInfoDataSetHolder.
  GetChargeSheetTimeFrameStartFieldValue: Variant;
begin

  Result := FChargeSheetsInfoHolder.TimeFrameStartFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.
  GetChargeSheetResponseFieldValue: String;
begin

  Result := FChargeSheetsInfoHolder.ResponseFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.
  GetChargeSheetIssuerDepartmentCodeFieldValue: String;
begin

  Result := FChargeSheetsInfoHolder.IssuerDepartmentCodeFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.
  GetChargeSheetIssuerDepartmentIdFieldValue: Variant;
begin

  Result := FChargeSheetsInfoHolder.IssuerDepartmentIdFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.
  GetChargeSheetIssuerDepartmentNameFieldValue: String;
begin

  Result := FChargeSheetsInfoHolder.IssuerDepartmentNameFieldValue;

end;

function TDocumentFullInfoDataSetHolder.
  GetChargeSheetIssuerIdFieldValue: Variant;
begin

  Result := FChargeSheetsInfoHolder.IssuerIdFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetChargeSheetIssuerIsForeignFieldValue: Boolean;
begin

  Result := FChargeSheetsInfoHolder.IssuerIsForeignFieldValue;
  
end;


function TDocumentFullInfoDataSetHolder.
  GetChargeSheetIssuerNameFieldValue: String;
begin

  Result := FChargeSheetsInfoHolder.IssuerNameFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.
  GetChargeSheetIssuerSpecialityFieldValue: String;
begin

  Result := FChargeSheetsInfoHolder.IssuerSpecialityFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.
  GetChargeSheetChargeTextFieldValue: String;
begin

  Result := FChargeSheetsInfoHolder.ChargeTextFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetChargeSheetDocumentIdFieldValue: Variant;
begin

  Result := FChargeSheetsInfoHolder.DocumentIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetChargeSheetDocumentKindIdFieldValue: Variant;
begin

  Result := FChargeSheetsInfoHolder.DocumentKindIdFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetChargeTextFieldValue: String;
begin

  Result := FChargesInfoHolder.ChargeTextFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetContentFieldName: String;
begin

  Result := FDocumentInfoHolder.ContentFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetCreationDateFieldValue: TDateTime;
begin

  Result := FDocumentInfoHolder.CreationDateFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetCurrentWorkCycleStageNameFieldValue: String;
begin

  Result := FDocumentInfoHolder.CurrentWorkCycleStageNameFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetCurrentWorkCycleStageNumberFieldValue: Integer;
begin

  Result := FDocumentInfoHolder.CurrentWorkCycleStageNumberFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetDateFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.DateFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetFileIdFieldValue: Variant;
begin

  Result := FFilesInfoHolder.IdFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetFileNameFieldValue: String;
begin

  Result := FFilesInfoHolder.NameFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetFilePathFieldValue: String;
begin

  Result := FFilesInfoHolder.PathFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetIdFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.IdFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetIsSelfRegisteredFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.IsSelfRegisteredFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetKindFieldValue: String;
begin

  Result := FDocumentInfoHolder.KindFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetKindIdFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.KindIdFieldValue;
            
end;

function TDocumentFullInfoDataSetHolder.GetNameFieldValue: String;
begin

  Result := FDocumentInfoHolder.NameFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetNoteFieldValue: String;
begin

  Result := FDocumentInfoHolder.NoteFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetNumberFieldValue: String;
begin

  Result := FDocumentInfoHolder.NumberFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetProductCodeFieldValue: String;
begin

  Result := FDocumentInfoHolder.ProductCodeFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetRelationIdFieldValue: Variant;
begin

  Result := FRelationsInfoHolder.RelationIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetResponsibleDepartmentCodeFieldValue: String;
begin

  Result := FDocumentInfoHolder.ResponsibleDepartmentCodeFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetResponsibleDepartmentIdFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.ResponsibleDepartmentIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetResponsibleDepartmentNameFieldValue: String;
begin

  Result := FDocumentInfoHolder.ResponsibleDepartmentNameFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetResponsibleIdFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.ResponsibleIdFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetResponsibleNameFieldValue: String;
begin

  Result := FDocumentInfoHolder.ResponsibleNameFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetResponsibleTelephoneNumberFieldValue: String;
begin

  Result := FDocumentInfoHolder.ResponsibleTelephoneNumberFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetSignerDepartmentCodeFieldValue: String;
begin

  Result := FDocumentInfoHolder.SignerDepartmentCodeFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetSignerDepartmentIdFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.SignerDepartmentIdFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetSignerDepartmentNameFieldValue: String;
begin

  Result := FDocumentInfoHolder.SignerDepartmentNameFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetSignerIdFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.SignerIdFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetSignerLeaderIdFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.SignerLeaderIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetSignerNameFieldValue: String;
begin

  Result := FDocumentInfoHolder.SignerNameFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetSignerSpecialityFieldValue: String;
begin

  Result := FDocumentInfoHolder.SignerSpecialityFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetSigningDateFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.SigningDateFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetSigningIdFieldValue: Variant;
begin

  Result := FDocumentInfoHolder.SigningIdFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetFieldNames: TDocumentFullInfoDataSetFieldNames;
begin

  Result := TDocumentFullInfoDataSetFieldNames(inherited FieldDefs);
  
end;

function TDocumentFullInfoDataSetHolder.GetRelatedDocumentDateFieldValue: TDateTime;
begin

  Result := FRelationsInfoHolder.RelatedDocumentDateFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetRelatedDocumentIdFieldValue: Variant;
begin

  Result := FRelationsInfoHolder.RelatedDocumentIdFieldValue;

end;

function TDocumentFullInfoDataSetHolder.GetRelatedDocumentKindIdFieldValue: Variant;
begin

  Result := FRelationsInfoHolder.RelatedDocumentKindIdFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetRelatedDocumentKindNameFieldValue: String;
begin

  Result := FRelationsInfoHolder.RelatedDocumentKindNameFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetRelatedDocumentNameFieldValue: String;
begin

  Result := FRelationsInfoHolder.RelatedDocumentNameFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetRelatedDocumentNumberFieldValue: String;
begin

  Result := FRelationsInfoHolder.RelatedDocumentNumberFieldValue;
  
end;

function TDocumentFullInfoDataSetHolder.GetTopLevelChargeSheetIdFieldValue: Variant;
begin

  Result := FChargeSheetsInfoHolder.TopLevelChargeSheetIdFieldValue;

end;

procedure TDocumentFullInfoDataSetHolder.Initialize;
begin

  inherited Initialize;

  FDocumentInfoHolder := CreateDocumentInfoHolder;
  FApprovingsInfoHolder := CreateApprovingsInfoHolder;
  FChargesInfoHolder := CreateChargesInfoHolder;
  FChargeSheetsInfoHolder := CreateChargeSheetsInfoHolder;
  FRelationsInfoHolder := CreateRelationsInfoHolder;
  FFilesInfoHolder := CreateFilesInfoHolder;
  
end;

procedure TDocumentFullInfoDataSetHolder.SetDataSet(const Value: TDataSet);
begin

  inherited;

  if Assigned(FDocumentInfoHolder) then
    FDocumentInfoHolder.DataSet := Value;

  if Assigned(FApprovingsInfoHolder) then
    FApprovingsInfoHolder.DataSet := Value;

  if Assigned(FChargesInfoHolder) then
    FChargesInfoHolder.DataSet := Value;

  if Assigned(FChargeSheetsInfoHolder) then
    FChargeSheetsInfoHolder.DataSet := Value;

  if Assigned(FRelationsInfoHolder) then
    FRelationsInfoHolder.DataSet := Value;

  if Assigned(FFilesInfoHolder) then
    FFilesInfoHolder.DataSet := Value;
    
end;

procedure TDocumentFullInfoDataSetHolder.SetApprovingsInfoHolder(
  const Value: TDocumentApprovingsInfoHolder);
begin

  FApprovingsInfoHolder := Value;
  FFreeApprovingsInfoHolder := Value;

  UpdateDataSet(Value);
  
end;

procedure TDocumentFullInfoDataSetHolder.SetChargeSheetsInfoHolder(
  const Value: TDocumentChargeSheetsInfoHolder);
begin

  FChargeSheetsInfoHolder := Value;
  FFreeChargeSheetsInfoHolder := Value;

  UpdateDataSet(Value);

end;

procedure TDocumentFullInfoDataSetHolder.SetChargesInfoHolder(
  const Value: TDocumentChargesInfoHolder);
begin

  FChargesInfoHolder := Value;
  FFreeChargesInfoHolder := Value;

  UpdateDataSet(Value);
  
end;

procedure TDocumentFullInfoDataSetHolder.SetFilesInfoHolder(
  const Value: TDocumentFilesInfoHolder);
begin

  FFilesInfoHolder := Value;
  FFreeFilesInfoHolder := Value;

  UpdateDataSet(Value);

end;

procedure TDocumentFullInfoDataSetHolder.SetDocumentInfoHolder(
  const Value: TDocumentInfoHolder);
begin

  FDocumentInfoHolder := Value;
  FFreeDocumentInfoHolder := Value;

  UpdateDataSet(Value);
  
end;

procedure TDocumentFullInfoDataSetHolder.SetRelationsInfoHolder(
  const Value: TDocumentRelationsInfoHolder);
begin

  FRelationsInfoHolder := Value;
  FFreeRelationsInfoHolder := FRelationsInfoHolder;

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

function TDocumentFullInfoDataSetFieldNames.GetBaseIdFieldName: String;
begin

  Result := FDocumentInfoFieldNames.BaseIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetChargeSheetIdFieldName: String;
begin

  Result := FChargeSheetsInfoFieldNames.IdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetActualApproverDepartmentCodeFieldName: String;
begin

  Result := FApprovingsInfoFieldNames.ActualApproverDepartmentCodeFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetActualApproverDepartmentIdFieldName: String;
begin

  Result := FApprovingsInfoFieldNames.ActualApproverDepartmentIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetActualApproverDepartmentNameFieldName: String;
begin

  Result := FApprovingsInfoFieldNames.ActualApproverDepartmentNameFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetActualApproverIdFieldName: String;
begin

  Result := FApprovingsInfoFieldNames.ActualApproverIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetActualApproverIsForeignFieldName: String;
begin

  Result := FApprovingsInfoFieldNames.ActualApproverIsForeignFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetActualApproverLeaderIdFieldName: String;
begin

  Result := FApprovingsInfoFieldNames.ActualApproverLeaderIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetActualApproverNameFieldName: String;
begin

  Result := FApprovingsInfoFieldNames.ActualApproverNameFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetActualApproverSpecialityFieldName: String;
begin

  Result := FApprovingsInfoFieldNames.ActualApproverSpecialityFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetActualSignerDepartmentCodeFieldName: String;
begin

  Result := FDocumentInfoFieldNames.ActualSignerDepartmentCodeFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetActualSignerDepartmentIdFieldName: String;
begin

  Result := FDocumentInfoFieldNames.ActualSignerDepartmentIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetActualSignerDepartmentNameFieldName: String;
begin

  Result := FDocumentInfoFieldNames.ActualSignerDepartmentNameFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetActualSignerIdFieldName: String;
begin

  Result := FDocumentInfoFieldNames.ActualSignerIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetActualSignerLeaderIdFieldName: String;
begin

  Result := FDocumentInfoFieldNames.ActualSignerLeaderIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetActualSignerNameFieldName: String;
begin

  Result := FDocumentInfoFieldNames.ActualSignerNameFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetActualSignerSpecialityFieldName: String;
begin

  Result := FDocumentInfoFieldNames.ActualSignerSpecialityFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetApproverDepartmentCodeFieldName: String;
begin

  Result := FApprovingsInfoFieldNames.ApproverDepartmentCodeFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetApproverDepartmentIdFieldName: String;
begin

  Result := FApprovingsInfoFieldNames.ApproverDepartmentIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetApproverDepartmentNameFieldName: String;
begin

  Result := FApprovingsInfoFieldNames.ApproverDepartmentNameFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetApproverIdFieldName: String;
begin

  Result := FApprovingsInfoFieldNames.ApproverIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetApproverIsForeignFieldName: String;
begin

  Result := FApprovingsInfoFieldNames.ApproverIsForeignFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetApproverLeaderIdFieldName: String;
begin

  Result := FApprovingsInfoFieldNames.ApproverLeaderIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetApproverNameFieldName: String;
begin

  Result := FApprovingsInfoFieldNames.ApproverNameFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetApproverSpecialityFieldName: String;
begin

  Result := FApprovingsInfoFieldNames.ApproverSpecialityFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetApprovingCycleIdFieldName: String;
begin

  Result := FApprovingsInfoFieldNames.CycleIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetApprovingCycleNumberFieldName: String;
begin

  Result := FApprovingsInfoFieldNames.CycleNumberFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetApprovingIdFieldName: String;
begin

  Result := FApprovingsInfoFieldNames.IdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetApprovingIsAccessibleFieldName: String;
begin

  Result := FApprovingsInfoFieldNames.IsAccessibleFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetApprovingIsCompletedFieldName: String;
begin

  Result := FApprovingsInfoFieldNames.IsCompletedFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetApprovingIsLookedByApproverFieldName: String;
begin

  Result := FApprovingsInfoFieldNames.IsLookedByApproverFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetApprovingNoteFieldName: String;
begin

  Result := FApprovingsInfoFieldNames.NoteFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetApprovingPerformingDateTimeFieldName: String;
begin

  Result := FApprovingsInfoFieldNames.PerformingDateTimeFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetApprovingPerformingResultFieldName: String;
begin

  Result := FApprovingsInfoFieldNames.PerformingResultFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetApprovingPerformingResultIdFieldName: String;
begin

  Result := FApprovingsInfoFieldNames.PerformingResultIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetAuthorDepartmentCodeFieldName: String;
begin

  Result := FDocumentInfoFieldNames.AuthorDepartmentCodeFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetAuthorDepartmentIdFieldName: String;
begin

  Result := FDocumentInfoFieldNames.AuthorDepartmentIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetAuthorDepartmentNameFieldName: String;
begin

  Result := FDocumentInfoFieldNames.AuthorDepartmentNameFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetAuthorIdFieldName: String;
begin

  Result := FDocumentInfoFieldNames.AuthorIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetAuthorLeaderIdFieldName: String;
begin

  Result := FDocumentInfoFieldNames.AuthorLeaderIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetAuthorNameFieldName: String;
begin

  Result := FDocumentInfoFieldNames.AuthorNameFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetAuthorSpecialityFieldName: String;
begin

  Result := FDocumentInfoFieldNames.AuthorSpecialityFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetChargeActualPerformerDepartmentCodeFieldName: String;
begin

  Result := FChargesInfoFieldNames.ActualPerformerDepartmentCodeFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetChargeActualPerformerDepartmentIdFieldName: String;
begin

  Result := FChargesInfoFieldNames.ActualPerformerDepartmentIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetChargeActualPerformerDepartmentNameFieldName: String;
begin

  Result := FChargesInfoFieldNames.ActualPerformerDepartmentNameFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetChargeActualPerformerIdFieldName: String;
begin

  Result := FChargesInfoFieldNames.ActualPerformerIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetChargeActualPerformerNameFieldName: String;
begin

  Result := FChargesInfoFieldNames.ActualPerformerNameFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetChargeActualPerformerSpecialityFieldName: String;
begin

  Result := FChargesInfoFieldNames.ActualPerformerSpecialityFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetChargeIdFieldName: String;
begin

  Result := FChargesInfoFieldNames.IdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetChargeIsForAcquaitanceFieldName: String;
begin

  Result := FChargesInfoFieldNames.IsForAcquaitanceFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetChargePerformerDepartmentCodeFieldName: String;
begin

  Result := FChargesInfoFieldNames.PerformerDepartmentCodeFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetChargePerformerDepartmentIdFieldName: String;
begin

  Result := FChargesInfoFieldNames.PerformerDepartmentIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetChargePerformerDepartmentNameFieldName: String;
begin

  Result := FChargesInfoFieldNames.PerformerDepartmentNameFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetChargePerformerIdFieldName: String;
begin

  Result := FChargesInfoFieldNames.PerformerIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetChargePerformerIsForeignFieldName: String;
begin

  Result := FChargesInfoFieldNames.PerformerIsForeignFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetChargePerformerNameFieldName: String;
begin

  Result := FChargesInfoFieldNames.PerformerNameFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetChargePerformerSpecialityFieldName: String;
begin

  Result := FChargesInfoFieldNames.PerformerSpecialityFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetChargePerformingDateTimeFieldName: String;
begin

  Result := FChargesInfoFieldNames.PerformingDateTimeFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetChargeTimeFrameDeadlineFieldName: String;
begin

  Result := FChargesInfoFieldNames.TimeFrameDeadlineFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetChargeTimeFrameStartFieldName: String;
begin

  Result := FChargesInfoFieldNames.TimeFrameStartFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetChargeResponseFieldName: String;
begin

  Result := FChargesInfoFieldNames.ResponseFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetChargeSheetActualPerformerDepartmentCodeFieldName: String;
begin

  Result := FChargeSheetsInfoFieldNames.ActualPerformerDepartmentCodeFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetChargeSheetActualPerformerDepartmentIdFieldName: String;
begin

  Result := FChargeSheetsInfoFieldNames.ActualPerformerDepartmentIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetChargeSheetActualPerformerDepartmentNameFieldName: String;
begin

  Result := FChargeSheetsInfoFieldNames.ActualPerformerDepartmentNameFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetChargeSheetActualPerformerIdFieldName: String;
begin

  Result := FChargeSheetsInfoFieldNames.ActualPerformerIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetChargeSheetActualPerformerNameFieldName: String;
begin

  Result := FChargeSheetsInfoFieldNames.ActualPerformerNameFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetChargeSheetActualPerformerSpecialityFieldName: String;
begin

  Result := FChargeSheetsInfoFieldNames.ActualPerformerSpecialityFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetChargeSheetIsForAcquaitanceFieldName: String;
begin

  Result := FChargeSheetsInfoFieldNames.IsForAcquaitanceFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetChargeSheetIssuingDateTimeFieldName: String;
begin

  Result := FChargeSheetsInfoFieldNames.IssuingDateTimeFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetChargeSheetPerformerDepartmentCodeFieldName: String;
begin

  Result := FChargeSheetsInfoFieldNames.PerformerDepartmentCodeFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetChargeSheetPerformerDepartmentIdFieldName: String;
begin

  Result := FChargeSheetsInfoFieldNames.PerformerDepartmentIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetChargeSheetPerformerDepartmentNameFieldName: String;
begin

  Result := FChargeSheetsInfoFieldNames.PerformerDepartmentNameFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetChargeSheetPerformerIdFieldName: String;
begin

  Result := FChargeSheetsInfoFieldNames.PerformerIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetChargeSheetPerformerIsForeignFieldName: String;
begin

  Result := FChargeSheetsInfoFieldNames.PerformerIsForeignFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetChargeSheetPerformerNameFieldName: String;
begin

  Result := FChargeSheetsInfoFieldNames.PerformerNameFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetChargeSheetPerformerSpecialityFieldName: String;
begin

  Result := FChargeSheetsInfoFieldNames.PerformerSpecialityFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetChargeSheetPerformingDateTimeFieldName: String;
begin

  Result := FChargeSheetsInfoFieldNames.PerformingDateTimeFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetChargeSheetTimeFrameDeadlineFieldName: String;
begin

  Result := FChargeSheetsInfoFieldNames.TimeFrameDeadlineFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetChargeSheetTimeFrameStartFieldName: String;
begin

  Result := FChargeSheetsInfoFieldNames.TimeFrameStartFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetChargeSheetResponseFieldName: String;
begin

  Result := FChargeSheetsInfoFieldNames.ResponseFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetChargeSheetIssuerDepartmentCodeFieldName: String;
begin

  Result := FChargeSheetsInfoFieldNames.IssuerDepartmentCodeFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetChargeSheetIssuerDepartmentIdFieldName: String;
begin

  Result := FChargeSheetsInfoFieldNames.IssuerDepartmentIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetChargeSheetIssuerDepartmentNameFieldName: String;
begin

  Result := FChargeSheetsInfoFieldNames.IssuerDepartmentNameFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetChargeSheetIssuerIdFieldName: String;
begin

  Result := FChargeSheetsInfoFieldNames.IssuerIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetChargeSheetIssuerIsForeignFieldName: String;
begin

  Result := FChargeSheetsInfoFieldNames.IssuerIsForeignFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetChargeSheetIssuerNameFieldName: String;
begin

  Result := FChargeSheetsInfoFieldNames.IssuerNameFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetChargeSheetIssuerSpecialityFieldName: String;
begin

  Result := FChargeSheetsInfoFieldNames.IssuerSpecialityFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetChargeSheetChargeTextFieldName: String;
begin

  Result := FChargeSheetsInfoFieldNames.ChargeTextFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetChargeSheetChargeIdFieldName: String;
begin

  Result := FChargeSheetsInfoFieldNames.ChargeIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetChargeSheetDocumentIdFieldName: String;
begin

  Result := FChargeSheetsInfoFieldNames.DocumentIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetChargeSheetDocumentKindIdFieldName: String;
begin

  Result := FChargeSheetsInfoFieldNames.DocumentKindIdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetChargeSheetViewDateByPerformerFieldName: String;
begin

  Result := FChargeSheetsInfoFieldNames.ViewDateByPerformerFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetChargeChargeTextFieldName: String;
begin

  Result := FChargesInfoFieldNames.ChargeTextFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetContentFieldName: String;
begin

  Result := FDocumentInfoFieldNames.ContentFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetCreationDateFieldName: String;
begin

  Result := FDocumentInfoFieldNames.CreationDateFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetCurrentWorkCycleStageNameFieldName: String;
begin

  Result := FDocumentInfoFieldNames.CurrentWorkCycleStageNameFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetCurrentWorkCycleStageNumberFieldName: String;
begin

  Result := FDocumentInfoFieldNames.CurrentWorkCycleStageNumberFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetDateFieldName: String;
begin

  Result := FDocumentInfoFieldNames.DateFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetFileIdFieldName: String;
begin

  Result := FFilesInfoFieldNames.IdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetFileNameFieldName: String;
begin

  Result := FFilesInfoFieldNames.NameFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetFilePathFieldName: String;
begin

  Result := FFilesInfoFieldNames.PathFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetIdFieldName: String;
begin

  Result := FDocumentInfoFieldNames.IdFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetIsSelfRegisteredFieldName: String;
begin

  Result := FDocumentInfoFieldNames.IsSelfRegisteredFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetKindFieldName: String;
begin

  Result := FDocumentInfoFieldNames.KindFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetKindIdFieldName: String;
begin

  Result := FDocumentInfoFieldNames.KindIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetNameFieldName: String;
begin

  Result := FDocumentInfoFieldNames.NameFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetNoteFieldName: String;
begin

  Result := FDocumentInfoFieldNames.NoteFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetNumberFieldName: String;
begin

  Result := FDocumentInfoFieldNames.NumberFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetProductCodeFieldName: String;
begin

  Result := FDocumentInfoFieldNames.ProductCodeFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetRelationIdFieldName: String;
begin

  Result := FRelationsInfoFieldNames.RelationIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetResponsibleDepartmentCodeFieldName: String;
begin

  Result := FDocumentInfoFieldNames.ResponsibleDepartmentCodeFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetResponsibleDepartmentIdFieldName: String;
begin

  Result := FDocumentInfoFieldNames.ResponsibleDepartmentIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetResponsibleDepartmentNameFieldName: String;
begin

  Result := FDocumentInfoFieldNames.ResponsibleDepartmentNameFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetResponsibleIdFieldName: String;
begin

  Result := FDocumentInfoFieldNames.ResponsibleIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetResponsibleNameFieldName: String;
begin

  Result := FDocumentInfoFieldNames.ResponsibleNameFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetResponsibleTelephoneNumberFieldName: String;
begin

  Result := FDocumentInfoFieldNames.ResponsibleTelephoneNumberFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetSignerDepartmentCodeFieldName: String;
begin

  Result := FDocumentInfoFieldNames.SignerDepartmentCodeFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetSignerDepartmentIdFieldName: String;
begin

  Result := FDocumentInfoFieldNames.SignerDepartmentIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetSignerDepartmentNameFieldName: String;
begin

  Result := FDocumentInfoFieldNames.SignerDepartmentNameFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetSignerIdFieldName: String;
begin

  Result := FDocumentInfoFieldNames.SignerIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetSignerLeaderIdFieldName: String;
begin

  Result := FDocumentInfoFieldNames.SignerLeaderIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetSignerNameFieldName: String;
begin

  Result := FDocumentInfoFieldNames.SignerNameFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetSignerSpecialityFieldName: String;
begin

  Result := FDocumentInfoFieldNames.SignerSpecialityFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetSigningDateFieldName: String;
begin

  Result := FDocumentInfoFieldNames.SigningDateFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetSigningIdFieldName: String;
begin

  Result := FDocumentInfoFieldNames.SigningIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetRelatedDocumentDateFieldName: String;
begin

  Result := FRelationsInfoFieldNames.RelatedDocumentDateFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetRelatedDocumentIdFieldName: String;
begin

  Result := FRelationsInfoFieldNames.RelatedDocumentIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetRelatedDocumentKindIdFieldName: String;
begin

  Result := FRelationsInfoFieldNames.RelatedDocumentKindIdFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetRelatedDocumentKindNameFieldName: String;
begin

  Result := FRelationsInfoFieldNames.RelatedDocumentKindNameFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetRelatedDocumentNameFieldName: String;
begin

  Result := FRelationsInfoFieldNames.RelatedDocumentNameFieldName;
  
end;

function TDocumentFullInfoDataSetFieldNames.GetRelatedDocumentNumberFieldName: String;
begin

  Result := FRelationsInfoFieldNames.RelatedDocumentNumberFieldName;

end;

function TDocumentFullInfoDataSetFieldNames.GetTopLevelChargeSheetIdFieldName: String;
begin

  Result := FChargeSheetsInfoFieldNames.TopLevelChargeSheetIdFieldName;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetBaseIdFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.BaseIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeSheetIdFieldName(
  const Value: String);
begin

  FChargeSheetsInfoFieldNames.IdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetActualApproverDepartmentCodeFieldName(
  const Value: String);
begin

  FApprovingsInfoFieldNames.ActualApproverDepartmentCodeFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetActualApproverDepartmentIdFieldName(
  const Value: String);
begin

  FApprovingsInfoFieldNames.ActualApproverDepartmentIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetActualApproverDepartmentNameFieldName(
  const Value: String);
begin

  FApprovingsInfoFieldNames.ActualApproverDepartmentNameFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetActualApproverIdFieldName(
  const Value: String);
begin

  FApprovingsInfoFieldNames.ActualApproverIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetActualApproverIsForeignFieldName(
  const Value: String);
begin

  FApprovingsInfoFieldNames.ActualApproverIsForeignFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetActualApproverLeaderIdFieldName(
  const Value: String);
begin

  FApprovingsInfoFieldNames.ActualApproverLeaderIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetActualApproverNameFieldName(
  const Value: String);
begin

  FApprovingsInfoFieldNames.ActualApproverNameFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetActualApproverSpecialityFieldName(
  const Value: String);
begin

  FApprovingsInfoFieldNames.ActualApproverSpecialityFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetActualSignerDepartmentCodeFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.ActualSignerDepartmentCodeFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetActualSignerDepartmentIdFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.ActualSignerDepartmentIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetActualSignerDepartmentNameFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.ActualSignerDepartmentNameFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetActualSignerIdFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.ActualSignerIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetActualSignerLeaderIdFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.ActualSignerLeaderIdFieldName := Value;
end;

procedure TDocumentFullInfoDataSetFieldNames.SetActualSignerNameFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.ActualSignerNameFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetActualSignerSpecialityFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.ActualSignerSpecialityFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetApproverDepartmentCodeFieldName(
  const Value: String);
begin

  FApprovingsInfoFieldNames.ApproverDepartmentCodeFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetApproverDepartmentIdFieldName(
  const Value: String);
begin

  FApprovingsInfoFieldNames.ApproverDepartmentIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetApproverDepartmentNameFieldName(
  const Value: String);
begin

  FApprovingsInfoFieldNames.ApproverDepartmentNameFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetApproverIdFieldName(
  const Value: String);
begin

  FApprovingsInfoFieldNames.ApproverIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetApproverIsForeignFieldName(
  const Value: String);
begin

  FApprovingsInfoFieldNames.ApproverIsForeignFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetApproverLeaderIdFieldName(
  const Value: String);
begin

  FApprovingsInfoFieldNames.ApproverLeaderIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetApproverNameFieldName(
  const Value: String);
begin

  FApprovingsInfoFieldNames.ApproverNameFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetApproverSpecialityFieldName(
  const Value: String);
begin

  FApprovingsInfoFieldNames.ApproverSpecialityFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetApprovingCycleIdFieldName(
  const Value: String);
begin

  FApprovingsInfoFieldNames.CycleIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetApprovingCycleNumberFieldName(
  const Value: String);
begin

  FApprovingsInfoFieldNames.CycleNumberFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetApprovingIdFieldName(
  const Value: String);
begin

  FApprovingsInfoFieldNames.IdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetApprovingIsAccessibleFieldName(
  const Value: String);
begin

  FApprovingsInfoFieldNames.IsAccessibleFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetApprovingIsCompletedFieldName(
  const Value: String);
begin

  FApprovingsInfoFieldNames.IsCompletedFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetApprovingIsLookedByApproverFieldName(
  const Value: String);
begin

  FApprovingsInfoFieldNames.IsLookedByApproverFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetApprovingNoteFieldName(
  const Value: String);
begin

  FApprovingsInfoFieldNames.NoteFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetApprovingPerformingDateTimeFieldName(
  const Value: String);
begin

  FApprovingsInfoFieldNames.PerformingDateTimeFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetApprovingPerformingResultFieldName(
  const Value: String);
begin

  FApprovingsInfoFieldNames.PerformingResultFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetApprovingPerformingResultIdFieldName(
  const Value: String);
begin

  FApprovingsInfoFieldNames.PerformingResultIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetAuthorDepartmentCodeFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.AuthorDepartmentCodeFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetAuthorDepartmentIdFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.AuthorDepartmentIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetAuthorDepartmentNameFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.AuthorDepartmentNameFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetAuthorIdFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.AuthorIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetAuthorLeaderIdFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.AuthorLeaderIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetAuthorNameFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.AuthorNameFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetAuthorSpecialityFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.AuthorSpecialityFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeActualPerformerDepartmentCodeFieldName(
  const Value: String);
begin

  FChargesInfoFieldNames.ActualPerformerDepartmentCodeFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeActualPerformerDepartmentIdFieldName(
  const Value: String);
begin

  FChargesInfoFieldNames.ActualPerformerDepartmentIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeActualPerformerDepartmentNameFieldName(
  const Value: String);
begin

  FChargesInfoFieldNames.ActualPerformerDepartmentNameFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeActualPerformerIdFieldName(
  const Value: String);
begin

  FChargesInfoFieldNames.ActualPerformerIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeActualPerformerNameFieldName(
  const Value: String);
begin

  FChargesInfoFieldNames.ActualPerformerNameFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeActualPerformerSpecialityFieldName(
  const Value: String);
begin

  FChargesInfoFieldNames.ActualPerformerSpecialityFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeIdFieldName(
  const Value: String);
begin

  FChargesInfoFieldNames.IdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeIsForAcquaitanceFieldName(
  const Value: String);
begin

  FChargesInfoFieldNames.IsForAcquaitanceFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargePerformerDepartmentCodeFieldName(
  const Value: String);
begin

  FChargesInfoFieldNames.PerformerDepartmentCodeFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargePerformerDepartmentIdFieldName(
  const Value: String);
begin

  FChargesInfoFieldNames.PerformerDepartmentIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargePerformerDepartmentNameFieldName(
  const Value: String);
begin

  FChargesInfoFieldNames.PerformerDepartmentNameFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargePerformerIdFieldName(
  const Value: String);
begin

  FChargesInfoFieldNames.PerformerIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargePerformerIsForeignFieldName(
  const Value: String);
begin

  FChargesInfoFieldNames.PerformerIsForeignFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargePerformerNameFieldName(
  const Value: String);
begin

  FChargesInfoFieldNames.PerformerNameFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargePerformerSpecialityFieldName(
  const Value: String);
begin

  FChargesInfoFieldNames.PerformerSpecialityFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargePerformingDateTimeFieldName(
  const Value: String);
begin

  FChargesInfoFieldNames.PerformingDateTimeFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeTimeFrameDeadlineFieldName(
  const Value: String);
begin

  FChargesInfoFieldNames.TimeFrameDeadlineFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeTimeFrameStartFieldName(
  const Value: String);
begin

  FChargesInfoFieldNames.TimeFrameStartFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeResponseFieldName(
  const Value: String);
begin

  FChargesInfoFieldNames.ResponseFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeSheetActualPerformerDepartmentCodeFieldName(
  const Value: String);
begin

  FChargeSheetsInfoFieldNames.ActualPerformerDepartmentCodeFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeSheetActualPerformerDepartmentIdFieldName(
  const Value: String);
begin

  FChargeSheetsInfoFieldNames.ActualPerformerDepartmentIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeSheetActualPerformerDepartmentNameFieldName(
  const Value: String);
begin

  FChargeSheetsInfoFieldNames.ActualPerformerDepartmentNameFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeSheetActualPerformerIdFieldName(
  const Value: String);
begin

  FChargeSheetsInfoFieldNames.ActualPerformerIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeSheetActualPerformerNameFieldName(
  const Value: String);
begin

  FChargeSheetsInfoFieldNames.ActualPerformerNameFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeSheetActualPerformerSpecialityFieldName(
  const Value: String);
begin

  FChargeSheetsInfoFieldNames.ActualPerformerSpecialityFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeSheetIsForAcquaitanceFieldName(
  const Value: String);
begin

  FChargeSheetsInfoFieldNames.IsForAcquaitanceFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeSheetIssuingDateTimeFieldName(
  const Value: String);
begin

  FChargeSheetsInfoFieldNames.IssuingDateTimeFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeSheetPerformerDepartmentCodeFieldName(
  const Value: String);
begin

  FChargeSheetsInfoFieldNames.PerformerDepartmentCodeFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeSheetPerformerDepartmentIdFieldName(
  const Value: String);
begin

  FChargeSheetsInfoFieldNames.PerformerDepartmentIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeSheetPerformerDepartmentNameFieldName(
  const Value: String);
begin

  FChargeSheetsInfoFieldNames.PerformerDepartmentNameFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeSheetPerformerIdFieldName(
  const Value: String);
begin

  FChargeSheetsInfoFieldNames.PerformerIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeSheetPerformerIsForeignFieldName(
  const Value: String);
begin

  FChargeSheetsInfoFieldNames.PerformerIsForeignFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeSheetPerformerNameFieldName(
  const Value: String);
begin

  FChargeSheetsInfoFieldNames.PerformerNameFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeSheetPerformerSpecialityFieldName(
  const Value: String);
begin

  FChargeSheetsInfoFieldNames.PerformerSpecialityFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeSheetPerformingDateTimeFieldName(
  const Value: String);
begin

  FChargeSheetsInfoFieldNames.PerformingDateTimeFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeSheetTimeFrameDeadlineFieldName(
  const Value: String);
begin

  FChargeSheetsInfoFieldNames.TimeFrameDeadlineFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeSheetTimeFrameStartFieldName(
  const Value: String);
begin

  FChargeSheetsInfoFieldNames.TimeFrameStartFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeSheetResponseFieldName(
  const Value: String);
begin

  FChargeSheetsInfoFieldNames.ResponseFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeSheetIssuerDepartmentCodeFieldName(
  const Value: String);
begin

  FChargeSheetsInfoFieldNames.IssuerDepartmentCodeFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeSheetIssuerDepartmentIdFieldName(
  const Value: String);
begin

  FChargeSheetsInfoFieldNames.IssuerDepartmentIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeSheetIssuerDepartmentNameFieldName(
  const Value: String);
begin

  FChargeSheetsInfoFieldNames.IssuerDepartmentNameFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeSheetIssuerIdFieldName(
  const Value: String);
begin

  FChargeSheetsInfoFieldNames.IssuerIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeSheetIssuerIsForeignFieldName(
  const Value: String);
begin

  FChargeSheetsInfoFieldNames.IssuerIsForeignFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeSheetIssuerNameFieldName(
  const Value: String);
begin

  FChargeSheetsInfoFieldNames.IssuerNameFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeSheetIssuerSpecialityFieldName(
  const Value: String);
begin

  FChargeSheetsInfoFieldNames.IssuerSpecialityFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeSheetChargeTextFieldName(
  const Value: String);
begin

  FChargeSheetsInfoFieldNames.ChargeTextFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeSheetDocumentIdFieldName(
  const Value: String);
begin

  FChargeSheetsInfoFieldNames.DocumentIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeSheetDocumentKindIdFieldName(
  const Value: String);
begin

  FChargeSheetsInfoFieldNames.DocumentKindIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeSheetChargeIdFieldName(
  const Value: String);
begin

  FChargeSheetsInfoFieldNames.ChargeIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeSheetViewDateByPerformerFieldName(
  const Value: String);
begin

  FChargeSheetsInfoFieldNames.ViewDateByPerformerFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetChargeChargeTextFieldName(
  const Value: String);
begin

  FChargesInfoFieldNames.ChargeTextFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetContentFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.ContentFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetCreationDateFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.CreationDateFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetCurrentWorkCycleStageNameFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.CurrentWorkCycleStageNameFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetCurrentWorkCycleStageNumberFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.CurrentWorkCycleStageNumberFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetDateFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.DateFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetFileIdFieldName(
  const Value: String);
begin

  FFilesInfoFieldNames.IdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetFileNameFieldName(
  const Value: String);
begin

  FFilesInfoFieldNames.NameFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetFilePathFieldName(
  const Value: String);
begin

  FFilesInfoFieldNames.PathFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetFilesInfoFieldNames(
  const Value: TDocumentFilesInfoFieldNames);
begin

  FFilesInfoFieldNames := Value;
  FFilesInfoFieldNames.IdFieldName := IdFieldName;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetIdFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.IdFieldName := Value;
  FRelationsInfoFieldNames.TargetDocumentIdFieldName := Value;
  FFilesInfoFieldNames.DocumentIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetInfoFieldNames(
  const Value: TDocumentInfoFieldNames);
begin

  FDocumentInfoFieldNames := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetIsSelfRegisteredFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.IsSelfRegisteredFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetKindFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.KindFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetKindIdFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.KindIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetNameFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.NameFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetNoteFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.NoteFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetNumberFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.NumberFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetProductCodeFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.ProductCodeFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetRelationIdFieldName(
  const Value: String);
begin

  FRelationsInfoFieldNames.RelationIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetRelationsInfoFieldNames(
  const Value: TDocumentRelationsInfoFieldNames);
begin

  FRelationsInfoFieldNames := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetResponsibleDepartmentCodeFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.ResponsibleDepartmentCodeFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetResponsibleDepartmentIdFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.ResponsibleDepartmentIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetResponsibleDepartmentNameFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.ResponsibleDepartmentNameFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetResponsibleIdFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.ResponsibleIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetResponsibleNameFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.ResponsibleNameFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetResponsibleTelephoneNumberFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.ResponsibleTelephoneNumberFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetSignerDepartmentCodeFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.SignerDepartmentCodeFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetSignerDepartmentIdFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.SignerDepartmentIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetSignerDepartmentNameFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.SignerDepartmentNameFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetSignerIdFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.SignerIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetSignerLeaderIdFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.SignerLeaderIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetSignerNameFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.SignerNameFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetSignerSpecialityFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.SignerSpecialityFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetSigningDateFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.SigningDateFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetSigningIdFieldName(
  const Value: String);
begin

  FDocumentInfoFieldNames.SigningIdFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetRelatedDocumentDateFieldName(
  const Value: String);
begin

  FRelationsInfoFieldNames.RelatedDocumentDateFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetRelatedDocumentIdFieldName(
  const Value: String);
begin

  FRelationsInfoFieldNames.RelatedDocumentIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetRelatedDocumentKindIdFieldName(
  const Value: String);
begin

  FRelationsInfoFieldNames.RelatedDocumentKindIdFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetRelatedDocumentKindNameFieldName(
  const Value: String);
begin

  FRelationsInfoFieldNames.RelatedDocumentKindNameFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetRelatedDocumentNameFieldName(
  const Value: String);
begin

  FRelationsInfoFieldNames.RelatedDocumentNameFieldName := Value;
  
end;

procedure TDocumentFullInfoDataSetFieldNames.SetRelatedDocumentNumberFieldName(
  const Value: String);
begin

  FRelationsInfoFieldNames.RelatedDocumentNumberFieldName := Value;

end;

procedure TDocumentFullInfoDataSetFieldNames.SetTopLevelChargeSheetIdFieldName(
  const Value: String);
begin

  FChargeSheetsInfoFieldNames.TopLevelChargeSheetIdFieldName := Value;
  
end;

end.

