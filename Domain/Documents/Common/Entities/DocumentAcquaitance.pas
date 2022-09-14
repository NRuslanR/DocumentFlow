unit DocumentAcquaitance;

interface

uses

  DocumentCharges,
  SysUtils;

type

  TDocumentAcquaitance = class (TDocumentCharge)

    public

      class function ChargeSheetType: TClass; override;
      
  end;

implementation

uses

  DocumentAcquaitanceSheet;

{ TDocumentAcquaitance }

class function TDocumentAcquaitance.ChargeSheetType: TClass;
begin

  Result := TDocumentAcquaitanceSheet;
  
end;

end.
