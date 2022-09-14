unit GeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo;

interface

uses

  DomainException,
  DomainObjectValueUnit,
  SysUtils;

type

  TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo = class (TDomainObjectValue)

    private

      function GetAllChargeSheetsAccessRightsAbsent: Boolean;
      function GetAllChargeSheetsAccessRightsAllowed: Boolean;

    public

      AnyChargeSheetsCanBeViewed: Boolean;
      AnyChargeSheetsCanBeIssued: Boolean;
      AnyChargeSheetsCanBeChanged: Boolean;
      AnyChargeSheetsCanBeRemoved: Boolean;
      AnyChargeSheetsCanBePerformed: Boolean;

      property AllChargeSheetsAccessRightsAbsent: Boolean
      read GetAllChargeSheetsAccessRightsAbsent;

      property AllChargeSheetsAccessRightsAllowed: Boolean
      read GetAllChargeSheetsAccessRightsAllowed;

  end;
  
implementation

{ TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo }

function TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo.
  GetAllChargeSheetsAccessRightsAbsent: Boolean;
begin

  Result :=
    not AnyChargeSheetsCanBeViewed
    and not AnyChargeSheetsCanBeIssued
    and not AnyChargeSheetsCanBeChanged
    and not AnyChargeSheetsCanBeRemoved
    and not AnyChargeSheetsCanBePerformed;
    
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

end.
