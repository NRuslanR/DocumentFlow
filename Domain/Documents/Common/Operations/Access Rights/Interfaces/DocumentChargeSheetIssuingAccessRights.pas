unit DocumentChargeSheetIssuingAccessRights;

interface

uses

  Document,
  DocumentChargeKind,
  Employee,
  DomainObjectValueUnit,
  DomainException,
  IDomainObjectBaseListUnit,
  IDomainObjectBaseUnit,
  SysUtils;

type

  TDocumentChargeSheetIssuingAccessRightsServiceException = class (TDomainException)

  end;

  TDocumentChargeSheetIssuingAccessRights = class (TDomainObjectValue)

    private

      FIssuingAlloweableHeadChargeSheetKinds: TDocumentChargeKinds;
      FFreeIssuingAlloweableHeadChargeSheetKinds: IDomainObjectBaseList;

      FIssuingAlloweableSubordinateChargeSheetKinds: TDocumentChargeKinds;
      FFreeIssuingAlloweableSubordinateChargeSheetKinds: IDomainObjectBaseList;

      FMainChargeSheetKind: TDocumentChargeKind;
      FFreeMainChargeSheetKind: IDomainObjectBase;

      procedure SetIssuingAlloweableHeadChargeSheetKinds(
        const Value: TDocumentChargeKinds);

      procedure SetIssuingAlloweableSubordinateChargeSheetKinds(
        const Value: TDocumentChargeKinds);

      procedure SetMainChargeSheetKind(const Value: TDocumentChargeKind);

    public

      constructor Create;

      function AllAccessRightsAbsent: Boolean;
      function AnyHeadChargeSheetsCanBeIssued: Boolean;
      function AnySubordinateChargeSheetsCanBeIssued: Boolean;
      function AnyChargeSheetsCanBeIssued: Boolean;
      
      property IssuingAlloweableHeadChargeSheetKinds: TDocumentChargeKinds
      read FIssuingAlloweableHeadChargeSheetKinds
      write SetIssuingAlloweableHeadChargeSheetKinds;
      
      property IssuingAlloweableSubordinateChargeSheetKinds: TDocumentChargeKinds
      read FIssuingAlloweableSubordinateChargeSheetKinds
      write SetIssuingAlloweableSubordinateChargeSheetKinds;
      
      property MainChargeSheetKind: TDocumentChargeKind
      read FMainChargeSheetKind write SetMainChargeSheetKind;
      
  end;

implementation

{ TDocumentChargeSheetIssuingAccessRights }

function TDocumentChargeSheetIssuingAccessRights.AllAccessRightsAbsent: Boolean;
begin

  Result:= not AnyChargeSheetsCanBeIssued;
  
end;

function TDocumentChargeSheetIssuingAccessRights.AnyChargeSheetsCanBeIssued: Boolean;
begin

  Result :=
    AnyHeadChargeSheetsCanBeIssued
    or AnySubordinateChargeSheetsCanBeIssued;
    
end;

function TDocumentChargeSheetIssuingAccessRights.AnyHeadChargeSheetsCanBeIssued: Boolean;
begin

  Result := not FIssuingAlloweableHeadChargeSheetKinds.IsEmpty;
  
end;

function TDocumentChargeSheetIssuingAccessRights.AnySubordinateChargeSheetsCanBeIssued: Boolean;
begin

  Result := not FIssuingAlloweableSubordinateChargeSheetKinds.IsEmpty;
  
end;

constructor TDocumentChargeSheetIssuingAccessRights.Create;
begin

  inherited;

  IssuingAlloweableHeadChargeSheetKinds := TDocumentChargeKinds.Create;
  IssuingAlloweableSubordinateChargeSheetKinds := TDocumentChargeKinds.Create;
  
end;

procedure TDocumentChargeSheetIssuingAccessRights.SetIssuingAlloweableHeadChargeSheetKinds(
  const Value: TDocumentChargeKinds);
begin

  FIssuingAlloweableHeadChargeSheetKinds := Value;
  FFreeIssuingAlloweableHeadChargeSheetKinds := Value;
  
end;

procedure TDocumentChargeSheetIssuingAccessRights.SetIssuingAlloweableSubordinateChargeSheetKinds(
  const Value: TDocumentChargeKinds);
begin

  FIssuingAlloweableSubordinateChargeSheetKinds := Value;
  FFreeIssuingAlloweableSubordinateChargeSheetKinds := Value;

end;

procedure TDocumentChargeSheetIssuingAccessRights.SetMainChargeSheetKind(
  const Value: TDocumentChargeKind);
begin

  FMainChargeSheetKind := Value;
  FFreeMainChargeSheetKind := Value;

end;

end.
