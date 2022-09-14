unit DocumentAcquaitanceSheet;

interface

uses

  DocumentChargeSheet,
  DomainException,
  DocumentCharges,
  IDocumentChargeSheetUnit,
  DomainObjectUnit,
  DomainObjectListUnit,
  Employee,
  IDomainObjectBaseUnit,
  DocumentAcquaitance,
  DocumentChargeSheetOverlappingPerformingService,
  TimeFrame,
  SysUtils,
  Classes;

type

  TDocumentAcquaitanceSheet = class (TDocumentChargeSheet)

    public

      class function ChargeType: TDocumentChargeClass; override;
      
  end;
  
implementation

{ TDocumentAcquaitanceSheet }

class function TDocumentAcquaitanceSheet.ChargeType: TDocumentChargeClass;
begin

  Result := TDocumentAcquaitance;

end;

end.
