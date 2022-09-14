unit DocumentPerforming;

interface

uses

  DocumentCharges,
  SysUtils;

type

  TDocumentPerforming = class (TDocumentCharge)

    public

      class function ChargeSheetType: TClass; override;
      
  end;

implementation

uses

  DocumentPerformingSheet;
  
{ TDocumentPerforming }

class function TDocumentPerforming.ChargeSheetType: TClass;
begin

  Result := TDocumentPerformingSheet;
  
end;

end.
