unit DocumentUsageEmployeeAccessRightsInfoDTO;

interface

uses

  Disposable,
  SysUtils,
  Classes;

type

  TDocumentChargeSheetsAccessRightsInfoDTO = class

    AnyChargeSheetsCanBeViewed: Boolean;
    AnyChargeSheetsCanBeIssued: Boolean;
    AnyChargeSheetsCanBeChanged: Boolean;
    AnyChargeSheetsCanBeRemoved: Boolean;
    AnyChargeSheetsCanBePerformed: Boolean;

  end;

  TPotentialEmployeeDocumentAccessRightsInfo = class

    public

      EmployeeHasRightsForSigning: Boolean;
      EmployeeHasRightsForSigningMarking: Boolean;
      EmployeeHasRightsForApproving: Boolean;
      EmployeeHasRightsForSendingToApproving: Boolean;
      EmployeeHasRightsForSendingToSigning: Boolean;
      EmployeeHasRightsForSendingToPerforming: Boolean;
      EmployeeHasRightsForRejectingFromSigning: Boolean;
      EmployeeHasRightsForRejectingFromApproving: Boolean;
      EmployeeHasRightsForMarkDocumentAsSelfRegistered: Boolean;

  end;

  TDocumentUsageEmployeeAccessRightsInfoDTO =
    class (TInterfacedObject, IDisposable)

      public

        NumberPrefixPattern: String;
        NumberCanBeChanged: Boolean;
        DocumentCanBeViewed: Boolean;
        DocumentCanBeViewedOnly: Boolean;
        DocumentCanBeRemoved: Boolean;
        CanBeChangedDocumentApproverList: Boolean;
        CanBeChangedDocumentApproversInfo: Boolean;
        DocumentCanBeApproved: Boolean;
        DocumentCanBeRejectedFromApproving: Boolean;
        DocumentApprovingCanBeCompleted: Boolean;
        DocumentCanBeSigned: Boolean;
        DocumentCanBeMarkedAsSigned: Boolean;
        DocumentCanBeRejectedFromSigning: Boolean;
        DocumentCanBePerformed: Boolean;
        DocumentCanBeSentToApproving: Boolean;
        DocumentCanBeSentToSigning: Boolean;
        DocumentCanBeSentToPerforming: Boolean;
        DocumentCanBeChanged: Boolean;
        DocumentCanBeMarkedAsSelfRegistered: Boolean;
        AllDocumentAccessRightsAbsent: Boolean;
        AllDocumentChargeSheetsAccessRightsAbsent: Boolean;
        AnyDocumentChargeSheetsAccessRightsAllowed: Boolean;
        AllDocumentAndChargeSheetsAccessRightsAbsent: Boolean;

        DocumentChargeSheetsAccessRightsInfoDTO: TDocumentChargeSheetsAccessRightsInfoDTO;

        PotentialEmployeeDocumentAccessRightsInfo: TPotentialEmployeeDocumentAccessRightsInfo;

        function Clone: TDocumentUsageEmployeeAccessRightsInfoDTO;

        function AnyChargeSheetsCanBeViewed: Boolean;
        function AnyChargeSheetsCanBeChanged: Boolean;
        function AnyChargeSheetsCanBePerformed: Boolean;

      private

        function GetEmployeeHasRightsForApproving: Boolean;
        function GetEmployeeHasRightsForRejectingFromApproving: Boolean;
        function GetEmployeeHasRightsForRejectingFromSigning: Boolean;
        function GetEmployeeHasRightsForSendingToApproving: Boolean;
        function GetEmployeeHasRightsForSendingToPerforming: Boolean;
        function GetEmployeeHasRightsForSendingToSigning: Boolean;
        function GetEmployeeHasRightsForSigning: Boolean;
        function GetEmployeeHasRightsForSigningMarking: Boolean;
        function GetEmployeeHasRightsForMarkDocumentAsSelfRegistered: Boolean;
      
        procedure SetEmployeeHasRightsForApproving(const Value: Boolean);

        procedure SetEmployeeHasRightsForRejectingFromApproving(
          const Value: Boolean
        );

        procedure SetEmployeeHasRightsForRejectingFromSigning(const Value: Boolean);
        procedure SetEmployeeHasRightsForSendingToApproving(const Value: Boolean);
        procedure SetEmployeeHasRightsForSendingToPerforming(const Value: Boolean);
        procedure SetEmployeeHasRightsForSendingToSigning(const Value: Boolean);
        procedure SetEmployeeHasRightsForSigning(const Value: Boolean);
        procedure SetEmployeeHasRightsForSigningMarking(const Value: Boolean);

        procedure SetEmployeeHasRightsForMarkDocumentAsSelfRegistered(
          const Value: Boolean
        );

      public

        destructor Destroy; override;

        constructor Create;

        property EmployeeHasRightsForSigning: Boolean
        read GetEmployeeHasRightsForSigning write SetEmployeeHasRightsForSigning;

        property EmployeeHasRightsForSigningMarking: Boolean
        read GetEmployeeHasRightsForSigningMarking write SetEmployeeHasRightsForSigningMarking;

        property EmployeeHasRightsForApproving: Boolean
        read GetEmployeeHasRightsForApproving write SetEmployeeHasRightsForApproving;

        property EmployeeHasRightsForSendingToApproving: Boolean
        read GetEmployeeHasRightsForSendingToApproving write SetEmployeeHasRightsForSendingToApproving;
      
        property EmployeeHasRightsForSendingToSigning: Boolean
        read GetEmployeeHasRightsForSendingToSigning write SetEmployeeHasRightsForSendingToSigning;
      
        property EmployeeHasRightsForSendingToPerforming: Boolean
        read GetEmployeeHasRightsForSendingToPerforming write SetEmployeeHasRightsForSendingToPerforming;
      
        property EmployeeHasRightsForRejectingFromSigning: Boolean
        read GetEmployeeHasRightsForRejectingFromSigning write SetEmployeeHasRightsForRejectingFromSigning;
      
        property EmployeeHasRightsForRejectingFromApproving: Boolean
        read GetEmployeeHasRightsForRejectingFromApproving write SetEmployeeHasRightsForRejectingFromApproving;

        property EmployeeHasRightsForMarkDocumentAsSelfRegistered: Boolean
        read GetEmployeeHasRightsForMarkDocumentAsSelfRegistered
        write SetEmployeeHasRightsForMarkDocumentAsSelfRegistered;
      
    end;

implementation

{ TDocumentUsageEmployeeAccessRightsInfoDTO }

function TDocumentUsageEmployeeAccessRightsInfoDTO.AnyChargeSheetsCanBeChanged: Boolean;
begin

  if Assigned(DocumentChargeSheetsAccessRightsInfoDTO) then
    Result := DocumentChargeSheetsAccessRightsInfoDTO.AnyChargeSheetsCanBeChanged

  else
    Result := False;

end;

function TDocumentUsageEmployeeAccessRightsInfoDTO.AnyChargeSheetsCanBePerformed: Boolean;
begin

  if Assigned(DocumentChargeSheetsAccessRightsInfoDTO) then
    Result := DocumentChargeSheetsAccessRightsInfoDTO.AnyChargeSheetsCanBePerformed

  else
    Result := False;
    
end;

function TDocumentUsageEmployeeAccessRightsInfoDTO.AnyChargeSheetsCanBeViewed: Boolean;
begin

  if Assigned(DocumentChargeSheetsAccessRightsInfoDTO) then
    Result := DocumentChargeSheetsAccessRightsInfoDTO.AnyChargeSheetsCanBeViewed

  else
    Result := False;

end;

function TDocumentUsageEmployeeAccessRightsInfoDTO.Clone: TDocumentUsageEmployeeAccessRightsInfoDTO;
begin

  Result := TDocumentUsageEmployeeAccessRightsInfoDTO.Create;

  Result.NumberPrefixPattern := NumberPrefixPattern;
  Result.NumberCanBeChanged := NumberCanBeChanged;
  Result.DocumentCanBeViewed := DocumentCanBeViewed;
  Result.DocumentCanBeRemoved := DocumentCanBeRemoved;
  Result.CanBeChangedDocumentApproverList := CanBeChangedDocumentApproverList;
  Result.CanBeChangedDocumentApproversInfo := CanBeChangedDocumentApproversInfo;
  Result.DocumentCanBeApproved := DocumentCanBeApproved;
  Result.DocumentCanBeRejectedFromApproving := DocumentCanBeRejectedFromApproving;
  Result.DocumentApprovingCanBeCompleted := DocumentApprovingCanBeCompleted;
  Result.DocumentCanBeSigned := DocumentCanBeSigned;
  Result.DocumentCanBeMarkedAsSigned := DocumentCanBeMarkedAsSigned;
  Result.DocumentCanBeRejectedFromSigning := DocumentCanBeRejectedFromSigning;
  Result.DocumentCanBePerformed := DocumentCanBePerformed;
  Result.DocumentCanBeSentToApproving := DocumentCanBeSentToApproving;
  Result.DocumentCanBeSentToSigning := DocumentCanBeSentToSigning;
  Result.DocumentCanBeSentToPerforming := DocumentCanBeSentToPerforming;
  Result.DocumentCanBeChanged := DocumentCanBeChanged;
  Result.DocumentCanBeMarkedAsSelfRegistered := DocumentCanBeMarkedAsSelfRegistered;
  Result.AllDocumentAccessRightsAbsent := AllDocumentAccessRightsAbsent;

  Result.EmployeeHasRightsForSigning := EmployeeHasRightsForSigning;
  Result.EmployeeHasRightsForSigningMarking := EmployeeHasRightsForSigningMarking;
  Result.EmployeeHasRightsForApproving := EmployeeHasRightsForApproving;
  Result.EmployeeHasRightsForSendingToApproving := EmployeeHasRightsForSendingToApproving;
  Result.EmployeeHasRightsForSendingToSigning := EmployeeHasRightsForSendingToSigning;
  Result.EmployeeHasRightsForSendingToPerforming := EmployeeHasRightsForSendingToPerforming;
  Result.EmployeeHasRightsForRejectingFromSigning := EmployeeHasRightsForRejectingFromSigning;
  Result.EmployeeHasRightsForRejectingFromApproving := EmployeeHasRightsForRejectingFromApproving;
  Result.EmployeeHasRightsForMarkDocumentAsSelfRegistered := EmployeeHasRightsForMarkDocumentAsSelfRegistered;

  if not Assigned(DocumentChargeSheetsAccessRightsInfoDTO) then Exit;
  
  Result.DocumentChargeSheetsAccessRightsInfoDTO :=
    TDocumentChargeSheetsAccessRightsInfoDTO.Create;

  Result.DocumentChargeSheetsAccessRightsInfoDTO.AnyChargeSheetsCanBeViewed :=
    DocumentChargeSheetsAccessRightsInfoDTO.AnyChargeSheetsCanBeViewed;

  Result.DocumentChargeSheetsAccessRightsInfoDTO.AnyChargeSheetsCanBeIssued :=
    DocumentChargeSheetsAccessRightsInfoDTO.AnyChargeSheetsCanBeIssued;
    
  Result.DocumentChargeSheetsAccessRightsInfoDTO.AnyChargeSheetsCanBeChanged :=
    DocumentChargeSheetsAccessRightsInfoDTO.AnyChargeSheetsCanBeChanged;

  Result.DocumentChargeSheetsAccessRightsInfoDTO.AnyChargeSheetsCanBeRemoved :=
    DocumentChargeSheetsAccessRightsInfoDTO.AnyChargeSheetsCanBeRemoved;
    
  Result.DocumentChargeSheetsAccessRightsInfoDTO.AnyChargeSheetsCanBePerformed :=
    DocumentChargeSheetsAccessRightsInfoDTO.AnyChargeSheetsCanBePerformed;

end;

constructor TDocumentUsageEmployeeAccessRightsInfoDTO.Create;
begin

  inherited;

  PotentialEmployeeDocumentAccessRightsInfo := TPotentialEmployeeDocumentAccessRightsInfo.Create;
  
end;

destructor TDocumentUsageEmployeeAccessRightsInfoDTO.Destroy;
begin

  FreeAndNil(PotentialEmployeeDocumentAccessRightsInfo);
  FreeAndNil(DocumentChargeSheetsAccessRightsInfoDTO);

  inherited;

end;

function TDocumentUsageEmployeeAccessRightsInfoDTO.GetEmployeeHasRightsForApproving: Boolean;
begin

  Result := PotentialEmployeeDocumentAccessRightsInfo.EmployeeHasRightsForApproving;
  
end;

function TDocumentUsageEmployeeAccessRightsInfoDTO.GetEmployeeHasRightsForMarkDocumentAsSelfRegistered: Boolean;
begin

  Result := PotentialEmployeeDocumentAccessRightsInfo.EmployeeHasRightsForMarkDocumentAsSelfRegistered;
  
end;

function TDocumentUsageEmployeeAccessRightsInfoDTO.GetEmployeeHasRightsForRejectingFromApproving: Boolean;
begin

  Result := PotentialEmployeeDocumentAccessRightsInfo.EmployeeHasRightsForRejectingFromApproving;

end;

function TDocumentUsageEmployeeAccessRightsInfoDTO.GetEmployeeHasRightsForRejectingFromSigning: Boolean;
begin

  Result := PotentialEmployeeDocumentAccessRightsInfo.EmployeeHasRightsForRejectingFromSigning;

end;

function TDocumentUsageEmployeeAccessRightsInfoDTO.GetEmployeeHasRightsForSendingToApproving: Boolean;
begin

  Result := PotentialEmployeeDocumentAccessRightsInfo.EmployeeHasRightsForSendingToApproving;
  

end;

function TDocumentUsageEmployeeAccessRightsInfoDTO.GetEmployeeHasRightsForSendingToPerforming: Boolean;
begin

  Result := PotentialEmployeeDocumentAccessRightsInfo.EmployeeHasRightsForSendingToPerforming;

end;

function TDocumentUsageEmployeeAccessRightsInfoDTO.GetEmployeeHasRightsForSendingToSigning: Boolean;
begin

  Result := PotentialEmployeeDocumentAccessRightsInfo.EmployeeHasRightsForSendingToSigning;

end;

function TDocumentUsageEmployeeAccessRightsInfoDTO.GetEmployeeHasRightsForSigning: Boolean;
begin

  Result := PotentialEmployeeDocumentAccessRightsInfo.EmployeeHasRightsForSigning;
  
end;

function TDocumentUsageEmployeeAccessRightsInfoDTO.GetEmployeeHasRightsForSigningMarking: Boolean;
begin

  Result := PotentialEmployeeDocumentAccessRightsInfo.EmployeeHasRightsForSigningMarking;

end;

procedure TDocumentUsageEmployeeAccessRightsInfoDTO.SetEmployeeHasRightsForApproving(
  const Value: Boolean);
begin

  PotentialEmployeeDocumentAccessRightsInfo.EmployeeHasRightsForApproving := Value;

end;

procedure TDocumentUsageEmployeeAccessRightsInfoDTO.SetEmployeeHasRightsForMarkDocumentAsSelfRegistered(
  const Value: Boolean);
begin

  PotentialEmployeeDocumentAccessRightsInfo.EmployeeHasRightsForMarkDocumentAsSelfRegistered := Value;
  
end;

procedure TDocumentUsageEmployeeAccessRightsInfoDTO.SetEmployeeHasRightsForRejectingFromApproving(
  const Value: Boolean);
begin

  PotentialEmployeeDocumentAccessRightsInfo.EmployeeHasRightsForRejectingFromApproving := Value;
  
end;

procedure TDocumentUsageEmployeeAccessRightsInfoDTO.SetEmployeeHasRightsForRejectingFromSigning(
  const Value: Boolean);
begin

  PotentialEmployeeDocumentAccessRightsInfo.EmployeeHasRightsForRejectingFromSigning := Value;
  
end;

procedure TDocumentUsageEmployeeAccessRightsInfoDTO.SetEmployeeHasRightsForSendingToApproving(
  const Value: Boolean);
begin

  PotentialEmployeeDocumentAccessRightsInfo.EmployeeHasRightsForSendingToApproving := Value;
  
end;

procedure TDocumentUsageEmployeeAccessRightsInfoDTO.SetEmployeeHasRightsForSendingToPerforming(
  const Value: Boolean);
begin

  PotentialEmployeeDocumentAccessRightsInfo.EmployeeHasRightsForSendingToPerforming := Value;
  
end;

procedure TDocumentUsageEmployeeAccessRightsInfoDTO.SetEmployeeHasRightsForSendingToSigning(
  const Value: Boolean);
begin

  PotentialEmployeeDocumentAccessRightsInfo.EmployeeHasRightsForSendingToSigning := Value;
  
end;

procedure TDocumentUsageEmployeeAccessRightsInfoDTO.SetEmployeeHasRightsForSigning(
  const Value: Boolean);
begin

  PotentialEmployeeDocumentAccessRightsInfo.EmployeeHasRightsForSigning := Value;
  
end;

procedure TDocumentUsageEmployeeAccessRightsInfoDTO.SetEmployeeHasRightsForSigningMarking(
  const Value: Boolean);
begin

  PotentialEmployeeDocumentAccessRightsInfo.EmployeeHasRightsForSigningMarking := Value;

end;

end.
