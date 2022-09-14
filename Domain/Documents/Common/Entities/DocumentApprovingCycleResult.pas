{ refactor: пересмотреть
  необходимость наличия этого класса
  во время анализа предметных сущностей,
  участвующих в реализации механизма
  согласования документов }
unit DocumentApprovingCycleResult;

interface

uses

  DomainException,
  DomainObjectListUnit,
  IDomainObjectListUnit,
  DomainObjectUnit,
  DomainObjectValueUnit,
  Employee,
  DocumentApprovings,
  SysUtils,
  Classes;

type

  TDocumentApprovingCycleResultException = class (TDomainException)

  end;

  TDocumentApprovingCycleResult = class (TDomainObject)

    private

      FCycleNumber: Integer;
      
      FDocumentApprovings: TDocumentApprovings;
      FFreeDocumentApprovings: IDomainObjectList;

      function GetDocumentId: Variant;
      function GetDocumentApprovings: TDocumentApprovings;

      procedure SetDocumentApprovings(const Value: TDocumentApprovings);

      procedure EnsureThatDocumentApprovingsAreValid(
        DocumentApprovings: TDocumentApprovings
      );
    procedure SetCycleNumber(const Value: Integer);

    public

      constructor Create(
        const CycleNumber: Integer;
        DocumentApprovings: TDocumentApprovings
      );

      function FetchAllApprovers: TEmployees;

    published

      property DocumentId: Variant read GetDocumentId;

      property DocumentApprovings: TDocumentApprovings
      read GetDocumentApprovings write SetDocumentApprovings;

      property CycleNumber: Integer read FCycleNumber write SetCycleNumber;
      
  end;

  TDocumentApprovingCycleResults = class;

  TDocumentApprovingCycleResultsEnumerator = class (TDomainObjectListEnumerator)

    protected

      function GetCurrentDocumentApprovingCycleResult:
        TDocumentApprovingCycleResult;

    public

      constructor Create(
        DocumentApprovingCycleResults: TDocumentApprovingCycleResults
      );

      property Current: TDocumentApprovingCycleResult
      read GetCurrentDocumentApprovingCycleResult;

  end;

  TDocumentApprovingCycleResults = class (TDomainObjectList)

    protected

      function GetDocumentApprovingCycleResultByIndex(
        Index: Integer
      ): TDocumentApprovingCycleResult;

      procedure SetDocumentApprovingCycleResultByIndex(
        Index: Integer;
        const Value: TDocumentApprovingCycleResult
      );
      
    public

      constructor CreateFrom(
        HistoricalDocumentApprovings: THistoricalDocumentApprovings
      );

      function First: TDocumentApprovingCycleResult;
      function Last: TDocumentApprovingCycleResult;

      function FetchAllApprovers: TEmployees;
      
      procedure Add(
        DocumentApprovingCycleResult: TDocumentApprovingCycleResult
      );

      procedure Remove(
        DocumentApprovingCycleResult: TDocumentApprovingCycleResult
      );

      procedure OrderByCycleNumber;

      procedure RemoveByIdentity(const Identity: Variant);
      
      function FindByIdentity(
        const Identity: Variant
      ): TDocumentApprovingCycleResult;

      function FindByCycleNumber(
        const CycleNumber: Integer
      ): TDocumentApprovingCycleResult;

      function GetEnumerator: TDocumentApprovingCycleResultsEnumerator;

      property Items[Index: Integer]: TDocumentApprovingCycleResult
      read GetDocumentApprovingCycleResultByIndex
      write SetDocumentApprovingCycleResultByIndex; default;

  end;

implementation

uses

  Variants,
  IDomainObjectBaseListUnit,
  DomainObjectBaseUnit,
  DomainObjectBaseListUnit;
  
{ TDocumentApprovingCycleResult }

constructor TDocumentApprovingCycleResult.Create(
  const CycleNumber: Integer;
  DocumentApprovings: TDocumentApprovings
);
begin

  inherited Create;

  if CycleNumber <= 0 then
    raise TDocumentApprovingCycleResultException.Create(
            'Номер цикла должен быть положительным числом'
          );

  EnsureThatDocumentApprovingsAreValid(DocumentApprovings);

  FCycleNumber := CycleNumber;
  FDocumentApprovings := DocumentApprovings;
  FFreeDocumentApprovings := DocumentApprovings;
  
end;

procedure TDocumentApprovingCycleResult.EnsureThatDocumentApprovingsAreValid(
  DocumentApprovings: TDocumentApprovings
);
var DocumentId: Variant;
    DocumentApproving: TDocumentApproving;
begin

  if not Assigned(DocumentApprovings) or DocumentApprovings.IsEmpty then
    raise TDocumentApprovingCycleResultException.Create(
            'Для завершения цикла ' +
            'согласования должен быть указан ' +
            'хотя бы один согласовант'
          );

  DocumentId := Null;

  for DocumentApproving in DocumentApprovings do begin

    if VarIsNull(DocumentId) then
      DocumentId := DocumentApproving.DocumentId

    else if DocumentId <> DocumentApproving.DocumentId then
      raise TDocumentApprovingCycleResultException.Create(
              'В рамках одного цикла ' +
              'согласования не могут ' +
              'согласовываться более ' +
              'одного документа'
            );

  end;

end;

function TDocumentApprovingCycleResult.FetchAllApprovers: TEmployees;
begin

  Result := FDocumentApprovings.FetchApprovers;
  
end;

function TDocumentApprovingCycleResult.GetDocumentApprovings: TDocumentApprovings;
begin

  Result := FDocumentApprovings;
  
end;

function TDocumentApprovingCycleResult.GetDocumentId: Variant;
begin

  Result := FDocumentApprovings.First.DocumentId;
  
end;

procedure TDocumentApprovingCycleResult.SetDocumentApprovings(
  const Value: TDocumentApprovings
);
begin

  if not InvariantsComplianceRequested then begin

    raise TDocumentApprovingCycleResultException.Create(
      'Результаты согласования ' +
      'не могут устанавливаться непосредственно'
    );

  end;

  FDocumentApprovings := Value;
  FFreeDocumentApprovings := FDocumentApprovings;
  
end;

procedure TDocumentApprovingCycleResult.SetCycleNumber(const Value: Integer);
begin

  if not InvariantsComplianceRequested then
    raise TDocumentApprovingCycleResultException.Create(
            'Номер цикла не может назначаться ' +
            'непосредственно. Ошибка программиста'
          );
          
  FCycleNumber := Value;

end;

{ TDocumentApprovingCycleResultsEnumerator }

constructor TDocumentApprovingCycleResultsEnumerator.Create(
  DocumentApprovingCycleResults: TDocumentApprovingCycleResults);
begin

  inherited Create(DocumentApprovingCycleResults);
  
end;

function TDocumentApprovingCycleResultsEnumerator.GetCurrentDocumentApprovingCycleResult: TDocumentApprovingCycleResult;
begin

  Result := GetCurrentDomainObject as TDocumentApprovingCycleResult;

end;

{ TDocumentApprovingCycleResults }

procedure TDocumentApprovingCycleResults.Add(
  DocumentApprovingCycleResult: TDocumentApprovingCycleResult);
begin

  AddDomainObject(DocumentApprovingCycleResult);
  
end;

{ Refactor: перенести в THistoricalDocumentApprovings,
  возвращать объект типа HistoricalDocumentApprovingsGroups }
constructor TDocumentApprovingCycleResults.CreateFrom(
  HistoricalDocumentApprovings: THistoricalDocumentApprovings
);
var
    HistoricalDocumentApproving: THistoricalDocumentApproving;
    PreviousApprovingCycleId: Variant;
    CycleResult: TDocumentApprovingCycleResult;
    CycleDocumentApprovings: TDocumentApprovings;
begin

  inherited Create;

  CycleResult := nil;
  CycleDocumentApprovings := nil;
  PreviousApprovingCycleId := Null;

  try
  
    for HistoricalDocumentApproving in HistoricalDocumentApprovings do begin

      if PreviousApprovingCycleId <> HistoricalDocumentApproving.ApprovingCycleId
      then begin

        CycleResult :=
          FindByCycleNumber(HistoricalDocumentApproving.ApprovingCycleId);

        if not Assigned(CycleResult) then begin

          CycleDocumentApprovings :=
            THistoricalDocumentApprovings.Create;

          CycleDocumentApprovings.Add(HistoricalDocumentApproving);

          CycleResult :=
            TDocumentApprovingCycleResult.Create(
              HistoricalDocumentApproving.ApprovingCycleId,
              CycleDocumentApprovings
            );

          Add(CycleResult);

        end

        else begin

          CycleDocumentApprovings := CycleResult.DocumentApprovings;

          CycleDocumentApprovings.Add(HistoricalDocumentApproving);
        
        end;

        PreviousApprovingCycleId := HistoricalDocumentApproving.ApprovingCycleId;

      end

      else CycleDocumentApprovings.Add(HistoricalDocumentApproving);

    end;

  except

    on E: Exception do begin

      Free;

      Raise;
      
    end;

  end;

end;

function TDocumentApprovingCycleResults.FindByIdentity(
  const Identity: Variant): TDocumentApprovingCycleResult;
begin

  Result := inherited FindByIdentity(Identity) as TDocumentApprovingCycleResult;

end;

function TDocumentApprovingCycleResults.FetchAllApprovers: TEmployees;
var
    ApprovingCycleResult: TDocumentApprovingCycleResult;

    Approvers: TEmployees;
    FreeApprovers: IDomainObjectBaseList;
begin

  Result := TEmployees.Create;

  try

    for ApprovingCycleResult in Self do begin

      Approvers := ApprovingCycleResult.FetchAllApprovers;

      FreeApprovers := Approvers;

      Result.AddDomainObjectList(Approvers);
      
    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDocumentApprovingCycleResults.FindByCycleNumber(
  const CycleNumber: Integer): TDocumentApprovingCycleResult;
var CycleResult: TDocumentApprovingCycleResult;
begin

  for CycleResult in Self do
    if CycleResult.CycleNumber = CycleNumber then
      Result := CycleResult;

  Result := nil;

end;

function TDocumentApprovingCycleResults.First: TDocumentApprovingCycleResult;
begin

  Result := inherited First as TDocumentApprovingCycleResult;

end;

function TDocumentApprovingCycleResults.GetDocumentApprovingCycleResultByIndex(
  Index: Integer): TDocumentApprovingCycleResult;
begin

  Result := GetDomainObjectByIndex(Index) as TDocumentApprovingCycleResult;

end;

function TDocumentApprovingCycleResults.GetEnumerator: TDocumentApprovingCycleResultsEnumerator;
begin

  Result := TDocumentApprovingCycleResultsEnumerator.Create(Self);
  
end;

function TDocumentApprovingCycleResults.Last: TDocumentApprovingCycleResult;
begin

  Result := inherited Last as TDocumentApprovingCycleResult;

end;

function ByNumberCycleResultComparator(First, Second: Pointer): Integer;
var FirstApprovingCycleResult, SecondApprovingCycleResult:
      TDocumentApprovingCycleResult;

begin

  FirstApprovingCycleResult :=
    TDocumentApprovingCycleResult(
      TDomainObjectBaseEntry(First).BaseDomainObject.Self
    );

  SecondApprovingCycleResult :=
    TDocumentApprovingCycleResult(
      TDomainObjectBaseEntry(Second).BaseDomainObject.Self
    );

  Result :=
    FirstApprovingCycleResult.CycleNumber -
    SecondApprovingCycleResult.CycleNumber;
    
end;

procedure TDocumentApprovingCycleResults.OrderByCycleNumber;
begin

  OrderByListComparator(ByNumberCycleResultComparator);

end;

procedure TDocumentApprovingCycleResults.Remove(
  DocumentApprovingCycleResult: TDocumentApprovingCycleResult);
begin

  DeleteDomainObject(DocumentApprovingCycleResult);
  
end;

procedure TDocumentApprovingCycleResults.RemoveByIdentity(
  const Identity: Variant);
begin

  DeleteDomainObjectByIdentity(Identity);
  
end;

procedure TDocumentApprovingCycleResults.SetDocumentApprovingCycleResultByIndex(
  Index: Integer; const Value: TDocumentApprovingCycleResult);
begin

  SetDomainObjectByIndex(Index, Value);
  
end;

end.
