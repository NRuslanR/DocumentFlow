unit DocumentUsageEmployeeAccessRightsInfoDTOMapper;

interface

uses

  DocumentUsageEmployeeAccessRightsInfo,
  EmployeeDocumentKindAccessRightsInfo,
  DocumentUsageEmployeeAccessRightsInfoDTO,
  DocumentChargeKindDtoDomainMapper,
  DocumentChargeKind,
  IGetSelfUnit,
  Disposable,
  SysUtils,
  Classes;

type

  TDocumentUsageEmployeeAccessRightsInfoDTOMapper =
    class (TInterfacedObject, IGetSelf)

      private

        FChargeKindDtoMapper: IDocumentChargeKindDtoDomainMapper;

      public

        constructor Create(ChargeKindDtoMapper: IDocumentChargeKindDtoDomainMapper);

        function GetSelf: TObject;
        
        function MapDocumentUsageEmployeeAccessRightsInfoDTOFrom(
          DocumentUsageEmployeeAccessRightsInfo: TDocumentUsageEmployeeAccessRightsInfo
        ): TDocumentUsageEmployeeAccessRightsInfoDTO;

    end;
    
implementation

uses

  GeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo,
  DocumentChargeSheetIssuingAccessRights,
  AuxDebugFunctionsUnit;

{ TDocumentUsageEmployeeAccessRightsInfoDTOMapper }
constructor TDocumentUsageEmployeeAccessRightsInfoDTOMapper.Create(
  ChargeKindDtoMapper: IDocumentChargeKindDtoDomainMapper);
begin

  inherited Create;

  FChargeKindDtoMapper := ChargeKindDtoMapper;
  
end;

function TDocumentUsageEmployeeAccessRightsInfoDTOMapper.GetSelf: TObject;
begin

  Result := Self;

end;

function TDocumentUsageEmployeeAccessRightsInfoDTOMapper.
MapDocumentUsageEmployeeAccessRightsInfoDTOFrom(
  DocumentUsageEmployeeAccessRightsInfo: TDocumentUsageEmployeeAccessRightsInfo
): TDocumentUsageEmployeeAccessRightsInfoDTO;
var
    MainChargeSheetKind: TDocumentChargeKind;
begin

  Result := TDocumentUsageEmployeeAccessRightsInfoDTO.Create;

  with Result do begin

    DocumentCanBeViewed :=
      DocumentUsageEmployeeAccessRightsInfo.DocumentCanBeViewed;

    DocumentCanBeViewedOnly :=
      DocumentUsageEmployeeAccessRightsInfo.DocumentCanBeViewedOnly;
    
    DocumentCanBeRemoved :=
      DocumentUsageEmployeeAccessRightsInfo.DocumentCanBeRemoved;

    CanBeChangedDocumentApproverList :=
      DocumentUsageEmployeeAccessRightsInfo.CanBeChangedDocumentApproverList;

    CanBeChangedDocumentApproversInfo :=
      DocumentUsageEmployeeAccessRightsInfo.CanBeChangedDocumentApproversInfo;

    DocumentCanBeApproved :=
      DocumentUsageEmployeeAccessRightsInfo.DocumentCanBeApproved;

    DocumentCanBeRejectedFromApproving :=
      DocumentUsageEmployeeAccessRightsInfo.DocumentCanBeRejectedFromApproving;

    DocumentApprovingCanBeCompleted :=
      DocumentUsageEmployeeAccessRightsInfo.DocumentApprovingCanBeCompleted;

    DocumentCanBeSigned :=
      DocumentUsageEmployeeAccessRightsInfo.DocumentCanBeSigned;

    DocumentCanBeMarkedAsSigned :=
      DocumentUsageEmployeeAccessRightsInfo.DocumentCanBeMarkedAsSigned;

    DocumentCanBeRejectedFromSigning :=
      DocumentUsageEmployeeAccessRightsInfo.DocumentCanBeRejectedFromSigning;

    DocumentCanBePerformed :=
      DocumentUsageEmployeeAccessRightsInfo.DocumentCanBePerformed;

    DocumentCanBeSentToApproving :=
      DocumentUsageEmployeeAccessRightsInfo.DocumentCanBeSentToApproving;

    DocumentCanBeSentToSigning :=
      DocumentUsageEmployeeAccessRightsInfo.DocumentCanBeSentToSigning;

    DocumentCanBeSentToPerforming :=
      DocumentUsageEmployeeAccessRightsInfo.DocumentCanBeSentToPerforming;

    DocumentCanBeChanged :=
      DocumentUsageEmployeeAccessRightsInfo.DocumentCanBeChanged;

    DocumentCanBeMarkedAsSelfRegistered :=
      DocumentUsageEmployeeAccessRightsInfo.DocumentCanBeMarkedAsSelfRegistered;

    AllDocumentAccessRightsAbsent :=
      DocumentUsageEmployeeAccessRightsInfo.AllDocumentAccessRightsAbsent;

    EmployeeHasRightsForSigning :=
      DocumentUsageEmployeeAccessRightsInfo.EmployeeHasRightsForSigning;

    EmployeeHasRightsForSigningMarking :=
      DocumentUsageEmployeeAccessRightsInfo.EmployeeHasRightsForSigningMarking;

    EmployeeHasRightsForApproving :=
      DocumentUsageEmployeeAccessRightsInfo.EmployeeHasRightsForApproving;

    EmployeeHasRightsForSendingToApproving :=
      DocumentUsageEmployeeAccessRightsInfo.EmployeeHasRightsForSendingToApproving;

    EmployeeHasRightsForSendingToSigning :=
      DocumentUsageEmployeeAccessRightsInfo.EmployeeHasRightsForSendingToSigning;

    EmployeeHasRightsForSendingToPerforming :=
      DocumentUsageEmployeeAccessRightsInfo.EmployeeHasRightsForSendingToPerforming;

    EmployeeHasRightsForRejectingFromSigning :=
      DocumentUsageEmployeeAccessRightsInfo.EmployeeHasRightsForRejectingFromSigning;

    EmployeeHasRightsForRejectingFromApproving :=
      DocumentUsageEmployeeAccessRightsInfo.EmployeeHasRightsForRejectingFromApproving;

    EmployeeHasRightsForMarkDocumentAsSelfRegistered :=
      DocumentUsageEmployeeAccessRightsInfo.EmployeeHasRightsForMarkDocumentAsSelfRegistered;

    AllDocumentChargeSheetsAccessRightsAbsent :=
      DocumentUsageEmployeeAccessRightsInfo.AllDocumentChargeSheetsAccessRightsAbsent;

    AnyDocumentChargeSheetsAccessRightsAllowed :=
      DocumentUsageEmployeeAccessRightsInfo.AnyDocumentChargeSheetsAccessRightsAllowed;

    AllDocumentAndChargeSheetsAccessRightsAbsent :=
      DocumentUsageEmployeeAccessRightsInfo.AllDocumentAndChargeSheetsAccessRightsAbsent;

    NumberCanBeChanged := DocumentUsageEmployeeAccessRightsInfo.NumberCanBeChanged;
    
    if not Assigned(
          DocumentUsageEmployeeAccessRightsInfo.
            GeneralChargeSheetsUsageEmployeeAccessRightsInfo
       )
    then Exit;

    DocumentChargeSheetsAccessRightsInfoDTO :=
      TDocumentChargeSheetsAccessRightsInfoDTO.Create;

    with DocumentChargeSheetsAccessRightsInfoDTO, DocumentUsageEmployeeAccessRightsInfo
    do begin

      AnyChargeSheetsCanBeViewed :=
        GeneralChargeSheetsUsageEmployeeAccessRightsInfo
          .AnyChargeSheetsCanBeViewed;

      AnyChargeSheetsCanBeViewedAsIssuer :=
        GeneralChargeSheetsUsageEmployeeAccessRightsInfo
          .AnyChargeSheetsCanBeViewedAsIssuer;

      AnyChargeSheetsCanBeViewedAsPerformer :=
        GeneralChargeSheetsUsageEmployeeAccessRightsInfo
          .AnyChargeSheetsCanBeViewedAsPerformer;

      AnyChargeSheetsCanBeViewedAsAuthorized :=
        GeneralChargeSheetsUsageEmployeeAccessRightsInfo
          .AnyChargeSheetsCanBeViewedAsAuthorized;

      AnyChargeSheetsCanBeChanged :=
        GeneralChargeSheetsUsageEmployeeAccessRightsInfo
          .AnyChargeSheetsCanBeChanged;

      AnyChargeSheetsCanBeRemoved :=
        GeneralChargeSheetsUsageEmployeeAccessRightsInfo
          .AnyChargeSheetsCanBeRemoved;

      AnyChargeSheetsCanBePerformed :=
        GeneralChargeSheetsUsageEmployeeAccessRightsInfo
          .AnyChargeSheetsCanBePerformed;

      AnyChargeSheetsCanBeIssued :=
        GeneralChargeSheetsUsageEmployeeAccessRightsInfo
          .AnyChargeSheetsCanBeIssued;

      AnyHeadChargeSheetsCanBeIssued :=
        GeneralChargeSheetsUsageEmployeeAccessRightsInfo
          .AnyHeadChargeSheetsCanBeIssued;

      AnySubordinateChargeSheetsCanBeIssued :=
        GeneralChargeSheetsUsageEmployeeAccessRightsInfo
          .AnySubordinateChargeSheetsCanBeIssued;
                                  
      AllChargeSheetsAccessRightsAbsent :=
        GeneralChargeSheetsUsageEmployeeAccessRightsInfo
          .AllChargeSheetsAccessRightsAbsent;

      AllChargeSheetsAccessRightsAllowed :=
        GeneralChargeSheetsUsageEmployeeAccessRightsInfo
          .AllChargeSheetsAccessRightsAllowed;

    end;

    with
      DocumentChargeSheetsAccessRightsInfoDTO.IssuingAccessRightsInfoDTO,
      DocumentUsageEmployeeAccessRightsInfo
    do begin


      AllAccessRightsAbsent :=
        GeneralChargeSheetsUsageEmployeeAccessRightsInfo
          .IssuingAccessRights
            .AllAccessRightsAbsent;

      AnyHeadChargeSheetsCanBeIssued :=
        GeneralChargeSheetsUsageEmployeeAccessRightsInfo
          .AnyHeadChargeSheetsCanBeIssued;

      AnySubordinateChargeSheetsCanBeIssued :=
        GeneralChargeSheetsUsageEmployeeAccessRightsInfo
          .AnySubordinateChargeSheetsCanBeIssued;

      AnyChargeSheetsCanBeIssued :=
        GeneralChargeSheetsUsageEmployeeAccessRightsInfo
          .AnyChargeSheetsCanBeIssued;

      MainChargeSheetKind :=
        GeneralChargeSheetsUsageEmployeeAccessRightsInfo
          .IssuingAccessRights
            .MainChargeSheetKind;

      { refactor:
            remove validation after
            refactor
              TStandardDocumentUsageEmployeeAccessRightsService
                .EnsureThatEmployeeHasRelatedDocumentUsageAccessRights
        }
        
      if Assigned(MainChargeSheetKind) then
      begin

        MainChargeSheetKindDto :=
          FChargeKindDtoMapper
            .MapDocumentChargeKindDto(MainChargeSheetKind);

      end;
      
      IssuingAlloweableHeadChargeSheetKindDtos :=
        FChargeKindDtoMapper
          .MapDocumentChargeKindDtos(
            GeneralChargeSheetsUsageEmployeeAccessRightsInfo
              .IssuingAccessRights
                .IssuingAlloweableHeadChargeSheetKinds
          );

      IssuingAlloweableSubordinateChargeSheetKindDtos :=
        FChargeKindDtoMapper
          .MapDocumentChargeKindDtos(
            GeneralChargeSheetsUsageEmployeeAccessRightsInfo
              .IssuingAccessRights
                .IssuingAlloweableSubordinateChargeSheetKinds
          );

    end;
    
  end;

end;

end.
