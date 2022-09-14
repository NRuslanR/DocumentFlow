unit DocumentChargeSheetAccessRights;

interface

uses

  DomainObjectValueUnit,
  SysUtils;

type

  TDocumentChargeSheetAccessRights = class (TDomainObjectValue)

    public

      ViewingAllowed: Boolean;
      ChargeSectionAccessible: Boolean;
      ResponseSectionAccessible: Boolean;
      RemovingAllowed: Boolean;
      PerformingAllowed: Boolean;

      function AllAccessRightsAbsent: Boolean;

  end;

implementation

{ TDocumentChargeSheetAccessRights }

function TDocumentChargeSheetAccessRights.AllAccessRightsAbsent: Boolean;
begin

  Result :=
    not (
      ViewingAllowed
      or
      ChargeSectionAccessible
      or
      ResponseSectionAccessible
      or
      RemovingAllowed
      or
      PerformingAllowed
    );
    
end;

end.
