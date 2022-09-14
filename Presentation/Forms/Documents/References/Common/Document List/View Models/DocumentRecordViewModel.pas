unit DocumentRecordViewModel;

interface

uses

  SysUtils,
  Classes;

type

  TDocumentRecordViewModel = class

    private
    
    protected

      FDocumentId: Variant;
      FBaseDocumentId: Variant;
      FKind: String;
      FKindId: Variant;
      FCreationDate: TDateTime;
      FDocumentDate: Variant;
      FCreationDateYear: Integer;
      FCreationDateMonth: Integer;
      FCurrentWorkCycleStageNumber: Integer;
      FCurrentWorkCycleStageName: String;
      FNumber: String;
      FName: String;
      FAuthorId: Variant;
      FAuthorName: String;
      FProductCode: Variant;
      FChargePerformingStatistics: Variant;
      FCanBeRemoved: Variant;
      FIsSelfRegistered: Variant;
      FAreApplicationsExists: Variant;

    protected

      function GetAuthorId: Variant; virtual;
      function GetAuthorName: String; virtual;
      function GetCanBeRemoved: Variant; virtual;
      function GetChargePerformingStatistics: Variant; virtual;
      function GetDocumentDate: Variant; virtual;
      function GetCreationDate: TDateTime; virtual;
      function GetCreationDateMonth: Integer; virtual;
      function GetCreationDateYear: Integer; virtual;
      function GetCurrentWorkCycleStageName: String; virtual;
      function GetCurrentWorkCycleStageNumber: Integer; virtual;
      function GetDocumentId: Variant; virtual;
      function GetBaseDocumentId: Variant; virtual;
      function GetKind: String; virtual;
      function GetKindId: Variant; virtual;
      function GetName: String; virtual;
      function GetNumber: String; virtual;
      function GetProductCode: Variant; virtual;
      function GetAreApplicationsExists: Variant; virtual;
      function GetIsSelfRegistered: Variant; virtual;

      procedure SetAuthorId(const Value: Variant); virtual;
      procedure SetAuthorName(const Value: String); virtual;
      procedure SetCanBeRemoved(const Value: Variant); virtual;
      procedure SetChargePerformingStatistics(const Value: Variant); virtual;
      procedure SetDocumentDate(const Value: Variant); virtual;
      procedure SetCreationDate(const Value: TDateTime); virtual;
      procedure SetCreationDateMonth(const Value: Integer); virtual;
      procedure SetCreationDateYear(const Value: Integer); virtual;
      procedure SetCurrentWorkCycleStageName(const Value: String); virtual;
      procedure SetCurrentWorkCycleStageNumber(const Value: Integer); virtual;
      procedure SetDocumentId(const Value: Variant); virtual;
      procedure SetBaseDocumentId(const Value: Variant); virtual;
      procedure SetKind(const Value: String); virtual;
      procedure SetKindId(const Value: Variant); virtual;
      procedure SetName(const Value: String); virtual;
      procedure SetNumber(const Value: String); virtual;
      procedure SetProductCode(const Value: Variant); virtual;
      procedure SetAreApplicationsExists(const Value: Variant); virtual;
      procedure SetIsSelfRegistered(const Value: Variant); virtual;

      procedure Initialize; virtual;
      
    public

      constructor Create; virtual;

      property DocumentId: Variant read GetDocumentId write SetDocumentId;
      property BaseDocumentId: Variant read GetBaseDocumentId write SetBaseDocumentId;
      property Kind: String read GetKind write SetKind;
      property KindId: Variant read GetKindId write SetKindId;
      property CreationDate: TDateTime read GetCreationDate write SetCreationDate;
      property DocumentDate: Variant read GetDocumentDate write SetDocumentDate;
      property CreationDateYear: Integer read GetCreationDateYear write SetCreationDateYear;
      property CreationDateMonth: Integer read GetCreationDateMonth write SetCreationDateMonth;

      property CurrentWorkCycleStageNumber: Integer
      read GetCurrentWorkCycleStageNumber write SetCurrentWorkCycleStageNumber;

      property CurrentWorkCycleStageName: String
      read GetCurrentWorkCycleStageName write SetCurrentWorkCycleStageName;

      property ProductCode: Variant read GetProductCode write SetProductCode;

      property Number: String read GetNumber write SetNumber;
      property Name: String read GetName write SetName;

      property AuthorId: Variant read GetAuthorId write SetAuthorId;
      property AuthorName: String read GetAuthorName write SetAuthorName;

      property ChargePerformingStatistics: Variant
      read GetChargePerformingStatistics write SetChargePerformingStatistics;

      property CanBeRemoved: Variant read GetCanBeRemoved write SetCanBeRemoved;

      property IsSelfRegistered: Variant
      read GetIsSelfRegistered write SetIsSelfRegistered;

      property AreApplicationsExists: Variant
      read GetAreApplicationsExists write SetAreApplicationsExists;

  end;

  TDocumentRecordViewModelClass = class of TDocumentRecordViewModel;

  TDocumentRecordViewModels = class;

  TDocumentRecordViewModelsEnumerator = class (TListEnumerator)

    protected

      function GetCurrentDocumentRecordViewModel: TDocumentRecordViewModel;
      
    public

      constructor Create(DocumentRecordViewModels: TDocumentRecordViewModels);

      property Current: TDocumentRecordViewModel
      read GetCurrentDocumentRecordViewModel;
      
  end;

  TDocumentRecordViewModels = class (TList)

    protected

      function GetDocumentRecordViewModelByIndex(
        Index: Integer
      ): TDocumentRecordViewModel;

      procedure SetDocumentRecordViewModelByIndex(
        Index: Integer;
        const Value: TDocumentRecordViewModel
      );
      
    protected

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;

    public

      function Add(DocumentRecordViewModel: TDocumentRecordViewModel): Integer;

      function GetEnumerator: TDocumentRecordViewModelsEnumerator;

      property Items[Index: Integer]: TDocumentRecordViewModel
      read GetDocumentRecordViewModelByIndex write SetDocumentRecordViewModelByIndex; default;
      
  end;

implementation

uses

  Variants;
  
{ TDocumentRecordViewModel }

constructor TDocumentRecordViewModel.Create;
begin

  inherited;

  Initialize;
  
end;

procedure TDocumentRecordViewModel.Initialize;
begin

  FDocumentId := Null;
  FKindId := Null;
  FAuthorId := Null;
  FCanBeRemoved := Null;
  FChargePerformingStatistics := Null;

end;

function TDocumentRecordViewModel.GetAreApplicationsExists: Variant;
begin

  Result := FAreApplicationsExists;

end;

function TDocumentRecordViewModel.GetAuthorId: Variant;
begin

  Result := FAuthorId;
  
end;

function TDocumentRecordViewModel.GetAuthorName: String;
begin

  Result := FAuthorName;
  
end;

function TDocumentRecordViewModel.GetBaseDocumentId: Variant;
begin

  Result := FBaseDocumentId;
  
end;

function TDocumentRecordViewModel.GetCanBeRemoved: Variant;
begin

  Result := FCanBeRemoved;
  
end;

function TDocumentRecordViewModel.GetChargePerformingStatistics: Variant;
begin

  Result := FChargePerformingStatistics;
  
end;

function TDocumentRecordViewModel.GetCreationDate: TDateTime;
begin

  Result := FCreationDate;
  
end;

function TDocumentRecordViewModel.GetCreationDateMonth: Integer;
begin

  Result := FCreationDateMonth;

end;

function TDocumentRecordViewModel.GetCreationDateYear: Integer;
begin

  Result := FCreationDateYear;

end;

function TDocumentRecordViewModel.GetCurrentWorkCycleStageName: String;
begin

  Result := FCurrentWorkCycleStageName;

end;

function TDocumentRecordViewModel.GetCurrentWorkCycleStageNumber: Integer;
begin

  Result := FCurrentWorkCycleStageNumber;
  
end;

function TDocumentRecordViewModel.GetDocumentDate: Variant;
begin

  Result := FDocumentDate;
  
end;

function TDocumentRecordViewModel.GetDocumentId: Variant;
begin

  Result := FDocumentId;

end;

function TDocumentRecordViewModel.GetIsSelfRegistered: Variant;
begin

  Result := FIsSelfRegistered;

end;

function TDocumentRecordViewModel.GetKind: String;
begin

  Result := FKind;

end;

function TDocumentRecordViewModel.GetKindId: Variant;
begin

  Result := FKindId;

end;

function TDocumentRecordViewModel.GetName: String;
begin

  Result := FName;

end;

function TDocumentRecordViewModel.GetNumber: String;
begin

  Result := FNumber;
  
end;

function TDocumentRecordViewModel.GetProductCode: Variant;
begin

  Result := FProductCode;
  
end;

procedure TDocumentRecordViewModel.SetAreApplicationsExists(
  const Value: Variant);
begin

  FAreApplicationsExists := Value;
  
end;

procedure TDocumentRecordViewModel.SetAuthorId(const Value: Variant);
begin

  FAuthorId := Value;
  
end;

procedure TDocumentRecordViewModel.SetAuthorName(const Value: String);
begin

  FAuthorName := Value;
  
end;

procedure TDocumentRecordViewModel.SetBaseDocumentId(const Value: Variant);
begin

  FBaseDocumentId := Value;
  
end;

procedure TDocumentRecordViewModel.SetCanBeRemoved(const Value: Variant);
begin

  FCanBeRemoved := Value;
  
end;

procedure TDocumentRecordViewModel.SetChargePerformingStatistics(
  const Value: Variant);
begin

  FChargePerformingStatistics := Value;
  
end;

procedure TDocumentRecordViewModel.SetCreationDate(const Value: TDateTime);
begin

  FCreationDate := Value;

end;

procedure TDocumentRecordViewModel.SetCreationDateMonth(const Value: Integer);
begin

  FCreationDateMonth := Value;
  
end;

procedure TDocumentRecordViewModel.SetCreationDateYear(const Value: Integer);
begin

  FCreationDateYear := Value;
  
end;

procedure TDocumentRecordViewModel.SetCurrentWorkCycleStageName(
  const Value: String);
begin

  FCurrentWorkCycleStageName := Value;

end;

procedure TDocumentRecordViewModel.SetCurrentWorkCycleStageNumber(
  const Value: Integer);
begin

  FCurrentWorkCycleStageNumber := Value;
  
end;

procedure TDocumentRecordViewModel.SetDocumentDate(const Value: Variant);
begin

  FDocumentDate := Value;
  
end;

procedure TDocumentRecordViewModel.SetDocumentId(const Value: Variant);
begin

  FDocumentId := Value;
  
end;

procedure TDocumentRecordViewModel.SetIsSelfRegistered(const Value: Variant);
begin

  FIsSelfRegistered := Value;

end;

procedure TDocumentRecordViewModel.SetKind(const Value: String);
begin

  FKind := Value;
  
end;

procedure TDocumentRecordViewModel.SetKindId(const Value: Variant);
begin

  FKindId := Value;
  
end;

procedure TDocumentRecordViewModel.SetName(const Value: String);
begin

  FName := Value;
  
end;

procedure TDocumentRecordViewModel.SetNumber(const Value: String);
begin

  FNumber := Value;

end;

procedure TDocumentRecordViewModel.SetProductCode(const Value: Variant);
begin

  FProductCode := Value;

end;

{ TDocumentRecordViewModels }

function TDocumentRecordViewModels.Add(
  DocumentRecordViewModel: TDocumentRecordViewModel): Integer;
begin

  Result := inherited Add(DocumentRecordViewModel);

end;

function TDocumentRecordViewModels.GetDocumentRecordViewModelByIndex(
  Index: Integer): TDocumentRecordViewModel;
begin

  Result := TDocumentRecordViewModel(Get(Index));

end;

function TDocumentRecordViewModels.GetEnumerator: TDocumentRecordViewModelsEnumerator;
begin

  Result := TDocumentRecordViewModelsEnumerator.Create(Self);
  
end;

procedure TDocumentRecordViewModels.Notify(Ptr: Pointer;
  Action: TListNotification);
begin

  inherited;

  if Action = lnDeleted then
    TDocumentRecordViewModel(Ptr).Free;

end;

procedure TDocumentRecordViewModels.SetDocumentRecordViewModelByIndex(
  Index: Integer; const Value: TDocumentRecordViewModel);
begin

  Put(Index, Value);
  
end;

{ TDocumentRecordViewModelsEnumerator }

constructor TDocumentRecordViewModelsEnumerator.Create(
  DocumentRecordViewModels: TDocumentRecordViewModels);
begin

  inherited Create(DocumentRecordViewModels);

end;

function TDocumentRecordViewModelsEnumerator.GetCurrentDocumentRecordViewModel: TDocumentRecordViewModel;
begin

  Result := TDocumentRecordViewModel(GetCurrent);
  
end;

end.
