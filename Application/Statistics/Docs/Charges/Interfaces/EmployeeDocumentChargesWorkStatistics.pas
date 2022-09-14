unit EmployeeDocumentChargesWorkStatistics;

interface

type

  TEmployeeDocumentChargesWorkStatistics = class

    private

      FPerformedChargeCount: Integer;
      FTotalChargeCount: Integer;
      
    public

      constructor Create; overload;
      constructor Create(
        const PerformedChargeCount: Integer;
        const TotalChargeCount: Integer
      ); overload;

    published

      property TotalChargeCount: Integer
      read FTotalChargeCount write FTotalChargeCount;

      property PerformedChargeCount: Integer
      read FPerformedChargeCount
      write FPerformedChargeCount;
      
  end;
  
implementation

{ TEmployeeDocumentChargesWorkStatistics }

constructor TEmployeeDocumentChargesWorkStatistics.Create;
begin

  inherited;

end;

constructor TEmployeeDocumentChargesWorkStatistics.Create(
  const PerformedChargeCount: Integer;
  const TotalChargeCount: Integer
);
begin

  inherited Create;

  Self.PerformedChargeCount := PerformedChargeCount;
  Self.TotalChargeCount := TotalChargeCount;
    
end;

end.
