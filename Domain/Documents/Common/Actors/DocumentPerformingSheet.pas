unit DocumentPerformingSheet;

interface

uses

  DocumentChargeSheet,
  DomainException,
  IDocumentChargeSheetUnit,
  DomainObjectUnit,
  DomainObjectListUnit,
  Employee,
  DocumentCharges,
  IDomainObjectBaseUnit,
  DocumentPerforming,
  DocumentChargeSheetOverlappingPerformingService,
  TimeFrame,
  SysUtils,
  Classes;

type

  TDocumentPerformingSheet = class (TDocumentChargeSheet)

    public

      class function ChargeType: TDocumentChargeClass; override;
      
  end;

implementation

{ TDocumentPerformingSheet }

class function TDocumentPerformingSheet.ChargeType: TDocumentChargeClass;
begin

  Result := TDocumentPerforming;

end;

end.
