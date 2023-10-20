unit DocumentApprovingCycleViewModel;

interface

type

  TDocumentApprovingCycleViewModel = class

    public

      CycleId: Variant;
      CycleNumber: Integer;
      CycleName: String;
      IsNew: Boolean;

      CanBeChanged: Variant;
      CanBeRemoved: Variant;
      CanBeCompleted: Variant;

      constructor Create;
      constructor CreateFrom(
        const CycleId: Variant;
        const CycleNumber: Integer;
        const CycleName: String;
        const IsNew: Boolean
      );

  end;

implementation

uses

  Variants;
  
{ TDocumentApprovingCycleRecordViewModel }

constructor TDocumentApprovingCycleViewModel.Create;
begin

  inherited;

  CycleId := Null;
  CanBeChanged := Null;
  CanBeRemoved := Null;
  CanBeCompleted := Null;
  
end;

constructor TDocumentApprovingCycleViewModel.CreateFrom(
  const CycleId: Variant;
  const CycleNumber: Integer;
  const CycleName: String;
  const IsNew: Boolean
);
begin

  Create;

  Self.CycleId := CycleId;
  Self.CycleNumber := CycleNumber;
  Self.CycleName := CycleName;
  Self.IsNew := IsNew;

end;

end.
