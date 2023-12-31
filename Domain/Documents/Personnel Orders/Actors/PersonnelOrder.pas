unit PersonnelOrder;

interface

uses

  DocumentChargeSheet,
  DocumentAcquaitanceSheet,
  DocumentWorkCycle,
  PersonnelOrderWorkCycle,
  Document,
  SysUtils,
  Classes;

type

  TPersonnelOrder = class (TDocument)

    private

      FSubKindId: Variant;

      procedure SetSubKindId(const Value: Variant);

    protected

      procedure CustomizeInitialState; override;

    public

      class function ListType: TDocumentsClass; override;
      class function WorkCycleType: TDocumentWorkCycleClass; override;
      
    published

      property SubKindId: Variant
      read FSubKindId write SetSubKindId;
      
  end;

  TPersonnelOrders = class (TDocuments)
  
  end;

implementation

uses

  Variants;

{ TPersonnelOrder }

procedure TPersonnelOrder.CustomizeInitialState;
begin

  inherited CustomizeInitialState;

  FSubKindId := Null;
  
end;

class function TPersonnelOrder.ListType: TDocumentsClass;
begin

  Result := TPersonnelOrders;
  
end;

procedure TPersonnelOrder.SetSubKindId(const Value: Variant);
begin

  if InvariantsComplianceRequested then
    RaiseExceptionIfEditingEmployeeNotAssigned;
    
  FSubKindId := Value;

end;

class function TPersonnelOrder.WorkCycleType: TDocumentWorkCycleClass;
begin

  Result := TPersonnelOrderWorkCycle;
  
end;

end.
