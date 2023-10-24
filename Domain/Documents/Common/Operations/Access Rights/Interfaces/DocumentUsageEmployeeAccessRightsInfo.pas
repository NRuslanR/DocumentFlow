unit DocumentUsageEmployeeAccessRightsInfo;

interface

uses

  EmployeeDocumentKindAccessRightsInfo,
  GeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo,
  DomainObjectValueUnit,
  IDomainObjectBaseUnit,
  SysUtils,
  Classes;
  
type

  TPotentialEmployeeDocumentAccessRightsInfo = class (TDomainObjectValue)

    private

      FEmployeeHasRightsForSigning: Boolean;
      FEmployeeHasRightsForSigningMarking: Boolean;
      FEmployeeHasRightsForApproving: Boolean;
      FEmployeeHasRightsForSendingToApproving: Boolean;
      FEmployeeHasRightsForSendingToSigning: Boolean;
      FEmployeeHasRightsForSendingToPerforming: Boolean;
      FEmployeeHasRightsForRejectingFromSigning: Boolean;
      FEmployeeHasRightsForRejectingFromApproving: Boolean;
      FEmployeeHasRightsForMarkDocumentAsSelfRegistered: Boolean;

    public

      property EmployeeHasRightsForSigning: Boolean
      read FEmployeeHasRightsForSigning write FEmployeeHasRightsForSigning;

      property EmployeeHasRightsForSigningMarking: Boolean
      read FEmployeeHasRightsForSigningMarking
      write FEmployeeHasRightsForSigningMarking;
      
      property EmployeeHasRightsForApproving: Boolean
      read FEmployeeHasRightsForApproving write FEmployeeHasRightsForApproving;

      property EmployeeHasRightsForSendingToApproving: Boolean
      read FEmployeeHasRightsForSendingToApproving
      write FEmployeeHasRightsForSendingToApproving;
      
      property EmployeeHasRightsForSendingToSigning: Boolean
      read FEmployeeHasRightsForSendingToSigning
      write FEmployeeHasRightsForSendingToSigning;
      
      property EmployeeHasRightsForSendingToPerforming: Boolean
      read FEmployeeHasRightsForSendingToPerforming
      write FEmployeeHasRightsForSendingToPerforming;
      
      property EmployeeHasRightsForRejectingFromSigning: Boolean
      read FEmployeeHasRightsForRejectingFromSigning
      write FEmployeeHasRightsForRejectingFromSigning;
      
      property EmployeeHasRightsForRejectingFromApproving: Boolean
      read FEmployeeHasRightsForRejectingFromApproving
      write FEmployeeHasRightsForRejectingFromApproving;

      property EmployeeHasRightsForMarkDocumentAsSelfRegistered: Boolean
      read FEmployeeHasRightsForMarkDocumentAsSelfRegistered
      write FEmployeeHasRightsForMarkDocumentAsSelfRegistered;

  end;
  
  TDocumentUsageEmployeeAccessRightsInfo = class (TDomainObjectValue)

    private

      FNumberPrefixPatternType: TDocumentNumberPrefixPatternType;
      FNumberCanBeChanged: Boolean;
      FDocumentCanBeViewed: Boolean;
      FDocumentCanBeRemoved: Boolean;
      FCanBeChangedDocumentApproverList: Boolean;
      FCanBeChangedDocumentApproversInfo: Boolean;
      FDocumentCanBeApproved: Boolean;
      FDocumentCanBeRejectedFromApproving: Boolean;
      FDocumentApprovingCanBeCompleted: Boolean;
      FDocumentCanBeSigned: Boolean;
      FDocumentCanBeMarkedAsSigned: Boolean;
      FDocumentCanBeRejectedFromSigning: Boolean;
      FDocumentCanBePerformed: Boolean;
      FDocumentCanBeSentToApproving: Boolean;
      FDocumentCanBeSentToSigning: Boolean;
      FDocumentCanBeSentToPerforming: Boolean;
      FDocumentCanBeChanged: Boolean;
      FDocumentCanBeMarkedAsSelfRegistered: Boolean;

      FGeneralChargeSheetsUsageEmployeeAccessRightsInfo:
        TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo;

      FFreeGeneralChargeSheetsUsageEmployeeAccessRightsInfo: IDomainObjectBase;

      FPotentialEmployeeDocumentAccessRightsInfo:
        TPotentialEmployeeDocumentAccessRightsInfo;

      FFreePotentialEmployeeDocumentAccessRightsInfo: IDomainObjectBase;

      function GetDocumentCanBeViewedOnly: Boolean;
      
      function GetAllDocumentAccessRightsAbsent: Boolean;
      function GetAllDocumentChargeSheetsAccessRightsAbsent: Boolean;
      function GetEmployeeHasRightsForApproving: Boolean;
      function GetEmployeeHasRightsForRejectingFromApproving: Boolean;
      function GetEmployeeHasRightsForRejectingFromSigning: Boolean;
      function GetEmployeeHasRightsForSendingToApproving: Boolean;
      function GetEmployeeHasRightsForSendingToPerforming: Boolean;
      function GetEmployeeHasRightsForSendingToSigning: Boolean;
      function GetEmployeeHasRightsForSigning: Boolean;
      function GetEmployeeHasRightsForSigningMarking: Boolean;
      function GetEmployeeHasRightsForMarkDocumentAsSelfRegistered: Boolean;

      procedure SetPotentialEmployeeDocumentAccessRightsInfo(
        const Value: TPotentialEmployeeDocumentAccessRightsInfo
      );

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
      
      procedure SetGeneralChargeSheetsUsageEmployeeAccessRightsInfo(
        const Value: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo);
      function GetAllDocumentAndChargeSheetsAccessRightsAbsent: Boolean;

    public

      constructor Create;

    published

      property DocumentCanBeViewed: Boolean
      read FDocumentCanBeViewed write FDocumentCanBeViewed;

      property NumberPrefixPatternType: TDocumentNumberPrefixPatternType
      read FNumberPrefixPatternType
      write FNumberPrefixPatternType;

      property NumberCanBeChanged: Boolean
      read FNumberCanBeChanged write FNumberCanBeChanged;
      
      property DocumentCanBeViewedOnly: Boolean
      read GetDocumentCanBeViewedOnly;
      
      property DocumentCanBeRemoved: Boolean
      read FDocumentCanBeRemoved write FDocumentCanBeRemoved;
      
      property CanBeChangedDocumentApproverList: Boolean
      read FCanBeChangedDocumentApproverList
      write FCanBeChangedDocumentApproverList;

      property CanBeChangedDocumentApproversInfo: Boolean
      read FCanBeChangedDocumentApproversInfo
      write FCanBeChangedDocumentApproversInfo;
      
      property DocumentCanBeApproved: Boolean
      read FDocumentCanBeApproved write FDocumentCanBeApproved;

      property DocumentCanBeRejectedFromApproving: Boolean
      read FDocumentCanBeRejectedFromApproving
      write FDocumentCanBeRejectedFromApproving;

      property DocumentApprovingCanBeCompleted: Boolean
      read FDocumentApprovingCanBeCompleted
      write FDocumentApprovingCanBeCompleted;
      
      property DocumentCanBeSigned: Boolean
      read FDocumentCanBeSigned write FDocumentCanBeSigned;

      property DocumentCanBeMarkedAsSigned: Boolean
      read FDocumentCanBeMarkedAsSigned write FDocumentCanBeMarkedAsSigned;
      
      property DocumentCanBeRejectedFromSigning: Boolean
      read FDocumentCanBeRejectedFromSigning
      write FDocumentCanBeRejectedFromSigning;

      property DocumentCanBePerformed: Boolean
      read FDocumentCanBePerformed
      write FDocumentCanBePerformed;

      property DocumentCanBeSentToApproving: Boolean
      read FDocumentCanBeSentToApproving
      write FDocumentCanBeSentToApproving;
      
      property DocumentCanBeSentToSigning: Boolean
      read FDocumentCanBeSentToSigning
      write FDocumentCanBeSentToSigning;
      
      property DocumentCanBeSentToPerforming: Boolean
      read FDocumentCanBeSentToPerforming
      write FDocumentCanBeSentToPerforming;

      property DocumentCanBeChanged: Boolean
      read FDocumentCanBeChanged write FDocumentCanBeChanged;

      property DocumentCanBeMarkedAsSelfRegistered: Boolean
      read FDocumentCanBeMarkedAsSelfRegistered
      write FDocumentCanBeMarkedAsSelfRegistered;
      
      property GeneralChargeSheetsUsageEmployeeAccessRightsInfo:
        TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo
      read FGeneralChargeSheetsUsageEmployeeAccessRightsInfo
      write SetGeneralChargeSheetsUsageEmployeeAccessRightsInfo;

      property AllDocumentAccessRightsAbsent: Boolean
      read GetAllDocumentAccessRightsAbsent;

      function AnyDocumentChargeSheetsAccessRightsAllowed: Boolean;
      
      property AllDocumentAndChargeSheetsAccessRightsAbsent: Boolean
      read GetAllDocumentAndChargeSheetsAccessRightsAbsent;
      
      property AllDocumentChargeSheetsAccessRightsAbsent: Boolean
      read GetAllDocumentChargeSheetsAccessRightsAbsent;

      property PotentialEmployeeDocumentAccessRightsInfo:
        TPotentialEmployeeDocumentAccessRightsInfo
      read FPotentialEmployeeDocumentAccessRightsInfo
      write SetPotentialEmployeeDocumentAccessRightsInfo;
      
      property EmployeeHasRightsForSigning: Boolean
      read GetEmployeeHasRightsForSigning
      write SetEmployeeHasRightsForSigning;

      property EmployeeHasRightsForSigningMarking: Boolean
      read GetEmployeeHasRightsForSigningMarking
      write SetEmployeeHasRightsForSigningMarking;
      
      property EmployeeHasRightsForApproving: Boolean
      read GetEmployeeHasRightsForApproving
      write SetEmployeeHasRightsForApproving;

      property EmployeeHasRightsForSendingToApproving: Boolean
      read GetEmployeeHasRightsForSendingToApproving
      write SetEmployeeHasRightsForSendingToApproving;
      
      property EmployeeHasRightsForSendingToSigning: Boolean
      read GetEmployeeHasRightsForSendingToSigning
      write SetEmployeeHasRightsForSendingToSigning;
      
      property EmployeeHasRightsForSendingToPerforming: Boolean
      read GetEmployeeHasRightsForSendingToPerforming
      write SetEmployeeHasRightsForSendingToPerforming;

      property EmployeeHasRightsForRejectingFromSigning: Boolean
      read GetEmployeeHasRightsForRejectingFromSigning
      write SetEmployeeHasRightsForRejectingFromSigning;
      
      property EmployeeHasRightsForRejectingFromApproving: Boolean
      read GetEmployeeHasRightsForRejectingFromApproving
      write SetEmployeeHasRightsForRejectingFromApproving;

      property EmployeeHasRightsForMarkDocumentAsSelfRegistered: Boolean
      read GetEmployeeHasRightsForMarkDocumentAsSelfRegistered
      write SetEmployeeHasRightsForMarkDocumentAsSelfRegistered;
      
  end;

implementation

{ TDocumentUsageEmployeeAccessRightsInfo }

function TDocumentUsageEmployeeAccessRightsInfo.AnyDocumentChargeSheetsAccessRightsAllowed: Boolean;
begin

  Result :=
    Assigned(GeneralChargeSheetsUsageEmployeeAccessRightsInfo)
    and GeneralChargeSheetsUsageEmployeeAccessRightsInfo.AnyChargeSheetsAccessRightsAllowed;
    
end;

constructor TDocumentUsageEmployeeAccessRightsInfo.Create;
begin

  inherited;

  PotentialEmployeeDocumentAccessRightsInfo :=
    TPotentialEmployeeDocumentAccessRightsInfo.Create;

  GeneralChargeSheetsUsageEmployeeAccessRightsInfo :=
    TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo.Create;
    
end;

function TDocumentUsageEmployeeAccessRightsInfo.GetAllDocumentAccessRightsAbsent: Boolean;
begin

  Result :=
    not DocumentCanBeViewed and
    not DocumentCanBeRemoved and
    not DocumentCanBeApproved and
    not DocumentCanBeRejectedFromApproving and
    not DocumentCanBeSigned and
    not DocumentCanBeMarkedAsSigned and
    not DocumentCanBeRejectedFromSigning and
    not DocumentCanBePerformed and
    not DocumentCanBeSentToSigning and
    not DocumentCanBeSentToPerforming and
    not DocumentCanBeChanged;
    
end;

function TDocumentUsageEmployeeAccessRightsInfo.GetAllDocumentAndChargeSheetsAccessRightsAbsent: Boolean;
begin

  Result :=
    AllDocumentAccessRightsAbsent and AllDocumentChargeSheetsAccessRightsAbsent;
    
end;

function TDocumentUsageEmployeeAccessRightsInfo.GetAllDocumentChargeSheetsAccessRightsAbsent: Boolean;
begin

  Result :=
    not Assigned(GeneralChargeSheetsUsageEmployeeAccessRightsInfo)
    or GeneralChargeSheetsUsageEmployeeAccessRightsInfo.AllChargeSheetsAccessRightsAbsent;

end;

function TDocumentUsageEmployeeAccessRightsInfo.GetDocumentCanBeViewedOnly: Boolean;
begin

  with GeneralChargeSheetsUsageEmployeeAccessRightsInfo do begin

    Result :=
      (DocumentCanBeViewed or AnyChargeSheetsCanBeViewed)
       and not(
         CanBeChangedDocumentApproverList
         or DocumentCanBeApproved
         or DocumentCanBeRejectedFromApproving
         or DocumentCanBeSigned
         or DocumentCanBeMarkedAsSigned
         or DocumentCanBeRejectedFromSigning
         or DocumentCanBeSentToSigning
         or DocumentCanBeSentToApproving
         or DocumentCanBeSentToPerforming
         or DocumentCanBeChanged
         or DocumentCanBePerformed
         or AnyChargeSheetsCanBeChanged
         or AnyChargeSheetsCanBePerformed
         or DocumentApprovingCanBeCompleted
       );

  end;

end;

function TDocumentUsageEmployeeAccessRightsInfo.
  GetEmployeeHasRightsForApproving: Boolean;
begin

  Result :=
    FPotentialEmployeeDocumentAccessRightsInfo.EmployeeHasRightsForApproving;

end;

function TDocumentUsageEmployeeAccessRightsInfo.GetEmployeeHasRightsForMarkDocumentAsSelfRegistered: Boolean;
begin

  Result :=
    FPotentialEmployeeDocumentAccessRightsInfo.EmployeeHasRightsForMarkDocumentAsSelfRegistered;
    
end;

function TDocumentUsageEmployeeAccessRightsInfo.
  GetEmployeeHasRightsForRejectingFromApproving: Boolean;
begin

  Result :=
    FPotentialEmployeeDocumentAccessRightsInfo.
      EmployeeHasRightsForRejectingFromApproving;

end;

function TDocumentUsageEmployeeAccessRightsInfo.
  GetEmployeeHasRightsForRejectingFromSigning: Boolean;
begin

  Result :=
    FPotentialEmployeeDocumentAccessRightsInfo.
      EmployeeHasRightsForRejectingFromSigning;

end;

function TDocumentUsageEmployeeAccessRightsInfo.
  GetEmployeeHasRightsForSendingToApproving: Boolean;
begin

  Result :=
    FPotentialEmployeeDocumentAccessRightsInfo.
      EmployeeHasRightsForSendingToApproving;

end;

function TDocumentUsageEmployeeAccessRightsInfo.
  GetEmployeeHasRightsForSendingToPerforming: Boolean;
begin

  Result :=
    FPotentialEmployeeDocumentAccessRightsInfo.
      EmployeeHasRightsForSendingToPerforming;

end;

function TDocumentUsageEmployeeAccessRightsInfo.
  GetEmployeeHasRightsForSendingToSigning: Boolean;
begin

  Result :=
    FPotentialEmployeeDocumentAccessRightsInfo.
      EmployeeHasRightsForSendingToSigning;
      
end;

function TDocumentUsageEmployeeAccessRightsInfo.
  GetEmployeeHasRightsForSigning: Boolean;
begin

  Result :=
    FPotentialEmployeeDocumentAccessRightsInfo.EmployeeHasRightsForSigning;
    
end;

function TDocumentUsageEmployeeAccessRightsInfo.
  GetEmployeeHasRightsForSigningMarking: Boolean;
begin

  Result :=
    FPotentialEmployeeDocumentAccessRightsInfo.EmployeeHasRightsForSigningMarking;
    
end;

procedure TDocumentUsageEmployeeAccessRightsInfo.
  SetPotentialEmployeeDocumentAccessRightsInfo(
    const Value: TPotentialEmployeeDocumentAccessRightsInfo
  );
begin

  FPotentialEmployeeDocumentAccessRightsInfo := Value;
  
  FFreePotentialEmployeeDocumentAccessRightsInfo :=
    FPotentialEmployeeDocumentAccessRightsInfo;
    
end;

procedure TDocumentUsageEmployeeAccessRightsInfo.
  SetEmployeeHasRightsForApproving(
    const Value: Boolean
  );
begin

  FPotentialEmployeeDocumentAccessRightsInfo.EmployeeHasRightsForApproving :=
    Value;
    
end;

procedure TDocumentUsageEmployeeAccessRightsInfo.SetEmployeeHasRightsForMarkDocumentAsSelfRegistered(
  const Value: Boolean);
begin

  FPotentialEmployeeDocumentAccessRightsInfo.EmployeeHasRightsForMarkDocumentAsSelfRegistered := Value;
  
end;

procedure TDocumentUsageEmployeeAccessRightsInfo.
  SetEmployeeHasRightsForRejectingFromApproving(
    const Value: Boolean
  );
begin

  FPotentialEmployeeDocumentAccessRightsInfo.
    EmployeeHasRightsForRejectingFromApproving := Value;

end;

procedure TDocumentUsageEmployeeAccessRightsInfo.
  SetEmployeeHasRightsForRejectingFromSigning(
    const Value: Boolean
  );
begin

  FPotentialEmployeeDocumentAccessRightsInfo.
    EmployeeHasRightsForRejectingFromSigning := Value;

end;

procedure TDocumentUsageEmployeeAccessRightsInfo.
  SetEmployeeHasRightsForSendingToApproving(
    const Value: Boolean
  );
begin

  FPotentialEmployeeDocumentAccessRightsInfo.
    EmployeeHasRightsForSendingToApproving := Value;

end;

procedure TDocumentUsageEmployeeAccessRightsInfo.
  SetEmployeeHasRightsForSendingToPerforming(
    const Value: Boolean
  );
begin

  FPotentialEmployeeDocumentAccessRightsInfo.
    EmployeeHasRightsForSendingToPerforming := Value;

end;

procedure TDocumentUsageEmployeeAccessRightsInfo.
  SetEmployeeHasRightsForSendingToSigning(
    const Value: Boolean
  );
begin

  FPotentialEmployeeDocumentAccessRightsInfo.
    EmployeeHasRightsForSendingToSigning := Value;

end;

procedure TDocumentUsageEmployeeAccessRightsInfo.
  SetEmployeeHasRightsForSigning(
    const Value: Boolean
  );
begin

  FPotentialEmployeeDocumentAccessRightsInfo.EmployeeHasRightsForSigning := Value;
  
end;

procedure TDocumentUsageEmployeeAccessRightsInfo.SetEmployeeHasRightsForSigningMarking(
  const Value: Boolean);
begin

  FPotentialEmployeeDocumentAccessRightsInfo.EmployeeHasRightsForSigningMarking := Value;

end;

procedure TDocumentUsageEmployeeAccessRightsInfo.SetGeneralChargeSheetsUsageEmployeeAccessRightsInfo(
  const Value: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo);
begin

  FGeneralChargeSheetsUsageEmployeeAccessRightsInfo := Value;
  
  FFreeGeneralChargeSheetsUsageEmployeeAccessRightsInfo :=
    FGeneralChargeSheetsUsageEmployeeAccessRightsInfo;
    
end;

end.
