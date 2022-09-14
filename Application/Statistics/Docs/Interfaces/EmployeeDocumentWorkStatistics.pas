unit EmployeeDocumentWorkStatistics;

interface

uses

  DocumentKinds,
  SysUtils,
  Classes;
  
type

  TEmployeeDocumentKindWorkStatistics = class

    private

      FDocumentKindId: Variant;
      
      FOwnActionDocumentCount: Integer;
      FInWorkingDocumentCount: Integer;

    public

      constructor Create;
      constructor CreateFrom(
        DocumentKindId: Variant;
        OwnActionDocumentCount: Integer;
        InWorkingDocumentCount: Integer
      );

    published

      property DocumentKindId: Variant
      read FDocumentKindId write FDocumentKindId;

      property OwnActionDocumentCount: Integer
      read FOwnActionDocumentCount write FOwnActionDocumentCount;

      property InWorkingDocumentCount: Integer
      read FInWorkingDocumentCount write FInWorkingDocumentCount;

  end;

  TEmployeeDocumentWorkStatisticsList = class;

  TEmployeeDocumentWorkStatisticsListEnumerator = class (TListEnumerator)

    private

      function GetCurrentEmployeeDocumentKindWorkStatistics:
        TEmployeeDocumentKindWorkStatistics;

    public

      constructor Create(
        EmployeeDocumentWorkStatisticsList: TEmployeeDocumentWorkStatisticsList
      );

      property Current: TEmployeeDocumentKindWorkStatistics
      read GetCurrentEmployeeDocumentKindWorkStatistics;

  end;

  TEmployeeDocumentWorkStatisticsList = class (TList)

    private

      function GetEmployeeDocumentKindWorkStatisticsByIndex(
        Index: Integer
      ): TEmployeeDocumentKindWorkStatistics;

      procedure SetGetCurrentEmployeeDocumentKindWorkStatistics(
        Index: Integer;
        EmployeeDocumentKindWorkStatistics: TEmployeeDocumentKindWorkStatistics
      );

    public

      procedure AddEmployeeDocumentKindWorkStatistics(
        const DocumentKindId: Variant;
        const OwnActionDocumentCount, InWorkingDocumentCount: Integer
      );

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;

      function GetEnumerator: TEmployeeDocumentWorkStatisticsListEnumerator;

      property Items[Index: Integer]: TEmployeeDocumentKindWorkStatistics
      read GetEmployeeDocumentKindWorkStatisticsByIndex
      write SetGetCurrentEmployeeDocumentKindWorkStatistics; default;

  end;

implementation

{ TEmployeeDocumentKindWorkStatistics }

constructor TEmployeeDocumentKindWorkStatistics.Create;
begin

  inherited;

end;

constructor TEmployeeDocumentKindWorkStatistics.CreateFrom(
  DocumentKindId: Variant;
  OwnActionDocumentCount,
  InWorkingDocumentCount: Integer
);
begin

  inherited Create;

  Self.DocumentKindId := DocumentKindId;
  Self.OwnActionDocumentCount := OwnActionDocumentCount;
  Self.InWorkingDocumentCount := InWorkingDocumentCount;
  
end;

{ TEmployeeDocumentWorkStatisticsListEnumerator }

constructor TEmployeeDocumentWorkStatisticsListEnumerator.Create(
  EmployeeDocumentWorkStatisticsList: TEmployeeDocumentWorkStatisticsList);
begin

  inherited Create(EmployeeDocumentWorkStatisticsList);
  
end;

function TEmployeeDocumentWorkStatisticsListEnumerator.GetCurrentEmployeeDocumentKindWorkStatistics: TEmployeeDocumentKindWorkStatistics;
begin

  Result := TEmployeeDocumentKindWorkStatistics(GetCurrent);
  
end;

{ TEmployeeDocumentWorkStatisticsList }

procedure TEmployeeDocumentWorkStatisticsList.AddEmployeeDocumentKindWorkStatistics(
  const DocumentKindId: Variant; const OwnActionDocumentCount,
  InWorkingDocumentCount: Integer);
begin

  Add(
    TEmployeeDocumentKindWorkStatistics.CreateFrom(
      DocumentKindId,
      OwnActionDocumentCount,
      InWorkingDocumentCount
    )
  );
  
end;

function TEmployeeDocumentWorkStatisticsList.GetEmployeeDocumentKindWorkStatisticsByIndex(
  Index: Integer): TEmployeeDocumentKindWorkStatistics;
begin

  Result := TEmployeeDocumentKindWorkStatistics(Get(Index));

end;

function TEmployeeDocumentWorkStatisticsList.GetEnumerator: TEmployeeDocumentWorkStatisticsListEnumerator;
begin

  Result := TEmployeeDocumentWorkStatisticsListEnumerator.Create(Self);

end;

procedure TEmployeeDocumentWorkStatisticsList.Notify(Ptr: Pointer;
  Action: TListNotification);
begin

  if (Action = lnDeleted) and Assigned(Ptr) then
    TEmployeeDocumentKindWorkStatistics(Ptr).Free;

end;

procedure TEmployeeDocumentWorkStatisticsList.SetGetCurrentEmployeeDocumentKindWorkStatistics(
  Index: Integer;
  EmployeeDocumentKindWorkStatistics: TEmployeeDocumentKindWorkStatistics);
begin

  Put(Index, EmployeeDocumentKindWorkStatistics);
  
end;

end.
