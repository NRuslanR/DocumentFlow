unit DocumentUsageEmployeeAccessRightsInfoDTOMapper;

interface

uses

  DocumentUsageEmployeeAccessRightsInfo,
  EmployeeDocumentKindAccessRightsInfo,
  DocumentUsageEmployeeAccessRightsInfoDTO,
  Disposable,
  SysUtils,
  Classes;

type

  TDocumentUsageEmployeeAccessRightsInfoDTOMapper =
    class (TInterfacedObject, IDisposable)

      public

        function MapDocumentUsageEmployeeAccessRightsInfoDTOFrom(
          DocumentUsageEmployeeAccessRightsInfo: TDocumentUsageEmployeeAccessRightsInfo
        ): TDocumentUsageEmployeeAccessRightsInfoDTO;

    end;
    
implementation

{ TDocumentUsageEmployeeAccessRightsInfoDTOMapper }

function TDocumentUsageEmployeeAccessRightsInfoDTOMapper.
MapDocumentUsageEmployeeAccessRightsInfoDTOFrom(
  DocumentUsageEmployeeAccessRightsInfo: TDocumentUsageEmployeeAccessRightsInfo
): TDocumentUsageEmployeeAccessRightsInfoDTO;
begin

  Result := TDocumentUsageEmployeeAccessRightsInfoDTO.Create;

  Result.DocumentCanBeViewed :=
    DocumentUsageEmployeeAccessRightsInfo.DocumentCanBeViewed;

  Result.DocumentCanBeViewedOnly :=
    DocumentUsageEmployeeAccessRightsInfo.DocumentCanBeViewedOnly;
    
  Result.DocumentCanBeRemoved :=
    DocumentUsageEmployeeAccessRightsInfo.DocumentCanBeRemoved;

  Result.CanBeChangedDocumentApproverList :=
    DocumentUsageEmployeeAccessRightsInfo.CanBeChangedDocumentApproverList;

  Result.CanBeChangedDocumentApproversInfo :=
    DocumentUsageEmployeeAccessRightsInfo.CanBeChangedDocumentApproversInfo;

  Result.DocumentCanBeApproved :=
    DocumentUsageEmployeeAccessRightsInfo.DocumentCanBeApproved;

  Result.DocumentCanBeRejectedFromApproving :=
    DocumentUsageEmployeeAccessRightsInfo.DocumentCanBeRejectedFromApproving;

  Result.DocumentApprovingCanBeCompleted :=
    DocumentUsageEmployeeAccessRightsInfo.DocumentApprovingCanBeCompleted;
    
  Result.DocumentCanBeSigned :=
    DocumentUsageEmployeeAccessRightsInfo.DocumentCanBeSigned;

  Result.DocumentCanBeMarkedAsSigned :=
    DocumentUsageEmployeeAccessRightsInfo.DocumentCanBeMarkedAsSigned;
    
  Result.DocumentCanBeRejectedFromSigning :=
    DocumentUsageEmployeeAccessRightsInfo.DocumentCanBeRejectedFromSigning;

  Result.DocumentCanBePerformed :=
    DocumentUsageEmployeeAccessRightsInfo.DocumentCanBePerformed;

  Result.DocumentCanBeSentToApproving :=
    DocumentUsageEmployeeAccessRightsInfo.DocumentCanBeSentToApproving;
    
  Result.DocumentCanBeSentToSigning :=
    DocumentUsageEmployeeAccessRightsInfo.DocumentCanBeSentToSigning;

  Result.DocumentCanBeSentToPerforming :=
    DocumentUsageEmployeeAccessRightsInfo.DocumentCanBeSentToPerforming;

  Result.DocumentCanBeChanged :=
    DocumentUsageEmployeeAccessRightsInfo.DocumentCanBeChanged;

  Result.DocumentCanBeMarkedAsSelfRegistered :=
    DocumentUsageEmployeeAccessRightsInfo.DocumentCanBeMarkedAsSelfRegistered;

  Result.AllDocumentAccessRightsAbsent :=
    DocumentUsageEmployeeAccessRightsInfo.AllDocumentAccessRightsAbsent;

  if Assigned(
        DocumentUsageEmployeeAccessRightsInfo.
          GeneralChargeSheetsUsageEmployeeAccessRightsInfo
     )
  then begin

    Result.DocumentChargeSheetsAccessRightsInfoDTO :=
      TDocumentChargeSheetsAccessRightsInfoDTO.Create;

    Result.AllDocumentChargeSheetsAccessRightsAbsent :=
      DocumentUsageEmployeeAccessRightsInfo.
        AllDocumentChargeSheetsAccessRightsAbsent;

    Result.AnyDocumentChargeSheetsAccessRightsAllowed :=
      not Result.AllDocumentChargeSheetsAccessRightsAbsent;
      
    Result.
      DocumentChargeSheetsAccessRightsInfoDTO.
        AnyChargeSheetsCanBeViewed :=
        
        DocumentUsageEmployeeAccessRightsInfo.
          GeneralChargeSheetsUsageEmployeeAccessRightsInfo.
            AnyChargeSheetsCanBeViewed;

    Result
      .DocumentChargeSheetsAccessRightsInfoDTO
        .AnyChargeSheetsCanBeIssued :=
        
          DocumentUsageEmployeeAccessRightsInfo
            .GeneralChargeSheetsUsageEmployeeAccessRightsInfo
              .AnyChargeSheetsCanBeIssued;
              
    Result.
      DocumentChargeSheetsAccessRightsInfoDTO.
        AnyChargeSheetsCanBeChanged :=

        DocumentUsageEmployeeAccessRightsInfo.
          GeneralChargeSheetsUsageEmployeeAccessRightsInfo.
            AnyChargeSheetsCanBeChanged;

    Result
      .DocumentChargeSheetsAccessRightsInfoDTO
        .AnyChargeSheetsCanBeRemoved :=

          DocumentUsageEmployeeAccessRightsInfo
            .GeneralChargeSheetsUsageEmployeeAccessRightsInfo
              .AnyChargeSheetsCanBeRemoved;
              
    Result.
      DocumentChargeSheetsAccessRightsInfoDTO.
        AnyChargeSheetsCanBePerformed :=

        DocumentUsageEmployeeAccessRightsInfo.
          GeneralChargeSheetsUsageEmployeeAccessRightsInfo.
            AnyChargeSheetsCanBePerformed;

  end;
  
  Result.EmployeeHasRightsForSigning :=
    DocumentUsageEmployeeAccessRightsInfo.EmployeeHasRightsForSigning;

  Result.EmployeeHasRightsForSigningMarking :=
    DocumentUsageEmployeeAccessRightsInfo.EmployeeHasRightsForSigningMarking;

  Result.EmployeeHasRightsForApproving :=
    DocumentUsageEmployeeAccessRightsInfo.EmployeeHasRightsForApproving;

  Result.EmployeeHasRightsForSendingToApproving :=
    DocumentUsageEmployeeAccessRightsInfo.EmployeeHasRightsForSendingToApproving;

  Result.EmployeeHasRightsForSendingToSigning :=
    DocumentUsageEmployeeAccessRightsInfo.EmployeeHasRightsForSendingToSigning;

  Result.EmployeeHasRightsForSendingToPerforming :=
    DocumentUsageEmployeeAccessRightsInfo.EmployeeHasRightsForSendingToPerforming;

  Result.EmployeeHasRightsForRejectingFromSigning :=
    DocumentUsageEmployeeAccessRightsInfo.EmployeeHasRightsForRejectingFromSigning;

  Result.EmployeeHasRightsForRejectingFromApproving :=
    DocumentUsageEmployeeAccessRightsInfo.EmployeeHasRightsForRejectingFromApproving;

  Result.EmployeeHasRightsForMarkDocumentAsSelfRegistered :=
    DocumentUsageEmployeeAccessRightsInfo.EmployeeHasRightsForMarkDocumentAsSelfRegistered;

  Result.AllDocumentAndChargeSheetsAccessRightsAbsent :=
    DocumentUsageEmployeeAccessRightsInfo.AllDocumentAndChargeSheetsAccessRightsAbsent;

  case DocumentUsageEmployeeAccessRightsInfo.NumberPrefixPatternType of

    ppNone: Result.NumberPrefixPattern := '.*';
    ppDigits: Result.NumberPrefixPattern := '^\d+$';
    ppAnyChars: Result.NumberPrefixPattern := '.+';
    
  end;

  Result.NumberCanBeChanged := DocumentUsageEmployeeAccessRightsInfo.NumberCanBeChanged;
  
end;

end.
