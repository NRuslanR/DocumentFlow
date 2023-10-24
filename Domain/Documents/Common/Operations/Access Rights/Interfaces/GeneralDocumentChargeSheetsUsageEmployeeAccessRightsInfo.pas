unit GeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo;

interface

uses

  DocumentChargeKind,
  DomainException,
  DomainObjectValueUnit,
  IDomainObjectBaseUnit,
  IDomainObjectBaseListUnit,
  DocumentChargeSheetIssuingAccessRights,
  SysUtils;

type


  TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo = class (TDomainObjectValue)

    private

      FIssuingAccessRights: TDocumentChargeSheetIssuingAccessRights;
      FFreeIssuingAccessRights: IDomainObjectBase;
      
      function GetAllChargeSheetsAccessRightsAbsent: Boolean;
      function GetAllChargeSheetsAccessRightsAllowed: Boolean;

      procedure SetIssuingAccessRights(
        const Value: TDocumentChargeSheetIssuingAccessRights);

    public
      
      AnyChargeSheetsCanBeViewedAsIssuer: Boolean;
      AnyChargeSheetsCanBeViewedAsPerformer: Boolean;
      AnyChargeSheetsCanBeViewedAsAuthorized: Boolean;
      AnyChargeSheetsCanBeChanged: Boolean;
      AnyChargeSheetsCanBeRemoved: Boolean;
      AnyChargeSheetsCanBePerformed: Boolean;

      constructor Create;

      function AnyChargeSheetsCanBeViewed: Boolean;
      function AnyHeadChargeSheetsCanBeIssued: Boolean;
      function AnySubordinateChargeSheetsCanBeIssued: Boolean;
      function AnyChargeSheetsCanBeIssued: Boolean;

      function AnyChargeSheetsAccessRightsAllowed: Boolean;
      
      property AllChargeSheetsAccessRightsAbsent: Boolean
      read GetAllChargeSheetsAccessRightsAbsent;

      property AllChargeSheetsAccessRightsAllowed: Boolean
      read GetAllChargeSheetsAccessRightsAllowed;

      property IssuingAccessRights: TDocumentChargeSheetIssuingAccessRights
      read FIssuingAccessRights write SetIssuingAccessRights;

  end;
  
implementation

{ TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo }

function TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo.AnyChargeSheetsCanBeViewed: Boolean;
begin

  Result :=
    AnyChargeSheetsCanBeViewedAsIssuer
    or AnyChargeSheetsCanBeViewedAsPerformer
    or AnyChargeSheetsCanBeViewedAsAuthorized;
    
end;

function TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo.AnyHeadChargeSheetsCanBeIssued: Boolean;
begin

  Result := IssuingAccessRights.AnyHeadChargeSheetsCanBeIssued;

end;

function TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo.AnySubordinateChargeSheetsCanBeIssued: Boolean;
begin

  Result := IssuingAccessRights.AnySubordinateChargeSheetsCanBeIssued;
  
end;

constructor TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo.Create;
begin

  inherited;

  IssuingAccessRights := TDocumentChargeSheetIssuingAccessRights.Create;

end;

function TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo.AnyChargeSheetsAccessRightsAllowed: Boolean;
begin

  Result := not AllChargeSheetsAccessRightsAbsent;

end;

function TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo.
  GetAllChargeSheetsAccessRightsAbsent: Boolean;
begin

  Result :=
    not (
      AnyChargeSheetsCanBeViewed
      or AnyChargeSheetsCanBeIssued
      or AnyChargeSheetsCanBeChanged
      or AnyChargeSheetsCanBeRemoved
      or AnyChargeSheetsCanBePerformed
    );
    
end;

function TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo.
  GetAllChargeSheetsAccessRightsAllowed: Boolean;
begin

  Result :=
    AnyChargeSheetsCanBeViewed
    and AnyChargeSheetsCanBeIssued
    and AnyChargeSheetsCanBeChanged
    and AnyChargeSheetsCanBeRemoved
    and AnyChargeSheetsCanBePerformed;

end;

procedure TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo.SetIssuingAccessRights(
  const Value: TDocumentChargeSheetIssuingAccessRights);
begin

  FIssuingAccessRights := Value;
  FFreeIssuingAccessRights := Value;

end;

function TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo.AnyChargeSheetsCanBeIssued: Boolean;
begin

  Result := IssuingAccessRights.AnyChargeSheetsCanBeIssued;
  
end;

end.
